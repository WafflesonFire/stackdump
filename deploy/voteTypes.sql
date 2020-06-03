-- Deploy stackdump:voteTypes to pg
-- requires: appschema

BEGIN;

CREATE TABLE stackdump.voteTypes(
    id INT PRIMARY KEY,
    name TEXT NOT NULL
);

INSERT INTO stackdump.voteTypes(id, name) VALUES
(1, 'AcceptedByOriginator'),
(2, 'UpMod'),
(3, 'DownMod'),
(4, 'Offensive'),
(5, 'Favorite'),
(6, 'Close'),
(7, 'Reopen'),
(8, 'BountyStart'),
(9, 'BountyClose'),
(10, 'Deletion'),
(11, 'Undeletion'),
(12, 'Spam'),
(15, 'ModeratorReview'),
(16, 'ApproveEditSuggestion');

COMMIT;
