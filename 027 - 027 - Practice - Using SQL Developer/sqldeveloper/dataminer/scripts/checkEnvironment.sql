-- Check DB Version
DECLARE
  v_version VARCHAR(30);
BEGIN
  SELECT DISTINCT DB.VERSION INTO v_version FROM PRODUCT_COMPONENT_VERSION DB WHERE DB.PRODUCT LIKE '%Oracle Database%';
  DBMS_OUTPUT.PUT_LINE('Database version is: ' || v_version);
  IF( v_version < '11.2.0.4') THEN
    RAISE_APPLICATION_ERROR(-20000, 'Not Supported Database Version. 11.2.0.4 or above is required.');
  END IF;
EXCEPTION WHEN NO_DATA_FOUND THEN
  DBMS_OUTPUT.PUT_LINE('NO_DATA_FOUND when attempting to query PRODUCT_COMPONENT_VERSION DB.');
  RAISE_APPLICATION_ERROR(-20000, 'Not Supported Database Version. 11.2.0.4 or above is required.');
END;
/


-- Check if database is CD$ROOT
-- Installation is not allowed on CD$ROOT. The Database must be a pluggable database.
/*
DECLARE
  v_con_name VARCHAR(200);
  invalid_userenv EXCEPTION;  --invalid USERENV parameter CON_NAME
  PRAGMA EXCEPTION_INIT(invalid_userenv, -2003);
BEGIN
  SELECT SYS_CONTEXT ('USERENV', 'CON_NAME') INTO v_con_name FROM DUAL;
  IF( v_con_name = 'CDB$ROOT') THEN
      RAISE_APPLICATION_ERROR(-20000, 'Data Miner can not be installed in CD$ROOT. Install in a pluggable database.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Validated database is not CD$ROOT.');  
  END IF;
EXCEPTION
  WHEN invalid_userenv THEN  -- not a valid argument on db less than 12.1
    DBMS_OUTPUT.PUT_LINE('Validated database is not CD$ROOT.');  
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error in querying SYS_CONTEXT CON_NAME.  May be the result of connecting to a container db instead of a pluggable db, or the pluggable db may not be opened. Error: '||SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE(), 1, 4000));
    RAISE_APPLICATION_ERROR(-20000, 'Unable to determine if database is CD$ROOT.');
END;
*/

