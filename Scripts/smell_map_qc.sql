-- ******************************************************
-- smell_map_qc.sql
--
-- Loader for the Smell Map Database
--
-- Description:	This script tests stored procedures, triggers, and 
-- referential and entity integrity.
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

spool smell_map_qc.lst


-- ******************************************************
--    QUALITY CONTROLS
--
-- Note:  Tests TODO
-- ******************************************************

/* Check column constraints */
-- View columns with value constraints
SELECT table_name, constraint_name, search_condition  FROM
user_constraints WHERE constraint_type='C' ORDER BY table_name;

-- smell_type rg_smell_type between '01' - '03'

-- smell_magnitude rg_smell_magnitude between '01' - '10'

-- smell_type rg_smell_type_profile between '01' - '03'

-- smell_magnitude rg_smell_magnitude_profile between '01' - '10'

/* Check entity integrity */
-- Ryan's pk_col script will list out all of the columns that are PKs so that we may use
-- them as reference when creating our test cases.  However, by convention, we have made it easy
-- to pick out our PKs by name.  
column table_name format A15
column column_name format A25
column constraint_name format A30
select a.table_name, column_name, a.constraint_name
from user_constraints a, user_cons_columns b
where a.constraint_type='P'
and a.constraint_name=b.constraint_name
order by table_name;

-- Try duplicate and null on each PK


/* Check referential integrity */
-- Ryan's fk_col script will show us which FK constraints we have and the constraint name
-- along with associated reference column.  This information will help us build our test cases.
column table_name format A15
column constraint_name format A30
column column_name format A30
select a.table_name, a.constraint_name, column_name
from user_constraints a, user_cons_columns b
where a.constraint_type='R'
and a.constraint_name=b.constraint_name
order by table_name, a.constraint_name;

-- Test adding a FK that does not correspond to a PK (Part '50' does not exist).

-- Attempt to delete a parent record before the associated default FK record.


-- ******************************************************
--    END SESSION
-- ******************************************************

spool off
