-- ******************************************************
-- smell_map_stored_proc.sql 
--
-- Loader for the Smell Map Database
--
-- Description:	This script contains stored procedures.
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

spool smell_map_stored_proc.lst


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


/* smellscape basic input */
-- need to add an in and out here
-- TODO:  Set in to WKT OUT to SDO - DOne, should remove this though as users should not be able to add to this.
-- CREATE OR REPLACE PROCEDURE new_smellscape
--     (
--         FIPS_CODE_IN IN smellscape.fips_code%TYPE,
--         FEATURE_IN IN smellscape.feature_geometry%TYPE
--     )

-- BEGIN
--     INSERT INTO smellscape values (
--         FIPS_CODE_IN,
--         SDO_UTIL.FROM_WKTGEOMETRY (FEATURE_IN)
--     );

-- END new_smellscape;
-- /

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




-- When spatial queries are necessary



-- ******************************************************
-- ******************************************************
-- ******************************************************
-- ******************************************************
-- ******************************************************
--    Added to main DDL - only use this file for testing
-- ******************************************************
-- ******************************************************
-- ******************************************************
-- ******************************************************





-- ******************************************************
--    END SESSION
-- ******************************************************

spool off