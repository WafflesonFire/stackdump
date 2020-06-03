-- Deploy stackdump:votes to pg
-- requires: appschema
-- requires: posts
-- requires: users

BEGIN;

CREATE TABLE stackdump.votes(
id INTEGER PRIMARY KEY,
postId INTEGER REFERENCES stackdump.posts(id),
voteTypeId INTEGER REFERENCES stackdump.voteTypes(id),
userId INTEGER REFERENCES stackdump.users(id),
creationDate TIMESTAMP,
bountyAmount INTEGER
);

COMMIT;
