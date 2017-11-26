-- ******************************************************
-- triggers.sql
--
-- Triggers for Project Database
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

spool s10triggers.lst


-- ******************************************************
--   Entity Integrity using Triggers
--            Demonstrates different features of triggers
--
--   Note:
--            Save each trigger on a separate file on your
--            scripts directory.  It's easier to call a
--            trigger than it is to copy and paste it
-- ******************************************************

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

CREATE sequence seq_gift
   increment by 1
   start with 1000
   maxvalue 9999;
   
SELECT seq_gift.currval FROM dual;

INSERT into tbPatron values (111, 'Andrew James', 'Manchester', 0);
INSERT into tbPatron values (112, 'Elizabeth Stewart', 'Boston', 0);

SELECT * from tbPatron;

/* Here is the trigger in question */

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

/* Testing the trigger, but show contents of tbGift before */

SELECT * from tbGift;

INSERT into tbGift
   (patronID, amount)
   values
   (111, 300);

SELECT * from tbGift;

/* Now check the sequence */

SELECT seq_gift.currval FROM dual;

/* Triggers precede an insert */

INSERT into tbGift
   values
   (3, 112, '14-APR-2017', 500);

/* Now check the sequence */

SELECT seq_gift.currval FROM dual;

SELECT seq_gift.nextval FROM dual;

/* Run the previous insert again */

INSERT into tbGift
   values
   (3, 112, '14-APR-2017', 500);

/* Then see which value was used by the sequencer */

SELECT * from tbGift;

/* And check the sequence */

SELECT seq_gift.currval FROM dual;

/* Prepare the scenario */

SELECT * FROM tbPatron;
SELECT * FROM tbGift;

UPDATE tbPatron
   SET nogifts = 1
   WHERE patronID = '111';
   
UPDATE tbPatron
   SET nogifts = 2
   WHERE patronID = '112';

SELECT * FROM tbPatron;
SELECT * FROM tbGift;

/* Triggers can perform two actions */

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
         /* update the number of gifts from that patron */
         UPDATE tbPatron a
            SET nogifts = nogifts + 1
            /* join clause refers to mutating record as :new */
            WHERE a.patronID = :new.patronID;
         /* send message to output */
         dbms_output.put_line (
            '*** Number of gifts updated - TR_new_gift_IN trigger');
   end TR_new_gift_IN;
/

INSERT into tbGift
   (patronID, amount)
   values
   (111, 600);

SELECT * FROM tbPatron;
SELECT * FROM tbGift;

/* Triggers can be of two types at once */

DROP trigger TR_new_gift_IN;

CREATE or REPLACE trigger TR_new_gift_IN_OUT
   /* trigger executes BEFORE
      an INSERT or DELETE into the GIFT table */
   before insert or
          delete on tbgift
   /* trigger executes for each ROW */
   for each row
   
   /* begins a PL/SQL Block */
   begin
      if inserting then
         /* get the next value of the PK sequence and today’s date */
         SELECT seq_gift.nextval, sysdate
            /* insert them into the :NEW ROW columns */
            into :new.giftNo, :new.gift_date
            FROM dual;
         /* update the number of gifts from that patron */
         UPDATE tbPatron a
            SET nogifts = nogifts + 1
            /* join clause refers to mutating record as :new */
            WHERE a.patronID = :new.patronID;
            /* send message to output */
         dbms_output.put_line (
            '*** Number of gifts increased - TR_new_gift_IN_OUT trigger');
      else
         /* update the number of gifts from that patron */
         UPDATE tbPatron a
            SET nogifts = nogifts - 1
            /* join clause refers to mutating record as :new */
            WHERE a.patronID = :old.patronID;
            /* send message to output */
         dbms_output.put_line (
            '*** Number of gifts reduced - TR_new_gift_IN_OUT trigger');
      end if;      
   end TR_new_gift_IN_OUT;
/


INSERT into tbGift
   (patronID, amount)
   values
   ('111', 1000);

SELECT * FROM tbPatron;
SELECT * FROM tbGift;

DELETE from tbgift
   WHERE giftno IN (SELECT max(giftno) FROM tbgift);

SELECT * FROM tbPatron;
SELECT * FROM tbGift;

/* Triggers to enforce a cascade update */

