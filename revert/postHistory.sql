-- Revert stackdump:postHistory from pg

BEGIN;

DROP TABLE stackdump.postHistory;

COMMIT;
