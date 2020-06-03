-- Revert stackdump:postLinks from pg

BEGIN;

DROP TABLE stackdump.postlinks;

COMMIT;
