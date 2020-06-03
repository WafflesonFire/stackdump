-- Revert stackdump:insert_tag from pg

BEGIN;

DROP FUNCTION stackdump.insert_tag(INTEGER, TEXT, INTEGER, INTEGER, INTEGER);

COMMIT;
