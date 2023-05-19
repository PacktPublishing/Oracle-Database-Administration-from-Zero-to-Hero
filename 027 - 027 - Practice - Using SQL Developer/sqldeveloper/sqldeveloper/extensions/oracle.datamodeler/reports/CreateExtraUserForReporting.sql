/*
  The script creates and enables a user (not schema owner) to generate reports, based on reporting repository
  Replace <owner> and <another_user> with real user names and <password> with real passsword
*/

DECLARE

 CURSOR cur_tables IS SELECT table_name, owner FROM all_tables WHERE owner = '<owner>';
 CURSOR cur_views IS SELECT view_name FROM all_views WHERE owner = '<owner>';
 CURSOR cur_types IS SELECT type_name FROM all_types WHERE owner = '<owner>';

BEGIN

 EXECUTE IMMEDIATE 'CREATE USER '|| '<another_user>' ||' IDENTIFIED BY '|| '<password>';
 EXECUTE IMMEDIATE 'GRANT READ, WRITE ON DIRECTORY OSDDM_REPORTS_DIR TO '|| '<another_user>';
 EXECUTE IMMEDIATE 'GRANT CREATE SESSION TO '|| '<another_user>';
 EXECUTE IMMEDIATE 'GRANT RESOURCE TO '|| '<another_user>';

 FOR rec_tables IN cur_tables LOOP
  EXECUTE IMMEDIATE 'GRANT SELECT ON '||'<owner>'||'.'||rec_tables.table_name||' TO '||'<another_user>';
  EXECUTE IMMEDIATE 'CREATE SYNONYM '||'<another_user>'||'.'||rec_tables.table_name||' FOR '||'<owner>'||'.'||rec_tables.table_name;
 END LOOP;
 
 FOR rec_views IN cur_views LOOP
  EXECUTE IMMEDIATE 'GRANT SELECT ON '||'<owner>'||'.'||rec_views.view_name||' TO '||'<another_user>';
  EXECUTE IMMEDIATE 'CREATE SYNONYM '||'<another_user>'||'.'||rec_views.view_name||' FOR '||'<owner>'||'.'||rec_views.view_name;
 END LOOP;
 
 FOR rec_types IN cur_types LOOP
  EXECUTE IMMEDIATE 'GRANT EXECUTE ON '||'<owner>'||'.'||rec_types.type_name||' TO '||'<another_user>';
  EXECUTE IMMEDIATE 'CREATE SYNONYM '||'<another_user>'||'.'||rec_types.type_name||' FOR '||'<owner>'||'.'||rec_types.type_name;
 END LOOP;
 
 ---<stored package>---
 EXECUTE IMMEDIATE 'GRANT EXECUTE ON '||'<owner>.pkg_osdm_utils'|| ' TO '|| '<another_user>';
 EXECUTE IMMEDIATE 'CREATE SYNONYM '||'<another_user>.pkg_osdm_utils'||' FOR ' || '<owner>.pkg_osdm_utils';
 
END;