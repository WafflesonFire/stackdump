-- Revert stackdump:insert_answer from pg

BEGIN;

DROP FUNCTION stackdump.insert_answer(INTEGER, INTEGER);

COMMIT;
