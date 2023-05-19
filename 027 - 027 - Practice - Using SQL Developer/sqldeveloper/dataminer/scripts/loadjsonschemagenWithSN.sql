
-- loads JSON parser and data guide generator (for 12.1.0.2 database and up)
--
-- Paramters:
-- 1. Sys User
-- 2. Sys Password
-- 3. Database Host
-- 4. Database Port
-- 5. Database Service Name
-- 6. Path of jar files (javax.json.jar and JSONSchemaGenerator.jar)
-- Example:
-- @loadjsonschemagen.sql <SYS USER> <SYS PASSWORD> <HOST> <PORT> <Service Name> <JAR PATH>
--------------------------------------------------------

SET SERVEROUTPUT ON;

DEFINE SYS_NAME = &&1
DEFINE SYS_PASS = &&2
DEFINE DB_HOST = &&3
DEFINE DB_PORT = &&4
DEFINE DB_SERVICE_NAME = &&5
DEFINE JSON_JAR_PATH = &&6

EXECUTE dbms_output.put_line('Start loading JSON Schema Generator. ' || systimestamp);

HOST dropjava -user &SYS_NAME/&SYS_PASS@&DB_HOST:&DB_PORT/&DB_SERVICE_NAME -schema ODMRSYS -thin -verbose -stdout &JSON_JAR_PATH/javax.json.jar
EXECUTE dbms_output.put_line('Dropped legacy JSON Parser. ' || systimestamp);

HOST dropjava -user &SYS_NAME/&SYS_PASS@&DB_HOST:&DB_PORT/&DB_SERVICE_NAME -schema ODMRSYS -thin -verbose -stdout &JSON_JAR_PATH/org.glassfish.javax.json.jar
EXECUTE dbms_output.put_line('Dropped JSON Parser. ' || systimestamp);

HOST dropjava -user &SYS_NAME/&SYS_PASS@&DB_HOST:&DB_PORT/&DB_SERVICE_NAME -schema ODMRSYS -thin -verbose -stdout &JSON_JAR_PATH/JSONSchemaGenerator.jar
EXECUTE dbms_output.put_line('Dropped JSON Schema Generator. ' || systimestamp);

HOST loadjava -user &SYS_NAME/&SYS_PASS@&DB_HOST:&DB_PORT/&DB_SERVICE_NAME -schema ODMRSYS -thin -force -resolve -verbose -stdout &JSON_JAR_PATH/org.glassfish.javax.json.jar -grant PUBLIC
EXECUTE dbms_output.put_line('Loaded JSON Parser. ' || systimestamp);

HOST loadjava -user &SYS_NAME/&SYS_PASS@&DB_HOST:&DB_PORT/&DB_SERVICE_NAME -schema ODMRSYS -thin -force -resolve -verbose -stdout &JSON_JAR_PATH/JSONSchemaGenerator.jar -grant PUBLIC
EXECUTE dbms_output.put_line('Loaded JSON Schema Generator. ' || systimestamp);

EXECUTE dbms_output.put_line('End loading JSON Schema Generator. ' || systimestamp);

WHENEVER SQLERROR EXIT SQL.SQLCODE;

alter session set current_schema = "SYS";
-- insure there are no invalid objects
@@validateODMRSYS.sql JAVA
