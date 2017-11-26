-- ******************************************************
-- projectDBbuild.sql
--
-- Loader for Project Database
--
-- Description: This script contains the DDL to load
--              the tables of the
--              PROJECTS database
--
-- There are 5 tables on this DB
--
-- Author:  Maria R. Garcia Altobello
--
-- Last Modified:   October, 2017
--
-- ******************************************************

-- ******************************************************
--    SPOOL SESSION
--              Creates a transcript of the session
--
--	Note:
--              For this to work properly, you must:
--              set echo on OR create a login.sql file
--
--	Syntax:
--              SPOOL <session_name>.lst
-- ******************************************************

spool session6.lst

-- ******************************************************
--    DROP TABLES
--              Drops tables you own
--              Tables are droped in the opposite order
--              in which they were created
--
--	Note:
--              Script will throw errors the first time
--              it runs, as the tables do not exist
--
--	Syntax:
--              DROP table <tablename> purge
-- ******************************************************

DROP table tbTimesheet purge;
DROP table tbTask purge;
DROP table tbTaskType purge;
DROP table tbStaff purge;
DROP table tbProject purge;


-- ******************************************************
--    DROP SEQUENCES
--              Drops sequences you own
--              There is no specific order to drop sequences
--
--	Note:
--              Script will throw errors the first time
--              it runs, as the sequences do not exist
--
--	Syntax:
--              DROP sequence <sequence_name>
-- ******************************************************

DROP sequence seq_timesheet;


-- ******************************************************
--    CREATE TABLES
--              Create new tables
--              Must create free entities first,
--              followed by basic entities,
--              to allow for referential integrity constraints
--  
--              Independent (basic) tables must be created first
--
--	Syntax:
--              CREATE table <table_name> ...
--              (see Reference Manual for more detail)
-- ******************************************************

CREATE table tbProject (
    projectNo           char(3)                            not null
        constraint pk_project primary key,
    projDescription     varchar2(30)                       not null,
    budget              number(11,2)                       null,
    targetDate          date                               null
);


CREATE table tbStaff (
    staffID             char(4)                            not null
        constraint pk_staff primary key,
    staffName           varchar2(30)                       not null,
    dateOfBirth         date                               null,
    salary              number(11,2)                       not null
        constraint rg_salary check (salary > 18000),
    mgrID               char(4)                            null
        constraint fk_mgrID_tbStaff references tbStaff (staffID) on delete set null
);


CREATE table tbTaskType (
    taskCode            char(3)                            not null
        constraint pk_tasktype primary key,
    typeOfTask          varchar2(30)                       not null
);


CREATE table tbTask (
    projectNo           char(3)                            not null
        constraint fk_projectNo_tbTask references tbProject (projectNo) on delete cascade,
    taskNo              char(2)                            not null
        constraint rg_taskNo check (taskNo between '01' and '10'),
    staffID             char(4)                            null
        constraint fk_staffID_tbTask references tbStaff (staffID),
    taskCode            char(3)                            not null
        constraint fk_taskCode_tbTask references tbTaskType (taskCode),
    estDays             number(4,0)         default 0      not null,
        constraint pk_task primary key (projectNo, taskNo)
);


CREATE table tbTimesheet (
    timeLogNo           number(9,0)                        not null
        constraint pk_timesheet primary key,
    projectNo           char(3)                            not null,
    taskNo              char(2)                            not null,
    staffID             char(4)                            null
        constraint fk_staffID_tbTimesheet references tbStaff (staffID),
    month               date                               null,
    days                number(4,0)         default 1      null,
        constraint fk_projNo_taskNo_tbTsheet foreign key (projectNo, taskNo) references tbTask (projectNo, taskNo) on delete cascade
);


-- ******************************************************
--    CREATE SEQUENCES
--              Autonumber fields need a sequence
--
--	Syntax:
--              CREATE sequence <sequence_name>
--              increment by <increments>
--              start with <start_number>;
--
-- 	To call:
--              <sequence_name>.currval   OR
--              <sequence_name>.nextval
-- ******************************************************

CREATE sequence seq_timesheet
    increment by 1
    start with 1;
  
    
-- ******************************************************
--    POPULATE TABLES
--
-- populate tables in the same order
-- in which they were created
-- ******************************************************

/* project tbProject */

INSERT into tbProject values ('333', 'Payroll System', 50000, to_date('11-2017','mm-yyyy'));
INSERT into tbProject values ('484', 'Choose DBMS', 55000, to_date('03-2018','mm-yyyy'));
INSERT into tbProject values ('590', 'Install LAN', 68000, to_date('02-2018','mm-yyyy'));
INSERT into tbProject values ('651', 'Install DBMS', 24000, to_date('12-2017','mm-yyyy'));

/* project tbStaff */

