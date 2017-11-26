-- ******************************************************
-- transactions.sql
--
-- Transactions for Project Database
--
-- Description:   This script contains sample SQL and PL/SQL
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

spool s11transactions.lst

-- ******************************************************
--    Transactions
--    Demonstrates some features of transactions
--
--	Note:
--            Save each transaction on a separate file on your
--            scripts directory.  It's easier to call a
--            transaction than it is to copy and paste it
-- ******************************************************

-- ******************************************************
--    Simple Transaction
--
--    Salary increase for employees within the salary grade
-- ******************************************************

/* Check values before */

SELECT distinct staffID, staffName, salary
          FROM tbStaff, tbGrade
          WHERE salary between minimum and maximum
          ORDER BY 1;

select * from tbgrade;


/* Name transaction */

SET TRANSACTION READ WRITE NAME 'salaryIncrease';

/* Staff members with salary within the grade table */

LOCK TABLE tbStaff IN ROW EXCLUSIVE MODE NOWAIT;

/* Update salaries */

UPDATE tbstaff
    set salary = salary * 1.1
    where staffid in ( SELECT distinct staffID
                          FROM tbStaff, tbGrade
                          WHERE salary between minimum and maximum);

COMMIT;
	
/

/* Check values after */

SELECT distinct staffID, staffName, salary
          FROM tbStaff
          ORDER BY 1;

-- ******************************************************
--    Rewrite trigger as transaction
--
--    Record a gift and update the total number of gifts
-- ******************************************************

/* Drop trigger from Trigger session */

DROP TRIGGER tr_new_gift_in_out;

/* Use initial Trigger which adds sequence and date */

CREATE or REPLACE trigger TR_new_gift_IN
   /* trigger executes BEFORE an INSERT into the GIFT table */
   before insert on tbGift
   /* trigger executes for each ROW being inserted */
   for each row
   
   /* begins a PL/SQL Block */
   begin
      /* get the next value of the PK sequence and today’s date */
      SELECT seq_gift.nextval, sysdate
         /* insert them into the :NEW ROW columns */
           into :new.giftNo, :new.gift_date
            FROM dual;
   end TR_new_gift_IN;
/

/* Check data before transaction */

SELECT * FROM tbPatron;
SELECT * FROM tbGift;


/* And now the transaction */

SET TRANSACTION NAME 'giftRecorder';

/* variable to keep track of number of gifts */

declare
   totalgifts number(3,0);

begin

  /* Get current number of gifts */

  SELECT nogifts
     INTO totalgifts
     FROM tbPatron
     WHERE patronid = '111'
     for UPDATE of nogifts;

  /* Add one to the total */

  totalgifts := totalgifts + 1;

  /* Execute insert */

  INSERT into tbGift
     (patronID, amount)
     values
     ('111', 700);

  /* Update number of gifts */

  UPDATE tbPatron
     SET nogifts = totalgifts
     WHERE patronid = '111';

  COMMIT;

end;

/

/* check results */

SELECT * FROM tbPatron;
SELECT * FROM tbGift;

-- ******************************************************
--    Add an Exception Block to a Transaction
-- ******************************************************

SET TRANSACTION NAME 'giftRecorder';

/* variable to keep track of number of gifts */

declare
   totalgifts number(3,0);

begin

  /* Get current number of gifts */

  SELECT nogifts
     INTO totalgifts
     FROM tbPatron
     WHERE patronid = '111'
     for UPDATE of nogifts;

  /* Add one to the total */

  totalgifts := totalgifts + 1;

  /* Execute insert */

  INSERT into tbGift
     (patronID, amount)
     values
     ('111', 700);

  /* Update number of gifts */

  UPDATE tbPatron
     SET nogifts = totalgifts
     WHERE patronid = '111';

  COMMIT;
	
   EXCEPTION
      when OTHERS then
         dbms_output.put_line ('*** Houston, we have a problem!  No gifts recorded');

end;

/

/* check results */

SELECT * from tbPatron;

-- ******************************************************
--    See the Exception Block at Work
-- ******************************************************

SET TRANSACTION NAME 'giftRecorder';

/* variable to keep track of number of gifts */

declare
   totalgifts number(3,0);

