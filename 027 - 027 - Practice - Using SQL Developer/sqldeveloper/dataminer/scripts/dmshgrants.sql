--    DESCRIPTION
--      This script grants SELECT on SH tables 
--      required to support Data Miner Cue Card demos
--      
--      The script is to be run in SYS account
--    NOTES
--       &&1    Name of the DM user
--    MODIFIED   (MM/DD/YY)
--       mbkelly     07/31/10 - copied and revised from rbms/demo to support
--                               Data Miner 
-- Example:
-- @dmshgrants.sql DMUSER
--------------------------------------------------------------------------------

DECLARE
  v_sql varchar2(100);
  user_account_value varchar2(120);
  v_privilege varchar2(10);
  DB_VER  VARCHAR2(30);
BEGIN
  user_account_value := q'[&&1]';
  SELECT VERSION INTO DB_VER FROM PRODUCT_COMPONENT_VERSION WHERE PRODUCT LIKE 'Oracle Database%' OR PRODUCT LIKE 'Personal Oracle Database %' ;
  IF (DB_VER >= '12.1.0.2' ) THEN
    v_privilege := 'READ';
  ELSE
    v_privilege := 'SELECT';
  END IF;
  -- unlock SH Account (MK:prompts for new password so I have commented this out)
  --PASSWORD SH UNLOCK;
  BEGIN
    v_sql := 'GRANT '||v_privilege||' ON sh.customers TO ' || '"' || user_account_value || '"' ;
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE (v_sql ||': succeeded');
  EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE (v_sql ||': sh.customers - no table/view exists');
  END;
  BEGIN
    v_sql := 'GRANT '||v_privilege||' ON sh.sales TO ' || '"' || user_account_value || '"';
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE (v_sql ||': succeeded');
  EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE (v_sql ||': sh.sales - no table/view exists');
  END;
  BEGIN
    v_sql := 'GRANT '||v_privilege||' ON sh.products TO ' || '"' || user_account_value || '"';
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE (v_sql ||': succeeded');
  EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE (v_sql ||': sh.products - no table/view exists');
  END;
  BEGIN
    v_sql := 'GRANT '||v_privilege||' ON sh.supplementary_demographics TO ' || '"' || user_account_value || '"';
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE (v_sql ||': succeeded');
  EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE (v_sql ||': sh.supplementary_demographics - no table/view exists');
  END;
  BEGIN
    v_sql := 'GRANT '||v_privilege||' ON sh.countries TO ' || '"' || user_account_value || '"';
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE (v_sql ||': succeeded');
  EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE (v_sql ||': sh.countries - no table/view exists');
  END;
  BEGIN
    v_sql := 'GRANT '||v_privilege||' ON sh.cal_month_sales_mv TO ' || '"' || user_account_value || '"';
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE (v_sql ||': succeeded');
  EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE (v_sql ||': sh.cal_month_sales_mv - no table/view exists');
  END;
  BEGIN
    v_sql := 'GRANT '||v_privilege||' ON sh.channels TO ' || '"' || user_account_value || '"';
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE (v_sql ||': succeeded');
  EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE (v_sql ||': sh.channels - no table/view exists');
  END;
  BEGIN
    v_sql := 'GRANT '||v_privilege||' ON sh.costs TO ' || '"' || user_account_value || '"';
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE (v_sql ||': succeeded');
  EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE (v_sql ||': sh.costs - no table/view exists');
  END;
  BEGIN
    v_sql := 'GRANT '||v_privilege||' ON sh.FWEEK_PSCAT_SALES_MV TO ' || '"' || user_account_value || '"';
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE (v_sql ||': succeeded');
  EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE (v_sql ||': sh.FWEEK_PSCAT_SALES_MV - no table/view exists');
  END;
  BEGIN
    v_sql := 'GRANT '||v_privilege||' ON sh.promotions TO ' || '"' || user_account_value || '"';
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE (v_sql ||': succeeded');
  EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE (v_sql ||': sh.promotions - no table/view exists');
  END;
  BEGIN
    v_sql := 'GRANT '||v_privilege||' ON sh.times TO ' || '"' || user_account_value || '"';
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE (v_sql ||': succeeded');
  EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE (v_sql ||': sh.times - no table/view exists');
  END;  
EXCEPTION
  WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE ('Exiting early from process of GRANTING demo data');
END;
/