-- Revert stackdump:posts from pg

BEGIN;

DROP TABLE stackdump.posts;

COMMIT;
