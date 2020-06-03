-- Verify stackdump:comments on pg

BEGIN;

SELECT id, postId, score
    FROM stackdump.comments
    WHERE FALSE;

ROLLBACK;
