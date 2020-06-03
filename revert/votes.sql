-- Revert stackdump:votes from pg

BEGIN;

DROP TABLE stackdump.votes;

COMMIT;
