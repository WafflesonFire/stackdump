-- Verify stackdump:postHistory on pg

BEGIN;

SELECT id, postHistoryTypeId, postId
    FROM stackdump.postHistory
    WHERE FALSE;

ROLLBACK;
