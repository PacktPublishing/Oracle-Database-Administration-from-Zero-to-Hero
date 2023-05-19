ALTER session set current_schema = "ODMRSYS";

EXECUTE dbms_output.put_line('Start repository upgrade from 11.2.0.1.13 to 11.2.1.1.1. ' || systimestamp);

-- drop tables/views if they exist
DECLARE
  sql_text varchar2(256);
  repos_version VARCHAR2(30);
  DB_VER  VARCHAR2(30);
BEGIN
    SELECT VERSION INTO DB_VER FROM PRODUCT_COMPONENT_VERSION WHERE PRODUCT LIKE 'Oracle Database%' OR PRODUCT LIKE 'Personal Oracle Database %' ;
    SELECT PROPERTY_STR_VALUE INTO repos_version FROM ODMRSYS.ODMR$REPOSITORY_PROPERTIES WHERE PROPERTY_NAME = 'VERSION';
    IF ( repos_version = '11.2.0.1.13' ) THEN
      dbms_output.put_line('Upgrade will be performed.');
      BEGIN
        sql_text := 'drop VIEW ODMRSYS.ODMR_MESSAGES' ;
        DBMS_OUTPUT.PUT_LINE (sql_text ); 
        execute immediate sql_text;
        EXCEPTION
        WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE ('Table/View does not exist' );
      END;
      BEGIN
        sql_text := 'drop TABLE ODMRSYS.ODMR$MESSAGES PURGE' ;
        DBMS_OUTPUT.PUT_LINE (sql_text ); 
        execute immediate sql_text;
        EXCEPTION
        WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE ('Table/View does not exist' );
      END;
      -- Message table fix
      EXECUTE IMMEDIATE 'CREATE TABLE ODMRSYS.ODMR$MESSAGES 
                  (
                    MESSAGE_ID NUMBER NOT NULL 
                  , LANGUAGE_ID VARCHAR2(5 CHAR) 
                  , MESSAGE NVARCHAR2(2000) 
                  , CONSTRAINT ODMR$MESSAGES_PK PRIMARY KEY 
                    (
                      MESSAGE_ID, LANGUAGE_ID 
                    )
                    ENABLE 
                  ) 
                  LOGGING 
                  PCTFREE 10 
                  INITRANS 1 
                  STORAGE 
                  ( 
                    INITIAL 65536 
                    MINEXTENTS 1 
                    MAXEXTENTS 2147483645 
                    BUFFER_POOL DEFAULT 
                  )';
                  
      EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW ODMRSYS.ODMR_MESSAGES AS SELECT 
                MESSAGE_ID,
                LANGUAGE_ID,
                MESSAGE 
              FROM ODMRSYS.ODMR$MESSAGES';
      EXECUTE IMMEDIATE 'CREATE INDEX ODMR$MESSAGES_MSG_ID_INDEX ON ODMRSYS.ODMR$MESSAGES (MESSAGE_ID)';
      EXECUTE IMMEDIATE 'CREATE INDEX ODMR$MESSAGES_LANG_ID_INDEX ON ODMRSYS.ODMR$MESSAGES (LANGUAGE_ID)';
      EXECUTE IMMEDIATE 'CREATE OR REPLACE PUBLIC SYNONYM ODMR_MESSAGES FOR ODMRSYS.ODMR_MESSAGES';
      IF (DB_VER >= '12.1.0.2' ) THEN
        EXECUTE IMMEDIATE 'GRANT READ ON ODMR_MESSAGES TO ODMRUSER';
      ELSE
        EXECUTE IMMEDIATE 'GRANT SELECT ON ODMR_MESSAGES TO ODMRUSER';
      END IF;
      --Log table fix
      EXECUTE IMMEDIATE 'ALTER TABLE ODMR$WF_LOG ADD (log_message_2 NVARCHAR2(2000))';
      EXECUTE IMMEDIATE 'UPDATE ODMR$WF_LOG  SET LOG_MESSAGE_2=LOG_MESSAGE';
      COMMIT;
      EXECUTE IMMEDIATE 'ALTER TABLE ODMR$WF_LOG DROP COLUMN LOG_MESSAGE';
      EXECUTE IMMEDIATE 'ALTER TABLE ODMR$WF_LOG RENAME COLUMN LOG_MESSAGE_2 to LOG_MESSAGE';
      
      -- uptick the VERSION
      UPDATE ODMRSYS.ODMR$REPOSITORY_PROPERTIES SET PROPERTY_STR_VALUE = '11.2.1.1.1' WHERE PROPERTY_NAME = 'VERSION';
      COMMIT;  
      dbms_output.put_line('Repository version updated to  11.2.1.1.1.');
  ELSE
    dbms_output.put_line('Upgrade is not necessary.');
  END IF;
END;
/


EXECUTE dbms_output.put_line('End repository upgrade from 11.2.0.1.13 to 11.2.1.1.1. ' || systimestamp);
