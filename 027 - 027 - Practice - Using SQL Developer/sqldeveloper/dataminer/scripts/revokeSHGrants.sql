--------------------------------------------------------------------------------
-- Revokes select privs on SH data from user.
-- 
-- Parameters:
-- 1. User account - account to drop views and tables on
-- Example:
-- @revokeSHGrants.sql DMUSER
--------------------------------------------------------------------------
--

-- User Account substitution variable
DEFINE USER_ACCOUNT = "q[&&1]"

EXECUTE dbms_output.put_line('');
EXECUTE dbms_output.put_line('Revoke Data Miner demo data access to SH schema objects');
EXECUTE dbms_output.put_line('');

DECLARE
v_sql varchar2(100);
user_account_value varchar2(120);
BEGIN

user_account_value := q'[&&1]';

-- Revoke grants to SH tables/views
     BEGIN
        EXECUTE IMMEDIATE 'REVOKE SELECT ON sh.customers FROM "' || user_account_value || '" ';
        DBMS_OUTPUT.PUT_LINE ('Revoked select privilige on sh.customers' );
        EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE ('No select privilige on sh.customers' );
      END;
      
     BEGIN
        EXECUTE IMMEDIATE 'REVOKE SELECT ON sh.sales FROM "' || user_account_value || '" ';
        DBMS_OUTPUT.PUT_LINE ('Revoked select privilige on sh.sales' );
        EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE ('No select privilige on sh.sales' );
      END;      
      
     BEGIN
        EXECUTE IMMEDIATE 'REVOKE SELECT ON sh.products FROM "' || user_account_value || '" ';
        DBMS_OUTPUT.PUT_LINE ('Revoked select privilige on sh.products' );
        EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE ('No select privilige on sh.products' );
      END;  

     BEGIN
         EXECUTE IMMEDIATE 'REVOKE SELECT ON sh.supplementary_demographics FROM "' || user_account_value || '" ';
         DBMS_OUTPUT.PUT_LINE ('Revoked select privilige on sh.supplementary_demographics' );
        EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE ('No select privilige on sh.supplementary_demographics ' );
      END;  

     BEGIN
          EXECUTE IMMEDIATE 'REVOKE SELECT ON sh.countries FROM "' || user_account_value || '" ';
          DBMS_OUTPUT.PUT_LINE ('Revoked select privilige on sh.countries' );
        EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE ('No select privilige on sh.countries ' );
      END; 

     BEGIN
           EXECUTE IMMEDIATE 'REVOKE SELECT ON sh.cal_month_sales_mv FROM "' || user_account_value || '" ';
           DBMS_OUTPUT.PUT_LINE ('Revoked select privilige on sh.cal_month_sales_mv' );
        EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE ('No select privilige on sh.cal_month_sales_mv ' );
      END; 
    

     BEGIN
            EXECUTE IMMEDIATE 'REVOKE SELECT ON sh.channels FROM "' || user_account_value || '" ';
            DBMS_OUTPUT.PUT_LINE ('Revoked select privilige on sh.channels' );
        EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE ('No select privilige on sh.channels ' );
      END; 

     BEGIN
            EXECUTE IMMEDIATE 'REVOKE SELECT ON sh.costs FROM "' || user_account_value || '" ';
            DBMS_OUTPUT.PUT_LINE ('Revoked select privilige on sh.costs' );
        EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE ('No select privilige on sh.costs ' );
      END; 

     BEGIN
            EXECUTE IMMEDIATE 'REVOKE SELECT ON sh.FWEEK_PSCAT_SALES_MV FROM "' || user_account_value || '" ';
            DBMS_OUTPUT.PUT_LINE ('Revoked select privilige on sh.FWEEK_PSCAT_SALES_MV' );
        EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE ('No select privilige on sh.FWEEK_PSCAT_SALES_MV ' );
      END; 
 
     BEGIN
            EXECUTE IMMEDIATE 'REVOKE SELECT ON sh.promotions FROM "' || user_account_value || '" ';
            DBMS_OUTPUT.PUT_LINE ('Revoked select privilige on sh.promotions' );
        EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE ('No select privilige on sh.promotions ' );
      END;  

     BEGIN
            EXECUTE IMMEDIATE 'REVOKE SELECT ON sh.times FROM "' || user_account_value || '" ';
            DBMS_OUTPUT.PUT_LINE ('Revoked select privilige on sh.times' );
        EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE ('No select privilige on sh.times ' );
      END;  
   
END;
/
