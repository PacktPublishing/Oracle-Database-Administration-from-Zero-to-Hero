--------------------------------------------------------------------------------
-- Drops views created in users account that are based on the
-- SH sample schema as well as the INSUR_CUST_LTV_SAMPLE table that is loaded via script.
-- 
-- Parameters:
-- 1. User account - account to drop views and tables on
-- Example:
-- @dropSHDemoData.sql DMUSER
--------------------------------------------------------------------------
--

EXECUTE dbms_output.put_line('');
EXECUTE dbms_output.put_line('Drop Data Miner demo views and tables.');
EXECUTE dbms_output.put_line('');
set serveroutput on
-- Drop Views
-- NOTE: ERRORS ARE OK FOR THESE DROPS AS THEY CONFIRM THE TABLES/VIEWS DO NOT EXIST
DECLARE
v_sql varchar2(100);
user_account_value varchar2(120);
BEGIN

user_account_value := q'[&&1]';

BEGIN
v_sql := 'drop VIEW "' || user_account_value || '".mining_data_apply_v';
EXECUTE IMMEDIATE v_sql;
DBMS_OUTPUT.PUT_LINE (v_sql ||': succeeded');
EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE (v_sql ||': drop unneccessary - no table/view exists');
END;

BEGIN
v_sql := 'drop VIEW "' || user_account_value || '".mining_data_build_v';
EXECUTE IMMEDIATE v_sql;
DBMS_OUTPUT.PUT_LINE (v_sql ||': succeeded');
EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE (v_sql ||': drop unneccessary - no table/view exists');
END;

BEGIN
v_sql := 'drop VIEW "' || user_account_value || '".mining_data_test_v';
EXECUTE IMMEDIATE v_sql;
DBMS_OUTPUT.PUT_LINE (v_sql ||': succeeded');
EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE (v_sql ||': drop unneccessary - no table/view exists');
END;

BEGIN
v_sql := 'drop VIEW "' || user_account_value || '".mining_data_text_apply_v';
EXECUTE IMMEDIATE v_sql;
DBMS_OUTPUT.PUT_LINE (v_sql ||': succeeded');
EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE (v_sql ||': drop unneccessary - no table/view exists');
END;

BEGIN
v_sql := 'drop VIEW "' || user_account_value || '".mining_data_text_build_v';
EXECUTE IMMEDIATE v_sql;
DBMS_OUTPUT.PUT_LINE (v_sql ||': succeeded');
EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE (v_sql ||': drop unneccessary - no table/view exists');
END;

BEGIN
v_sql := 'drop VIEW "' || user_account_value || '".mining_data_text_test_v';
EXECUTE IMMEDIATE v_sql;
DBMS_OUTPUT.PUT_LINE (v_sql ||': succeeded');
EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE (v_sql ||': drop unneccessary - no table/view exists');
END;

BEGIN
v_sql := 'drop TABLE "' || user_account_value || '".ODMR_CARS_DATA';
EXECUTE IMMEDIATE v_sql;
DBMS_OUTPUT.PUT_LINE (v_sql ||': succeeded');
EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE (v_sql ||': drop unneccessary - no table/view exists');
END;

BEGIN
v_sql := 'DROP TABLE "' || user_account_value || '"."INSUR_CUST_LTV_SAMPLE" cascade constraints';
EXECUTE IMMEDIATE v_sql;
DBMS_OUTPUT.PUT_LINE (v_sql ||': succeeded');
EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE (v_sql ||': drop unneccessary - no table/view exists');
END;

--(12.1.0.2)
--BEGIN
--v_sql := 'DROP TABLE "' || user_account_value || '"."SALES" cascade constraints';
--EXECUTE IMMEDIATE v_sql;
--DBMS_OUTPUT.PUT_LINE (v_sql ||': succeeded');
--EXCEPTION
--WHEN OTHERS THEN
--DBMS_OUTPUT.PUT_LINE (v_sql ||': drop unneccessary - no table/view exists');
--END;

--(12.2.0.0)
BEGIN
v_sql := 'DROP TABLE "' || user_account_value || '".WIKISAMPLE';
EXECUTE IMMEDIATE v_sql;
DBMS_OUTPUT.PUT_LINE (v_sql ||': succeeded');
EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE (v_sql ||': drop unneccessary - no table/view exists');
END;

EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE ('Exiting early from process of dropping demo data');
END;
/