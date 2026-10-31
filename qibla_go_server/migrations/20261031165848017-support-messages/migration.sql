BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "support_message" (
    "id" bigserial PRIMARY KEY,
    "message" text NOT NULL,
    "contact" text,
    "platform" text,
    "appVersion" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "handledAt" timestamp without time zone
);

-- Indexes
CREATE INDEX "support_message_created_idx" ON "support_message" USING btree ("createdAt");


--
-- MIGRATION VERSION FOR qibla_go
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('qibla_go', '20261031165848017-support-messages', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261031165848017-support-messages', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();


COMMIT;
