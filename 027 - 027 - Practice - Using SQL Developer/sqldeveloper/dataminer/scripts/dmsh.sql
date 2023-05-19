--------------------------------------------------------------------------------
--    DESCRIPTION
--      This script creates views using SH data
--      in the schema of the data mining user.
--      Some of these are referenced by Data Miner Cue Card Demos.
--      Others are referenced for use by demo programs.
--      This is not an exact copy of the dmsh.sql used in the 
--      supporting demo programs. Specifically, no text indexing
--      is being performed and no nested tables are being generated.
--      Data Miner adresses these steps differently then do the demo
--      programs.
--
--    NOTES
--       The script assumes that the full SH schema is already created and the
--       necessary SELECTs have been granted (See dmshgrants.sql). This script runs in 
--       the schema of the data mining user.
--       mining_data_*_v views : Used for mining 
--
--    MODIFIED   (MM/DD/YY)
--       mbkelly     07/31/10 - copied from rdbms/demo and revised for ODMr
--
--    Parameters:
--    1. User Account - user account to create the views in
--    Example:
--    @dmsh.sql DMUSER
--------------------------------------------------------------------------------
--


EXECUTE dbms_output.put_line('');
EXECUTE dbms_output.put_line('Create Data Miner demo tables and views based on SH schema.');
EXECUTE dbms_output.put_line('');
SET SERVEROUTPUT ON
DECLARE
v_sql varchar2(32767);
user_account_value varchar2(120);
BEGIN

user_account_value := q'[&&1]';

-- Change to the new user schema
BEGIN
v_sql := 'ALTER session set current_schema = "' || user_account_value || '" ' ; -- Enter the user schema
EXECUTE IMMEDIATE v_sql;
DBMS_OUTPUT.PUT_LINE (v_sql ||': succeeded');
EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE (v_sql ||': ***  Failed ***');
raise;
END;

-- unlock SH Account (MK:prompts for new password so I have commented this out)
--PASSWORD SH UNLOCK;
BEGIN
v_sql := 'CREATE VIEW mining_data_apply_v AS
SELECT
 a.CUST_ID,
 a.CUST_GENDER,
 2003-a.CUST_YEAR_OF_BIRTH AGE,
 a.CUST_MARITAL_STATUS,
 c.COUNTRY_NAME,
 a.CUST_INCOME_LEVEL,
 b.EDUCATION,
 b.OCCUPATION,
 b.HOUSEHOLD_SIZE,
 b.YRS_RESIDENCE,
 b.AFFINITY_CARD,
 b.BULK_PACK_DISKETTES,
 b.FLAT_PANEL_MONITOR,
 b.HOME_THEATER_PACKAGE,
 b.BOOKKEEPING_APPLICATION,
 b.PRINTER_SUPPLIES,
 b.Y_BOX_GAMES,
 b.OS_DOC_SET_KANJI
FROM
 sh.customers a,
 sh.supplementary_demographics b,
 sh.countries c
WHERE
 a.CUST_ID = b.CUST_ID
 AND a.country_id  = c.country_id
 AND a.cust_id between 100001 and 101500';
EXECUTE IMMEDIATE v_sql;
DBMS_OUTPUT.PUT_LINE (v_sql ||': succeeded');
EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE (v_sql ||': ***  Failed ***');
raise;
END;
-------------------------------------------------------------------------------------

BEGIN
v_sql := 'CREATE VIEW mining_data_build_v AS
SELECT
 a.CUST_ID,
 a.CUST_GENDER,
 2003-a.CUST_YEAR_OF_BIRTH AGE,
 a.CUST_MARITAL_STATUS,
 c.COUNTRY_NAME,
 a.CUST_INCOME_LEVEL,
 b.EDUCATION,
 b.OCCUPATION,
 b.HOUSEHOLD_SIZE,
 b.YRS_RESIDENCE,
 b.AFFINITY_CARD,
 b.BULK_PACK_DISKETTES,
 b.FLAT_PANEL_MONITOR,
 b.HOME_THEATER_PACKAGE,
 b.BOOKKEEPING_APPLICATION,
 b.PRINTER_SUPPLIES,
 b.Y_BOX_GAMES,
 b.OS_DOC_SET_KANJI
FROM
 sh.customers a,
 sh.supplementary_demographics b,
 sh.countries c
WHERE
 a.CUST_ID = b.CUST_ID
 AND a.country_id  = c.country_id
 AND a.cust_id between 101501 and 103000';
EXECUTE IMMEDIATE v_sql;
DBMS_OUTPUT.PUT_LINE (v_sql ||': succeeded');
EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE (v_sql ||': *** Failed ***');
raise;
END;
----------------------------------------------------------------------

