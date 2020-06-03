-- Revert stackdump:insert_postHistory from pg

BEGIN;

DROP FUNCTION stackdump.insert_postHistory(INTEGER, INTEGER, INTEGER, TEXT, TIMESTAMP, INTEGER, TEXT, TEXT, TEXT);

COMMIT;
