-- ******************************************************
-- tips.sql
--
-- Queries for Project Database
--
-- Description:   This script contains sample queries
--      to run on the PROJECTS database
--
-- Note:  must load the PROJECTS DB first
--
-- Author:  Maria R. Garcia Altobello
--
-- Date:   October, 2017
--
-- ******************************************************

-- ******************************************************
--    SPOOL SESSION
--      Creates a transcript of the session
--
--   Note:
--      For this to work properly, you must:
--      set echo on OR create a login.sql file
--
--   Syntax:
--      SPOOL <session_name>.lst
-- ******************************************************

spool s9tips.lst


-- ******************************************************
--    ASKING FOR HELP
-- ******************************************************

help index

/* Reserved Words */

help reserved words

-- ******************************************************
--    IDENTIFYING STRINGS
-- ******************************************************

INSERT into tbStaff values
     ('5555', 'alan', null, 50000, null);

/* All Names */

SELECT staffname
     FROM tbstaff

/* As is */

SELECT staffname
     FROM tbstaff
     WHERE staffname like 'Alan%'

/* Using UPPER */

SELECT staffname
     FROM tbstaff
     WHERE UPPER(staffname) like 'ALAN%'

-- ******************************************************
--    TIMING QUERIES
-- ******************************************************

SET TIMING ON

/* Subquery */

SELECT staffName STAFF,
       projDescription DESCRIPTION,
       taskNo, typeOfTask
  FROM tbStaff a, tbProject b, tbTask c, tbTaskType d
  WHERE a.staffID = c.staffID
        and b.projectNo = c.projectNo
        and c.taskCode = d.taskCode
  ORDER by 1, 2, 3;

/* Join */

SELECT staffName STAFF,
       projDescription DESCRIPTION,
       taskNo, typeOfTask
  FROM tbStaff NATURAL JOIN tbProject NATURAL JOIN tbTask NATURAL JOIN tbTaskType
  ORDER by 1, 2, 3;

-- ******************************************************
--    SCALAR SUBQUERIES
-- ******************************************************

/* Query inside the select clause */

SELECT
     (SELECT min(salary) FROM tbStaff) MIN_SALARY,    
     (SELECT max(salary) FROM tbStaff) MAX_SALARY,
     (SELECT sum(salary) FROM tbStaff) SUM_SALARY,
     (SELECT avg(salary) FROM tbStaff) AVG_SALARY,
     (SELECT count(salary) FROM tbStaff) COUNT_SALARY
     FROM dual;

/* Simpler */

SELECT min(salary), max(salary), sum(salary),
  avg(salary), count(*)
  FROM tbStaff;

/* Using a scalar subquery on an insert */

INSERT into tbStaff values
     ('7777',
     'Big Boss',
     null,
     (SELECT max(salary) from tbstaff),
     null);

/* Using a scalar subquery and arithmetic on an insert */

INSERT into tbStaff values
     ('8888',
     'Big Boss',
     null,
     (SELECT max(salary) from tbstaff) + 10000,
     null);
 
-- ******************************************************
--    END SESSION
--      Closes the transcript file
--
--   Note:
--      If you forget to do it,
--       ORACLE will close it when you log out
--
--   Syntax:
--      SPOOL off
-- ******************************************************

spool off
