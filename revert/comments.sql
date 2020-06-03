-- Revert stackdump:comments from pg

BEGIN;

DROP TABLE stackdump.comments;

COMMIT;
