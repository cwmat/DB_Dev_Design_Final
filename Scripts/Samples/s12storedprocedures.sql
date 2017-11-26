-- ******************************************************
-- s13storedprocedures.sql
--
-- Stored Procedures
--
-- Description:   This script contains sample SQL and PL/SQL
--      to run on the PROJECTS database
--
-- Note:  must load the PROJECTS DB first
--
-- Author:  Maria R. Garcia Altobello
--
-- Date:   November, 2017
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

spool s13storedprocedures.lst


/* Setting up environment prior to running the trigger */

DROP table tbGift purge;
DROP table tbPatron purge;
DROP sequence seq_gift;

CREATE table tbPatron (
   patronID     char(3)
      constraint        pk_patron       primary key,
   name         char(25)        not null,
   city         varchar(25)     null,     
   nogifts      number(7,0)     default 0
);
 
CREATE table tbGift (
   giftNo               number(7,0)
      constraint        pk_gift         primary key,   
   patronID   char(3)         null
      constraint        fk_patronid_tbPatron
         references tbPatron(patronID) on delete set null,   
   gift_date    date            not null, 
   amount       number(11,2)    not null
); 


/* Script to list the columns which are used in a foreign key.
	Note:  user fk_col_ref.sql script to see which columns are
	referred to by the foreign key */

column table_name format A15
column constraint_name format A30
column column_name format A30
select a.table_name, a.constraint_name, column_name
from user_constraints a, user_cons_columns b
where a.constraint_type='R'
and a.constraint_name=b.constraint_name


/* Drop Identity Column Example Table */

DROP table tbGiftID purge;


/* Reproducing session on triggers */

CREATE sequence seq_gift
   increment by 1
   start with 1000
   maxvalue 9999;
   
INSERT into tbPatron values (111, 'Andrew James', 'Manchester', 1);

INSERT into tbPatron values (112, 'Elizabeth Stewart', 'Boston', 2);

INSERT into tbGift
   values
   (seq_gift.nextval, 111, '28-OCT-2017', 300);
   
INSERT into tbGift
   values
   (seq_gift.nextval, 112, '28-OCT-2017', 500);
   
INSERT into tbGift
   values
   (seq_gift.nextval, 112, '28-OCT-2017', 500);
   
SELECT * from tbPatron;
SELECT * from tbGift;
   

-- ******************************************************
-- @initialTrigger.sql
-- ******************************************************


DROP trigger TR_new_gift_IN_OUT;


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

-- ****************************************************************
-- @newGiftProc.sql
--
-- purpose: Using a procedure to insert a new gift and
--			keep track of gifts received from each patron
-- ****************************************************************

create or replace procedure new_gift

   /* declare parameters
      note you can obtain datatype from table definitions
   */

   (   PATRON_ID      in      TBGIFT.PATRONID%TYPE,
       GIFT_AMOUNT    in      TBGIFT.AMOUNT%TYPE,
       GIFT_COUNT     out     TBPATRON.NOGIFTS%TYPE
   )
	
is

   new_gift_count integer;   /* gift count - declare variable */
	
begin

   /* get the current gift count, and lock table */

   select nogifts
      into new_gift_count
      from tbpatron
      where patronid = PATRON_ID
      for update;

      /* add one to the current count */
	
      new_gift_count := ( new_gift_count + 1 );

      /* do the gift insert */

   insert into tbGift
      (patronID, amount)         /* Use trigger */
      values
      (PATRON_ID, GIFT_AMOUNT);

   /* update the GIFT count in PATRON record */
	
   update tbpatron
      set nogifts = new_gift_count
      where patronid = PATRON_ID;

   /* set output parameter */
	
      GIFT_COUNT := new_gift_count;

end new_gift;
/


show errors


-- ****************************************************************
-- @newGiftWithProc.sql
--
-- purpose: Using a transaction to register a new gift
--          by calling a stored procedure
-- ****************************************************************

declare
   PATRON_ID        TBGIFT.PATRONID%TYPE;
   GIFT_AMOUNT      TBGIFT.AMOUNT%TYPE;
   NEW_GIFT_COUNT   integer;

begin

   PATRON_ID := '111';
   GIFT_AMOUNT := 950;

   /* calling stored procedure and passing parameters */

   new_gift (PATRON_ID, GIFT_AMOUNT, NEW_GIFT_COUNT);
	
   dbms_output.put_line ('*** New gift count is ' || NEW_GIFT_COUNT);
	
   commit;
    
end;
/


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
