# Flutter & Serverpod project

This project is a Flutter app (frontend) backed by a Serverpod server (backend). Always build the app's backend with Serverpod.
Build for multiple users, use Serverpod's built-in authentication, which is already set up in `lib/server.dart`.

The user starts the server and Flutter app with `serverpod start`. There is no need to check if the server is running: make the changes and call the `serverpod` MCP tools as needed. If the server is not running, an informative error message will be received from the MCP server. Then STOP and ask the user to start it. NEVER start the server yourself. The Flutter app is started along with it, or can be launched from the MCP tool `spawn_flutter_app`.

While running, `serverpod start` watches for file changes to run incremental code generation and hot reload both the server and the Flutter app.

Calling `serverpod generate` directly is not needed, but might be useful to troubleshoot when an incremental generation fails.

ALWAYS use the MCP server instead of the command line. Use the MCP server to:

- `create_migration` and `apply_migrations` for database (after you change data models).
- `create_repair_migration` if the database has drifted out of sync with the migrations.
- `tail_server_logs` to read logs from the server.
- `tail_flutter_logs` to read the raw stdout/stderr of the Flutter app.
- `hot_reload` / `hot_restart` to reload or restart the server and the Flutter app. ALWAYS call `hot_restart` after doing changes in the Flutter app that may not work with normal hot reload (which is automatically applied).
- `spawn_flutter_app` to start a Flutter app declared under `serverpod: flutter_apps:` in the server `pubspec.yaml`.
- `get_flutter_app_dtd` (Dart tooling daemon) for connecting to the app through the `dart` MCP.

NEVER edit generated code. The server's `lib/src/generated/` directory and the whole `askbytes_client` package are rewritten by the code generator. Change the `.spy.yaml` models, the endpoints, or `lib/server.dart` instead.

Migrations are a narrow exception: the `migration.sql` of a generated migration MAY be edited by hand when the generated SQL would lose data — to add a data transformation, or to reach a destructive change through non-destructive steps. Never touch the other files in the migration directory, and keep the schema the SQL ends up with identical to `definition.sql` — new databases are created from that file and never run `migration.sql`.

Only when the server cannot be started at all, fall back to the CLI in the server package:

- `serverpod generate` to regenerate the client and the generated server code.
- `serverpod create-migration` after changing a model with a `table` (add `--force` for destructive changes). It only writes the migration; `serverpod start` applies pending migrations when it boots the server.

Tests need no Docker. `config/test.yaml` sets `database.dataPath`, so Serverpod starts and manages the test database (an embedded PostgreSQL) itself, and the project's `docker-compose.yaml` is not used for it. Just run `dart test` in the server package.

Checklist after doing changes, in this order:

- `dart analyze` (CLI)
- `dart format` (CLI)
- `create_migration` and `apply_migrations` (MCP - only if necessary)
- Do `serverpod` MCP `hot_restart` if required (hot reload is done automatically). Will also hot restart Flutter app
- Run tests, if applicable (`dart test` in the server package)
- Check `serverpod` MCP `tail_server_logs` and `tail_flutter_logs` for any issues.

If the user asks you to test the app:

1. Use `get_flutter_app_dtd` (`serverpod` MCP) to get the Flutter app's DTD
2. Pass the DTD to `connect_dart_tooling_daemon` (`dart` MCP) to connect to the app
3. Use `flutter_driver` (`dart` MCP) to navigate through the app

The app is launched from `askbytes_flutter/lib/driver.dart`, which starts the Flutter driver extension with text entry emulation turned off so the app stays usable by hand. To let the driver type, set `enableTextEntryEmulation: true` there and `hot_restart` the app.

## About AskBytes

Live Q&A for conference talks. Attendees scan a QR code, join anonymously, post and upvote questions; AI merges near-duplicates and writes a recap when the speaker ends the session. Built for the FlutterBytes x Serverpod 2026 hackathon.

**Server (`askbytes_server`)**
- Models in `lib/src/models/`: `Event`, `TalkSession` (not `Session`, which clashes with Serverpod's), `Question` (`embedding` is `Vector(768)`, server-only), `Vote`, `SessionRecap`, plus protocol models `LiveUpdate`, `QuestionResult`, `SessionSnapshot` and `AskBytesException`.
- Endpoints in `lib/src/endpoints/`: `SessionEndpoint` (lifecycle + the `listenToSession` stream), `QuestionEndpoint` (post with dedup, upvote, pin; requires login), `RecapEndpoint`. Auth endpoints in `lib/src/auth/`: email, anonymous, Google.
- Real-time: every mutation calls `broadcast()` (`services/live_channel.dart`), which posts a `LiveUpdate` on channel `session_<id>`; `listenToSession` yields a snapshot, then that channel.
- Dedup: `QuestionEndpoint.postQuestion` embeds the text with Gemini, then runs a pgvector cosine query (`distanceCosine < 0.12`, i.e. similarity > 0.88) within the session. A hit merges into the original (votes +1, `mergeCount`, `mergeNote`) instead of inserting.
- Speakers vs attendees: both are Serverpod auth users. `requireSpeaker` (`services/auth_helpers.dart`) rejects anyone with an `AnonymousAccount`. Attendee votes and posts are keyed by the auth user id.
- AI goes through `services/ai_service.dart`: Gemini first (`gemini_service.dart`: `gemini-embedding-001` at 768 dims, recap via `geminiModel`, default `gemini-2.5-flash`), Groq as fallback (`groq_service.dart`, `groqModel`, default `openai/gpt-oss-120b`; no embeddings, so it judges duplicates with an LLM and writes recaps). Keys are the `geminiApiKey` / `groqApiKey` passwords. With no working provider, dedup is skipped and the recap is a plain list; nothing breaks. Opt-in live tests: `test/ai_live_test.dart`.
- `RecapFutureCall` re-broadcasts the recap 5 minutes after a session ends, scheduled inside a try/catch because future calls may be unavailable on some Cloud plans.
- Timer: `createSession(autoEnd: true)` schedules `SessionTimerFutureCall.autoEnd` via `services/session_lifecycle.dart`, which also owns `closeSessionAndRecap` (shared by End Session and the timer).
- Extras: `getMyVotes` (vote buttons survive reload), `getStats` (recap stats row).
- Tests: `test/integration/qa_flow_test.dart` (`dart test`); full live E2E in `askbytes_client/tool/e2e.dart`; demo data via `tool/seed_demo.dart`.

**Flutter web (`askbytes_flutter`)**
- `go_router` routes in `lib/router.dart`: `/`, `/signin`, `/dashboard`, `/session/create`, `/join/:code`, `/manage/:sessionId`, `/present/:sessionId`, `/recap/:sessionId`. Speaker routes redirect to `/signin` unless the server confirms a speaker.
- `LiveSessionController` (`lib/state/live_session.dart`) owns the stream subscription with exponential-backoff reconnect. `AuthState` (`lib/state/auth_state.dart`) caches the speaker check and does anonymous sign-in for attendees.
- `RankedList` animates re-ordering (FLIP) and insertion. Theme in `lib/theme.dart`.
- Google sign-in is hidden unless built with `--dart-define=GOOGLE_ENABLED=true` and the server has `googleClientSecret`.

**Deploy**: see `README.md`.
