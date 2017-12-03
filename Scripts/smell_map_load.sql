-- ******************************************************
-- smell_map_load.sql
--
-- Loader for the Smell Map Database
--
-- Description:	This script loads initital data into the database.
-- It is meant to be run after the DDL script.
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

spool smell_map_load.lst

-- ******************************************************
--    POPULATE TABLES
--
-- Note:  Fill tables with initial data.
-- ******************************************************

/* inventory user_account */
BEGIN

    new_user_account('Angel', 'Jarvis', 'ajarvis', 'ajarvis@gmail.com', 'supersecret123');
    new_user_account('Adamo', 'Esposito', 'aesposito', 'aesposito@gmail.com', 'supersecret456');
    new_user_account('Kay-Re', 'Chang', 'kchang', 'kchang@gmail.com', 'supersecret789');
    new_user_account('Geanie', 'McJeanie', 'gmcjeanie', 'gmcjeanie@gmail.com', 'supersecret195');

END;
/


/* inventory smell_type */
BEGIN
    new_smell_type('01', 'Good');
    new_smell_type('02', 'Neutral');
    new_smell_type('03', 'Bad');

END;
/


/* inventory smell_magnitude */
BEGIN
    new_smell_magnitude('01', '{DESC1}', 0.1);
    new_smell_magnitude('02', '{DESC2}', 0.2);
    new_smell_magnitude('03', '{DESC3}', 0.3);
    new_smell_magnitude('04', '{DESC4}', 0.4);
    new_smell_magnitude('05', '{DESC5}', 0.5);
    new_smell_magnitude('06', '{DESC6}', 0.6);
    new_smell_magnitude('07', '{DESC7}', 0.7);
    new_smell_magnitude('08', '{DESC8}', 0.8);
    new_smell_magnitude('09', '{DESC9}', 0.9);
    new_smell_magnitude('10', '{DESC10}', 1.0);
    
END;
/

/* inventory smellscape */
-- Loaded via separate script


/* inventory smell_profile */
-- test a few IN
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

    new_smell_profile(angel_id, lat, long, '01', '10', 'Basic Desc');
    new_smell_profile(adamo_id, lat, long, '02', '2', 'Basic Desc');
    new_smell_profile(kay_id, lat, long, '01', '7', 'Basic Desc');
    new_smell_profile(geanie_id, lat, long, '03', '3', 'Basic Desc');

END;
/





/* inventory comment_log */
-- For this demo project we will assume that we want to add example comments for the four existing members.
-- Therefore we will select their IDs via a select statement on their name (we will assume no first anme repeats at this point since this script is run directly after a fresh DDL run).


/* inventory subscription_log */



-- ******************************************************
--    VIEW TABLES
--
-- Note:  Issue the appropiate commands to show your data
-- ******************************************************

SELECT * FROM user_account;
SELECT * FROM smell_type;
SELECT * FROM smell_magnitude;
SELECT * FROM smellscape;
SELECT * FROM smell_profile;
SELECT * FROM comment_log;
SELECT * FROM subscription_log;


-- ******************************************************
--    END SESSION
-- ******************************************************

spool off