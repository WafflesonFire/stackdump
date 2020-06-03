-- Verify stackdump:insert_vote on pg

BEGIN;

SELECT has_function_privilege('stackdump.insert_vote(INTEGER, INTEGER, INTEGER, INTEGER, TIMESTAMP, INTEGER)', 'execute');

ROLLBACK;