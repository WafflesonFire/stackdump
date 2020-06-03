-- Revert stackdump:insert_badge from pg

BEGIN;

DROP FUNCTION stackdump.insert_badge(INTEGER, INTEGER, TEXT, TIMESTAMP, INTEGER, BOOLEAN);

COMMIT;
