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
     ('113', 700);

  /* Update number of gifts */

  UPDATE tbPatron
     SET nogifts = totalgifts
     WHERE patronid = '111';

  COMMIT;
	
end;

/
