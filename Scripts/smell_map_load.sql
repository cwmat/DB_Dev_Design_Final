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


/* inventory smell_type */


/* inventory smell_magnitude */


/* inventory smellscape */


/* inventory smell_profile */


/* inventory comment_log */


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