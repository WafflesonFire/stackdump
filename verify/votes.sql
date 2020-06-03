-- Verify stackdump:votes on pg

BEGIN;

SELECT id, postId, voteTypeId
    FROM stackdump.votes
    WHERE FALSE;

ROLLBACK;
