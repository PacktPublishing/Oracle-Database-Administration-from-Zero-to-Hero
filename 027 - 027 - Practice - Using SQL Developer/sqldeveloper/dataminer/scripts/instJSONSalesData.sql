
-- loads ODMR_SALES_JSON_DATA table with JSON data for Data Miner OBE Demo
--
-- Paramters:
-- 1. User account - account to load the table into
-- Example:
-- @instJSONSalesData.sql DMUSER
---------------------------------------------------------------------------

EXECUTE dbms_output.put_line('');
EXECUTE dbms_output.put_line('Load Data Miner demo table ODMR_SALES_JSON_DATA.');
EXECUTE dbms_output.put_line('');

-- Drop table if it already exists
-- NOTE: ERRORS ARE OK FOR THE DROP TABLE AS IT CONFIRMS THE TABLE DOES NOT EXIST
DECLARE
  db_ver  VARCHAR2(30);
  v_sql varchar2(32767); 
  user_account_value varchar2(120);
  v_compatible_level VARCHAR2(30);
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

  SELECT VALUE INTO v_compatible_level FROM database_compatible_level;
  DBMS_OUTPUT.PUT_LINE('Database compatible level = ' || v_compatible_level);
  
  SELECT VERSION INTO db_ver FROM product_component_version WHERE product LIKE 'Oracle Database%' OR product like 'Personal Oracle Database %' ;
  IF (db_ver >= '12.1.0.2' AND v_compatible_level >= '12.1.0.2') THEN

    BEGIN
      v_sql := 'DROP TABLE ODMR_SALES_JSON_DATA cascade constraints';
      EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE (v_sql ||': succeeded');
    EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE (v_sql ||': drop unneccessary - no table/view exists');
    END;
    
    --------------------------------------------------------
    --  DDL for Table ODMR_SALES_JSON_DATA
    --------------------------------------------------------
    
    EXECUTE IMMEDIATE 'CREATE TABLE ODMR_SALES_JSON_DATA 
     (JSON_DATA CLOB,
      CONSTRAINT ODMR_SALES_JSON_DATA_CONSTRNT CHECK (JSON_DATA IS JSON (STRICT))
     ) NOLOGGING';
    
    ----------------------------------------------------------------
    --  Populate Table ODMR_SALES_JSON_DATA used data from SH.SALES
    ----------------------------------------------------------------
    
    EXECUTE IMMEDIATE 'INSERT INTO ODMR_SALES_JSON_DATA (JSON_DATA)
        SELECT
            dbms_xmlgen.CONVERT(
            ''{"CUST_ID":''||a.CUST_ID||'',''||
            ''"EDUCATION":''||''"''||a.EDUCATION||''",''||
            ''"OCCUPATION":''||''"''||a.OCCUPATION||''",''||
            ''"HOUSEHOLD_SIZE":''||''"''||a.HOUSEHOLD_SIZE||''",''||
            ''"YRS_RESIDENCE":''||''"''||a.YRS_RESIDENCE||''",''||
            ''"AFFINITY_CARD":''||''"''||a.AFFINITY_CARD||''",''||
            ''"BULK_PACK_DISKETTES":''||''"''||a.BULK_PACK_DISKETTES||''",''||
            ''"FLAT_PANEL_MONITOR":''||''"''||a.FLAT_PANEL_MONITOR||''",''||
            ''"HOME_THEATER_PACKAGE":''||''"''||a.HOME_THEATER_PACKAGE||''",''||
            ''"BOOKKEEPING_APPLICATION":''||''"''||a.BOOKKEEPING_APPLICATION||''",''||
            ''"PRINTER_SUPPLIES":''||''"''||a.PRINTER_SUPPLIES||''",''||
            ''"Y_BOX_GAMES":''||''"''||a.Y_BOX_GAMES||''",''||
            ''"OS_DOC_SET_KANJI":''||''"''||a.OS_DOC_SET_KANJI||''",''||
            ''"COMMENTS":''||''"''||a.COMMENTS||''",''||
            ''"SALES":[''||
            RTRIM(
            XMLAGG(XMLELEMENT(E,(''{''||''"PROD_ID":''||PROD_ID||'',''||''"QUANTITY_SOLD":''||QUANTITY_SOLD||'',''||''"AMOUNT_SOLD":''||AMOUNT_SOLD||'',''||''"CHANNEL_ID":''||CHANNEL_ID||'',''||''"PROMO_ID":''||PROMO_ID||''}''||'',''))).EXTRACT(''//text()'').getclobval()
            ,'','')
            ,1)||'']}''
        FROM SH.SUPPLEMENTARY_DEMOGRAPHICS a, SH.SALES b
        WHERE a.CUST_ID = b.CUST_ID
        GROUP BY a.CUST_ID, a.EDUCATION, a.OCCUPATION, a.HOUSEHOLD_SIZE, a.YRS_RESIDENCE, a.AFFINITY_CARD, a.BULK_PACK_DISKETTES, a.FLAT_PANEL_MONITOR,
        a.HOME_THEATER_PACKAGE, a.BOOKKEEPING_APPLICATION, a.PRINTER_SUPPLIES, a.Y_BOX_GAMES, a.OS_DOC_SET_KANJI, a.COMMENTS';
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE ('Data Miner demo table ODMR_SALES_JSON_DATA loaded.');
  ELSE
    DBMS_OUTPUT.PUT_LINE ('Data Miner demo table ODMR_SALES_JSON_DATA not loaded for database version and compatible level below 12.1.0.2.');
  END IF;
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE ('Error Loading Data Miner demo table ODMR_SALES_JSON_DATA.');
END;
/