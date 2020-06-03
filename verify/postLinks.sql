-- Verify stackdump:postLinks on pg

BEGIN;

SELECT id, creationDate, postId
    FROM stackdump.postLinks
    WHERE FALSE;

ROLLBACK;
