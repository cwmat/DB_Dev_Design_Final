/* inventory smell_type */ 



/* inventory smell_magnitude */


-- CREATE OR REPLACE PROCEDURE new_smell_profile
--     (
--         -- FIPS_CODE_IN IN smell_profile.fips_code%TYPE,
--         USER_IN IN smell_profile.user_id%TYPE,
--         LATITUDE_IN IN smell_profile.latitude%TYPE,
--         LONGITUDE_IN IN smell_profile.longitude%TYPE,
--         -- FEATURE_IN IN smell_profile.feature_geometry%TYPE,
--         TYPE_IN IN smell_profile.type_id%TYPE,
--         MAGNITUDE_IN IN smell_profile.magnitude_id%TYPE,
--         DESCRIPTION_IN IN smell_profile.open_description%TYPE
--     )

-- IS
--     matching_fips smell_profile.fips_code%TYPE;
--     feature smell_profile.feature_geometry%TYPE;
--     LONG_STRING varchar2(20);
--     LAT_STRING varchar2(20);
--     NEW_GEOM varchar2(100);

-- BEGIN
--     SAVEPOINT start_new_smell_profile;
--     -- Form geom
--     SELECT CAST (LONGITUDE_IN AS varchar2 (20)) INTO LONG_STRING FROM dual;
--     SELECT CAST (LATITUDE_IN AS varchar2 (20)) INTO LAT_STRING FROM dual;
--     -- LONG_STRING := CAST (LONGITUDE_IN AS varchar2 (20));
--     -- LAT_STRING := CAST (LATITUDE_IN AS varchar2 (20));
--     NEW_GEOM := 'POINT(' || LONG_STRING || ' ' || LAT_STRING || ')';

--     feature := SDO_GEOMETRY(NEW_GEOM, 8307);

--     -- Spatial query select FIPS of within (should only be one)
--     -- TODO, if time add error handling for null return.
--     SELECT smellscape.fips_code INTO matching_fips
--         FROM smellscape
--         WHERE SDO_CONTAINS (smellscape.feature_geometry,
--                             feature
--                             ) = 'TRUE';


--     dbms_output.put_line(matching_fips);
--     dbms_output.put_line(NEW_GEOM);

--     -- Insert
--     INSERT INTO smell_profile values (
--         matching_fips,
--         USER_IN,
--         LATITUDE_IN,
--         LONGITUDE_IN,
--         feature, -- TODO: Calc from above
--         TYPE_IN,
--         MAGNITUDE_IN,
--         DESCRIPTION_IN
--     );

--     COMMIT;

--     -- EXCEPTION
--     --     WHEN OTHERS THEN
--     --         dbms_output.put_line('This smell-profile failed to load, the geometry was possibly out of bounds - see documentation for explaination.');
--     --         ROLLBACK TO start_new_smell_profile;

-- END new_smell_profile;
-- /

-- SHOW ERRORS



DECLARE

    angel_id number(11, 0);
    adamo_id number(11, 0);
    kay_id number(11, 0);
    geanie_id number(11, 0);

BEGIN

    SELECT user_id INTO angel_id FROM user_account WHERE first_name = 'Angel';
    SELECT user_id INTO adamo_id FROM user_account WHERE first_name = 'Adamo';
    SELECT user_id INTO kay_id FROM user_account WHERE first_name = 'Kay-Re';
    SELECT user_id INTO geanie_id FROM user_account WHERE first_name = 'Geanie';

    -- new_comment_log(angel_id, );

    new_smell_profile(angel_id, 37.55119634300007192, -77.47205794499996045, '01', '10', 'Basic Desc');
    -- new_smell_profile(adamo_id, lat, long, '02', '2', 'Basic Desc');
    -- new_smell_profile(kay_id, lat, long, '01', '7', 'Basic Desc');
    -- new_smell_profile(geanie_id, lat, long, '03', '3', 'Basic Desc');

END;
/

SHOW ERRORS


-- SELECT smellscape.fips_code
--     FROM smellscape
--     WHERE SDO_CONTAINS (smellscape.feature_geometry,
--                         SDO_GEOMETRY('POINT(-77.47205794499996045 37.55119634300007192)', 8307);
--                         ) = 'TRUE';