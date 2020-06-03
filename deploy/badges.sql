-- Deploy stackdump:badges to pg
-- requires: appschema
-- requires: users

BEGIN;

CREATE TABLE stackdump.badges(
id INTEGER PRIMARY KEY,
userId INTEGER REFERENCES stackdump.users(id),
name TEXT,
date TIMESTAMP,
class INTEGER,
tagBased BOOLEAN
);

COMMIT;
