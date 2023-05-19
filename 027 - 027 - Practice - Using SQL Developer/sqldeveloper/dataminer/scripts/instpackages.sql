-- installs repository pl/sql packages
WHENEVER SQLERROR EXIT SQL.SQLCODE;

EXECUTE dbms_output.put_line('Install pl/sql packages into repository. ' || systimestamp);

SET DEFINE OFF

--install headers first
@@odmr_constant_hdr.sql
@@odmr_msg_hdr.sql
@@odmr_engine_sec_hdr.sql
@@odmr_internal_util_hdr.sql
@@odmr_project_sec_hdr.sql
@@odmr_engine_transforms_sec_hdr.sql
@@odmr_internal_util_sec_hdr.sql
@@odmr_engine_text_sec_hdr.sql
@@odmr_engine_output_sec_hdr.sql
@@odmr_engine_mining_sec_hdr.sql
@@odmr_engine_data_sec_hdr.sql
@@odmr_workflow_sec_hdr.sql
@@odmr_engine_hdr.sql
@@odmr_project_hdr.sql
@@odmr_engine_transforms_hdr.sql
@@odmr_engine_dynamic_node_hdr.sql
@@odmr_util_hdr.sql
@@odmr_engine_text_hdr.sql
@@odmr_engine_output_hdr.sql
@@odmr_engine_mining_hdr.sql
@@odmr_engine_data_hdr.sql
@@odmr_workflow_hdr.sql

--install bodys
@@odmr_msg_body.plb
@@odmr_engine_sec_body.plb
@@odmr_internal_util_body.plb
@@odmr_project_sec_body.plb
@@odmr_engine_transforms_sec_body.plb
@@odmr_internal_util_sec_body.plb
@@odmr_engine_text_sec_body.plb
@@odmr_engine_output_sec_body.plb
@@odmr_engine_mining_sec_body.plb
@@odmr_engine_data_sec_body.plb
@@odmr_workflow_sec_body.plb
@@odmr_engine_body.plb
@@odmr_project_body.plb
@@odmr_engine_transforms_body.plb
@@odmr_engine_dynamic_node_body.plb
@@odmr_util_body.plb
@@odmr_engine_text_body.plb
@@odmr_engine_output_body.plb
@@odmr_engine_mining_body.plb
@@odmr_engine_data_body.plb
@@odmr_workflow_body.plb

SET DEFINE ON

EXECUTE dbms_output.put_line('Finshed installing pl/sql packages into repository. ' || systimestamp);
