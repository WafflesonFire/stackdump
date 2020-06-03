-- Revert stackdump:postTypes from pg

BEGIN;

DROP TABLE stackdump.postTypes;

COMMIT;