--Check if data mining option is available
--per dwong: disable this check since Data Mining option is now standard in all versions of db
-- DECLARE
--   v_installed VARCHAR(10);
-- BEGIN
--   EXECUTE IMMEDIATE 'SELECT VALUE FROM v$option WHERE PARAMETER = ''Data Mining''' INTO v_installed;
--   IF( v_installed  = 'FALSE' ) THEN
--     RAISE_APPLICATION_ERROR(-20000, 'Data Mining option not installed.
--       Please install the Data Mining option, or see your database administrator for assistance.');
--   ELSE
--     DBMS_OUTPUT.PUT_LINE('Validated Data Mining option is on.');
--   END IF;
-- EXCEPTION WHEN NO_DATA_FOUND THEN
--   DBMS_OUTPUT.PUT_LINE('NO_DATA_FOUND when attempting to query v$option for Data Mining option.');
--   RAISE_APPLICATION_ERROR(-20000, 'Unable to determine if database has Data Mining option set to TRUE');
-- END;
-- /


--Validate that the db has text and xmldb options installed
/*
DECLARE
  CURSOR c_comps IS
    SELECT COMP_ID, STATUS FROM DBA_REGISTRY WHERE COMP_ID IN ('XDB','CONTEXT');
  v_comp   DBA_REGISTRY.COMP_ID%TYPE := '';
  v_status DBA_REGISTRY.STATUS%TYPE := '';
  v_xdb      BOOLEAN := FALSE;
  v_text     BOOLEAN := FALSE;
  
BEGIN

  OPEN c_comps;
  
  LOOP
  FETCH c_comps INTO v_comp, v_status;
  EXIT WHEN c_comps%NOTFOUND;
  
    IF( v_comp = 'XDB' AND v_status = 'VALID') THEN
      v_xdb := TRUE;
    ELSIF ( v_comp = 'CONTEXT' AND v_status = 'VALID') THEN
      v_text := TRUE;
    END IF;
  END LOOP;
    
  CLOSE c_comps;

  IF( v_xdb = FALSE AND v_text = FALSE ) THEN
    RAISE_APPLICATION_ERROR(-20000, 
      'Oracle XMLDB and Text features required by Data Miner are not installed. 
       Please install the Oracle XMLDB and Text features, or see your database administrator for assistance.');
  ELSIF( v_xdb = TRUE AND v_text = FALSE ) THEN
    RAISE_APPLICATION_ERROR(-20000, 
      'Oracle Text feature required by Data Miner is not installed. 
       Please install the Oracle Text feature, or see your database administrator for assistance.');
  ELSIF( v_xdb = FALSE AND v_text = TRUE ) THEN
    RAISE_APPLICATION_ERROR(-20000, 
      'Oracle XMLDB feature required by Data Miner is not installed. 
       Please install the Oracle XMLDB feature, or see your database administrator for assistance.');
  END IF;
  DBMS_OUTPUT.PUT_LINE('Validated Oracle XMLDB and Text features are installed.');
 
EXCEPTION WHEN NO_DATA_FOUND THEN
  DBMS_OUTPUT.PUT_LINE('Oracle XMLDB and Text features required by Data Miner are not installed.');
  RAISE_APPLICATION_ERROR(-20000, 
      'Unable to determine if Oracle XMLDB and Text features are installed.');
END;
*/

--Check Knowledge base
DECLARE
  v_policy VARCHAR2(30);
  rtab ctx_doc.theme_tab;
  v_del BOOLEAN := FALSE;
  
  FUNCTION generateUniqueName RETURN VARCHAR2 IS
    v_uniqueName VARCHAR2(30);
    BEGIN
      SELECT 'ODMR$'||TO_CHAR(SYSTIMESTAMP,'HH24_MI_SS_FF')||dbms_random.string(NULL, 7) INTO v_uniqueName FROM dual;
    RETURN v_uniqueName;
  END;

BEGIN
  v_policy := generateUniqueName;
  ctx_ddl.CREATE_POLICY(policy_name => v_policy);
  v_del := TRUE;
  ctx_doc.policy_themes(v_policy, 'this is a test for Oracle Text theme generation', rtab);
  FOR i IN 1..rtab.COUNT LOOP
    dbms_output.put_line(rtab(i).theme||':'||rtab(i).weight);
  END LOOP;
  IF (v_del) THEN
    ctx_ddl.DROP_POLICY(policy_name => v_policy);
  END IF;
EXCEPTION WHEN OTHERS THEN
  IF (v_del) THEN
    ctx_ddl.DROP_POLICY(policy_name => v_policy);
  END IF;
  dbms_output.put_line('Oracle Text Error: '||SQLERRM);
  dbms_output.put_line('Warning: Oracle Text KnowledgeBase is not configured. 
                        This will prevent use of Text Theme generation as part of Text transformations. 
                        See Oracle Database documentation on how to install Examples media which will configure the Oracle Text KnowledgeBase.');
END;
/

-- Check if the repository is already installed
DECLARE
  REPOS_PROP_NOT_FOUND EXCEPTION;
  PRAGMA EXCEPTION_INIT(REPOS_PROP_NOT_FOUND, -942);
  v_user_name VARCHAR2(30);
  v_repo_status VARCHAR(35);
BEGIN
  EXECUTE IMMEDIATE 'select username from DBA_USERS where username = ''ODMRSYS''' INTO v_user_name;
  EXECUTE IMMEDIATE 'SELECT PROPERTY_STR_VALUE FROM ODMRSYS.ODMR$REPOSITORY_PROPERTIES WHERE PROPERTY_NAME = ''REPOSITORY_STATUS''' INTO v_repo_status;
  
  DBMS_OUTPUT.PUT_LINE('Repository status:' || v_repo_status );
  RAISE_APPLICATION_ERROR(-20000, 'An existing repository is already installed. Please review documenation on how to migrate or drop a repository.');
EXCEPTION
  WHEN REPOS_PROP_NOT_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Verified that ODMRSYS is not installed.');
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Verified that ODMRSYS is not installed.');
END;
/

-- Check the compatibility level
DECLARE
  v_compatible_level VARCHAR2(30);
  v_version          VARCHAR(30);
  v_compatible       BOOLEAN := FALSE;
BEGIN
    EXECUTE IMMEDIATE 'select VALUE from database_compatible_level' INTO v_compatible_level;
    DBMS_OUTPUT.PUT_LINE('DATABASE COMPATIBLE LEVEL = ' || v_compatible_level);
    
    SELECT VERSION INTO v_version FROM PRODUCT_COMPONENT_VERSION  WHERE PRODUCT like 'Oracle Database %' OR PRODUCT like 'Personal Oracle Database %';
    
    IF ( SUBSTR(v_version,1,4) = '12.1') THEN
      IF ( SUBSTR(v_compatible_level,1,4) = '12.0' OR SUBSTR(v_compatible_level,1,4) = '12.1' ) THEN
        v_compatible := TRUE;
      END IF;
      
    ELSIF( SUBSTR(v_version,1,4) = SUBSTR(v_compatible_level,1,4) ) THEN
      v_compatible := TRUE;
    END IF;
    
    IF( v_compatible = FALSE ) THEN
      IF( (v_compatible_level >= '11.2.0.0') = FALSE AND ('11.2.0.4' >= v_version ) = TRUE ) THEN
        RAISE_APPLICATION_ERROR(-20002, 'The database''s compatibility setting is lower than 11.2, which is not allowed for this version of Data Miner.
          Please ask the database administrator to change the compatibility level in order to proceed.');
      ELSE
        DBMS_OUTPUT.PUT_LINE('The database''s compatibility setting is lower than the database''s current major release version number. 
          This can result in features behaving differently then expected in order to comply with the older release behavior.  
          If this is not desired then it would be better to change the compatibility setting prior to installing the repository.');
      END IF;
    END IF;
    

EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE(
      'Error in Check Compatibility level: ' || CHR(13) || CHR(10) || SQLERRM || CHR(13) || CHR(10) ||
      DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
    RAISE_APPLICATION_ERROR(-20002, 'NO_DATA_FOUND returned when querying database compatibility level.');      
END;
/

-- Check if a conversion from OR to Binary is required (db 11.2.0.4 and up). If so, does the ODMRSYS account Table Space have ASM setting
DECLARE
  v_db_ver  VARCHAR2(30);
  v_segment VARCHAR2(30);
BEGIN
  SELECT VERSION INTO v_db_ver FROM product_component_version WHERE product LIKE 'Oracle Database%' OR product like 'Personal Oracle Database%';
  
  dbms_output.put_line('Database Version:' || v_db_ver);
  
  IF ( INSTR(v_db_ver, '11.2.0.3') > 0 
    OR INSTR(v_db_ver, '11.2.0.2') > 0 
    OR INSTR(v_db_ver, '11.2.0.1') > 0 
    OR INSTR(v_db_ver, '11.2.0.0') > 0) THEN
    NULL; -- no OR to Binary is necessary
  ELSE
    SELECT SEGMENT_SPACE_MANAGEMENT INTO v_segment FROM dba_tablespaces WHERE tablespace_name = '&&1';    
    IF (v_segment != 'AUTO') THEN
      RAISE_APPLICATION_ERROR(-20002, 'Default table space with ASM setting is required for installation.');
    ELSE
      dbms_output.put_line('Continue installation');
    END IF;
  END IF;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
  RAISE_APPLICATION_ERROR(-20002, 'Default table space is not found.');
END;
/

-- Check the extent size
/*
DECLARE
  v_id NUMBER;
  v_securefile  VARCHAR2(30);
  v_block_size  dba_tablespaces.block_size%type;
  v_extent_size dba_tablespaces.initial_extent%type;

BEGIN 
  --SELECT value INTO v_securefile FROM v$parameter WHERE name = 'db_securefile';
  v_id := dbms_utility.get_parameter_value('db_securefile', v_id, v_securefile);
  IF v_securefile = 'ALWAYS' THEN
    SELECT block_size, initial_extent INTO v_block_size, v_extent_size 
    FROM dba_tablespaces WHERE tablespace_name = '&&1';
    
    IF v_extent_size <= (v_block_size * 14) THEN
      RAISE_APPLICATION_ERROR(-20001, 'Extent size too small, must be at least 14 times the block size plus 1');
    ELSE
      dbms_output.put_line('Correct extent size');
    END IF;
  ELSE
    dbms_output.put_line('Continue installation');
END IF;
END;
*/

-- Check JVM existence
DECLARE
  v_exist NUMBER;
BEGIN
  --select comp_name, version, status from dba_registry WHERE comp_name like '%JAVA%' and status='VALID'
  SELECT COUNT(*) INTO v_exist FROM dba_registry WHERE comp_name like '%JAVA%' and status='VALID';
  IF( v_exist = 0) THEN
    DBMS_OUTPUT.PUT_LINE('JVM not found or invalid');
    EXECUTE IMMEDIATE 'ALTER SESSION SET PLSQL_CCFLAGS=''install_java_json_parser:false''';
  ELSE
    DBMS_OUTPUT.PUT_LINE('JVM has been installed');
    EXECUTE IMMEDIATE 'ALTER SESSION SET PLSQL_CCFLAGS=''install_java_json_parser:true''';
  END IF;
END;
/
