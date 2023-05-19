
-- drops JSON parser and data guide generator (for pre 12.2.0.0.0 database)
--
-- Paramters:
-- 1. Sys User
-- 2. Sys Password
-- 3. Database Host
-- 4. Database Port
-- 5. Database SID
-- 6. Path of jar files (javax.json.jar and JSONSchemaGenerator.jar)
-- Example:
-- @dropjsonschemagen.sql <SYS USER> <SYS PASSWORD> <HOST> <PORT> <SID> <JAR PATH>
--------------------------------------------------------

SET SERVEROUTPUT ON;

DEFINE SYS_NAME = &&1
DEFINE SYS_PASS = &&2
DEFINE DB_HOST = &&3
DEFINE DB_PORT = &&4
DEFINE DB_SID = &&5
DEFINE JSON_JAR_PATH = &&6

EXECUTE dbms_output.put_line('Start dropping JSON Schema Generator. ' || systimestamp);

HOST dropjava -user &SYS_NAME/&SYS_PASS@&DB_HOST:&DB_PORT:&DB_SID -schema ODMRSYS -thin -verbose -stdout &JSON_JAR_PATH/javax.json.jar
EXECUTE dbms_output.put_line('Dropped legacy JSON Parser. ' || systimestamp);

HOST dropjava -user &SYS_NAME/&SYS_PASS@&DB_HOST:&DB_PORT:&DB_SID -schema ODMRSYS -thin -verbose -stdout &JSON_JAR_PATH/org.glassfish.javax.json.jar
EXECUTE dbms_output.put_line('Dropped JSON Parser. ' || systimestamp);

HOST dropjava -user &SYS_NAME/&SYS_PASS@&DB_HOST:&DB_PORT:&DB_SID -schema ODMRSYS -thin -verbose -stdout &JSON_JAR_PATH/JSONSchemaGenerator.jar
EXECUTE dbms_output.put_line('Dropped JSON Schema Generator. ' || systimestamp);

EXECUTE dbms_output.put_line('End dropping JSON Schema Generator. ' || systimestamp);
