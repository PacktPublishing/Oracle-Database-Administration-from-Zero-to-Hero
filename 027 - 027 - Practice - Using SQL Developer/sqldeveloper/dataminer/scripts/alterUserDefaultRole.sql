-- Run this script to determine if it is necessary to alter the user to include
-- the OMDRUSER role as part of the default roles for the specified user
-- Assumptions: 
--  1.The ODMRUSER role has already been granted to the specified user
--  2.If the ODMRUSER role shows up as default = no, then it 
--  must be added to the current list of roles that have default = yes
--  granted to the specified user.
-- @alterUserDefaultRole.sql <P1> 
--    P1: User account
-- Example: @alterUserDefaultRole.sql DMUSER

SET SERVEROUTPUT ON;
DEFINE USER_ACCOUNT = &&1
set verify off;

EXECUTE dbms_output.put_line('');
EXECUTE dbms_output.put_line('Add ODMRUSER as one of the user default roles.');
EXECUTE dbms_output.put_line('');

DECLARE
TYPE roles IS TABLE OF VARCHAR2(100)
    INDEX BY PLS_INTEGER;            
v_newuser varchar2(30) := q'[&&1]';
v_username varchar2(30);
v_default_role varchar2 (100);
v_granted_role varchar2 (100);
v_list_of_roles varchar2 (5000);
sql_text varchar2(6000);
Dynamic_Cursor integer; 
dummy integer; 
v_err_msg  VARCHAR2(4000);
v_roles_query_result roles;
v_odmruser_default VARCHAR2(1000);
v_all_default_roles VARCHAR2(1000);
 
BEGIN
 DBMS_OUTPUT.ENABLE(NULL);

v_odmruser_default :=
'select default_role from dba_role_privs 
 where granted_role = ''ODMRUSER''
and grantee = :1';

v_all_default_roles :=
'select granted_role from dba_role_privs 
 where default_role = ''YES''
and grantee = :1';

-- Is ODMRUSER one of the default roles, if so, no work required
EXECUTE IMMEDIATE v_odmruser_default INTO v_default_role USING v_newuser;
-- ODMRUSER is not one of the default roles so add it.
if v_default_role = 'NO' THEN
  -- create list of all existing default roles
  EXECUTE IMMEDIATE v_all_default_roles BULK COLLECT INTO v_roles_query_result USING v_newuser;
  FOR i IN 1..v_roles_query_result.COUNT LOOP
     v_list_of_roles := v_list_of_roles  || v_roles_query_result(i) || ',' ; 
  END LOOP;
  -- add ODMRUSER to that list
  v_list_of_roles := v_list_of_roles || 'ODMRUSER'; 
  -- alter user to have a new set of default roles
  sql_text := 'ALTER USER ' || '"' || v_newuser || '" DEFAULT ROLE ' || v_list_of_roles;
  DBMS_OUTPUT.PUT_LINE('Command: ' || sql_text);
  Dynamic_Cursor := dbms_sql.open_cursor;
  dbms_sql.parse(Dynamic_Cursor, sql_text, dbms_sql.native);
  dummy := dbms_sql.execute(Dynamic_Cursor);
  dbms_sql.close_cursor(Dynamic_Cursor); 
  DBMS_OUTPUT.PUT_LINE('ODMUSER added to list of default roles for user');
ELSE
  DBMS_OUTPUT.PUT_LINE
       ('Validated ODMRUSER is a default role of user');  
END IF;
END;
/
--end of alterUserDefaultRole.sql script