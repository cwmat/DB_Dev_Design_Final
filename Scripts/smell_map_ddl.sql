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
    magnitude_weight        number(2, 2)    NOT NULL
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
    latitude                    number(3, 8)        NOT NULL,
    longitude                   number(3, 8)        NOT NULL,
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
    fips_code               char(8)             NOT NULL
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
    fips_code               char(8)             NOT NULL
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
--    POPULATE TABLES
--
-- Note:  Follow instructions and data provided on PS-3
--        to populate the tables
-- ******************************************************

/* inventory tbComponent */


/* inventory tbPart */


/* inventory tbProduct */


/* inventory tbQuote */


/* inventory tbShipment */


/* inventory tbVendor */


-- ******************************************************
--    VIEW TABLES
--
-- Note:  Issue the appropiate commands to show your data
-- ******************************************************

SELECT * FROM tbComponent;
SELECT * FROM tbPart;
SELECT * FROM tbProduct;
SELECT * FROM tbQuote;
SELECT * FROM tbShipment;
SELECT * FROM tbVendor;


-- ******************************************************
--    QUALITY CONTROLS
--
-- Note:  Test only 2 constraints of each of
--        the following types:
--        *) Entity integrity
--        *) Referential integrity
--        *) Column constraints
-- ******************************************************


-- ******************************************************
--    END SESSION
-- ******************************************************

spool off

