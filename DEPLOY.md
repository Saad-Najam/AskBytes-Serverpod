# Deploying AskBytes to Serverpod Cloud

Everything below was checked against `scloud` 1.2.0 (`scloud --help`) and the Serverpod Cloud docs. The only parts not tested here are the ones that need your Serverpod Cloud account: logging in, creating the project, and the actual rollout.

## 0. What you need

- A Serverpod Cloud account (created in the browser the first time you log in, see step 2).
- Flutter and Dart on your PATH. The deploy builds the Flutter web app on your machine first.
- A Gemini API key (https://aistudio.google.com/apikey). A Groq key (https://console.groq.com/keys) is optional, as a fallback.
- Optional, for Google sign-in: a Google Cloud OAuth client (see "Google sign-in" below).

## 1. Install the CLI

```bash
dart pub global activate serverpod_cloud_cli
scloud --version
```

If `scloud` is not found, add the pub cache `bin` folder to PATH (`%LOCALAPPDATA%\Pub\Cache\bin` on Windows).

## 2. Create your account and log in

```bash
scloud auth login
```

This opens your browser. Sign up there (Serverpod Cloud's web console handles accounts, billing and project dashboards), then return to the terminal. The docs say the first project has a one-month free trial and does not need a credit card. Check the current plans and prices at https://serverpod.dev/cloud before you pick one, because I could not confirm them.

## 3. Launch (first deploy)

```bash
cd askbytes/askbytes_server
scloud launch
```

It walks you through:

1. **Project**: it opens the browser console to create one. The project ID is pre-filled from the package name; pick `askbytes` if it is free, otherwise anything unique. Your public URLs are derived from it:
   - Web app: `https://<id>.serverpod.space/`
   - API: `https://<id>.api.serverpod.space/`
2. **Plan and database**: pick the plan and keep the database **on** (AskBytes needs Postgres).
3. **Pre-deploy hooks**: accept. It adds `serverpod generate` and `serverpod run flutter_build`, so the Flutter web app is built and bundled into the server before upload.
4. **Passwords**: it offers to upload entries from `config/passwords.yaml`. Only the `production` and `shared` ones are preselected, so your AI keys (under `development`) are **not** uploaded. Set them in step 4.
5. It writes `scloud.yaml`, then uploads, builds and rolls out. Wait for "rollout" to succeed.

Later updates are just `scloud deploy`.

## 4. Set the secrets

```bash
scloud password set geminiApiKey YOUR_GEMINI_KEY
scloud password set groqApiKey YOUR_GROQ_KEY        # optional fallback
scloud deploy --redeploy                             # apply secrets to the running build
```

Never commit keys. `config/passwords.yaml` is git-ignored.

## 5. Check it

1. Open `https://<id>.serverpod.space/`. You should see the AskBytes landing page.
2. Open `https://<id>.serverpod.space/assets/assets/config.json`. It must show `"apiUrl"` pointing at your real API host (`https://<id>.api.serverpod.space`). If it shows `examplepod.com`, edit the three `publicHost` values in `config/production.yaml` to your real hosts and run `scloud deploy`.
3. Sign up as a speaker (the email code is sent through Serverpod Cloud's email service in production), create a session, scan the QR with a phone, post two similar questions and watch them merge.
4. Optionally seed a demo session: `cd askbytes_client && dart run tool/seed_demo.dart you@example.com 'password' https://<id>.api.serverpod.space/`.

## Deployed and verified

Deployed as project `askbytes` on the starter plan: web `https://askbytes.serverpod.space`, API `https://askbytes.api.serverpod.space`. The full end-to-end suite (`askbytes_client/tool/e2e.dart --url ... --login ...`) passes against it: real Gemini, the pgvector merge query, live streaming, votes, recap and stats. `config.json` already points at the real API host, so `production.yaml` needed no change. Findings on the starter plan:

- pgvector works (the migration applied).
- Future calls are **not available** (`FutureCalls is not initialized`). The auto-end timer cannot run there; the create screen now tells the speaker and they end the session manually. The 5-minute latecomer re-send is skipped silently.
- `scloud launch` is interactive only. For scripts use `scloud project create`, `scloud password set` and `scloud deploy` (the build script `serverpod run flutter_build` must run first so `web/app` is fresh).

## Known risks (not testable without a Cloud account)

- **pgvector** (verified working on starter): the first migration runs `CREATE EXTENSION vector`. If Cloud's Postgres does not offer it, the deploy fails at migration time with "Required extension vector is not available". Tell me and I will switch embeddings to a JSON column with cosine similarity computed in Dart (the PRD's fallback).
- **Future calls** (auto-end timer and the 5-minute recap re-send) may be disabled on the starter plan. The app handles that: End Session still works, and the timer simply never fires.
- **Streaming/WebSockets** should work over TLS on Cloud. If live updates stall in production, the app reconnects automatically and re-sends a snapshot.

## Google sign-in (optional)

1. Go to https://console.cloud.google.com, create a project, then APIs & Services, OAuth consent screen (External, add yourself as a test user).
2. Credentials, Create credentials, OAuth client ID, type **Web application**. Add `https://<id>.serverpod.space` as an authorized JavaScript origin and the redirect URIs from Serverpod's Google guide: https://docs.serverpod.dev/concepts/authentication/providers/google/setup
3. Download the client JSON, then:
   ```bash
   scloud password set googleClientSecret '<paste the whole JSON on one line>'
   ```
4. Rebuild the web app with the flag, then deploy: add `--dart-define=GOOGLE_ENABLED=true` to the Flutter build (edit the `flutter_build` script in `askbytes_server/pubspec.yaml`), and run `scloud deploy`.

Without these steps email sign-in works and the Google button stays hidden.

## Submission checklist (hackathon)

- Live URL: `https://<id>.serverpod.space`
- Project ID: the `<id>` from step 3
- Demo video under 2 minutes (script is in the PRD)
- README rubric map: `README.md`
