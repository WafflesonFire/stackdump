-- Deploy stackdump:posts to pg
-- requires: appschema
-- requires: postTypes
-- requires: users

BEGIN;

CREATE TABLE stackdump.posts(
id INTEGER PRIMARY KEY,
postTypeId INTEGER REFERENCES stackdump.postTypes(id),
acceptedAnswerId INTEGER REFERENCES stackdump.posts(id),
creationDate TIMESTAMP,
score INTEGER,
viewCount INTEGER,
body TEXT,
ownerUserId INTEGER REFERENCES stackdump.users(id),
ownerDisplayName TEXT,
lastEditorUserId INTEGER REFERENCES stackdump.users(id),
lastEditDate TIMESTAMP,
lastActivityDate TIMESTAMP,
title TEXT,
tags TEXT,
answerCount INTEGER,
commentCount INTEGER,
favoriteCount INTEGER
);

COMMIT;
