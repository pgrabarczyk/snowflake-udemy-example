drop database EXERCISE_DB;
create database EXERCISE_DB;
use database EXERCISE_DB;

create table customer (
    ID INT,
    first_name varchar,
    last_name varchar,
    email varchar,
    age int,
    city varchar
);

create or replace file format csv
    TYPE = CSV,
    field_delimiter =',',
    SKIP_HEADER = 1;

create or replace stage customer_stage
    url = 's3://snowflake-assignments-mc/copyoptions/example1',
    FILE_FORMAT = csv;

list @customer_stage;

select t.$1, t.$2 from @customer_stage t;

copy into customer
    from @customer_stage
    validation_mode = RETURN_ERRORS;

copy into customer
    from @customer_stage
    ON_ERROR = CONTINUE;

select count(*) from customer;