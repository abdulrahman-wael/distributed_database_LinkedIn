
--Vertical Fragmentation

select * from Employees;

--vertical fragment 1: we select the columns for employees' personal information from Emp table and stored in site 1
select SSN, Fname, Minit, Lname, Bdate, street, zone_name, gender into Emp_Info
from Employees;

select * from Emp_Info;

--vertical fragment 2: we select the columns for employees' Info Working from Emp table and stored in site 2
select SSN, ID, Fname, salary, DNO, Super_SSN into Emp_Info_Working
from Employees;

select * from Emp_Info_Working;

--Reconstructe
--select col_names from t1 join t2 on condition
select * from Emp_Info join Emp_Info_Working
on Emp_Info.SSN = Emp_Info_Working.SSN;


--Horizontal Fragmentation

--horizontal fragment 1: We select the rows in which employees work in (Dno = 1)
select * into Emp1 
from Employees
where DNO = 1;

select * from Emp1;

--horizontal fragment 2: We select the rows in which employees work in (Dno = 4)
select * into Emp2 
from Employees
where DNO = 4;

select * from Emp2;

--horizontal fragment 3: We select the rows in which employees work in (Dno = 5)
select * into Emp3 
from Employees
where DNO = 5;

select * from Emp3;

--Reconstructe
select * from Emp1
union all
select * from Emp2
union all
select * from Emp3


--Hybrid Fragmentation ( Based on the example of the doctor in the third lecture )
-- (1) we divide the Emp table into 2 hybrid fragmentation one of them has employees who work in Dno = 4 and the other has employees who work Dno = 5
--hybrid fragment 1: for Dno = 4
select SSN, Fname, Minit, Lname, salary, Super_SSN, DNO into EMPD_4
from Employees
where DNO = 4;

select * from EMPD_4;

--hybrid fragment 2: for Dno = 5
select SSN, Fname, Minit, Lname, salary, Super_SSN, DNO into EMPD_5
from Employees
where DNO = 5;

select * from EMPD_5;

-- (2) we divide the Deptartment table into 2 horizontal fragmentation one of them for Dno = 4 and the other for Dno = 5
--horizontal fragment 1: for Dno = 4
select * into DEP_4 
from Department
where Dnumber = 4;

select * from DEP_4;

--horizontal fragment 2: for Dno = 5
select * into DEP_5 
from Department
where Dnumber = 5;

select * from DEP_5;

-- (3) we divide the Dept_location table into 2 horizontal fragmentation one of them has location for Dno = 4 and the other has location for Dno = 5
--horizontal fragment 1: for Dno = 4
select * into DEP_4_LOCS 
from Dept_Locations
where Dnumber = 4;

select * from DEP_4_LOCS;

--horizontal fragment 2: for Dno = 5
select * into DEP_5_LOCS 
from Dept_Locations
where Dnumber = 5;

select * from DEP_5_LOCS;

-- (4) we divide the Project table into 2 horizontal fragmentation one of them has projects for Dno = 4 and the other has projects for Dno = 5
--horizontal fragment 1: for Dno = 4
select * into PROJS_4 
from PROJECT
where DNO = 4;

select * from PROJS_4;

--horizontal fragment 2: for Dno = 5
select * into PROJS_5 
from PROJECT
where DNO = 5;

select * from PROJS_5;

-- (5) we divide the Works_On table into 2 horizontal fragmentation one of them includes employees who work on projects for Dno = 4 and the other includes employees who work on projects for Dno = 5
--horizontal fragment 1: for Dno = 4
select * into WORKS_ON_4 
from Works_on
where PNO = 4 or PNO = 6;

select * from WORKS_ON_4;

--horizontal fragment 2: for Dno = 5
select * into WORKS_ON_5 
from Works_on
where PNO = 1 or PNO = 2 or PNO = 3;

select * from WORKS_ON_5;