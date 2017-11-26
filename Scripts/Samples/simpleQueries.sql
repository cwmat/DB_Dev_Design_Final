-- ******************************************************
-- simpleQueries.sql
--
-- Simple Queries for Project Database
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

spool s6simpleQueries.lst


-- ******************************************************
--    SUBQUERIES
--
--   Shows:
--      Use of aggregate functions in subqueries
--      Use of multiple nesting levels
--      Use of EXISTS and NOT EXISTS
--      Correlated subqueries
--      Use of NOT IN
--      Issues with NULL values
-- ******************************************************

/* Simple Query */

SELECT * FROM tbProject;

/* Conditional, Sorted Query */

SELECT * FROM tbProject 
    WHERE budget > 5000
    ORDER BY targetdate desc;

/* Unions */

SELECT staffID
    FROM tbStaff
    WHERE salary > 49000
    UNION
    SELECT staffID
    FROM tbTask
    WHERE taskCode = 'MGR'
    ORDER BY 1;

/* Union All */

SELECT staffID
    FROM tbStaff
    WHERE salary > 49000
    UNION ALL
    SELECT staffID
    FROM tbTask
    WHERE taskCode = 'MGR'
    ORDER BY 1;

-- ******************************************************
--    JOINS
-- ******************************************************

SELECT staffName
    FROM tbStaff, tbTask
    WHERE tbStaff.staffID = tbTask.staffID
    and taskCode = 'MGR'
    ORDER by staffName;

/* Use of Distinct */

SELECT DISTINCT staffName
    FROM tbStaff, tbTask
    WHERE tbStaff.staffID = tbTask.staffID
    and taskCode = 'MGR'
    ORDER BY staffName;

/* Use of Aliases */

select DISTINCT staffName
    FROM tbStaff a, tbTask b
    WHERE a.staffID = b.staffID
    and taskCode = 'MGR'
    ORDER BY staffName;
    
/* Natural Join */

SELECT DISTINCT staffName
    FROM tbStaff
    NATURAL JOIN tbTask
    WHERE taskCode = 'MGR'
    ORDER BY staffName;
    
/* Alternative Syntax */

SELECT DISTINCT staffName
    FROM tbStaff
    NATURAL JOIN tbTask
    WHERE taskCode = 'MGR'
    ORDER BY 1;

/* Join Multiple Tables */
    
SELECT projDescription, taskNo, staffName, typeOfTask
    FROM tbProject a, tbStaff b, tbTask c, tbTaskType d
    WHERE a.projectNo = c.projectNo
    and b.staffID = c.staffID
    and c.taskCode = d.taskCode
    ORDER by projDescription, taskNo;

/* Alternative Syntax */

SELECT projDescription, taskNo, staffName, typeOfTask
    FROM tbProject NATURAL JOIN tbStaff
    NATURAL JOIN tbTask NATURAL JOIN tbTaskType
    ORDER by projDescription, taskNo;

-- ******************************************************
--    PROJECTION AND RESTRICTION
-- ******************************************************

/* Basic Query */

SELECT * FROM tbStaff;

/* Projection */

SELECT projDescription, budget
    FROM tbProject;

/* Restriction */

SELECT * FROM tbTask
    WHERE projectNo = '333';

/* Projection and Restriction */

SELECT staffName, dateofbirth, salary
    FROM tbStaff
    WHERE salary > 43000;

/* Restriction with Arithmetic */

SELECT *
    FROM tbTask
    WHERE estDays / 20 > 2;

/* Restriction using Range */

SELECT * 
    FROM tbStaff
    WHERE salary between 40000 and 70000;

/* Using the IN Predicate */

SELECT *
    FROM tbTask
    WHERE projectNo IN ('333', '651');

/* Matching a Character Pattern */

SELECT *
    FROM tbStaff
    WHERE staffName LIKE '%Alan%';

-- ******************************************************
--    BOOLEAN OPERATORS
-- ******************************************************

/* Using AND */

SELECT *
  FROM tbTask
  WHERE projectNo = '333'
  and estDays > 30
  ORDER by 2;

/* Using OR */

SELECT *
  FROM tbTask
  WHERE projectNo = '651'
  or estDays > 30
  ORDER by 1, 2;

/* Combining operators */

SELECT *
  FROM tbTask
  WHERE projectNo = 590
  and projectNo = 651 or estDays > 15
  ORDER by 1, 2;

/* Parenthesis and Boolean Operators */

SELECT *
  FROM tbTask
  WHERE projectNo = 590
  or projectNo = 651
  and estDays > 15
  ORDER by 1, 2;

SELECT *
  FROM tbTask
  WHERE projectNo = 590
  or (projectNo = 651
  and estDays > 15)
  ORDER by 1, 2;

SELECT *
  FROM tbTask
  WHERE (projectNo = 590
  or projectNo = 651)
  and estDays > 15
  ORDER by 1, 2;

-- ******************************************************
--    NULL VALUES
-- ******************************************************

/* NULL */

SELECT *
  FROM tbTask
  WHERE staffID is null;

/* NOT NULL */

SELECT *
  FROM tbTask
  WHERE staffID is not null;

-- ******************************************************
--    ADDING COLUMNS
-- ******************************************************

SELECT projectNo, taskCode, estDays,
  estDays/20 as MONTHS
  FROM tbTask
  ORDER by 1, 3 DESC;


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