begin

  /* Get current number of gifts */

  SELECT nogifts
     INTO totalgifts
     FROM tbPatron
     WHERE patronid = '111'
     for UPDATE of nogifts;

  /* Add one to the total */

  totalgifts := totalgifts + 1;

  /* Execute insert */

  INSERT into tbGift
     (patronID, amount)
     values
     ('113', 700);

  /* Update number of gifts */

  UPDATE tbPatron
     SET nogifts = totalgifts
     WHERE patronid = '111';

  COMMIT;
	
   EXCEPTION
      when OTHERS then
         dbms_output.put_line ('*** Houston, we have a problem!  No gifts recorded');

end;

/

/* check results */

SELECT * from tbPatron;

-- ******************************************************
--    Errors Without Exception
-- ******************************************************

SET TRANSACTION NAME 'giftRecorder';

/* variable to keep track of number of gifts */

declare
   totalgifts number(3,0);

begin

  /* Get current number of gifts */

  SELECT nogifts
     INTO totalgifts
     FROM tbPatron
     WHERE patronid = '111'
     for UPDATE of nogifts;

  /* Add one to the total */

  totalgifts := totalgifts + 1;

  /* Execute insert */

  INSERT into tbGift
     (patronID, amount)
     values
     ('113', 700);

  /* Update number of gifts */

  UPDATE tbPatron
     SET nogifts = totalgifts
     WHERE patronid = '111';

  COMMIT;

end;

/

-- ******************************************************
--    Good Transaction, Should Work
-- ******************************************************

declare
   tranState char(10);                 /* variable to keep track of the state */

begin
   tranState := 'project';             /* begin new project process */
	
   insert into tbProject
      values ('987', 'Test Project', 30000, '15-DEC-17');
    
   commit;
    
   savepoint project_in;               /* define savepoint */
    
      tranState := 'task';             /* begin phone numbers process */
	
      insert into tbTask
      values ('987', '01', '4444', 'MGR', 25);
      insert into tbTask
      values ('987', '02', '2323', 'INS', 12);
    	
   commit;
	
   EXCEPTION
      when DUP_VAL_ON_INDEX then
         if tranState = 'task' then
            dbms_output.put_line ('*** Failed attempt to enter duplicate task number for this project');
               ROLLBACK to project_in;
         else
            dbms_output.put_line ('*** A project with this NUMBER already exists');
         end if;

      when OTHERS then
         if tranState = 'task' then
            dbms_output.put_line ('*** Problems inserting TASK record');
            ROLLBACK to project_in;
         else
            dbms_output.put_line ('*** Problems creating new PROJECT record');
         end if;	
end;
/


SELECT * FROM tbProject ORDER BY 1;

SELECT projDescription, taskno, taskcode
	FROM tbProject a, tbtask b
	WHERE a.projectNo = b.projectNo(+)
	 and a.projectNo = 987;

-- ******************************************************
--    Bad transaction, duplicate task number
-- ******************************************************

declare
   tranState char(10);                 /* variable to keep track of the state */

begin
   tranState := 'project';             /* begin new project process */
	
   insert into tbProject
      values ('999', 'Test Project', 30000, '15-DEC-17');
    
   commit;
    
   savepoint project_in;               /* define savepoint */
    
      tranState := 'task';             /* begin phone numbers process */
	
      insert into tbTask
      values ('999', '01', '4444', 'MGR', 25);
      insert into tbTask
      values ('999', '01', '2323', 'INS', 12);
    	
   commit;
	
   EXCEPTION
      when DUP_VAL_ON_INDEX then
         if tranState = 'task' then
            dbms_output.put_line ('*** Failed attempt to enter duplicate task number for this project');
               ROLLBACK to project_in;
         else
            dbms_output.put_line ('*** A project with this NUMBER already exists');
         end if;

      when OTHERS then
         if tranState = 'task' then
            dbms_output.put_line ('*** Problems inserting TASK record');
            ROLLBACK to project_in;
         else
            dbms_output.put_line ('*** Problems creating new PROJECT record');
         end if;	
end;
/

SELECT * FROM tbProject ORDER BY 1;

SELECT projDescription, taskno, taskcode
	FROM tbProject a, tbtask b
	WHERE a.projectNo = b.projectNo(+)
	 and a.projectNo = '999';

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
