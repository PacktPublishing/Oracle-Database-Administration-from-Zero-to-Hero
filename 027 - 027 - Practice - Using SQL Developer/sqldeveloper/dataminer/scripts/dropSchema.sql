-- Script to make sure the odmr.xsd schema is deleted
-- It will be run at the end of the drop repository process as a safe measure
EXECUTE dbms_output.put_line('Start dropSchema process: ' || systimestamp);

ALTER session set current_schema = "SYS";
/
DECLARE
  schema_exist NUMBER;
BEGIN

  SELECT COUNT(*) INTO schema_exist FROM ALL_XML_SCHEMAS WHERE SCHEMA_URL='http://xmlns.oracle.com/odmr11/odmr.xsd';
  
  IF (schema_exist > 0) THEN
    DBMS_XMLSCHEMA.DELETESCHEMA('http://xmlns.oracle.com/odmr11/odmr.xsd', DBMS_XMLSCHEMA.DELETE_CASCADE_FORCE);
        
    SELECT COUNT(*) INTO schema_exist FROM ALL_XML_SCHEMAS WHERE SCHEMA_URL='http://xmlns.oracle.com/odmr11/odmr.xsd';
    
     IF (schema_exist > 0) THEN
      DBMS_OUTPUT.PUT_LINE('dropSchema.sql was unable to remove the schema.');
     END IF;

  END IF;
EXCEPTION WHEN OTHERS THEN
  RAISE;
END;
/
EXECUTE dbms_output.put_line('Finished dropSchema process: ' || systimestamp);