BEGIN
v_sql := 'CREATE VIEW mining_data_test_v AS
SELECT
 a.CUST_ID,
 a.CUST_GENDER,
 2003-a.CUST_YEAR_OF_BIRTH AGE,
 a.CUST_MARITAL_STATUS,
 c.COUNTRY_NAME,
 a.CUST_INCOME_LEVEL,
 b.EDUCATION,
 b.OCCUPATION,
 b.HOUSEHOLD_SIZE,
 b.YRS_RESIDENCE,
 b.AFFINITY_CARD,
 b.BULK_PACK_DISKETTES,
 b.FLAT_PANEL_MONITOR,
 b.HOME_THEATER_PACKAGE,
 b.BOOKKEEPING_APPLICATION,
 b.PRINTER_SUPPLIES,
 b.Y_BOX_GAMES,
 b.OS_DOC_SET_KANJI
FROM
 sh.customers a,
 sh.supplementary_demographics b,
 sh.countries c
WHERE
 a.CUST_ID = b.CUST_ID
 AND a.country_id  = c.country_id
 AND a.cust_id between 103001 and 104500';
EXECUTE IMMEDIATE v_sql;
DBMS_OUTPUT.PUT_LINE (v_sql ||': succeeded');
EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE (v_sql ||': *** Failed ***');
raise;
END;
----------------------------------------------------------------------

BEGIN
v_sql := 'CREATE VIEW mining_data_text_apply_v AS
SELECT
 a.CUST_ID,
 a.CUST_GENDER,
 2003-a.CUST_YEAR_OF_BIRTH AGE,
 a.CUST_MARITAL_STATUS,
 c.COUNTRY_NAME,
 a.CUST_INCOME_LEVEL,
 b.EDUCATION,
 b.OCCUPATION,
 b.HOUSEHOLD_SIZE,
 b.YRS_RESIDENCE,
 b.AFFINITY_CARD,
 b.BULK_PACK_DISKETTES,
 b.FLAT_PANEL_MONITOR,
 b.HOME_THEATER_PACKAGE,
 b.BOOKKEEPING_APPLICATION,
 b.PRINTER_SUPPLIES,
 b.Y_BOX_GAMES,
 b.OS_DOC_SET_KANJI,
 b.comments 
FROM
 sh.customers a,
 sh.supplementary_demographics b,
 sh.countries c
WHERE
 a.CUST_ID = b.CUST_ID
 AND a.country_id  = c.country_id
 AND a.cust_id between 100001 and 101500';
EXECUTE IMMEDIATE v_sql;
DBMS_OUTPUT.PUT_LINE (v_sql ||': succeeded');
EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE (v_sql ||': *** Failed ***');
raise;
END;

----------------------------------------------------------------------

BEGIN
v_sql := 'CREATE VIEW mining_data_text_build_v AS
SELECT
 a.CUST_ID,
 a.CUST_GENDER,
 2003-a.CUST_YEAR_OF_BIRTH AGE,
 a.CUST_MARITAL_STATUS,
 c.COUNTRY_NAME,
 a.CUST_INCOME_LEVEL,
 b.EDUCATION,
 b.OCCUPATION,
 b.HOUSEHOLD_SIZE,
 b.YRS_RESIDENCE,
 b.AFFINITY_CARD,
 b.BULK_PACK_DISKETTES,
 b.FLAT_PANEL_MONITOR,
 b.HOME_THEATER_PACKAGE,
 b.BOOKKEEPING_APPLICATION,
 b.PRINTER_SUPPLIES,
 b.Y_BOX_GAMES,
 b.OS_DOC_SET_KANJI,
 b.comments 
FROM
 sh.customers a,
 sh.supplementary_demographics b,
 sh.countries c
WHERE
 a.CUST_ID = b.CUST_ID
 AND a.country_id  = c.country_id
 AND a.cust_id between 101501 and 103000';
EXECUTE IMMEDIATE v_sql;
DBMS_OUTPUT.PUT_LINE (v_sql ||': succeeded');
EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE (v_sql ||': *** Failed ***');
raise;
END;

----------------------------------------------------------------------

BEGIN
v_sql := 'CREATE VIEW mining_data_text_test_v AS
SELECT
 a.CUST_ID,
 a.CUST_GENDER,
 2003-a.CUST_YEAR_OF_BIRTH AGE,
 a.CUST_MARITAL_STATUS,
 c.COUNTRY_NAME,
 a.CUST_INCOME_LEVEL,
 b.EDUCATION,
 b.OCCUPATION,
 b.HOUSEHOLD_SIZE,
 b.YRS_RESIDENCE,
 b.AFFINITY_CARD,
 b.BULK_PACK_DISKETTES,
 b.FLAT_PANEL_MONITOR,
 b.HOME_THEATER_PACKAGE,
 b.BOOKKEEPING_APPLICATION,
 b.PRINTER_SUPPLIES,
 b.Y_BOX_GAMES,
 b.OS_DOC_SET_KANJI,
 b.comments 
FROM
 sh.customers a,
 sh.supplementary_demographics b,
 sh.countries c
WHERE
 a.CUST_ID = b.CUST_ID
 AND a.country_id  = c.country_id
 AND a.cust_id between 103001 and 104500';
EXECUTE IMMEDIATE v_sql;
DBMS_OUTPUT.PUT_LINE (v_sql ||': succeeded');
EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE (v_sql ||': *** Failed ***');
raise;
END;

EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE ('*** ERROR: SH Views could not be created.***');
END;
/