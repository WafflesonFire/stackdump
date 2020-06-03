-- Revert stackdump:tags from pg

BEGIN;

DROP TABLE stackdump.tags;

COMMIT;
