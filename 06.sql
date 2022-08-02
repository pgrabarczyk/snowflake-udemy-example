drop database EXERCISE_DB;
create database EXERCISE_DB;
use database EXERCISE_DB;

create table employees (
    customer_id int,
    first_name varchar(50),
    last_name varchar(50),
    email varchar(50),
    age int,
    department varchar(50)
);

create or replace file format csv
TYPE = CSV,
field_delimiter =',',
SKIP_HEADER = 1;

create or replace stage my_stage
url = 's3://snowflake-assignments-mc/copyoptions/example2',
FILE_FORMAT = csv;

list @my_stage;

select t.$1, t.$2 from @my_stage t;

copy into employees
from @my_stage
TRUNCATECOLUMNS = true;

select count(*) from employees;