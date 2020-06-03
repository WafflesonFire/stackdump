-- Verify stackdump:appschema on pg

BEGIN;

SELECT pg_catalog.has_schema_privilege('stackdump', 'usage');

ROLLBACK;
