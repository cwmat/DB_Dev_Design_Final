-- ******************************************************
-- schemaExamples.sql
--
-- Purpose:  Show how schemas work in Oracle
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

spool schemaExamples.lst

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

DROP table test2 purge;
DROP table test1 purge;


-- ******************************************************
--    CREATE SCHEMA
--              Create new tables
--  
--	Syntax:
--              CREATE schema authorization <username> ...
--              (see Reference Manual for more detail)
-- ******************************************************

CREATE schema authorization lecture
    CREATE table test2 (
	testid  char(1)  not null
	    constraint pk_test2 primary key
	    constraint fk_test2 references test1 (testid)    
    )
    CREATE table test1 (
	testid  char(1) not null
	    constraint pk_test1 primary key    
);

/* Verify tables */

desc test1;
desc test2;

-- ******************************************************
--    CREATE SCHEMA - REPEAT A TABLE
--              Create new tables
--              Order of entities does not matter
--  
--	Syntax:
--              CREATE schema authorization <username> ...
--              (see Reference Manual for more detail)
-- ******************************************************

CREATE schema authorization lecture
    CREATE table test1 (
	testid  char(1) not null
	    constraint pk_test1 primary key    
    )
    CREATE table test3 (
	testid  char(1)  not null
	    constraint pk_test3 primary key
);

/* Changing the order of the statements will only change
   line referenced in the error, but not the error */
   
CREATE schema authorization lecture
    CREATE table test3 (
	testid  char(1)  not null
	    constraint pk_test3 primary key
    )
    CREATE table test1 (
	testid  char(1) not null
	    constraint pk_test1 primary key    
);

-- ******************************************************
--    CREATE SCHEMA - DUPLICATE PK NAMES
--              Create new tables
--  
--	Syntax:
--              CREATE schema authorization <username> ...
--              (see Reference Manual for more detail)
-- ******************************************************

CREATE schema authorization lecture
    CREATE table test3 (
	testid  char(1) not null
	    constraint pk_test3 primary key
    )
    CREATE table test4 (
	testid  char(1)  not null
	    constraint pk_test3 primary key
	    constraint fk_test4 references test3 (testid)    
);

/* Changing the order of the statements will change
   the table referenced, but not the error */
   
CREATE schema authorization lecture
    CREATE table test4 (
	testid  char(1)  not null
	    constraint pk_test3 primary key
	    constraint fk_test4 references test3 (testid)    
    )
    CREATE table test3 (
	testid  char(1) not null
	    constraint pk_test3 primary key
);

-- ******************************************************
--    DROP TABLES
--
--	Note:
--              Drop tables before next example
--
--	Syntax:
--              DROP table <tablename> purge
-- ******************************************************

DROP table test2 purge;
DROP table test1 purge;



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
