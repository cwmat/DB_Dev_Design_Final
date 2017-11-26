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