-- ******************************************************
-- moreQueries.sql
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

spool s8moreQueries.lst


-- ******************************************************
--    AGGREGATE FUNCTIONS
-- ******************************************************

SELECT avg(salary)
  FROM tbStaff;

SELECT min(salary), max(salary), sum(salary),
  avg(salary), count(*)
  FROM tbStaff;

SELECT projectNo, sum(estDays)
  FROM tbTask
  GROUP BY projectNo;

/* Conditionals and Grouping */

SELECT projectNo, sum(estDays)
  FROM tbTask
  GROUP by projectNo
  HAVING sum(estDays) >= 60;

SELECT projectNo, taskCode,
  sum(estDays), count(*)
  FROM tbTask
  GROUP by projectNo, taskCode
  ORDER by 1, 2;

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

/* How Subqueries Work */

SELECT *
  FROM tbTask
  WHERE staffID in (SELECT staffID
                      FROM tbStaff
                      WHERE salary > 45000)
  ORDER BY 1, 2;

SELECT staffID
  FROM tbStaff
  WHERE salary > 45000;

SELECT *
  FROM tbTask;

/* Built-in Aggregate Functions */

SELECT avg(estDays)
  FROM tbTask;

SELECT projectNo, sum(estDays)
  FROM tbTask
  GROUP by projectNo;

SELECT projectNo, sum(estDays)
  FROM tbTask
  GROUP by projectNo
  HAVING sum(estDays) < (SELECT avg(estDays)
                           FROM tbTask);

/* Multiple Nesting Levels */

SELECT staffID
  FROM tbStaff
  WHERE salary < 45000;

SELECT projectNo
  FROM tbTask
  WHERE staffID IN ('2323', '3001', '5678', '8365');

SELECT projDescription
  FROM tbProject
  WHERE projectNo in ('333', '484');

SELECT projDescription
  FROM tbProject
  WHERE projectNo in (SELECT projectNo
                        FROM tbTask
                        WHERE staffID in (SELECT staffID
                                            FROM tbStaff
                                            WHERE salary < 45000))
  ORDER by 1;

/* 3-Table Join */

SELECT distinct projDescription
  FROM tbProject a, tbTask b, tbStaff c
  WHERE a.projectNo = b.projectNo
  and b.staffID = c.staffID
  and salary < 45000;

SELECT distinct projDescription
  FROM tbProject NATURAL JOIN tbTask
  NATURAL JOIN tbStaff
  WHERE salary < 45000;

/* Correlated Subqueries */

SELECT staffName
  FROM tbStaff a
  WHERE EXISTS (SELECT *
                  FROM tbTask
                  WHERE staffID = a.staffID);

/* NOT EXISTS v NOT IN */

SELECT staffName
  FROM tbStaff a
  WHERE NOT EXISTS (SELECT *
                  FROM tbTask
                  WHERE staffID = a.staffID);

SELECT staffName
  FROM tbStaff
  WHERE staffID NOT IN (SELECT staffID 
                          FROM tbTask);

SELECT staffName
  FROM tbStaff
  WHERE staffID NOT IN (SELECT staffID 
                          FROM tbTask
                          WHERE staffID is not null);

/* Negative Existence Test */

select distinct staffID
  FROM tbTask a
  WHERE not exists (SELECT *
                      FROM tbProject b
                      WHERE not exists (SELECT *
                                          FROM tbTask c
                                          WHERE a.staffID = c.staffID
                                          and b.projectNo = c.projectNo));

select staffName
  FROM tbStaff a
  WHERE not exists (SELECT *
                      FROM tbProject b
                      WHERE not exists (SELECT *
                                          FROM tbTask c
                                          WHERE a.staffID = c.staffID
                                          and b.projectNo = c.projectNo));

-- ******************************************************
--    VIEWS
-- ******************************************************

CREATE view projectStats (
  projNo, projDesc, totDays, taskCount )
  as
  SELECT a.projectNo, projDescription, sum(estDays), count(*)
    FROM tbProject a, tbTask b
    WHERE a.projectNo = b.projectNo
    GROUP by a.projectNo, projDescription;

SELECT * FROM projectStats;

/* Answering Complex Questions */

SELECT staffName
  FROM tbStaff a, tbTask b, projectStats c
  WHERE a.staffID = b.staffID
        and b.projectNo = c.projNo
        and taskCount = (SELECT max(taskCount)
                           FROM projectStats);

/* Views as Intermediate Queries */

CREATE view projectDays (
  project, estimated, reported, percent)
  as
  SELECT projDescription, sum(b.estDays),
          sum(c.days), sum(c.days)/sum(b.estDays)*100
    FROM tbProject a, tbTask b, tbTimesheet c
    WHERE a.projectNo = b.projectNo
          and b.projectNo = c.projectNo
          and b.taskNo = c.taskNo
    GROUP by projDescription;

SELECT * FROM projectDays;

SELECT project, percent
  FROM projectDays
  WHERE percent = (SELECT max(percent)
                     FROM projectDays);

-- ******************************************************
--    FORMATTING QUERIES
-- ******************************************************

/* As Is */

SELECT object_name, object_type
     from user_objects
     where object_type = 'TABLE';
     
/* Columns */
     
column object_name format A15
column object_type format A15

SELECT object_name, object_type
     from user_objects
     where object_type = 'TABLE';

/* No PADding */

select donor.donorid, donorname, amount
    from donor, donation
    where donor.donorid = donation.donorid;

/* PADding */

select donor.donorid,
    rpad(donorname,15), lpad(amount,6,'*')
    from donor, donation
    where donor.donorid = donation.donorid;
    
/* Name Columns */

select donor.donorid,
    rpad(donorname,15) DONOR,
    lpad(amount,6,'*') AMOUNT
    from donor, donation
    where donor.donorid = donation.donorid;

/* Qualifying */

select donor.donorid, 
   rpad(donorname,15) DONOR, lpad(amount,6,'*') AMOUNT,
   from donor, donation;

select * from donation;

-- ******************************************************
--    COMMIT AND ROLLBACK
-- ******************************************************


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