CREATE or REPLACE trigger TR_TASKID_FK_UPDATE
   /* trigger executes BEFORE
      an UPDATE of STAFFID on the STAFF table */
   before update of staffid on tbstaff
   /* trigger executes for each ROW */
   for each row
   
   /* begins a PL/SQL Block */
   begin
      /* update staffid on task */
      UPDATE tbTask a
         SET a.staffid = :new.staffid
         WHERE :old.staffid = a.staffid;
      /* update the staffid on timesheet */
      UPDATE tbTimesheet b
         SET b.staffid = :new.staffid
         WHERE :old.staffid = b.staffid;
      /* send message to output */
      dbms_output.put_line (
         '*** Related rows in the
            TASK and TIMESHEET table updated - TR_TASKID_FK_UPDATE trigger');
   end TR_new_gift_IN_OUT;
/


SELECT projectno, taskno, staffid,
   staffname, month, days
   FROM tbTask a NATURAL JOIN tbTimesheet b
      NATURAL JOIN tbStaff c
   ORDER by 1, 2, 3, 5;


UPDATE tbStaff
   SET staffid = '1007'
   WHERE staffid = '7001';

SELECT projectno, taskno, staffid,
   staffname, month, days
   FROM tbTask a NATURAL JOIN tbTimesheet b
      NATURAL JOIN tbStaff c
   ORDER by 1, 2, 3, 5;


/* Triggers with mistake */

CREATE or REPLACE trigger TR_TASKID_FK_UPDATE
   before update of staffid on tbstaff

   for each row
   
   begin
      UPDATE tbTask a
         SET a.staffid = :new.staffid
         WHERE :old.staffid = a.staffid
      UPDATE tbTimesheet b
         SET b.staffid = :new.staffid
         WHERE :old.staffid = b.staffid;
      dbms_output.put_line (
         '*** Related rows in the
            TASK and TIMESHEET table updated -
            TR_TASKID_FK_UPDATE trigger');
   end TR_new_gift_IN_OUT;
/


UPDATE tbStaff
   SET staffid = '7001'
   WHERE staffid = '1007';

SHOW ERRORS trigger TR_new_gift_IN_OUT;


/* Where are my triggers?????? */

desc user_triggers;

SELECT rpad(trigger_name, 20) NAME,
      rpad(table_name, 10) "T NAME",
      trigger_type TYPE,
      rpad(triggering_event, 30) EVENT
FROM user_triggers;


/* Only one project manager rule */

SELECT projectno, projdescription,
  count(taskno) "MGR COUNT"
  FROM tbProject LEFT OUTER JOIN tbTask
       USING (projectNo)
  WHERE taskcode = 'MGR'
       GROUP BY projectno, projdescription
       ORDER by 1, 3;


CREATE OR REPLACE trigger one_mgr_rule
   after insert or update or delete on tbtask   
   declare
      x number; /* PL/SQL variable */   
   begin
      /* projects with no tasks considered */
      select count(*) into x
         from tbproject a
         where not exists ( select count(*)
                        from tbtask b
                        where a.projectno = b.projectno
                         and taskcode = 'MGR'
                         group by projectno
                         having count(*) = 1);                         
      if x > 0 then
         dbms_output.put_line (
            '*** Warning, only one manager allowed per project - 
            ONE_MGR_RULE TRIGGER ');
      end if;
   end ONE_MGR_RULE;
/

UPDATE tbtask
   SET taskcode = 'MGR'
   WHERE projectno = 590
   and taskno = 2;
   
SELECT projectno, projdescription,
   count(taskno) "MGR COUNT"
   FROM tbProject LEFT OUTER JOIN tbTask USING (projectNo)
   WHERE taskcode = 'MGR'
   GROUP BY projectno, projdescription
   ORDER by 1, 3;

UPDATE tbtask
   SET taskcode = 'FAC'
   WHERE projectno = 333
   and taskno = 1;
   
SELECT projectno, projdescription,
   count(taskno) "MGR COUNT"
   FROM tbProject LEFT OUTER JOIN tbTask USING (projectNo)
   WHERE taskcode = 'MGR'
   GROUP BY projectno, projdescription
   ORDER by 1, 3;

DELETE from tbtask
   WHERE projectno = 651;

SELECT projectno, projdescription,
   count(taskno) "MGR COUNT"
   FROM tbProject LEFT OUTER JOIN tbTask USING (projectNo)
   WHERE taskcode = 'MGR'
   GROUP BY projectno, projdescription
   ORDER by 1, 3;

INSERT into tbtask
   values (
      651, '02', null, 'MGR', 30);

SELECT projectno, projdescription,
   count(taskno) "MGR COUNT"
   FROM tbProject LEFT OUTER JOIN tbTask USING (projectNo)
   WHERE taskcode = 'MGR'
   GROUP BY projectno, projdescription
   ORDER by 1, 3;

UPDATE tbtask
   SET taskcode = 'FAC'
   WHERE projectno = 590
   and taskno = '02';

UPDATE tbtask
   SET taskcode = 'MGR'
   WHERE projectno = 333
   and taskno = '01';

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
