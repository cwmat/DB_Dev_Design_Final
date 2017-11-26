-- *********************************************
-- RYAN'S SCRIPTS
-- @qualityControl.sql
-- *********************************************

/* Ryan's Scripts 
	@qualityControl.sql
Attached are a number of scripts which will help you see what constraints,
foreign keys, and primary keys you have in your tables.
You can either save these as text documents (with a .sql extension)
and FTP to your account, or manually type them in yourself and save as
.sql scripts.

These queries run against the tables user_constraints and user_cons_columns
(you can use the desc command to find out what columns are in these tables).
These will list information about all tables you own.  Feel free to modify
to list only a single table.

constr.sql
	Lists all value constraints, such as "is not null" or
	"between '000' and '999'"

pk_col.sql
        List what columns in a table serve as the primary key.
        If more than one column is listed, you have a compound
	primary key

fk.sql
        Lists the foreign keys, with the name of the foreign key constraint,
        the name of the primary key constraint which is referenced
        (if you name these properly, it should tell you what table the
        fk references), and the delete mode (i.e delete cascade)

fk_col.sql
        Lists what columns in a table are used as a foreign key by a named
        foreign key constraint

fk_col_ref.sql
        Lists the referenced table and columns used by a named foreign key
        constraint.  Note that the first table is where the foreign key
        lives, and the second table is the one referenced by the foreign key.

Think of fk_col as the first half of a foreign key (before the "references"
clause) constraint and fk_col_ref as the second half  (after the
"references" clause).

*/

-- *********************************************
-- @constr.sql
-- *********************************************
/* Script to list column constraints for all tables */

column table_name format A15
column constraint_name format A20
column search_condition format A35
select table_name, constraint_name, search_condition  from
user_constraints where constraint_type='C' order by table_name;

-- *********************************************
-- fk.sql
-- *********************************************

/* Script to select Foreign Key ("Referential") constraints
	for user's tables */

column table_name format A15
column constraint_name format A30
column r_constraint_name format A20
column delete_rule format A12
select table_name, constraint_name, r_constraint_name, delete_rule from
user_constraints where constraint_type='R' order by table_name;

-- *********************************************
-- fk_col.sql
-- *********************************************

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
order by table_name, a.constraint_name;

-- *********************************************
-- pk_col_ref.sql
-- *********************************************

/* Script which list the referenced table and the referenced table columns
	for a foreign key constraint 
	NOTE:  To see the columns which the foreign key uses to reference, use
	the script fk_col.sql */

column table_name format A15
column constraint_name format A27
column ref_table format A15
column ref_col format A17
select a.table_name, a.constraint_name, b.table_name as "ref_table"
	, column_name as "ref_col"
from user_constraints a, user_cons_columns b
where a.constraint_type='R'
and a.r_constraint_name=b.constraint_name
order by table_name, a.constraint_name;

-- *********************************************
-- pk_col.sql
-- *********************************************

/* Script to list the columns which make up the primary key of user tables */

column table_name format A15
column column_name format A25
column constraint_name format A30
select a.table_name, column_name, a.constraint_name
from user_constraints a, user_cons_columns b
where a.constraint_type='P'
and a.constraint_name=b.constraint_name
order by table_name;

