-- Deploy stackdump:insert_vote to pg
-- requires: appschema
-- requires: votes

BEGIN;

CREATE OR REPLACE FUNCTION stackdump.insert_vote(
    id INTEGER,
    postId INTEGER,
    voteTypeId INTEGER,
    userId INTEGER,
    creationDate TIMESTAMP,
    bountyAmount INTEGER
) RETURNS VOID LANGUAGE PLPGSQL AS $$
    BEGIN
    INSERT INTO stackdump.votes VALUES($1, $2, $3, $4, $5, $6);
    EXCEPTION
        WHEN foreign_key_violation THEN
            RAISE NOTICE 'Caught fk violation: ';
            IF (SELECT NOT EXISTS(SELECT 1 FROM stackdump.posts WHERE posts.id = $2) AND $2 IS NOT NULL) THEN
                $2 := NULL;
                RAISE NOTICE 'Invalid postId on vote with id = (%)', $1;
            END IF;
            IF (SELECT NOT EXISTS(SELECT 1 FROM stackdump.voteTypes WHERE voteTypes.id = $3) AND $3 IS NOT NULL) THEN
                $3 := NULL;
                RAISE NOTICE 'Invalid voteTypeId on vote with id = (%)', $1;
            END IF;
            IF (SELECT NOT EXISTS(SELECT 1 FROM stackdump.users WHERE users.id = $4) AND $4 IS NOT NULL) THEN
                $4 := NULL;
                RAISE NOTICE 'Invalid userId on vote with id = (%)', $1;
            END IF;
            INSERT INTO stackdump.votes VALUES($1, $2, $3, $4, $5, $6);
    END;
$$;

COMMIT;