INSERT into tbStaff values ('2323', 'Alice Sheppard', to_date('01-12-1965','mm-dd-yyyy'), 43000, null);
INSERT into tbStaff values ('3001', 'Sam Smith', to_date('10-24-1975','mm-dd-yyyy'), 42000, null);
INSERT into tbStaff values ('4444', 'Grace Smith', to_date('02-12-1982','mm-dd-yyyy'), 59000, null);
INSERT into tbStaff values ('5678', 'Sam Vincent', to_date('05-09-1970','mm-dd-yyyy'), 43000, 4444);
INSERT into tbStaff values ('7001', 'Alan Johnson', to_date('02-12-1978','mm-dd-yyyy'), 49000, 3001);
INSERT into tbStaff values ('7654', 'Alan Jameson', to_date('01-12-1975','mm-dd-yyyy'), 49000, 4444);
INSERT into tbStaff values ('8365', 'Fred Callahan', to_date('09-24-1962','mm-dd-yyyy'), 35100, 4444);


/* project tbTaskType */

INSERT into tbTaskType values ('MGR', 'Manager');
INSERT into tbTaskType values ('ANA', 'Analyst');
INSERT into tbTaskType values ('SPR', 'Senior Programmer');
INSERT into tbTaskType values ('FAC', 'Facilitator');
INSERT into tbTaskType values ('CON', 'Consultant');
INSERT into tbTaskType values ('PGR', 'Programmer');
INSERT into tbTaskType values ('INS', 'Instructor');

/* project tbTask */

INSERT into tbTask values ('333', '01', '3001', 'MGR', 90);
INSERT into tbTask values ('333', '02', '7001', 'ANA', 120);
INSERT into tbTask values ('333', '03', '4444', 'SPR', 60);
INSERT into tbTask values ('333', '04', null, 'ANA', 10);
INSERT into tbTask values ('333', '05', null, 'FAC', 20);
INSERT into tbTask values ('333', '06', '2323', 'CON', 10);
INSERT into tbTask values ('484', '01', '4444', 'MGR', 60);
INSERT into tbTask values ('484', '02', '3001', 'PGR', 60);
INSERT into tbTask values ('590', '01', '7001', 'MGR', 20);
INSERT into tbTask values ('590', '02', '4444', 'INS', 15);
INSERT into tbTask values ('651', '01', '4444', 'MGR', 10);

/* project tbTimesheet */

INSERT into tbTimesheet values (seq_timesheet.nextval, '333', '01', '3001', '01-JUN-2017', 15);
INSERT into tbTimesheet values (seq_timesheet.nextval, '333', '02', '7001', '01-JUN-2017', 15);
INSERT into tbTimesheet values (seq_timesheet.nextval, '333', '01', '3001', '01-JUL-2017', 15);
INSERT into tbTimesheet values (seq_timesheet.nextval, '333', '03', '4444', '01-JUL-2017', 15);
INSERT into tbTimesheet values (seq_timesheet.nextval, '484', '01', '4444', '01-JUL-2017', 15);
INSERT into tbTimesheet values (seq_timesheet.nextval, '484', '02', '3001', '01-JUL-2017', 10);
INSERT into tbTimesheet values (seq_timesheet.nextval, '484', '01', '4444', '01-AUG-2017', 10);
INSERT into tbTimesheet values (seq_timesheet.nextval, '484', '02', '3001', '01-AUG-2017', 10);
INSERT into tbTimesheet values (seq_timesheet.nextval, '333', '01', '3001', '01-SEP-2017', 5);
INSERT into tbTimesheet values (seq_timesheet.nextval, '333', '02', '7001', '01-SEP-2017', 10);
INSERT into tbTimesheet values (seq_timesheet.nextval, '333', '01', '3001', '01-SEP-2017', 5);
INSERT into tbTimesheet values (seq_timesheet.nextval, '333', '03', '4444', '01-SEP-2017', 10);
INSERT into tbTimesheet values (seq_timesheet.nextval, '590', '01', '7001', '01-SEP-2017', 5);
INSERT into tbTimesheet values (seq_timesheet.nextval, '590', '02', '4444', '01-SEP-2017', 5);


-- ******************************************************
--    VIEW TABLES
-- ******************************************************

SELECT * FROM tbProject;
SELECT * FROM tbStaff;
SELECT * FROM tbTaskType;
SELECT * FROM tbTask;
SELECT * FROM tbTimesheet;


-- ******************************************************
--    QUALITY CONTROL
--
--    Perform table testing:
--    	1) Entity integrity
--    	2) Referential integrity
--	3) Column constraints
--
--    Note:  you will need to add your own for the PS
--
-- ******************************************************



-- ******************************************************
--    END SESSION
--              Closes the transcript file
--
--	Note:
--              If you forget to do it,
--              ORACLE will close it when you log out
--
--	Syntax:
--              SPOOL off
-- ******************************************************

spool off


