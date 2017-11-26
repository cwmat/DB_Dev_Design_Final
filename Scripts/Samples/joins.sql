-- ******************************************************
-- joins.sql
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

spool s9joins.lst


-- ******************************************************
--    JOINS
-- ******************************************************

SELECT staffName STAFF,
       projDescription DESCRIPTION,
       taskNo, typeOfTask
  FROM tbStaff a, tbProject b, tbTask c, tbTaskType d
  WHERE a.staffID = c.staffID
        and b.projectNo = c.projectNo
        and c.taskCode = d.taskCode
  ORDER by 1, 2, 3;

/* Alternative Syntax */

SELECT staffName STAFF,
       projDescription DESCRIPTION,
       taskNo, typeOfTask
  FROM tbStaff NATURAL JOIN tbProject NATURAL JOIN tbTask NATURAL JOIN tbTaskType
  ORDER by 1, 2, 3;


/* Right Outer Join with (+) Syntax */

SELECT projectNo, taskNo, typeOfTask,
       a.staffID, staffName
  FROM tbStaff a, tbTask b, tbTaskType c
  WHERE a.staffID(+) = b.staffID
        and b.taskCode = c.taskCode
  ORDER by 1, 2;  

/* Right Outer Join */

SELECT projectNo, taskNo, typeOfTask,
       a.staffID, staffName
  FROM tbStaff a RIGHT OUTER JOIN tbTask b
      ON (a.staffID = b.staffID)
  JOIN tbTaskType c
      ON (b.taskCode = c.taskCode)
  ORDER by 1, 2;

/* Left Outer Join with (+) Syntax */

SELECT a.staffID, staffName,
       projectNo, taskNo, taskCode
  FROM tbStaff a, tbTask b
  WHERE a.staffID = b.staffID(+)
  ORDER by 1, 3, 4; 


/* Left Outer Join */

SELECT a.staffID, staffName,
       projectNo, taskNo, taskCode
  FROM tbStaff a LEFT OUTER JOIN tbTask b
      ON (a.staffID = b.staffID)
  ORDER by 1, 3, 4;

/* Full Outer Join with (+) Syntax */

SELECT a.staffID, staffName,
       projectNo, taskNo, taskCode
  FROM tbStaff a, tbTask b
  WHERE a.staffID(+) = b.staffID(+)
  ORDER by 1, 3, 4;

/* Full Outer Join */

SELECT projectNo, taskNo, b.staffID,
       staffName, taskCode
  FROM tbTask a FULL OUTER JOIN tbStaff b
      ON (a.staffID = b.staffID)
  ORDER by 1, 2;

/* Oracle Join */

SELECT projectNo, taskNo,
       staffID, staffName, taskCode
  FROM tbTask JOIN tbStaff USING (staffID)
  ORDER by 1, 2;
  
SELECT projectNo, taskNo,
       b.staffID, staffName, taskCode
  FROM tbTask a JOIN tbStaff b ON (a.staffID = b.staffID)
  ORDER by 1, 2;
  
SELECT projectNo, taskNo,
       staffID, staffName,
       taskCode
  FROM tbStaff NATURAL JOIN
       tbTask
  ORDER by 1, 2;

SELECT projDescription,
       taskNo, staffName
  FROM tbStaff
    NATURAL JOIN tbTask
    JOIN tbProject
    USING (projectno)
  ORDER by 1, 2;

/* Self Join */

SELECT a.staffID, a.staffName,
       b.staffName MANAGER
  FROM tbStaff a, tbStaff b
  WHERE a.mgrID = b.staffID(+)
  ORDER by 1;

SELECT a.staffName STAFF, a.salary,
       b.staffName MANAGER, b.salary
  FROM tbStaff a, tbStaff b
  WHERE a.mgrID = b.staffID(+)
        and a.salary > b.salary
  ORDER by 1;

/* Many to Many Joins */

CREATE table tbGrade (
    grade            char(1)                  not null
        constraint pk_grade primary key,
    minimum          number(10,2)             not null,
    maximum          number(10,2)             not null
);

INSERT into tbGrade values ('A', 40000, 45000);
INSERT into tbGrade values ('B', 42000, 46000);
INSERT into tbGrade values ('C', 45000, 50000);
INSERT into tbGrade values ('D', 46000, 52000);

SELECT * from tbGrade;

INSERT into tbstaff values
  ('9999', 'Big Boss', null, 52000, null);

SELECT staffID, staffName, grade,
       salary, minimum, maximum
  FROM tbStaff, tbGrade
  WHERE salary between minimum and maximum
  ORDER by 1, 2;

SELECT staffName, salary
  FROM tbStaff
  WHERE not exists (SELECT *
                      FROM tbGrade
                      WHERE salary between minimum and maximum)
  ORDER by 2, 1;

SELECT staffName, grade, salary, minimum, maximum
  FROM tbStaff JOIN tbGrade
     ON (salary between minimum and maximum)
  ORDER by 1, 2;

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
