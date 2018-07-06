-- ******************************************************
-- smell_map_ddl.sql 
--
-- Loader for the Smell Map Database
--
-- Description:	This script contains the DDL to load
--              the tables of the
--              SMELL_MAP database
--
-- There are 7 tables in this DB
--
-- Author:  Charles Mateer
--
-- Student:  Charles Mateer cmateer@g.harvard.edu
--
-- Date:   November, 2017
--
-- ******************************************************

-- ******************************************************
--    SPOOL SESSION
-- ******************************************************

spool smell_map_ddl.lst


-- ******************************************************
--    DROP TABLES
-- Note:  Issue the appropiate commands to drop tables
-- ******************************************************

DROP TABLE subscription_log purge;
DROP TABLE comment_log purge;
DROP TABLE smell_profile purge;
DROP TABLE smellscape purge;
DROP TABLE smell_magnitude purge;
DROP TABLE smell_type purge;
DROP TABLE user_account purge;

-- ******************************************************
--    DROP SEQUENCES
-- Note:  Issue the appropiate commands to drop sequences.
--        Ensure that children are dropped before parents.
-- ******************************************************

DROP SEQUENCE sequence_comment_log;
DROP SEQUENCE sequence_subscription_log;
DROP SEQUENCE sequence_smell_profile;
DROP SEQUENCE sequence_user;


-- ******************************************************
--    CREATE TABLES
-- ******************************************************

-- TODO: Research hashing in Oracle
-- https://docs.oracle.com/cd/B28359_01/server.111/b28286/functions112.htm#SQLRF06313
-- https://stackoverflow.com/questions/11075452/does-oracle-have-any-built-in-hash-function
-- Maybe add date of creation
CREATE TABLE user_account (
    user_id         number(11, 0)       NOT NULL
        CONSTRAINT pk_user_account PRIMARY KEY,
    first_name      varchar2(256)       NOT NULL,
    last_name       varchar2(256)       NOT NULL,
    username        varchar2(20)        NOT NULL,
    email           varchar2(256)       NOT NULL,
    user_password   varchar2(256)       NOT NULL
);


-- TODO: Note change in Type ID to numercial char vs letter char
-- TODO: Note change in field names (throughout)
CREATE TABLE smell_type (
    type_id                 char(2)         NOT NULL
        CONSTRAINT pk_smell_type PRIMARY KEY,
        CONSTRAINT rg_smell_type CHECK (type_id BETWEEN '01' AND '03'),
    type_description        varchar2(7)     NOT NULL
);

CREATE TABLE smell_magnitude (
    magnitude_id            char(2)         NOT NULL
        CONSTRAINT pk_smell_magnitude PRIMARY KEY,
        CONSTRAINT rg_smell_magnitude CHECK (magnitude_id BETWEEN '01' AND '10'),
    magnitude_description   varchar2(50)    NOT NULL,
    magnitude_weight        number(2, 1)    NOT NULL
);

-- TODO: Review JSON in Oracle
-- https://oracle-base.com/articles/12c/json-support-in-oracle-database-12cr1#introduction-to-json
-- TODO: update for actual FIPS codes for Richmond blocks
-- TODO: Research spatial within:
-- https://en.wikipedia.org/wiki/Point_in_polygon#Ray_casting_algorithm
-- https://automating-gis-processes.github.io/2016/Lesson3-point-in-polygon.html
-- TODO: Figure out max character length of GeoJSON I plan to use and change length for feature_geom
-- TODO: Review delete methods
CREATE TABLE smellscape (
    fips_code               char(15)             NOT NULL
        CONSTRAINT pk_smellscape PRIMARY KEY,
    feature_geometry        SDO_GEOMETRY      NOT NULL
);


-- TODO: Research dual PKs here and what I was thinking inititally with smellscape_id
-- TODO: Researh oracle numebr type and how I want to represent coords
CREATE TABLE smell_profile (
    fips_code               char(15)             NOT NULL
        CONSTRAINT fk_fips_code_smell_profile REFERENCES smellscape (fips_code) ON DELETE CASCADE,
    user_id                     number(11, 0)       NOT NULL
        CONSTRAINT fk_user_id_smell_profile REFERENCES user_account (user_id) ON DELETE SET NULL,
    latitude                    number(21, 17)        NOT NULL,
    longitude                   number(21, 17)        NOT NULL,
    feature_geometry            SDO_GEOMETRY        NOT NULL,
    type_id                     char(2)             NOT NULL
        CONSTRAINT rg_smell_type_profile CHECK (type_id BETWEEN '01' AND '03')
        CONSTRAINT fk_type_id_smell_profile REFERENCES smell_type (type_id) ON DELETE SET NULL,
    magnitude_id                char(2)             NOT NULL
        CONSTRAINT rg_smell_magnitude_profile CHECK (magnitude_id BETWEEN '01' AND '10')
        CONSTRAINT fk_magnitude_id_smell_profile REFERENCES smell_magnitude (magnitude_id) ON DELETE SET NULL,
    open_description            varchar2(1000)      NULL,
        CONSTRAINT pk_smell_profile PRIMARY KEY (fips_code, user_id)
);


