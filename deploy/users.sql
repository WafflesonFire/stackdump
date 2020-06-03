-- Deploy stackdump:users to pg
-- requires: appschema

BEGIN;

CREATE TABLE stackdump.users(
id INTEGER PRIMARY KEY,
reputation INTEGER,
creationDate TIMESTAMP,
displayName TEXT,
lastAccessDate TIMESTAMP,
websiteUrl TEXT,
location TEXT,
aboutMe TEXT,
views INTEGER,
upVotes INTEGER,
downVotes INTEGER,
profileImageUrl TEXT,
accountId INTEGER
);

COMMIT;
