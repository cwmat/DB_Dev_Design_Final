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

BEGIN
    INSERT INTO user_account values (
        1, -- Trigger will supercede
        FIRST_NAME_IN,
        LAST_NAME_IN,
        USERNAME_IN,
        EMAIL_IN,
        USER-PASSWORD_IN
    );

END new_user_account;
/

/* smell_type basic input */
CREATE OR REPLACE PROCEDURE new_smell_type
    (
        TYPE_ID_IN IN smell_type.type_id%TYPE,
        TYPE_DESC_IN IN smell_type.type_description%TYPE
    )

BEGIN
    INSERT INTO smell_type values (
        TYPE_ID_IN,
        TYPE_DESC_IN
    );

END new_smell_type;
/

/* smell_magnitude basic input */
CREATE OR REPLACE PROCEDURE new_smell_magnitude
    (
        MAGNITUDE_ID_IN IN smell_magnitude.magnitude_id%TYPE,
        MAGNITUDE_DESC_IN IN smell_magnitude.magnitude_description%TYPE,
        MAGNITUDE_WEIGHT_IN IN smell_magnitude.magnitude_weight%TYPE
    )

BEGIN
    INSERT INTO smell_magnitude values (
        MAGNITUDE_ID_IN,
        MAGNITUDE_DESC_IN,
        MAGNITUDE_WEIGHT_IN
    );

END new_smell_magnitude;
/

/* smellscape basic input */
-- need to add an in and out here
-- TODO:  Set in to WKT OUT to SDO
CREATE OR REPLACE PROCEDURE new_smellscape
    (
        FIPS_CODE_IN IN smellscape.fips_code%TYPE,
        FEATURE_IN IN smellscape.feature_geometry%TYPE
    )

BEGIN
    INSERT INTO smellscape values (
        FIPS_CODE_IN,
        SDO_UTIL.FROM_WKTGEOMETRY (FEATURE_IN)
    );

END new_smellscape;
/

/* smell_profile basic input */
-- TODO: Spatial WITHIN to get FIPS and also need to calc feature geom.
CREATE OR REPLACE PROCEDURE new_smell_profile
    (
        FIPS_CODE_IN IN smell_profile.fips_code%TYPE,
        USER_IN IN smell_profile.user_id%TYPE,
        LATITUDE_IN IN smell_profile.latitude%TYPE,
        LONGITUDE_IN IN smell_profile.longitude%TYPE,
        FEATURE_IN IN smell_profile.feature_geometry%TYPE,
        TYPE_IN IN smell_profile.type_id%TYPE,
        MAGNITUDE_IN IN smell_profile.magnitude_id%TYPE,
        DESCRIPTION_IN IN smell_profile.open_description%TYPE
    )

BEGIN
    INSERT INTO smell_profile values (
        FIPS_CODE_IN, -- TODO calc after calcing featre_in
        USER_IN,
        LATITUDE_IN,
        LONGITUDE_IN,
        FEATURE_IN, -- TODO: Calc from above
        TYPE_IN,
        MAGNITUDE_IN,
        DESCRIPTION_IN
    );

END new_smell_profile;
/

/* comment_log basic input */
CREATE OR REPLACE PROCEDURE new_comment_log
    (
        USER_IN IN comment_log.user_id%TYPE,
        FIPS_CODE_IN IN comment_log.fips_code%TYPE,
        COMMENT_DESC_IN IN comment_log.comment_desc%TYPE,
    )

BEGIN
    INSERT INTO comment_log values (
        1, -- PK overwritten by trigger
        USER_IN,
        FIPS_CODE_IN,
        1, -- Date overwritten by trigger
        COMMENT_DESC_IN
    );

END new_comment_log;
/

/* subscription_log basic input */
CREATE OR REPLACE PROCEDURE new_subscription_log
    (
        USER_IN IN subscription_log.user_id%TYPE,
        FIPS_CODE_IN IN comment_log.fips_code%TYPE
    )

BEGIN
    INSERT INTO subscription_log values (
        1, -- PK overwritten by trigger
        USER_IN,
        FIPS_CODE_IN,
        1 -- Date overwritten by trigger
    );

END new_subscription_log;
/




-- When spatial queries are necessary









-- ******************************************************
--    END SESSION
-- ******************************************************

spool off