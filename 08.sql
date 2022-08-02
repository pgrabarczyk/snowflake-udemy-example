drop database EXERCISE_DB;
create database EXERCISE_DB;
use database EXERCISE_DB;

CREATE STAGE MY_STAGE
    URL = 's3://snowflake-assignments-mc/unstructureddata/';

CREATE FILE FORMAT MY_FILE_FORMAT
    TYPE = JSON;

CREATE TABLE JSON_RAW  (
    RAW VARIANT
);

LIST @MY_STAGE;

SELECT t.$1, t.$2 FROM @MY_STAGE t;

COPY INTO JSON_RAW
FROM @MY_STAGE
FILE_FORMAT = MY_FILE_FORMAT;

SELECT COUNT(*) FROM JSON_RAW;

SELECT * FROM JSON_RAW LIMIT 1;

SELECT $1:last_name FROM JSON_RAW;

SELECT
    RAW:first_name::string as first_name,
    RAW:last_name::string as last_name,
    RAW:Skills[0]::string as skills_1,
    RAW:Skills[1]::string as skills_2
FROM JSON_RAW;

CREATE TABLE MY_TABLE(
    first_name STRING,
    last_name STRING,
    skills_1 STRING,
    skills_2 STRING
) AS SELECT
    RAW:first_name::string as first_name,
    RAW:last_name::string as last_name,
    RAW:Skills[0]::string as skills_1,
    RAW:Skills[1]::string as skills_2
FROM JSON_RAW;

SELECT * FROM MY_TABLE;

SELECT skills_1 FROM MY_TABLE
WHERE first_name = 'Florina';


SELECT * FROM JSON_RAW;

SELECT
    RAW:first_name::string as first_name,
    f.value:language::string as first_language,
    f.value:level::string as level_spoken
FROM JSON_RAW, TABLE(flatten(RAW:spoken_languages)) f;