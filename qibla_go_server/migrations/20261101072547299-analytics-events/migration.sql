BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "analytics_event" (
    "id" bigserial PRIMARY KEY,
    "receivedAt" timestamp without time zone NOT NULL,
    "occurredAt" timestamp without time zone NOT NULL,
    "sessionId" text NOT NULL,
    "name" text NOT NULL,
    "platform" text NOT NULL,
    "appVersion" text,
    "language" text,
    "screen" text,
    "fromScreen" text,
    "durationMs" bigint,
    "outcome" text
);

-- Indexes
CREATE INDEX "analytics_event_name_time_idx" ON "analytics_event" USING btree ("name", "occurredAt");
CREATE INDEX "analytics_event_received_idx" ON "analytics_event" USING btree ("receivedAt");
CREATE INDEX "analytics_event_session_idx" ON "analytics_event" USING btree ("sessionId");


--
-- MIGRATION VERSION FOR qibla_go
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('qibla_go', '20261101072547299-analytics-events', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261101072547299-analytics-events', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();


COMMIT;
