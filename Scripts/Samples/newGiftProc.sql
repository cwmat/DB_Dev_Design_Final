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