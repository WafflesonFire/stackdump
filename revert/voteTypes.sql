-- Revert stackdump:voteTypes from pg

BEGIN;

DROP TABLE stackdump.voteTypes;

COMMIT;
