-- Deploy stackdump:postLinks to pg
-- requires: appschema
-- requires: posts

BEGIN;

CREATE TABLE stackdump.postlinks(
id INTEGER PRIMARY KEY,
creationDate TIMESTAMP,
postId INTEGER REFERENCES stackdump.posts(id),
relatedPostId INTEGER REFERENCES stackdump.posts(id),
linkTypeId INTEGER
);

COMMIT;
