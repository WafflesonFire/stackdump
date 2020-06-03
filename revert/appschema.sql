-- Revert stackdump:appschema from pg

BEGIN;

DROP SCHEMA stackdump;

COMMIT;
