-- Revert stackdump:postHistoryTypes from pg

BEGIN;

DROP TABLE stackdump.postHistoryTypes;

COMMIT;
