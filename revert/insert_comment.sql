-- Revert stackdump:insert_comment from pg

BEGIN;

DROP FUNCTION stackdump.insert_comment(INTEGER, INTEGER, INTEGER, TEXT, TIMESTAMP, INTEGER);

COMMIT;
