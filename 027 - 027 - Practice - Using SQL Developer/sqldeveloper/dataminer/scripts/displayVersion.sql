-- display wf_version, version and db version Bug16575250
SET serveroutput ON

DECLARE
db_ver   VARCHAR2(30);
wf_ver   VARCHAR2(30);
rep_ver  VARCHAR2(30);

BEGIN

  BEGIN
    EXECUTE IMMEDIATE 'SELECT property_str_value FROM "ODMRSYS"."ODMR$REPOSITORY_PROPERTIES" WHERE property_name = :1'
    INTO wf_ver USING IN 'WF_VERSION'   ;
  EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('displayVersion.sql Error: '||SUBSTR(DBMS_UTILITY.FORMAT_ERROR_STACK(), 1, 4000));
  END;

  BEGIN
    EXECUTE IMMEDIATE 'SELECT property_str_value FROM "ODMRSYS"."ODMR$REPOSITORY_PROPERTIES" WHERE property_name = :1'
    INTO rep_ver USING IN 'VERSION'   ;
  EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('displayVersion.sql Error: '||SUBSTR(DBMS_UTILITY.FORMAT_ERROR_STACK(), 1, 4000));
  END;

  BEGIN
    EXECUTE IMMEDIATE 'SELECT version FROM product_component_version WHERE product LIKE ''Oracle Database%'' OR product like ''Personal Oracle Database%'''
    INTO db_ver;
  EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('displayVersion.sql Error: '||SUBSTR(DBMS_UTILITY.FORMAT_ERROR_STACK(), 1, 4000));
  END;

  dbms_output.put_line('Workflow Version: ' || wf_ver);
  dbms_output.put_line('Repository Version: ' || rep_ver);
  dbms_output.put_line('Database Version:' || db_ver);
END;
/
