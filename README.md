# AskBytes

Real-time, AI-moderated audience Q&A for conference talks. Built end to end with Serverpod 4 and Flutter web for the FlutterBytes x Serverpod 2026 hackathon.

Attendees scan a QR code, join anonymously (no install, no account), post and upvote questions. Gemini embeddings merge near-duplicates, and when the speaker ends the session an AI recap is generated and pushed to every screen.

## Run it locally

```bash
# 1. Add AI keys to askbytes_server/config/passwords.yaml (git-ignored), under development:
#      geminiApiKey: '...'   # embeddings (dedup) + recap, free at aistudio.google.com/apikey
#      groqApiKey: '...'     # fallback if Gemini fails or is rate limited

# 2. Start server + Flutter app (applies migrations, embedded Postgres + pgvector)
cd askbytes
serverpod start
```

AI fallback chain: Gemini embeddings drive duplicate merging; if they fail, Groq judges duplicates against the session's top questions. Recaps try Gemini, then Groq, then a plain top-questions list. With no keys at all the app still works, just without merging or an AI recap.

Email sign-in codes are printed to the server console in development.

## Seed a demo session

```bash
cd askbytes_client
dart run tool/seed_demo.dart speaker@example.com 'password'   # speaker must already exist
```

## Tests

```bash
cd askbytes_server && dart test
```

Full end-to-end check against a running server (real DB and Gemini, takes about 2 minutes, `--fast` skips the timer test): `cd askbytes_client && dart run tool/e2e.dart <path-to-server-log>`; the log is read to pick up the email verification code.

Live checks against the real providers are opt-in: set `GEMINI_API_KEY` and `GROQ_API_KEY`, then run `dart test test/ai_live_test.dart`.

## Deploy to Serverpod Cloud

Full walkthrough (accounts, commands, secrets, checks, risks): [DEPLOY.md](DEPLOY.md).

Short version:

```bash
dart pub global activate serverpod_cloud_cli
scloud auth login                 # opens the browser, create your account here
cd askbytes_server
scloud launch                     # creates the project, builds the Flutter web app, deploys
scloud password set geminiApiKey YOUR_KEY
scloud password set groqApiKey YOUR_GROQ_KEY
scloud deploy --redeploy          # apply the secrets
```

## Rubric map

| Criterion | Where |
| --- | --- |
| Does it work | One flow end to end: QR/code join, post, live feed, upvote, AI merge, end, recap. `askbytes_server/test/integration/qa_flow_test.dart` covers the server side. |
| Serverpod stack | Streaming method `SessionEndpoint.listenToSession` + `session.messages` (`services/live_channel.dart`); ORM with relations (`models/*.spy.yaml`); native pgvector `Vector(768)` + cosine query (`QuestionEndpoint.postQuestion`); anonymous + email (+ Google) auth (`lib/server.dart`, `lib/src/auth/`); future call (`futures/recap_future_call.dart`); secrets via `session.passwords`; Flutter web served by the server. |
| Craft | FLIP re-ranking animation (`widgets/ranked_list.dart`), merge badge, projector mode (`/present/:id`), shareable recap (`/recap/:id`), auto-reconnecting stream. |
| Usefulness | Built for the 600+ attendee, 3-hall FlutterBytes format. |
| AI theme | All AI runs server side in Dart (`services/gemini_service.dart`); the API key never reaches the client. |

## Notes and deviations from the PRD

- The PRD's `Session` model is named `TalkSession` because `Session` collides with Serverpod's own class.
- Merged duplicates are not stored as separate rows. They increment the original's `voteCount` and `mergeCount`, and set `mergeNote`. This keeps the feed clean and drops the `isMerged`/`mergedIntoId` fields.
- Embeddings use the native pgvector column rather than JSON text, since Serverpod 4 supports it. Migrations create the extension and fail loudly if the database lacks it.
- Groq (`openai/gpt-oss-120b`, override with `groqModel`) is the fallback; it has no embeddings, so it covers recaps and LLM-judged duplicate detection only.
- Gemini models: the PRD's `text-embedding-004` and `gemini-1.5-flash` are retired. This uses `gemini-embedding-001` (768 dims) and `gemini-2.5-flash` (override with the `geminiModel` password).
- State management is a small `ChangeNotifier` rather than Riverpod; the app has one live controller and one auth object.
- P1 session timer: speakers can opt in to "Auto-end when time is up" (a future call ends the session and writes the recap). Off by default so a talk is never cut short by surprise.
- P1 analytics are a lightweight stats row on the recap (questions, votes, merged duplicates, people), not a full dashboard.
- Live at https://askbytes.serverpod.space (Serverpod Cloud starter). Future calls are unavailable on that plan, so the auto-end timer and the latecomer re-send do not run there; the create screen says so.
- The latecomer recap future call is best effort and silently skipped where future calls are unavailable.
