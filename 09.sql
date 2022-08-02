-- Switch to role of accountadmin --

USE ROLE ACCOUNTDMIN;
CREATE DATABASE DEMO_DB;
USE DATABASE DEMO_DB;
USE WAREHOUSE COMPUTE_WH;

CREATE OR REPLACE TABLE DEMO_DB.PUBLIC.PART
AS
SELECT * FROM "SNOWFLAKE_SAMPLE_DATA"."TPCH_SF1"."PART";

SELECT * FROM PART
ORDER BY P_MFGR DESC;

UPDATE DEMO_DB.PUBLIC.PART
SET P_MFGR='Manufacturer#CompanyX'
WHERE P_MFGR='Manufacturer#5';

----> Note down query id here:

SELECT * FROM PART
ORDER BY P_MFGR DESC
LIMIT 100;

--- 3.1: Travel back using the offset until you get the result of before the update
SELECT * FROM PART
AT(OFFSET => -1*60) -- here you need to pass ofset when data would exists before the update
ORDER BY P_MFGR DESC;

--- 3.2: Travel back using the query id to get the result before the update

---- get query id which made the update ----
select QUERY_ID
from table(information_schema.query_history(dateadd('hours',-1,current_timestamp()),current_timestamp()))
where query_type = 'UPDATE'
order by start_time;

SELECT * FROM PART
BEFORE(STATEMENT => '01a5c1e1-3201-bd06-0001-2dfe0001209a')
ORDER BY P_MFGR DESC;
