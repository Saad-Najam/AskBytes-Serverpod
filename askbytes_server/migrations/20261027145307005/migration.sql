BEGIN;

--
-- CREATE VECTOR EXTENSION IF AVAILABLE
--
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_available_extensions WHERE name = 'vector') THEN
    EXECUTE 'CREATE EXTENSION IF NOT EXISTS vector';
  ELSE
    RAISE EXCEPTION 'Required extension "vector" is not available on this instance. Please install pgvector. For instructions, see https://docs.serverpod.dev/upgrading/upgrade-to-pgvector.';
  END IF;
END
$$;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "event" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "description" text,
    "ownerId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "question" (
    "id" bigserial PRIMARY KEY,
    "sessionId" bigint NOT NULL,
    "text" text NOT NULL,
    "voteCount" bigint NOT NULL DEFAULT 0,
    "embedding" vector(768),
    "mergeCount" bigint NOT NULL DEFAULT 0,
    "mergeNote" text,
    "pinned" boolean NOT NULL DEFAULT false,
    "postedById" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "question_session_idx" ON "question" USING btree ("sessionId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "session_recap" (
    "id" bigserial PRIMARY KEY,
    "sessionId" bigint NOT NULL,
    "summaryMarkdown" text NOT NULL,
    "keyThemes" json NOT NULL,
    "topQuestions" text NOT NULL,
    "unanswered" json NOT NULL,
    "generatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "session_recap_session_idx" ON "session_recap" USING btree ("sessionId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "talk_session" (
    "id" bigserial PRIMARY KEY,
    "eventId" bigint,
    "title" text NOT NULL,
    "speakerName" text NOT NULL,
    "description" text,
    "durationMinutes" bigint,
    "speakerId" uuid NOT NULL,
    "joinCode" text NOT NULL,
    "status" text NOT NULL DEFAULT 'active'::text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "endedAt" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "talk_session_join_code_idx" ON "talk_session" USING btree ("joinCode");
CREATE INDEX "talk_session_speaker_idx" ON "talk_session" USING btree ("speakerId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "vote" (
    "id" bigserial PRIMARY KEY,
    "questionId" bigint NOT NULL,
    "voterToken" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "vote_unique_voter_idx" ON "vote" USING btree ("questionId", "voterToken");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "question"
    ADD CONSTRAINT "question_fk_0"
    FOREIGN KEY("sessionId")
    REFERENCES "talk_session"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "session_recap"
    ADD CONSTRAINT "session_recap_fk_0"
    FOREIGN KEY("sessionId")
    REFERENCES "talk_session"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "talk_session"
    ADD CONSTRAINT "talk_session_fk_0"
    FOREIGN KEY("eventId")
    REFERENCES "event"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "vote"
    ADD CONSTRAINT "vote_fk_0"
    FOREIGN KEY("questionId")
    REFERENCES "question"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR askbytes
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('askbytes', '20261027145307005', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261027145307005', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260924105404509', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105404509', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260924105232991', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105232991', "timestamp" = now();


COMMIT;
