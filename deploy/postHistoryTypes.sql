-- Deploy stackdump:postHistoryTypes to pg
-- requires: appschema

BEGIN;

CREATE TABLE stackdump.postHistoryTypes(
    id INT PRIMARY KEY,
    name TEXT NOT NULL
);

INSERT INTO stackdump.postHistoryTypes(id, name) VALUES
(1, 'Initial Title'),
(2, 'Initial Body'),
(3, 'Initial Tags'),
(4, 'Edit Title'),
(5, 'Edit Body'),
(6, 'Edit Tags'),
(7, 'Rollback Title'),
(8, 'Rollback Body'),
(9, 'Rollback Tags'),
(10, 'Post Closed'),
(11, 'Post Reopened'),
(12, 'Post Deleted'),
(13, 'Post Undeleted'),
(14, 'Post Locked'),
(15, 'Post Unlocked'),
(16, 'Community Owned'),
(17, 'Post Migrated'),
(18, 'Question Merged'),
(19, 'Question Protected'),
(20, 'Question Unprotected'),
(21, 'Post Disassociated'),
(22, 'Question Unmerged'),
(23, 'Unknown dev related event'),
(24, 'Suggested Edit Approved'),
(25, 'Post Tweeted'),
(26, 'Vote nullification by dev'),
(27, 'Moderator migration'),
(28, 'Suggestion event'),
(29, 'Moderator event'),
(30, 'Unknown event'),
(31, 'Comment discussion moved to chat'),
(33, 'Post notice added'),
(34, 'Post notice removed'),
(35, 'Post migrated away'),
(36, 'Post migrated here'),
(37, 'Post merge source'),
(38, 'Post merge destination'),
(50, 'Bumped by Community User'),
(52, 'Question became hot network question'),
(53, 'Question removed from hot network questions by a moderator');

COMMIT;
