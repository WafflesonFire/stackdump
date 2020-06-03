-- Revert stackdump:insert_vote from pg

BEGIN;

DROP FUNCTION stackdump.insert_vote(INTEGER, INTEGER, INTEGER, INTEGER, TIMESTAMP, INTEGER);

COMMIT;
