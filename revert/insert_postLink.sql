-- Revert stackdump:insert_postLink from pg

BEGIN;

DROP FUNCTION stackdump.insert_postLink(INTEGER, TIMESTAMP, INTEGER, INTEGER, INTEGER);

COMMIT;
