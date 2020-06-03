-- Deploy stackdump:postTypes to pg
-- requires: appschema

BEGIN;

CREATE TABLE stackdump.postTypes(
    id INT PRIMARY KEY,
    name TEXT NOT NULL
);

INSERT INTO stackdump.postTypes(id, name) VALUES
(1, 'Question'),
(2, 'Answer'),
(3, 'Orphaned tag wiki'),
(4, 'Tag wiki excerpt'),
(5, 'Tag wiki'),
(6, 'Moderator nomination'),
(7, 'Wiki placeholder'),
(8, 'Privilege wiki');

COMMIT;
