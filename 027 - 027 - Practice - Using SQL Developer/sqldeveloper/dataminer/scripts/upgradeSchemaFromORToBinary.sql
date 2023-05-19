
WHENEVER SQLERROR EXIT SQL.SQLCODE;

EXECUTE dbms_output.put_line('Start upgrade schema from OR to Binary.' || systimestamp);

-- create a WORKFLOW_DATA_BACKUP column (Binary Storage) to backup existing workflows
ALTER TABLE "ODMRSYS"."ODMR$WORKFLOWS" ADD(WORKFLOW_DATA_BACKUP SYS.XMLTYPE)
  XMLTYPE COLUMN WORKFLOW_DATA_BACKUP STORE AS SECUREFILE BINARY XML;

-- backup workflows to WORKFLOW_DATA_BACKUP
BEGIN
  FOR wf IN (
    SELECT 
      b.WORKFLOW_ID,
      b.WORKFLOW_DATA.createNonSchemaBasedXML() "WORKFLOW_DATA"
    FROM ODMRSYS.ODMR$WORKFLOWS b
  )
  LOOP
    BEGIN
      UPDATE ODMRSYS.ODMR$WORKFLOWS w
      SET w.WORKFLOW_DATA_BACKUP = wf.WORKFLOW_DATA
      WHERE w.WORKFLOW_ID = wf.WORKFLOW_ID;
      COMMIT;
      dbms_output.put_line('Workflow backed up: '||wf.WORKFLOW_ID);
    EXCEPTION WHEN OTHERS THEN
      dbms_output.put_line('Workflow backup failed: '||wf.WORKFLOW_ID);
    END;
  END LOOP;
END;
/

-- drop existing WORKFLOW_DATA column
ALTER TABLE "ODMRSYS"."ODMR$WORKFLOWS" DROP COLUMN "WORKFLOW_DATA";

-- rename the WORKFLOW_DATA_BACKUP column to WORKFLOW_DATA
ALTER TABLE "ODMRSYS"."ODMR$WORKFLOWS" RENAME COLUMN "WORKFLOW_DATA_BACKUP" TO "WORKFLOW_DATA";

-- delete existing xml schema since the new WORKFLOW_DATA column is non-schema based
DECLARE
  schema_exist NUMBER;
BEGIN
  SELECT COUNT(*) INTO schema_exist FROM ALL_XML_SCHEMAS WHERE SCHEMA_URL='http://xmlns.oracle.com/odmr11/odmr.xsd';
  IF (schema_exist > 0) THEN
    DBMS_XMLSCHEMA.DELETESCHEMA('http://xmlns.oracle.com/odmr11/odmr.xsd', DBMS_XMLSCHEMA.DELETE_CASCADE_FORCE);
    SELECT COUNT(*) INTO schema_exist FROM ALL_XML_SCHEMAS WHERE SCHEMA_URL='http://xmlns.oracle.com/odmr11/odmr.xsd';
    IF (schema_exist > 0) THEN
      DBMS_OUTPUT.PUT_LINE('Dropped existing workflow XML Schema failed.');
    ELSE
      DBMS_OUTPUT.PUT_LINE('Dropped existing workflow XML Schema success.');
    END IF;
  END IF;
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('Dropped existing workflow XML Schema failed: '||DBMS_UTILITY.FORMAT_ERROR_STACK());
END;
/

EXECUTE dbms_output.put_line('Finished upgrade schema from OR to Binary.' || systimestamp);