CREATE TABLE comment_log (
    comment_id              number(11, 0)       NOT NULL
        CONSTRAINT pk_comment_log PRIMARY KEY,
    user_id                 number(11, 0)       NOT NULL
        CONSTRAINT fk_user_id_comment_log REFERENCES user_account (user_id) ON DELETE CASCADE,
    fips_code               char(15)             NOT NULL
        CONSTRAINT fk_fips_code_comment_log REFERENCES smellscape (fips_code) ON DELETE CASCADE,
    comment_date            date                default CURRENT_DATE    NULL,
    comment_desc                 varchar2(1000)      NOT NULL
);

-- Note change in PK name
-- TODO: These actually need to be after Smellscape, smellscape should not have fields for comment/subs
CREATE TABLE subscription_log (
    subscription_id              number(11, 0)       NOT NULL
        CONSTRAINT pk_subscription_log PRIMARY KEY,
    user_id                 number(11, 0)       NOT NULL
        CONSTRAINT fk_user_id_subscription_log REFERENCES user_account (user_id) ON DELETE CASCADE,
    fips_code               char(15)             NOT NULL
        CONSTRAINT fk_fips_code_subscription_log REFERENCES smellscape (fips_code) ON DELETE CASCADE,
    subscription_date            date                default CURRENT_DATE    NULL
);



-- ******************************************************
--    CREATE SEQUENCES
-- ******************************************************

CREATE SEQUENCE sequence_user
    INCREMENT BY 1
    START WITH 1;

CREATE SEQUENCE sequence_smell_profile
    INCREMENT BY 1
    START WITH 1;

CREATE SEQUENCE sequence_subscription_log
    INCREMENT BY 1
    START WITH 1;

CREATE SEQUENCE sequence_comment_log
    INCREMENT BY 1
    START WITH 1;
    

-- ******************************************************
--    Create Triggers
-- ******************************************************

/* user_account Auto-number PK */
CREATE OR REPLACE trigger tr_new_user_in

    BEFORE INSERT ON  user_account

    FOR EACH ROW

    BEGIN

        SELECT sequence_user.nextval
            INTO :new.user_id
            FROM dual;

    END tr_new_user_in;
/

/* comment_log Auto-number PK and current date */
CREATE OR REPLACE TRIGGER tr_new_comment_in

    BEFORE INSERT ON comment_log

    FOR EACH ROW

    BEGIN

        SELECT sequence_comment_log.nextval, SYSDATE
        INTO :new.comment_id, :new.comment_date
        FROM dual;

    END tr_new_comment_in;
/

/* subscription_log Auto-number PK and current date */
CREATE OR REPLACE TRIGGER tr_new_subscription_in

    BEFORE INSERT ON subscription_log
    
    FOR EACH ROW

    BEGIN

        SELECT sequence_subscription_log.nextval, SYSDATE
        INTO :new.subscription_id, :new.subscription_date
        FROM dual;

    END tr_new_subscription_in;
/


-- ******************************************************
--    Create Stored Procedures
-- ******************************************************

-- TODO: Add hasing either trigger or stored proc (hould be proc i think)
-- TODO: Add generic error message for failure on all to catch edge cases such as too many cahracters or something.  Will have more specific validation in tirggers and other procs.  
/* user_account basic input */
CREATE OR REPLACE PROCEDURE new_user_account
    (
        FIRST_NAME_IN IN user_account.first_name%TYPE,
        LAST_NAME_IN IN user_account.last_name%TYPE,
        USERNAME_IN IN user_account.username%TYPE,
        EMAIL_IN IN user_account.email%TYPE,
        USER_PASSWORD_IN IN user_account.user_password%TYPE
    )
IS

BEGIN
    INSERT INTO user_account values (
        1, -- Trigger will supercede
        FIRST_NAME_IN,
        LAST_NAME_IN,
        USERNAME_IN,
        EMAIL_IN,
        USER_PASSWORD_IN
    );

    COMMIT;

END new_user_account;
/

SHOW ERRORS


/* smell_type basic input */
CREATE OR REPLACE PROCEDURE new_smell_type
    (
        TYPE_ID_IN IN smell_type.type_id%TYPE,
        TYPE_DESC_IN IN smell_type.type_description%TYPE
    )

IS

BEGIN
    INSERT INTO smell_type values (
        TYPE_ID_IN,
        TYPE_DESC_IN
    );

    COMMIT;

END new_smell_type;
/

SHOW ERRORS


