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