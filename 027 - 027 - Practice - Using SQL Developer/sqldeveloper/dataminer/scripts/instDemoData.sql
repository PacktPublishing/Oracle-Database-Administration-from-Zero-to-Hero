-- prepares demo data for user
-- A. Grant user access to SH schema
-- B. Create mining_data_* views in user account based on SH schema
-- C. Load insurance data into table in user account
-- Parameters:
-- 1: <USER>  - user account
-- Example:
-- @instDemoData.sql MYUSER

EXECUTE dbms_output.put_line('Start installing demo data. ' || systimestamp);

-- User account subsitution variable
DEFINE USER_ACCOUNT = &&1

-- drop prexisting demo views/tables and revokes SH select grants
@@dropSHDemoData.sql "&USER_ACCOUNT"  

--grant rights to SH
@@dmshgrants.sql "&USER_ACCOUNT"

-- create demo tables/views based on SH data in users account
@@dmsh.sql "&USER_ACCOUNT"

-- load odmr cars data
@@instCarsDemoData.sql "&USER_ACCOUNT"

-- load insurance customer demo data
@@instInsurCustData.sql "&USER_ACCOUNT"

-- load customer JSON sales demo data (12.1.0.2)
@@instJSONSalesData.sql "&USER_ACCOUNT"

-- load wikipedia demo data (12.2.0.0)
@@instWikiSampleData.sql "&USER_ACCOUNT"

-- Create mining data text table  (12.2.0.0)
@@instMiningDataText.sql "&USER_ACCOUNT"

-- create ODMR_SALES_DATA table (12.2.0.0)
@@instSalesData.sql "&USER_ACCOUNT"

EXECUTE dbms_output.put_line('Finished installing demo data. ' || systimestamp);


exit;
