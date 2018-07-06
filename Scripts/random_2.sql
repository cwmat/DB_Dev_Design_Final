-- SELECT smellscape.fips_code 
--     FROM smellscape
--     WHERE SDO_CONTAINS (smellscape.feature_geometry,
--                         SDO_GEOMETRY('POINT(-77.47552247999993824 37.56914486900006978)', 8307)
--                         ) = 'TRUE';

-- BEGIN

-- new_smell_profile(3, 37.56914486900006978, -77.47552247999993824, '01', '7', 'Basic Desc');

-- END;
-- /
-- 
-- INSERT INTO smell_profile VALUES ('517600402002039', 3, 37.56914486900006978, -77.47552247999993824, SDO_GEOMETRY('POINT(-77.47552247999993824 37.56914486900006978)', 8307), '01', '7', 'Basic Desc');

-- new_smell_profile(geanie_id, 37.55074414821800843, -77.42892908699997179, '03', '3', 'Basic Desc');
-- new_smell_profile(geanie_id, 37.57135124600006293, -77.42892908699997179, '03', '3', 'Basic Desc');


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

    -- Solo
    -- new_smell_profile(angel_id, 37.55119634300007192, -77.47205794499996045, '01', '10', 'Basic Desc');
    -- new_smell_profile(adamo_id, 37.55321796100002985, -77.47570924699994066, '02', '02', 'Basic Desc');
    -- new_smell_profile(kay_id, 37.56914486900006978, -77.47552247999993824, '01', '07', 'Basic Desc');
    -- new_smell_profile(geanie_id, 37.57135124600006293, -77.42892908699997179, '03', '03', 'Basic Desc');

    -- -- In cluster
    -- new_smell_profile(angel_id, 37.55134763159432509, -77.46885709712546486, '01', '10', 'Basic Desc');
    -- new_smell_profile(adamo_id, 37.55088783473618008, -77.46845477487458709, '02', '02', 'Basic Desc');
    -- new_smell_profile(geanie_id, 37.57135124600006293, -77.46900078364363651, '03', '03', 'Basic Desc');

    /* inventory comment_log */
    new_comment_log(angel_id, '517600107002002', '{Fips1Comment1}');
    -- new_comment_log(adamo_id, '517600107002002', '{Fips1Comment2}');
    -- new_comment_log(angel_id, '517600402002027', '{Fips2Comment1}');

    -- /* inventory subscription_log */
    -- new_subscriber_log(kay_id, '517600107002002');
    -- new_subscriber_log(geanie_id, '517600402002027');
    -- new_subscriber_log(geanie_id, '517600107002002');


END;
/