/* smell_magnitude basic input */
CREATE OR REPLACE PROCEDURE new_smell_magnitude
    (
        MAGNITUDE_ID_IN IN smell_magnitude.magnitude_id%TYPE,
        MAGNITUDE_DESC_IN IN smell_magnitude.magnitude_description%TYPE,
        MAGNITUDE_WEIGHT_IN IN smell_magnitude.magnitude_weight%TYPE
    )
IS

BEGIN
    INSERT INTO smell_magnitude values (
        MAGNITUDE_ID_IN,
        MAGNITUDE_DESC_IN,
        MAGNITUDE_WEIGHT_IN
    );

    COMMIT;

END new_smell_magnitude;
/

SHOW ERRORS



/* smell_profile basic input */
-- TODO: Spatial WITHIN to get FIPS and also need to calc feature geom.
CREATE OR REPLACE PROCEDURE new_smell_profile
    (
        -- FIPS_CODE_IN IN smell_profile.fips_code%TYPE,
        USER_IN IN smell_profile.user_id%TYPE,
        LATITUDE_IN IN smell_profile.latitude%TYPE,
        LONGITUDE_IN IN smell_profile.longitude%TYPE,
        -- FEATURE_IN IN smell_profile.feature_geometry%TYPE,
        TYPE_IN IN smell_profile.type_id%TYPE,
        MAGNITUDE_IN IN smell_profile.magnitude_id%TYPE,
        DESCRIPTION_IN IN smell_profile.open_description%TYPE
    )

IS
    matching_fips smell_profile.fips_code%TYPE;
    feature smell_profile.feature_geometry%TYPE;
    LONG_STRING varchar2(20);
    LAT_STRING varchar2(20);
    NEW_GEOM varchar2(100);
    CHECK_CONSTRAINT_VIOLATED EXCEPTION;

BEGIN
    SAVEPOINT start_new_smell_profile;
    -- Form geom
    SELECT CAST (LONGITUDE_IN AS varchar2 (20)) INTO LONG_STRING FROM dual;
    SELECT CAST (LATITUDE_IN AS varchar2 (20)) INTO LAT_STRING FROM dual;
    -- LONG_STRING := CAST (LONGITUDE_IN AS varchar2 (20));
    -- LAT_STRING := CAST (LATITUDE_IN AS varchar2 (20));
    NEW_GEOM := 'POINT(' || LONG_STRING || ' ' || LAT_STRING || ')';

    feature := SDO_GEOMETRY(NEW_GEOM, 8307);

    -- Spatial query select FIPS of within (should only be one)
    -- TODO, if time add error handling for null return.
    SELECT smellscape.fips_code INTO matching_fips
        FROM smellscape
        WHERE SDO_CONTAINS (smellscape.feature_geometry,
                            feature
                            ) = 'TRUE';

    -- Insert
    INSERT INTO smell_profile values (
        matching_fips,
        USER_IN,
        LATITUDE_IN,
        LONGITUDE_IN,
        feature, -- TODO: Calc from above
        TYPE_IN,
        MAGNITUDE_IN,
        DESCRIPTION_IN
    );

    COMMIT;

    EXCEPTION
        WHEN CHECK_CONSTRAINT_VIOLATED THEN
            dbms_output.put_line('This smell-profile failed to load, there may have been a constraint error.');
            ROLLBACK TO start_new_smell_profile;
        WHEN OTHERS THEN
            dbms_output.put_line('This smell-profile failed to load, the geometry was possibly out of bounds - see documentation for explaination.');
            ROLLBACK TO start_new_smell_profile;

END new_smell_profile;
/

SHOW ERRORS


/* comment_log basic input */
CREATE OR REPLACE PROCEDURE new_comment_log
    (
        USER_IN IN comment_log.user_id%TYPE,
        FIPS_CODE_IN IN comment_log.fips_code%TYPE,
        COMMENT_DESC_IN IN comment_log.comment_desc%TYPE
    )
IS

BEGIN
    INSERT INTO comment_log values (
        1, -- PK overwritten by trigger
        USER_IN,
        FIPS_CODE_IN,
        '01-NOV-17', -- Date overwritten by trigger
        COMMENT_DESC_IN
    );

END new_comment_log;
/

SHOW ERRORS



/* subscription_log basic input */
CREATE OR REPLACE PROCEDURE new_subscription_log
    (
        USER_IN IN subscription_log.user_id%TYPE,
        FIPS_CODE_IN IN comment_log.fips_code%TYPE
    )
IS

BEGIN
    INSERT INTO subscription_log values (
        1, -- PK overwritten by trigger
        USER_IN,
        FIPS_CODE_IN,
        '01-NOV-17' -- Date overwritten by trigger
    );

END new_subscription_log;
/

SHOW ERRORS




-- ******************************************************
--    END SESSION
-- ******************************************************

spool off

