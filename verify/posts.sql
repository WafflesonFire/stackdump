-- Verify stackdump:posts on pg

BEGIN;

SELECT id, postTypeId, acceptedAnswerId
    FROM stackdump.posts
    WHERE FALSE;

ROLLBACK;
