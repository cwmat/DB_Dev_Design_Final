-- ******************************************************
-- smell_map_triggers.sql
--
-- Loader for the Smell Map Database
--
-- Description:	This script contains triggers.
--
-- There are 7 tables in this DB
--
-- Author:  Charles Mateer
--
-- Student:  Charles Mateer cmateer@g.harvard.edu
--
-- Date:   November, 2017
--
-- ******************************************************

-- ******************************************************
--    SPOOL SESSION
-- ******************************************************

spool smell_map_triggers.lst


-- ******************************************************
--    Create Triggers
-- ******************************************************

/* user_account Auto-number PK */
CREATE OR RELACE TRIGGER tr_new_user_in
    BEFORE INSERT ON user_account
    FOR EACH ROW

    BEGIN
        SELECT sequence_user.nextval
        INTO :new.user_id
        FROM dual;

    END tr_new_user_in;
/

/* comment_log Auto-number PK and current date */
CREATE OR RELACE TRIGGER tr_new_comment_in
    BEFORE INSERT ON comment_log
    FOR EACH ROW

    BEGIN
        SELECT sequence_comment_log.nextval, SYSDATE
        INTO :new.comment_id, :new.comment_date
        FROM dual;

    END tr_new_comment_in;
/

/* subscription_log Auto-number PK and current date */
CREATE OR RELACE TRIGGER tr_new_subscription_in
    BEFORE INSERT ON subscription_log
    FOR EACH ROW

    BEGIN
        SELECT sequence_subscription_log.nextval, SYSDATE
        INTO :new.subscription_id, :new.subscription_date
        FROM dual;

    END tr_new_subscription_in;
/

-- TODO: Add date triggers









-- ******************************************************
--    END SESSION
-- ******************************************************

spool off