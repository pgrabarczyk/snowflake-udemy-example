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

create or replace stage customer_stage
    url = 's3://snowflake-assignments-mc/fileformat/',
    FILE_FORMAT = (
        TYPE = CSV,
        field_delimiter ='|',
        SKIP_HEADER = 1
    );

list @customer_stage;

select t.$1, t.$2 from @customer_stage t;

copy into customer
    from @customer_stage
    ON_ERROR = CONTINUE;

select * from customer;