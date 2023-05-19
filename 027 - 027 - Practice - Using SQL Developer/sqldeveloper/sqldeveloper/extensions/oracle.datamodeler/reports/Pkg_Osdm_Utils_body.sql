create or replace PACKAGE BODY PKG_OSDM_UTILS AS

log_file   UTL_FILE.File_Type;
temp_file  UTL_FILE.File_Type;

PROCEDURE Generate_OS_File(v_blob IN BLOB, filename IN VARCHAR2) IS

result_file     UTL_FILE.File_Type;
compressed_blob BLOB;
len             NUMBER;
l_pos           INTEGER := 1;
l_amount        BINARY_INTEGER := 32767;
l_buffer        RAW(32767);

BEGIN

 result_file := UTL_FILE.FOpen('OSDDM_REPORTS_DIR',filename,'wb', 32767); 

 len := DBMS_LOB.getlength(v_blob);
 
 WHILE l_pos < len LOOP
      DBMS_LOB.read(v_blob, l_amount, l_pos, l_buffer);
      UTL_FILE.put_raw(result_file, l_buffer, TRUE);
      l_pos := l_pos + l_amount;
 END LOOP;

 UTL_FILE.fclose(result_file);
 
EXCEPTION

 WHEN others THEN
 
  IF UTL_FILE.Is_Open(result_file) THEN
     UTL_FILE.FClose(result_file);
  END IF;

  UTL_FILE.PUT_LINE(log_file, 'Pkg_Osdm_Utils.Generate_OS_File Exception : ' || SQLERRM);  
  UTL_FILE.PUT_LINE(log_file, 'Pkg_Osdm_Utils.Generate_OS_File Exception : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  
END Generate_OS_File;

FUNCTION Gather_Constraint_Details_XML(col_attr_ovid VARCHAR2, namespace VARCHAR2) RETURN CLOB IS

res        CLOB;
v_vl_value VARCHAR2(50) := namespace||':VLValue';
v_s_descr  VARCHAR2(50) := namespace||':VLShortDescription';

CURSOR cur_c_constraints(v_ovid IN VARCHAR2, v_ns IN VARCHAR2) IS
 SELECT DECODE(v_ns, single_table_prefix,  XMLElement(EVALNAME(single_table_prefix  || ':DatabaseType'), XMLCDATA(cc.text)).getClobVal(),
                     all_tables_prefix,    XMLElement(EVALNAME(all_tables_prefix    || ':DatabaseType'), XMLCDATA(cc.text)).getClobVal(),
                     single_entity_prefix, XMLElement(EVALNAME(single_entity_prefix || ':DatabaseType'), XMLCDATA(cc.text)).getClobVal(),
                     all_entities_prefix,  XMLElement(EVALNAME(all_entities_prefix  || ':DatabaseType'), XMLCDATA(cc.text)).getClobVal())           text,
        DECODE(v_ns, single_table_prefix,  XMLElement(EVALNAME(single_table_prefix  || ':DatabaseType'), XMLCDATA(cc.database_type)).getClobVal(),
                     all_tables_prefix,    XMLElement(EVALNAME(all_tables_prefix    || ':DatabaseType'), XMLCDATA(cc.database_type)).getClobVal(),
                     single_entity_prefix, XMLElement(EVALNAME(single_entity_prefix || ':DatabaseType'), XMLCDATA(cc.database_type)).getClobVal(),
                     all_entities_prefix,  XMLElement(EVALNAME(all_entities_prefix  || ':DatabaseType'), XMLCDATA(cc.database_type)).getClobVal())  db_type,
        COUNT(cc.text) over()                                                                                                                       total_row_count
 FROM   dmrs_check_constraints cc
 WHERE  cc.dataelement_ovid = v_ovid
 ORDER BY sequence;
rec_c_constraints cur_c_constraints%rowtype;

CURSOR cur_vr_constraints(v_ovid IN VARCHAR2, v_ns IN VARCHAR2) IS
 SELECT DECODE(v_ns, single_table_prefix, XMLElement(EVALNAME(single_table_prefix   || ':RangeBeginValue'), XMLCDATA(vr.begin_value)).getClobVal(),
                     all_tables_prefix,XMLElement(EVALNAME(all_tables_prefix        || ':RangeBeginValue'), XMLCDATA(vr.begin_value)).getClobVal(),
                     single_entity_prefix, XMLElement(EVALNAME(single_entity_prefix || ':RangeBeginValue'), XMLCDATA(vr.begin_value)).getClobVal(),
                     all_entities_prefix,XMLElement(EVALNAME(all_entities_prefix    || ':RangeBeginValue'), XMLCDATA(vr.begin_value)).getClobVal())              begin_value,
        DECODE(v_ns, single_table_prefix, XMLElement(EVALNAME(single_table_prefix   || ':RangeEndValue'), XMLCDATA(vr.end_value)).getClobVal(),
                     all_tables_prefix,XMLElement(EVALNAME(all_tables_prefix        || ':RangeEndValue'), XMLCDATA(vr.end_value)).getClobVal(),
                     single_entity_prefix, XMLElement(EVALNAME(single_entity_prefix || ':RangeEndValue'), XMLCDATA(vr.end_value)).getClobVal(),
                     all_entities_prefix,XMLElement(EVALNAME(all_entities_prefix    || ':RangeEndValue'), XMLCDATA(vr.end_value)).getClobVal())                  end_value,
        DECODE(v_ns, single_table_prefix, XMLElement(EVALNAME(single_table_prefix   || ':RangeShortDescription'), XMLCDATA(vr.short_description)).getClobVal(),  
                     all_tables_prefix,XMLElement(EVALNAME(all_tables_prefix        || ':RangeShortDescription'), XMLCDATA(vr.short_description)).getClobVal(),  
                     single_entity_prefix, XMLElement(EVALNAME(single_entity_prefix || ':RangeShortDescription'), XMLCDATA(vr.short_description)).getClobVal(),
                     all_entities_prefix,XMLElement(EVALNAME(all_entities_prefix    || ':RangeShortDescription'), XMLCDATA(vr.short_description)).getClobVal())  short_description,
        COUNT(vr.begin_value) over()                                                                                                                             total_row_count
 FROM   dmrs_value_ranges vr
 WHERE  vr.dataelement_ovid = v_ovid
 ORDER BY sequence;
rec_vr_constraints cur_vr_constraints%rowtype;

CURSOR cur_vl_constraints(v_ovid IN VARCHAR2, v_ns IN VARCHAR2) IS
 SELECT DECODE(v_ns, single_table_prefix, XMLElement(EVALNAME(single_table_prefix || ':VLValue'), XMLCDATA(av.value)).getClobVal(),
                     all_tables_prefix,XMLElement(EVALNAME(all_tables_prefix || ':VLValue'), XMLCDATA(av.value)).getClobVal(),
                     single_entity_prefix, XMLElement(EVALNAME(single_entity_prefix || ':VLValue'), XMLCDATA(av.value)).getClobVal(),
                     all_entities_prefix,XMLElement(EVALNAME(all_entities_prefix || ':VLValue'), XMLCDATA(av.value)).getClobVal())                         av_value,
        DECODE(v_ns, single_table_prefix, XMLElement(EVALNAME(single_table_prefix || ':VLShortDescription'), XMLCDATA(av.short_description)).getClobVal(),
                     all_tables_prefix,XMLElement(EVALNAME(all_tables_prefix || ':VLShortDescription'), XMLCDATA(av.short_description)).getClobVal(),
                     single_entity_prefix, XMLElement(EVALNAME(single_entity_prefix || ':VLShortDescription'), XMLCDATA(av.short_description)).getClobVal(),
                     all_entities_prefix,XMLElement(EVALNAME(all_entities_prefix || ':VLShortDescription'), XMLCDATA(av.short_description)).getClobVal())  short_description,
        COUNT(av.value) over()                                                                                         total_row_count
 FROM   dmrs_avt av,
        dmrs_columns c
 WHERE  c.ovid = av.dataelement_ovid
 AND    av.dataelement_ovid = v_ovid;
rec_vl_constraints cur_vl_constraints%rowtype;

BEGIN

  DBMS_LOB.CREATETEMPORARY(res, TRUE);

  FOR rec_vr_constraints IN cur_vr_constraints(col_attr_ovid, namespace) LOOP
     IF (cur_vr_constraints%ROWCOUNT = 1) THEN
       DBMS_LOB.APPEND (res, '<'||namespace||':RangesCollection>');
     END IF;

       DBMS_LOB.APPEND (res, '<'||namespace||':RangeDetails>');
       DBMS_LOB.APPEND (res, rec_vr_constraints.begin_value);
       DBMS_LOB.APPEND (res, rec_vr_constraints.end_value);
       DBMS_LOB.APPEND (res, rec_vr_constraints.short_description);
       DBMS_LOB.APPEND (res, '</'||namespace||':RangeDetails>');
    
     IF (cur_vr_constraints%ROWCOUNT = rec_vr_constraints.total_row_count) THEN
       DBMS_LOB.APPEND (res, '</'||namespace||':RangesCollection>');
     END IF;
  END LOOP;
 
  FOR rec_vl_constraints IN cur_vl_constraints(col_attr_ovid, namespace) LOOP
     IF (cur_vl_constraints%ROWCOUNT = 1) THEN
       DBMS_LOB.APPEND (res, '<'||namespace||':ValueListsCollection>');
     END IF;
   
       DBMS_LOB.APPEND (res, '<'||namespace||':ValueListDetails>');
       DBMS_LOB.APPEND (res, rec_vl_constraints.av_value);
       DBMS_LOB.APPEND (res, rec_vl_constraints.short_description);
       DBMS_LOB.APPEND (res, '</'||namespace||':ValueListDetails>');
     
     IF (cur_vl_constraints%ROWCOUNT = rec_vl_constraints.total_row_count) THEN
       DBMS_LOB.APPEND (res, '</'||namespace||':ValueListsCollection>');
     END IF;
  END LOOP;

  FOR rec_c_constraints IN cur_c_constraints(col_attr_ovid, namespace) LOOP
     IF (cur_c_constraints%ROWCOUNT = 1) THEN
       DBMS_LOB.APPEND (res, '<'||namespace||':CheckConstraintsCollection>');
     END IF;

      DBMS_LOB.APPEND (res, '<'||namespace||':CheckConstraintDetails>');
      DBMS_LOB.APPEND (res, rec_c_constraints.text);
      DBMS_LOB.APPEND (res, rec_c_constraints.db_type);
      DBMS_LOB.APPEND (res, '</'||namespace||':CheckConstraintDetails>');
   
     IF (cur_c_constraints%ROWCOUNT = rec_c_constraints.total_row_count) THEN
       DBMS_LOB.APPEND (res, '</'||namespace||':CheckConstraintsCollection>');
     END IF;
  END LOOP;

  RETURN res;

EXCEPTION
 WHEN others THEN
  UTL_FILE.PUT_LINE(log_file, 'Pkg_Osdm_Utils.Gather_Constraint_Details_XML Exception : : ' || SQLERRM);  
  UTL_FILE.PUT_LINE(log_file, 'Pkg_Osdm_Utils.Gather_Constraint_Details_XML Exception : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  RETURN res;

END Gather_Constraint_Details_XML;

FUNCTION Gather_SingleTable_Data(v_table_ovid IN VARCHAR2, reportTemplate IN REPORT_TEMPLATE, v_report_name IN VARCHAR2) RETURN CLOB IS 

res             CLOB;
v_description   VARCHAR2(32767);
v_notes         VARCHAR2(32767);
v_cc_created    BOOLEAN := FALSE;
token_value     CLOB;

-- Common Data
CURSOR cur_common_data(v_t_ovid IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(single_table_prefix || ':DesignName'),d.design_name).getClobVal()                                      design_name,
        XMLElement(EVALNAME(single_table_prefix || ':VersionDate'),TO_CHAR(d.date_published,'dd.mm.yyyy hh24:mi:ss')).getClobVal() version_date,

        XMLElement(EVALNAME(single_table_prefix || ':VersionComment'),XMLCDATA(d.version_comments)).getClobVal()                   version_comment,
        XMLElement(EVALNAME(single_table_prefix || ':ModelName'),m.model_name).getClobVal()                                        model_name
 FROM   dmrs_designs d, 
        dmrs_models m,
        dmrs_tables t
 WHERE  d.design_ovid = m.design_ovid
 AND   t.model_ovid = m.model_ovid
 AND   t.ovid = v_t_ovid;
rec_common_data cur_common_data%ROWTYPE;

-- Table General Data
CURSOR cur_table(v_t_ovid IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(single_table_prefix || ':TableName'),DECODE(t.schema_name, NULL, '', t.schema_name ||'.') || t.table_name).getClobVal()  table_name,
        XMLElement(EVALNAME(single_table_prefix || ':Abbreviation'),t.abbreviation).getClobVal()                                                     abbreviation,
        XMLElement(EVALNAME(single_table_prefix || ':ClassificationTypeName'),t.classification_type_name).getClobVal()                               class_type_name,
        XMLElement(EVALNAME(single_table_prefix || ':ObjectTypeName'),t.structured_type_name).getClobVal()                                           obj_type_name,
        XMLElement(EVALNAME(single_table_prefix || ':NumberOfColumns'),t.number_data_elements).getClobVal()                                          number_cols,
        XMLElement(EVALNAME(single_table_prefix || ':NumberOfRowsMin'),t.min_volume).getClobVal()                                                    number_rows_min,
        XMLElement(EVALNAME(single_table_prefix || ':NumberOfRowsMax'),t.max_volume).getClobVal()                                                    number_rows_max,
        XMLElement(EVALNAME(single_table_prefix || ':ExpectedNumberOfRows'),t.expected_volume).getClobVal()                                          number_rows_expected,
        XMLElement(EVALNAME(single_table_prefix || ':ExpectedGrowth'),t.growth_rate_percents).getClobVal()                                           growth_expected,
        XMLElement(EVALNAME(single_table_prefix || ':GrowthInterval'),t.growth_rate_interval).getClobVal()                                           growth_interval,
        XMLElement(EVALNAME(single_table_prefix || ':FunctionalName'), (SELECT NVL(e.entity_name,'')                        
                                              FROM   dmrs_entities e,
                                                     dmrs_mappings m
                                              WHERE  m.relational_object_ovid = t.ovid
                                              AND    m.logical_object_ovid  = e.ovid
                                              AND    ROWNUM = 1)).getClobVal()                                                                       functional_name
 FROM	 dmrs_tables t
 WHERE  t.ovid = v_t_ovid;
rec_table cur_table%ROWTYPE;

-- Diagrams
CURSOR cur_diagrams(v_t_ovid IN VARCHAR2, v_rep_name IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(single_table_prefix || ':Diagram'), 
          XMLElement(EVALNAME(single_table_prefix || ':Name'), v_rep_name || '_files/' || REGEXP_REPLACE(SUBSTR(d.pdf_name, 1, INSTR(d.pdf_name, '.PDF')-1), '[^a-zA-Z1-9_]', '_') || '.pdf'),
          XMLElement(EVALNAME(single_table_prefix || ':Suffix'), NULL)).getClobVal()                                                                                                            pdf_name,
        COUNT(d.pdf_name) over()                                                                                                                                                                total_row_count
 FROM   dmrs_vdiagrams d,
       (SELECT diagram_ovid 
        FROM   dmrs_diagram_elements
        WHERE  ovid = v_t_ovid) b
 WHERE d.ovid = b.diagram_ovid
 AND   d.diagram_type = 'Subview'
 AND   d.is_display = 'N';
rec_diagrams cur_diagrams%ROWTYPE;

-- Columns Data
CURSOR cur_columns(v_t_ovid IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(single_table_prefix || ':Sequence'),c.sequence).getClobVal()                                                                                              seq,
        XMLElement(EVALNAME(single_table_prefix || ':ColumnName'),c.column_name).getClobVal()                                                                                         column_name,
        XMLElement(EVALNAME(single_table_prefix || ':PK'),c.pk_flag).getClobVal()                                                                                                     pk,
        XMLElement(EVALNAME(single_table_prefix || ':FK'),c.fk_flag).getClobVal()                                                                                                     fk,
        XMLElement(EVALNAME(single_table_prefix || ':M'),DECODE(c.mandatory,'N',' ',c.mandatory)).getClobVal()                                                                        m,
        XMLElement(EVALNAME(single_table_prefix || ':DataTypeKind'),DECODE(c.datatype_kind,                                                                                           
                                                 'Domain',         'DOM',
                                                 'Logical Type',   'LT',
                                                 'Distinct Type',  'DT',
                                                 'Ref Struct Type','RST',
                                                 'Structured Type','ST',
                                                 'Collection Type','CT')
                  ).getClobVal()                                                                                                                             dt_kind,
         XMLElement(EVALNAME(single_table_prefix || ':DataType'), 
            DECODE(c.datatype_kind, 
                  'Domain', c.logical_type_name ||' '||
                           DECODE (NVL(c.t_size,''),'',
                              DECODE(NVL(c.t_scale,0),0,
                                 DECODE(NVL(c.t_precision,0),0,null,'('|| DECODE(NVL(c.t_precision,0),0,null,c.t_precision) ||')'),
                                   '('|| DECODE(NVL(c.t_precision,0),0,null,c.t_precision) || ',' || DECODE(NVL(c.t_scale,0),0,null,c.t_scale)||')'),
                                   '('||TRIM(DECODE(c.t_size,'',null,c.t_size||' '||c.char_units ))||')'),
                   'Logical Type', c.logical_type_name  ||' '|| 
                           DECODE (NVL(c.t_size,''),'',
                              DECODE(NVL(c.t_scale,0),0,
                                 DECODE(NVL(c.t_precision,0),0,null,'('|| DECODE(NVL(c.t_precision,0),0,null,c.t_precision) ||')'),
                                   '('|| DECODE(NVL(c.t_precision,0),0,null,c.t_precision) || ',' || DECODE(NVL(c.t_scale,0),0,null,c.t_scale)||')'),
                                   '('||TRIM(DECODE(c.t_size,'',null,c.t_size||' '||c.char_units ))||')')
            ) ||
            DECODE (c.auto_increment_column,'Y', ' - AI','') ||
            DECODE (c.identity_column,'Y', ' - ID','')
          ).getClobVal()                                                                                                                                    data_type,
        XMLElement(EVALNAME(single_table_prefix || ':DomainName'),DECODE(c.domain_name,'Unknown',null,c.domain_name)).getClobVal()                                                     domain_name,
        XMLElement(EVALNAME(single_table_prefix || ':Formula'), TRIM(c.formula||' '||c.default_value)).getClobVal()                                                                    formula,
        XMLElement(EVALNAME(single_table_prefix || ':Security'),DECODE(c.personally_id_information ||'/'||c.sensitive_information||'/'||c.mask_for_none_production,'//',
                                      null,c.personally_id_information ||'/'||c.sensitive_information||'/'||c.mask_for_none_production)).getClobVal()       security,
        XMLElement(EVALNAME(single_table_prefix || ':PreferredAbbreviation'),c.abbreviation).getClobVal()                                                                              abbreviation,
        COUNT(c.column_name) over()                                                                                                                         total_row_count
 FROM 	dmrs_columns c
 WHERE  c.container_ovid = v_t_ovid
 ORDER BY c.sequence;
rec_columns cur_columns%ROWTYPE;

-- Columns Comments Data
CURSOR cur_columns_comments(v_t_ovid IN VARCHAR2) IS
 SELECT a.seq                       seq, 
        a.column_name               column_name, 
        a.column_description        column_description, 
        a.column_notes              column_notes,
        COUNT(a.column_name) over() total_row_count
 FROM (
  SELECT XMLElement(EVALNAME(single_table_prefix || ':ColumnCommentsSequence'),c.sequence).getStringVal()  seq,
         XMLElement(EVALNAME(single_table_prefix || ':ColumnCommentsName'),c.column_name).getStringVal()   column_name,
         XMLElement(EVALNAME(single_table_prefix || ':ColumnDescription'),XMLCDATA(
         NVL(
        (SELECT t.text comments_in_rdbms
         FROM   dmrs_large_text t
         WHERE  t.ovid = c.ovid
         AND    t.type='Comments'),
        (SELECT t.text comments_in_rdbms
         FROM   dmrs_large_text t
         WHERE  t.ovid = c.ovid
         AND    t.type='CommentsInRDBMS')))).getClobVal()                                                  column_description, 
         XMLElement(EVALNAME(single_table_prefix || ':ColumnNotes'),XMLCDATA(
        (SELECT t.text comments_in_rdbms
         FROM   dmrs_large_text t
         WHERE  t.ovid = c.ovid
         AND    t.type='Note'))).getClobVal()                                                             column_notes
  FROM   dmrs_columns c
  WHERE  c.container_ovid = v_t_ovid
  ORDER BY c.sequence
 ) a
 WHERE DBMS_LOB.getlength(column_description) > 0 OR DBMS_LOB.getlength(column_notes) > 0;
rec_columns_comments cur_columns_comments%ROWTYPE;

--Indexes
CURSOR cur_indexes(v_t_ovid IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(single_table_prefix || ':IndexName'),i.index_name).getClobVal()                                                                                        idx_name,
        XMLElement(EVALNAME(single_table_prefix || ':IndexState'),DECODE(i.state,'Unique Plain Index','UN','Unique Constraint','UK','Primary Constraint','PK',null)).getClobVal()  state,
        XMLElement(EVALNAME(single_table_prefix || ':IndexFunctional'),DECODE(i.functional,'N',' ',i.functional)).getClobVal()                                                     functional,
        XMLElement(EVALNAME(single_table_prefix || ':IndexSpatial'),DECODE(i.spatial_index,'N',' ',i.spatial_index)).getClobVal()                                                  spatial,
        XMLElement(EVALNAME(single_table_prefix || ':IndexExpression'),i.expression).getClobVal()                                                                                  expression,
        XMLElement(EVALNAME(single_table_prefix || ':IndexColumnName'),c.column_name).getClobVal()                                                                                 col_name,
        XMLElement(EVALNAME(single_table_prefix || ':IndexSortOrder'),c.sort_order).getClobVal()                                                                                   sort_order,
        c.sequence                                                                                                                                      idx_sequence,
        COUNT(c.column_name) over()                                                                                                                     total_row_count
 FROM   dmrs_tables t,
        dmrs_indexes i,
        dmrs_constr_index_columns c
 WHERE  t.ovid = i.container_ovid
 AND    i.ovid = c.index_ovid
 AND    t.ovid = v_t_ovid
 ORDER BY i.index_name, c.sequence, c.sort_order;
rec_indexes cur_indexes%ROWTYPE;

-- Table Level Constraints
CURSOR cur_tl_constraints(v_t_ovid IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(single_table_prefix || ':TLConstraintType'), CASE WHEN rownum>1 THEN ''
                                               ELSE 'Table Level'
                                               END ).getClobVal()                                         c_type,
        XMLElement(EVALNAME(single_table_prefix || ':TLConstraintName'), tc.constraint_name).getClobVal() c_name,
        XMLElement(EVALNAME(single_table_prefix || ':TLConstraintRule'), XMLCDATA(tc.text)).getClobVal()  c_details,
        COUNT(tc.constraint_name) over()                                                                  total_row_count
 FROM   dmrs_table_constraints tc
 WHERE  tc.table_ovid = v_t_ovid;
rec_tl_constraints cur_tl_constraints%ROWTYPE;

-- Column Level Constraints
CURSOR cur_cl_constraints(v_t_ovid IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(single_table_prefix || ':ContstraintType'), CASE WHEN rownum>1 THEN ''
                                              ELSE 'Column Level'
                                              END).getClobVal()                                        c_type,
        XMLElement(EVALNAME(single_table_prefix || ':ALCConstraintName'), c.column_name || 
                                                DECODE((SELECT DISTINCT(constraint_name) 
                                                        FROM dmrs_check_constraints 
                                                        WHERE c.ovid = dataelement_ovid),NULL,'',
                                               ' / '|| (SELECT  DISTINCT(constraint_name) 
                                                        FROM dmrs_check_constraints 
                                                        WHERE c.ovid = dataelement_ovid))).getClobVal() c_name,
        Gather_Constraint_Details_XML(c.ovid, single_table_prefix)                                      c_details,
        COUNT(c.column_name) over()                                                                     total_row_count
 FROM   dmrs_columns c
 WHERE  c.container_ovid = v_t_ovid
 AND    (c.ovid IN (SELECT dataelement_ovid FROM dmrs_avt) OR 
         c.ovid IN (SELECT dataelement_ovid FROM dmrs_value_ranges) OR 
         c.ovid IN (SELECT dataelement_ovid FROM dmrs_check_constraints));
rec_cl_constraints cur_cl_constraints%ROWTYPE;

--Foreign keys referring to other tables
CURSOR cur_fk_referring_to(v_t_ovid IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(single_table_prefix || ':FKName'),CASE WHEN ic.sequence>1 THEN ' '
                                    ELSE fk.fk_name
                                    END
                   ).getClobVal()                                               fk_name,
        XMLElement(EVALNAME(single_table_prefix || ':FKReferringTo'),CASE WHEN ic.sequence>1 THEN ' '
                                          ELSE fk.referred_table_name
                                          END
                  ).getClobVal()                                                referring_to,
        XMLElement(EVALNAME(single_table_prefix || ':FKMandatory'),CASE WHEN ic.sequence>1 THEN ' '
                                         ELSE DECODE(fk.mandatory,'Y',fk.mandatory,' ')
                                         END
                  ).getClobVal()                                                mandatory,
        XMLElement(EVALNAME(single_table_prefix || ':FKTransferable'),CASE WHEN ic.sequence>1 THEN ' '
                                            ELSE DECODE(fk.transferable,'Y',fk.transferable,' ')
                                            END
                  ).getClobVal()                                                transferable,
        XMLElement(EVALNAME(single_table_prefix || ':FKInArc'),CASE WHEN ic.sequence>1 THEN ' '
                                     ELSE DECODE(fk.in_arc,'Y',fk.in_arc,' ')
                                     END
                  ).getClobVal()                                                in_arc,
        XMLElement(EVALNAME(single_table_prefix || ':FKColumnName'),ic.column_name).getClobVal()          col_name,
        ic.sequence                                                             seq,
        COUNT(ic.column_name) over()                                            total_row_count
 FROM   dmrs_foreignkeys fk,
        dmrs_constr_fk_columns ic
 WHERE  fk.child_table_ovid = v_t_ovid
 AND    fk.ovid = ic.fk_ovid
 ORDER BY fk.referred_table_name,fk.fk_name, ic.sequence;
rec_fk_referring_to cur_fk_referring_to%ROWTYPE;

--Foreign keys referred from other tables
CURSOR cur_fk_referred_from(v_t_ovid IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(single_table_prefix || ':FKName'),CASE WHEN ic.sequence>1 THEN ' '
                                    ELSE fk.fk_name
                                    END
                   ).getClobVal()                                              fk_name,
        XMLElement(EVALNAME(single_table_prefix || ':FKReferredFrom'),CASE WHEN ic.sequence>1 THEN ' '
                                           ELSE fk.child_table_name
                                           END
                  ).getClobVal()                                                referred_from,
        XMLElement(EVALNAME(single_table_prefix || ':FKMandatory'),CASE WHEN ic.sequence>1 THEN ' '
                                         ELSE DECODE(fk.mandatory,'Y',fk.mandatory,' ')
                                         END
                  ).getClobVal()                                                mandatory,
        XMLElement(EVALNAME(single_table_prefix || ':FKTransferable'),CASE WHEN ic.sequence>1 THEN ' '
                                            ELSE DECODE(fk.transferable,'Y',fk.transferable,' ')
                                            END
                  ).getClobVal()                                                transferable,
        XMLElement(EVALNAME(single_table_prefix || ':FKInArc'),CASE WHEN ic.sequence>1 THEN ' '
                                     ELSE DECODE(fk.in_arc,'Y',fk.in_arc,' ')
                                     END
                  ).getClobVal()                                                in_arc,
        XMLElement(EVALNAME(single_table_prefix || ':FKColumnName'),ic.column_name).getClobVal()           col_name,
        ic.sequence                                                             seq,
        COUNT(ic.column_name) over()                                            total_row_count
 FROM   dmrs_foreignkeys fk,
        dmrs_constr_fk_columns ic
 WHERE  fk.referred_table_ovid = v_t_ovid
 AND    fk.ovid = ic.fk_ovid
 ORDER BY fk.child_table_name,fk.fk_name, ic.sequence;
rec_fk_referred_from cur_fk_referred_from%ROWTYPE;

BEGIN

  UTL_FILE.PUT_LINE(log_file, TO_CHAR(SYSDATE,'yy.mm.dd hh:mi:ss') ||' '|| 'Gathering single table data started ...');

   DBMS_LOB.CREATETEMPORARY(res, TRUE);
   DBMS_LOB.APPEND (res,'<' || single_table_prefix || ':Table xmlns:' || single_table_prefix || '="http://oracle.com/datamodeler/reports/table">');

   -- Common Data
   FOR rec_common_data IN cur_common_data(v_table_ovid) LOOP

      DBMS_LOB.APPEND (res, rec_common_data.design_name);
      DBMS_LOB.APPEND (res, rec_common_data.version_date);  
      DBMS_LOB.APPEND (res, rec_common_data.version_comment);  
      DBMS_LOB.APPEND (res, rec_common_data.model_name);
 
   END LOOP;

   -- Description / Notes
   IF (reportTemplate.reportType = 0 OR reportTemplate.useDescriptionInfo = 1) THEN

      DBMS_LOB.APPEND (res, '<' || single_table_prefix || ':DescriptionNotes>');

      SELECT 
        XMLElement(EVALNAME(single_table_prefix || ':Description'), XMLCDATA(
            NVL((SELECT t.text comments_in_rdbms
                 FROM   dmrs_large_text t
                 WHERE  t.ovid = v_table_ovid
                 AND    t.type='Comments'),
                (SELECT t.text comments_in_rdbms
                 FROM   dmrs_large_text t
                 WHERE  t.ovid = v_table_ovid
                 AND    t.type='CommentsInRDBMS')))).getClobVal(), 
        XMLElement(EVALNAME(single_table_prefix || ':Notes'), XMLCDATA(
               (SELECT t.text comments_in_rdbms
                FROM   dmrs_large_text t
                WHERE  t.ovid = v_table_ovid
                AND    t.type='Note'))).getClobVal()
      INTO   v_description, 
             v_notes
      FROM  dual;

      DBMS_LOB.APPEND (res, v_description);
      DBMS_LOB.APPEND (res, v_notes);
      DBMS_LOB.APPEND (res, '</' || single_table_prefix || ':DescriptionNotes>');

   END IF;

   --Table General Data
   FOR rec_table IN cur_table(v_table_ovid) LOOP
      DBMS_LOB.APPEND (res, rec_table.table_name);
      DBMS_LOB.APPEND (res, rec_table.functional_name);      
      DBMS_LOB.APPEND (res, rec_table.abbreviation);
      DBMS_LOB.APPEND (res, rec_table.class_type_name);
      DBMS_LOB.APPEND (res, rec_table.obj_type_name);

      IF (reportTemplate.reportType = 0 OR reportTemplate.useQuantitativeInfo = 1) THEN
        DBMS_LOB.APPEND (res, '<' || single_table_prefix || ':QuantitativeInfoCollection>');
        DBMS_LOB.APPEND (res, rec_table.number_cols);
        DBMS_LOB.APPEND (res, rec_table.number_rows_min);
        DBMS_LOB.APPEND (res, rec_table.number_rows_max);
        DBMS_LOB.APPEND (res, rec_table.number_rows_expected);
        DBMS_LOB.APPEND (res, rec_table.growth_expected);
        DBMS_LOB.APPEND (res, rec_table.growth_interval);
        DBMS_LOB.APPEND (res, '</' || single_table_prefix || ':QuantitativeInfoCollection>');
      END IF;
   END LOOP;
   
   -- Diagrams
   IF (reportTemplate.reportType = 0 OR reportTemplate.useDiagrams = 1) THEN
     FOR rec_diagrams IN cur_diagrams(v_table_ovid, v_report_name) LOOP
        IF (cur_diagrams%ROWCOUNT = 1) THEN
          DBMS_LOB.APPEND (res,'<' || single_table_prefix || ':DiagramsCollection>');
        END IF;
          
          DBMS_LOB.APPEND (res, rec_diagrams.pdf_name);

        IF (cur_diagrams%ROWCOUNT = rec_diagrams.total_row_count) THEN
         DBMS_LOB.APPEND (res, '</' || single_table_prefix || ':DiagramsCollection>');
        END IF;
     END LOOP;
   END IF;
   
   -- Columns
   IF (reportTemplate.reportType = 0 OR reportTemplate.useTableColumns = 1) THEN
     FOR rec_columns IN cur_columns(v_table_ovid) LOOP
        IF (cur_columns%ROWCOUNT = 1) THEN
          DBMS_LOB.APPEND (res,'<' || single_table_prefix || ':ColumnsCollection>');
        END IF;
        
          DBMS_LOB.APPEND (res, '<' || single_table_prefix || ':ColumnDetails>');
          DBMS_LOB.APPEND (res, rec_columns.seq);
          DBMS_LOB.APPEND (res, rec_columns.column_name);
          DBMS_LOB.APPEND (res, rec_columns.pk);
          DBMS_LOB.APPEND (res, rec_columns.fk);
          DBMS_LOB.APPEND (res, rec_columns.m);
          IF (INSTR(LOWER(rec_columns.data_type),'unknown') = 0) THEN
            DBMS_LOB.APPEND (res, rec_columns.data_type);
          ELSE
            SELECT XMLElement(EVALNAME(single_table_prefix || ':DataType'), '').getClobVal() INTO token_value FROM dual;
            DBMS_LOB.APPEND (res, token_value);
          END IF;
          DBMS_LOB.APPEND (res, rec_columns.dt_kind);
          DBMS_LOB.APPEND (res, rec_columns.domain_name);
          DBMS_LOB.APPEND (res, rec_columns.formula);
          DBMS_LOB.APPEND (res, rec_columns.security);
          DBMS_LOB.APPEND (res, rec_columns.abbreviation);
          DBMS_LOB.APPEND (res,'</' || single_table_prefix || ':ColumnDetails>');
        
        IF (cur_columns%ROWCOUNT = rec_columns.total_row_count) THEN
         DBMS_LOB.APPEND (res, '</' || single_table_prefix || ':ColumnsCollection>');
        END IF;
     END LOOP;
   END IF;

   -- Columns Comments
   IF (reportTemplate.reportType = 0 OR reportTemplate.useTableColumnsComments = 1) THEN
     FOR rec_columns_comments IN cur_columns_comments(v_table_ovid) LOOP
        IF (cur_columns_comments%ROWCOUNT = 1) THEN
          DBMS_LOB.APPEND (res,'<' || single_table_prefix || ':ColumnsCommentsCollection>');
        END IF;

          DBMS_LOB.APPEND (res, '<' || single_table_prefix || ':ColumnCommentsDetails>');
          DBMS_LOB.APPEND (res, rec_columns_comments.seq);
          DBMS_LOB.APPEND (res, rec_columns_comments.column_name);
          DBMS_LOB.APPEND (res, rec_columns_comments.column_description);
          DBMS_LOB.APPEND (res, rec_columns_comments.column_notes);
          DBMS_LOB.APPEND (res,'</' || single_table_prefix || ':ColumnCommentsDetails>');

        IF (cur_columns_comments%ROWCOUNT = rec_columns_comments.total_row_count) THEN
          DBMS_LOB.APPEND (res, '</' || single_table_prefix || ':ColumnsCommentsCollection>');
        END IF;
     END LOOP;
   END IF;

   -- Indexes
   IF (reportTemplate.reportType = 0 OR reportTemplate.useTableIndexes = 1) THEN
     FOR rec_indexes IN cur_indexes(v_table_ovid) LOOP
        IF (cur_indexes%ROWCOUNT = 1) THEN
          DBMS_LOB.APPEND (res,'<' || single_table_prefix || ':IndexesCollection>');
        END IF;
     
          DBMS_LOB.APPEND (res, '<' || single_table_prefix || ':IndexDetails>');
          DBMS_LOB.APPEND (res, rec_indexes.idx_name);
          DBMS_LOB.APPEND (res, rec_indexes.state);
          DBMS_LOB.APPEND (res, rec_indexes.functional);
          DBMS_LOB.APPEND (res, rec_indexes.spatial);
          DBMS_LOB.APPEND (res, rec_indexes.expression);
          DBMS_LOB.APPEND (res, rec_indexes.col_name);
          DBMS_LOB.APPEND (res, rec_indexes.sort_order);
          DBMS_LOB.APPEND (res,'</' || single_table_prefix || ':IndexDetails>');
     
        IF (cur_indexes%ROWCOUNT = rec_indexes.total_row_count) THEN
         DBMS_LOB.APPEND (res, '</' || single_table_prefix || ':IndexesCollection>');
        END IF;
     END LOOP;
   END IF;

   -- Constraints
   v_cc_created := FALSE;
   IF (reportTemplate.reportType = 0 OR reportTemplate.useTableConstraints = 1) THEN
     -- Table Level Constraints
     FOR rec_tl_constraints IN cur_tl_constraints(v_table_ovid) LOOP
        IF (cur_tl_constraints%ROWCOUNT = 1) THEN
          DBMS_LOB.APPEND (res,'<' || single_table_prefix || ':ConstraintsCollection>');
          v_cc_created := TRUE;
          DBMS_LOB.APPEND (res,'<' || single_table_prefix || ':TableLevelConstraintsCollection>');
        END IF;

          DBMS_LOB.APPEND (res, '<' || single_table_prefix || ':TableLevelConstraintDetails>');
          DBMS_LOB.APPEND (res, rec_tl_constraints.c_type);
          DBMS_LOB.APPEND (res, rec_tl_constraints.c_name);
          DBMS_LOB.APPEND (res, rec_tl_constraints.c_details);
          DBMS_LOB.APPEND (res, '</' || single_table_prefix || ':TableLevelConstraintDetails>');

        IF (cur_tl_constraints%ROWCOUNT = rec_tl_constraints.total_row_count) THEN
          DBMS_LOB.APPEND (res, '</' || single_table_prefix || ':TableLevelConstraintsCollection>');
        END IF;

     END LOOP;

     -- Column Level Constraints
     FOR rec_cl_constraints IN cur_cl_constraints(v_table_ovid) LOOP
        IF (cur_cl_constraints%ROWCOUNT = 1) THEN
          IF NOT v_cc_created THEN
             DBMS_LOB.APPEND (res,'<' || single_table_prefix || ':ConstraintsCollection>');
             v_cc_created := TRUE;
          END IF;

         DBMS_LOB.APPEND (res,'<' || single_table_prefix || ':ColumnLevelConstraintsCollection>');
         v_cc_created := TRUE;
        END IF;

         DBMS_LOB.APPEND (res, '<' || single_table_prefix || ':ConstraintDetails>');
         DBMS_LOB.APPEND (res, rec_cl_constraints.c_type);
         DBMS_LOB.APPEND (res, rec_cl_constraints.c_name);
         DBMS_LOB.APPEND (res, rec_cl_constraints.c_details);
         DBMS_LOB.APPEND (res,'</' || single_table_prefix || ':ConstraintDetails>');

        IF (cur_cl_constraints%ROWCOUNT = rec_cl_constraints.total_row_count) THEN
          DBMS_LOB.APPEND (res, '</' || single_table_prefix || ':ColumnLevelConstraintsCollection>');
        END IF;
     END LOOP;

     IF v_cc_created THEN
       DBMS_LOB.APPEND (res,'</' || single_table_prefix || ':ConstraintsCollection>');
     END IF;
   END IF;

   -- Foreign Keys Referring To
   IF (reportTemplate.reportType = 0 OR reportTemplate.useTableFKReferringTo = 1) THEN
     FOR rec_fk_referring_to IN cur_fk_referring_to(v_table_ovid) LOOP
        IF (cur_fk_referring_to%ROWCOUNT = 1) THEN
          DBMS_LOB.APPEND (res,'<' || single_table_prefix || ':FKRTCollection>');
        END IF;

         DBMS_LOB.APPEND (res, '<' || single_table_prefix || ':FKRTDetails>');
         DBMS_LOB.APPEND (res, rec_fk_referring_to.fk_name);
         DBMS_LOB.APPEND (res, rec_fk_referring_to.referring_to);
         DBMS_LOB.APPEND (res, rec_fk_referring_to.mandatory);
         DBMS_LOB.APPEND (res, rec_fk_referring_to.transferable);
         DBMS_LOB.APPEND (res, rec_fk_referring_to.in_arc);
         DBMS_LOB.APPEND (res, rec_fk_referring_to.col_name);
         DBMS_LOB.APPEND (res,'</' || single_table_prefix || ':FKRTDetails>');
         
        IF (cur_fk_referring_to%ROWCOUNT = rec_fk_referring_to.total_row_count) THEN
         DBMS_LOB.APPEND (res, '</' || single_table_prefix || ':FKRTCollection>');
        END IF;
     END LOOP;
   END IF;

   -- Foreign Keys Referred From
   IF (reportTemplate.reportType = 0 OR reportTemplate.useTableFKReferredFrom = 1) THEN
     FOR rec_fk_referred_from IN cur_fk_referred_from(v_table_ovid) LOOP
        IF (cur_fk_referred_from%ROWCOUNT = 1) THEN
            DBMS_LOB.APPEND (res,'<' || single_table_prefix || ':FKRFCollection>');
        END IF;

         DBMS_LOB.APPEND (res, '<' || single_table_prefix || ':FKRFDetails>');
         DBMS_LOB.APPEND (res, rec_fk_referred_from.fk_name);
         DBMS_LOB.APPEND (res, rec_fk_referred_from.referred_from);
         DBMS_LOB.APPEND (res, rec_fk_referred_from.mandatory);
         DBMS_LOB.APPEND (res, rec_fk_referred_from.transferable);
         DBMS_LOB.APPEND (res, rec_fk_referred_from.in_arc);
         DBMS_LOB.APPEND (res, rec_fk_referred_from.col_name);
         DBMS_LOB.APPEND (res,'</' || single_table_prefix || ':FKRFDetails>');
        
        IF (cur_fk_referred_from%ROWCOUNT = rec_fk_referred_from.total_row_count) THEN
         DBMS_LOB.APPEND (res, '</' || single_table_prefix || ':FKRFCollection>');
        END IF;
     END LOOP;
   END IF;

   DBMS_LOB.APPEND (res,'</' || single_table_prefix || ':Table>');

  UTL_FILE.PUT_LINE(log_file, TO_CHAR(SYSDATE,'yy.mm.dd hh:mi:ss') ||' '|| 'Gathering single table data ended');

RETURN res;

 EXCEPTION
 WHEN others THEN
  UTL_FILE.PUT_LINE(log_file, 'Pkg_Osdm_Utils.Gather_SingleTable_Data Exception : ' || SQLERRM);  
  UTL_FILE.PUT_LINE(log_file, 'Pkg_Osdm_Utils.Gather_SingleTable_Data Exception : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  RETURN res;
	
END Gather_SingleTable_Data;

FUNCTION Gather_AllTables_Data(v_model_ovid IN VARCHAR2, reportTemplate IN REPORT_TEMPLATE, objects IN OBJECTS_LIST, v_report_name IN VARCHAR2) RETURN CLOB IS 

res             CLOB;
v_description   VARCHAR2(32767);
v_notes         VARCHAR2(32767);
v_cc_created    BOOLEAN := FALSE;
token_value     CLOB;

-- Common Data
CURSOR cur_common_data(v_m_ovid IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(all_tables_prefix || ':DesignName'),d.design_name).getClobVal()                                      design_name,
        XMLElement(EVALNAME(all_tables_prefix || ':VersionDate'),TO_CHAR(d.date_published,'dd.mm.yyyy hh24:mi:ss')).getClobVal() version_date,
        XMLElement(EVALNAME(all_tables_prefix || ':VersionComment'),XMLCDATA(d.version_comments)).getClobVal()                   version_comment,
        XMLElement(EVALNAME(all_tables_prefix || ':ModelName'),m.model_name).getClobVal()                                        model_name
 FROM   dmrs_designs d, 
        dmrs_models m
 WHERE  d.design_ovid = m.design_ovid
 AND    m.model_ovid = v_m_ovid;
rec_common_data cur_common_data%ROWTYPE;

-- All Tables General Data
CURSOR cur_all_tables(v_m_ovid IN VARCHAR2) IS
 SELECT /*+ index(t TABLES_FK_IDXV1) */
        XMLElement(EVALNAME(all_tables_prefix || ':TableName'), DECODE(t.schema_name, NULL, '', t.schema_name ||'.') || t.table_name).getClobVal()  table_name,
        XMLElement(EVALNAME(all_tables_prefix || ':EncodedTableName'),t.ovid).getClobVal()															xml_ovid,
        XMLElement(EVALNAME(all_tables_prefix || ':Abbreviation'),t.abbreviation).getClobVal()                                                      abbreviation,
        XMLElement(EVALNAME(all_tables_prefix || ':ClassificationTypeName'),t.classification_type_name).getClobVal()                                class_type_name,
        XMLElement(EVALNAME(all_tables_prefix || ':ObjectTypeName'),t.structured_type_name).getClobVal()                                            obj_type_name,
        XMLElement(EVALNAME(all_tables_prefix || ':NumberOfColumns'),t.number_data_elements).getClobVal()                                           number_cols,
        XMLElement(EVALNAME(all_tables_prefix || ':NumberOfRowsMin'),t.min_volume).getClobVal()                                                     number_rows_min,
        XMLElement(EVALNAME(all_tables_prefix || ':NumberOfRowsMax'),t.max_volume).getClobVal()                                                     number_rows_max,
        XMLElement(EVALNAME(all_tables_prefix || ':ExpectedNumberOfRows'),t.expected_volume).getClobVal()                                           number_rows_expected,
        XMLElement(EVALNAME(all_tables_prefix || ':ExpectedGrowth'),t.growth_rate_percents).getClobVal()                                            growth_expected,
        XMLElement(EVALNAME(all_tables_prefix || ':GrowthInterval'),t.growth_rate_interval).getClobVal()                                            growth_interval,
        XMLElement(EVALNAME(all_tables_prefix || ':FunctionalName'), (SELECT NVL(e.entity_name,'')                        
                                              FROM   dmrs_entities e,
                                                     dmrs_mappings m
                                              WHERE  m.relational_object_ovid = t.ovid
                                              AND    m.logical_object_ovid  = e.ovid
                                              AND    ROWNUM = 1)).getClobVal()                                                                      functional_name, 
       t.ovid                                                                                                                                       table_ovid,
       COUNT(t.table_name) over()                                                                                                                   total_row_count
 FROM 	 dmrs_tables t
 WHERE  t.model_ovid = v_m_ovid
 AND    t.ovid MEMBER OF objects
 ORDER BY t.table_name;
rec_all_tables cur_all_tables%ROWTYPE;

-- Diagrams
CURSOR cur_diagrams(v_t_ovid IN VARCHAR2, v_rep_name IN VARCHAR2) IS

 SELECT XMLElement(EVALNAME(all_tables_prefix || ':Diagram'), 
          XMLElement(EVALNAME(all_tables_prefix || ':Name'), v_rep_name || '_files/' || REGEXP_REPLACE(SUBSTR(d.pdf_name, 1, INSTR(d.pdf_name, '.PDF')-1), '[^a-zA-Z1-9_]', '_') || '.pdf'),
		  XMLElement(EVALNAME(all_tables_prefix || ':Link'), v_rep_name || '_files/' || REGEXP_REPLACE(SUBSTR(d.pdf_name, 1, INSTR(d.pdf_name, '.PDF')-1), '[^a-zA-Z1-9_]', '_') || '.pdf')   link,          
          XMLElement(EVALNAME(all_tables_prefix || ':Suffix'), NULL)).getClobVal()                                                                                                            pdf_name,
        COUNT(d.pdf_name) over()                                                                                                                                                              total_row_count
 FROM   dmrs_vdiagrams d,
       (SELECT diagram_ovid 
        FROM   dmrs_diagram_elements
        WHERE  ovid = v_t_ovid) b
 WHERE d.ovid = b.diagram_ovid
 AND   d.diagram_type = 'Subview'
 AND   d.is_display = 'N';
rec_diagrams cur_diagrams%ROWTYPE;

-- Columns Data
CURSOR cur_columns(v_t_ovid IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(all_tables_prefix || ':Sequence'),c.sequence).getClobVal()                                                                                              seq,
        XMLElement(EVALNAME(all_tables_prefix || ':ColumnName'),c.column_name).getClobVal()                                                                                         column_name,
        XMLElement(EVALNAME(all_tables_prefix || ':PK'),c.pk_flag).getClobVal()                                                                                                     pk,
        XMLElement(EVALNAME(all_tables_prefix || ':FK'),c.fk_flag).getClobVal()                                                                                                     fk,
        XMLElement(EVALNAME(all_tables_prefix || ':M'),DECODE(c.mandatory,'N',' ',c.mandatory)).getClobVal()                                                                        m,
        XMLElement(EVALNAME(all_tables_prefix || ':DataTypeKind'),DECODE(c.datatype_kind,                                                                                           
                                                 'Domain',         'DOM',                                                                                   
                                                 'Logical Type',   'LT',                                                                                    
                                                 'Distinct Type',  'DT',                                                                                    
                                                 'Ref Struct Type','RST',                                                                                   
                                                 'Structured Type','ST',                                                                                    
                                                 'Collection Type','CT')                                                                                    
                  ).getClobVal()                                                                                                                             dt_kind,
         XMLElement(EVALNAME(all_tables_prefix || ':DataType'), 
            DECODE(c.datatype_kind, 
                  'Domain', c.logical_type_name ||' '||
                           DECODE (NVL(c.t_size,''),'',
                              DECODE(NVL(c.t_scale,0),0,
                                 DECODE(NVL(c.t_precision,0),0,null,'('|| DECODE(NVL(c.t_precision,0),0,null,c.t_precision) ||')'),
                                   '('|| DECODE(NVL(c.t_precision,0),0,null,c.t_precision) || ',' || DECODE(NVL(c.t_scale,0),0,null,c.t_scale)||')'),
                                   '('||TRIM(DECODE(c.t_size,'',null,c.t_size||' '||c.char_units ))||')'),
                   'Logical Type', c.logical_type_name  ||' '|| 
                           DECODE (NVL(c.t_size,''),'',
                              DECODE(NVL(c.t_scale,0),0,
                                 DECODE(NVL(c.t_precision,0),0,null,'('|| DECODE(NVL(c.t_precision,0),0,null,c.t_precision) ||')'),
                                   '('|| DECODE(NVL(c.t_precision,0),0,null,c.t_precision) || ',' || DECODE(NVL(c.t_scale,0),0,null,c.t_scale)||')'),
                                   '('||TRIM(DECODE(c.t_size,'',null,c.t_size||' '||c.char_units ))||')')
            ) ||
            DECODE (c.auto_increment_column,'Y', ' - AI','') ||
            DECODE (c.identity_column,'Y', ' - ID','')
          ).getClobVal()                                                                                                                                     data_type,
        XMLElement(EVALNAME(all_tables_prefix || ':DomainName'),DECODE(c.domain_name,'Unknown',null,c.domain_name)).getClobVal()                                                     domain_name,
        XMLElement(EVALNAME(all_tables_prefix || ':Formula'),TRIM(c.formula||' '||c.default_value)).getClobVal()                                                                     formula,
        XMLElement(EVALNAME(all_tables_prefix || ':Security'),DECODE(c.personally_id_information ||'/'||c.sensitive_information||'/'||c.mask_for_none_production,'//',
                                      null,c.personally_id_information ||'/'||c.sensitive_information||'/'||c.mask_for_none_production)).getClobVal()        security,
        XMLElement(EVALNAME(all_tables_prefix || ':PreferredAbbreviation'),c.abbreviation).getClobVal()                                                                              abbreviation,
        COUNT(c.column_name) over()                                                                                                                          total_row_count
 FROM 	dmrs_columns c
 WHERE  c.container_ovid = v_t_ovid
 ORDER BY c.sequence;
rec_columns cur_columns%ROWTYPE;

-- Columns Comments Data
CURSOR cur_columns_comments(v_t_ovid IN VARCHAR2) IS
 SELECT a.seq                       seq, 
        a.column_name               column_name, 
        a.column_description        column_description, 
        a.column_notes              column_notes,
        COUNT(a.column_name) over() total_row_count
 FROM (
  SELECT XMLElement(EVALNAME(all_tables_prefix || ':ColumnCommentsSequence'),c.sequence).getStringVal()  seq,
         XMLElement(EVALNAME(all_tables_prefix || ':ColumnCommentsName'),c.column_name).getStringVal()   column_name,
         XMLElement(EVALNAME(all_tables_prefix || ':ColumnDescription'),XMLCDATA(
            NVL(( SELECT t.text comments_in_rdbms
                  FROM   dmrs_large_text t
                  WHERE  t.ovid = c.ovid
                  AND    t.type='Comments'),
                ( SELECT t.text comments_in_rdbms
                  FROM   dmrs_large_text t
                  WHERE  t.ovid = c.ovid
                  AND    t.type='CommentsInRDBMS')))).getClobVal()                                       column_description, 
         XMLElement(EVALNAME(all_tables_prefix || ':ColumnNotes'),XMLCDATA(
                ( SELECT t.text comments_in_rdbms
                  FROM   dmrs_large_text t
                  WHERE  t.ovid = c.ovid
                  AND    t.type='Note'))).getClobVal()                                                   column_notes
  FROM   dmrs_columns c
  WHERE  c.container_ovid = v_t_ovid
  ORDER BY c.sequence
 ) a
 WHERE DBMS_LOB.getlength(column_description) > 0 OR DBMS_LOB.getlength(column_notes) > 0;
rec_columns_comments cur_columns_comments%ROWTYPE;

--Indexes
CURSOR cur_indexes(v_t_ovid IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(all_tables_prefix || ':IndexName'),i.index_name).getClobVal()                                                                                        idx_name,
        XMLElement(EVALNAME(all_tables_prefix || ':IndexState'),DECODE(i.state,'Unique Plain Index','UN','Unique Constraint','UK','Primary Constraint','PK',null)).getClobVal()  state,
        XMLElement(EVALNAME(all_tables_prefix || ':IndexFunctional'),DECODE(i.functional,'N',' ',i.functional)).getClobVal()                                                     functional,
        XMLElement(EVALNAME(all_tables_prefix || ':IndexSpatial'),DECODE(i.spatial_index,'N',' ',i.spatial_index)).getClobVal()                                                  spatial,
        XMLElement(EVALNAME(all_tables_prefix || ':IndexExpression'),i.expression).getClobVal()                                                                                  expression,
        XMLElement(EVALNAME(all_tables_prefix || ':IndexColumnName'),c.column_name).getClobVal()                                                                                 col_name,
        XMLElement(EVALNAME(all_tables_prefix || ':IndexSortOrder'),c.sort_order).getClobVal()                                                                                   sort_order,
        c.sequence                                                                                                                                       idx_sequence,
        COUNT(c.column_name) over()                                                                                                                      total_row_count
 FROM   dmrs_tables t,
        dmrs_indexes i,
        dmrs_constr_index_columns c
 WHERE  t.ovid = i.container_ovid
 AND    i.ovid = c.index_ovid
 AND    t.ovid = v_t_ovid
 ORDER BY i.index_name, c.sequence, c.sort_order;
rec_indexes cur_indexes%ROWTYPE;

-- Table Level Constraints
CURSOR cur_tl_constraints(v_t_ovid IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(all_tables_prefix || ':TLConstraintType'), CASE WHEN rownum>1 THEN ''
                                               ELSE 'Table Level'
                                               END ).getClobVal()               c_type,
        XMLElement(EVALNAME(all_tables_prefix || ':TLConstraintName'), tc.constraint_name).getClobVal() c_name,
        tc.text                                                                 c_details,
        COUNT(tc.constraint_name) over()                                        total_row_count
 FROM   dmrs_table_constraints tc
 WHERE  tc.table_ovid = v_t_ovid;
rec_tl_constraints cur_tl_constraints%ROWTYPE;

-- Column Level Constraints
CURSOR cur_cl_constraints(v_t_ovid IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(all_tables_prefix || ':ContstraintType'), CASE WHEN rownum>1 THEN ''
                                              ELSE 'Column Level'
                                              END).getClobVal()                                        c_type,
        XMLElement(EVALNAME(all_tables_prefix || ':ALCConstraintName'), c.column_name || 
                                                DECODE((SELECT DISTINCT(constraint_name) 
                                                        FROM dmrs_check_constraints 
                                                        WHERE c.ovid = dataelement_ovid),NULL,'',
                                               ' / '|| (SELECT  DISTINCT(constraint_name) 
                                                        FROM dmrs_check_constraints 
                                                        WHERE c.ovid = dataelement_ovid))).getClobVal() c_name,
        Gather_Constraint_Details_XML(c.ovid, all_tables_prefix)                                        c_details,
        COUNT(c.column_name) over()                                                                     total_row_count
 FROM   dmrs_columns c
 WHERE  c.container_ovid = v_t_ovid
 AND    (c.ovid IN (SELECT dataelement_ovid FROM dmrs_avt) OR 
         c.ovid IN (SELECT dataelement_ovid FROM dmrs_value_ranges) OR 
         c.ovid IN (SELECT dataelement_ovid FROM dmrs_check_constraints));
rec_cl_constraints cur_cl_constraints%ROWTYPE;

--Foreign keys referring to other tables
CURSOR cur_fk_referring_to(v_t_ovid IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(all_tables_prefix || ':FKName'),CASE WHEN ic.sequence>1 THEN ' '
                                    ELSE fk.fk_name
                                    END
                   ).getClobVal()                                               fk_name,
        XMLElement(EVALNAME(all_tables_prefix || ':FKReferringTo'),CASE WHEN ic.sequence>1 THEN ' '
                                          ELSE fk.referred_table_name
                                          END
                  ).getClobVal()                                                referring_to,
        XMLElement(EVALNAME(all_tables_prefix || ':FKMandatory'),CASE WHEN ic.sequence>1 THEN ' '
                                         ELSE DECODE(fk.mandatory,'Y',fk.mandatory,' ')
                                         END
                  ).getClobVal()                                                mandatory,
        XMLElement(EVALNAME(all_tables_prefix || ':FKTransferable'),CASE WHEN ic.sequence>1 THEN ' '
                                            ELSE DECODE(fk.transferable,'Y',fk.transferable,' ')
                                            END
                  ).getClobVal()                                                transferable,
        XMLElement(EVALNAME(all_tables_prefix || ':FKInArc'),CASE WHEN ic.sequence>1 THEN ' '
                                     ELSE DECODE(fk.in_arc,'Y',fk.in_arc,' ')
                                     END
                  ).getClobVal()                                                in_arc,
        XMLElement(EVALNAME(all_tables_prefix || ':FKColumnName'),ic.column_name).getClobVal()          col_name,
        ic.sequence                                                             seq,
        COUNT(ic.column_name) over()                                            total_row_count
 FROM   dmrs_foreignkeys fk,
        dmrs_constr_fk_columns ic
 WHERE  fk.child_table_ovid = v_t_ovid
 AND    fk.ovid = ic.fk_ovid
 ORDER BY fk.referred_table_name,fk.fk_name, ic.sequence;
rec_fk_referring_to cur_fk_referring_to%ROWTYPE;

--Foreign keys referring from other tables
CURSOR cur_fk_referred_from(v_t_ovid IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(all_tables_prefix || ':FKName'),CASE WHEN ic.sequence>1 THEN ' '
                                    ELSE fk.fk_name
                                    END
                   ).getClobVal()                                               fk_name,
        XMLElement(EVALNAME(all_tables_prefix || ':FKReferredFrom'),CASE WHEN ic.sequence>1 THEN ' '
                                           ELSE fk.child_table_name
                                           END
                  ).getClobVal()                                                referred_from,
        XMLElement(EVALNAME(all_tables_prefix || ':FKMandatory'),CASE WHEN ic.sequence>1 THEN ' '
                                         ELSE DECODE(fk.mandatory,'Y',fk.mandatory,' ')
                                         END
                  ).getClobVal()                                                mandatory,
        XMLElement(EVALNAME(all_tables_prefix || ':FKTransferable'),CASE WHEN ic.sequence>1 THEN ' '
                                            ELSE DECODE(fk.transferable,'Y',fk.transferable,' ')
                                            END
                  ).getClobVal()                                                transferable,
        XMLElement(EVALNAME(all_tables_prefix || ':FKInArc'),CASE WHEN ic.sequence>1 THEN ' '
                                     ELSE DECODE(fk.in_arc,'Y',fk.in_arc,' ')
                                     END
                  ).getClobVal()                                                in_arc,
        XMLElement(EVALNAME(all_tables_prefix || ':FKColumnName'),ic.column_name).getClobVal()          col_name,
        ic.sequence                                                             seq,
        COUNT(ic.column_name) over()                                            total_row_count
 FROM   dmrs_foreignkeys fk,
        dmrs_constr_fk_columns ic
 WHERE  fk.referred_table_ovid = v_t_ovid
 AND    fk.ovid = ic.fk_ovid
 ORDER BY fk.child_table_name,fk.fk_name, ic.sequence;
rec_fk_referred_from cur_fk_referred_from%ROWTYPE;

BEGIN

  UTL_FILE.PUT_LINE(log_file, TO_CHAR(SYSDATE,'yy.mm.dd hh:mi:ss') ||' '|| 'Gathering all tables data started ...');

  DBMS_LOB.CREATETEMPORARY(res, TRUE);
  DBMS_LOB.APPEND (res,'<' || all_tables_prefix || ':Tables xmlns:' || all_tables_prefix || '="http://oracle.com/datamodeler/reports/tables">');

   -- Common Data
   FOR rec_common_data IN cur_common_data(v_model_ovid) LOOP

      DBMS_LOB.APPEND (res, rec_common_data.design_name);
      DBMS_LOB.APPEND (res, rec_common_data.version_date);
      DBMS_LOB.APPEND (res, rec_common_data.version_comment);
      DBMS_LOB.APPEND (res, rec_common_data.model_name);
 
   END LOOP;

   FOR rec_all_tables IN cur_all_tables(v_model_ovid) LOOP

      IF (cur_all_tables%ROWCOUNT = 1) THEN
           DBMS_LOB.APPEND (res,'<'||all_tables_prefix||':TablesCollection>');
      END IF;
      
      DBMS_LOB.APPEND (res,'<'||all_tables_prefix||':TableDetails>');

      -- Description / Notes
      IF (reportTemplate.reportType = 0 OR reportTemplate.useDescriptionInfo = 1) THEN
      
         DBMS_LOB.APPEND (res, '<'||all_tables_prefix||':DescriptionNotes>');
         
         SELECT 
            XMLElement(EVALNAME(all_tables_prefix || ':Description'), XMLCDATA(
               NVL((SELECT t.text comments_in_rdbms
                    FROM   dmrs_large_text t
                    WHERE  t.ovid = rec_all_tables.table_ovid
                    AND    t.type='Comments'),
                  ( SELECT t.text comments_in_rdbms
                    FROM   dmrs_large_text t
                    WHERE  t.ovid = rec_all_tables.table_ovid
                    AND    t.type='CommentsInRDBMS')))).getClobVal(), 
            XMLElement(EVALNAME(all_tables_prefix || ':Notes'), XMLCDATA(
                  ( SELECT t.text comments_in_rdbms
                    FROM   dmrs_large_text t
                    WHERE  t.ovid = rec_all_tables.table_ovid
                    AND    t.type='Note'))).getClobVal()
         INTO   v_description, 
                v_notes
         FROM  dual;

        DBMS_LOB.APPEND (res, v_description);
        DBMS_LOB.APPEND (res, v_notes);
        DBMS_LOB.APPEND (res, '</'||all_tables_prefix||':DescriptionNotes>');
         
      END IF;

         DBMS_LOB.APPEND (res, rec_all_tables.table_name);
         DBMS_LOB.APPEND (res, rec_all_tables.xml_ovid);
         DBMS_LOB.APPEND (res, rec_all_tables.functional_name);      
         DBMS_LOB.APPEND (res, rec_all_tables.abbreviation);
         DBMS_LOB.APPEND (res, rec_all_tables.class_type_name);
         DBMS_LOB.APPEND (res, rec_all_tables.obj_type_name);
       IF (reportTemplate.reportType = 0 OR reportTemplate.useQuantitativeInfo = 1) THEN
         DBMS_LOB.APPEND (res, '<'||all_tables_prefix||':QuantitativeInfoCollection>');
         DBMS_LOB.APPEND (res, rec_all_tables.number_cols);
         DBMS_LOB.APPEND (res, rec_all_tables.number_rows_min);
         DBMS_LOB.APPEND (res, rec_all_tables.number_rows_max);
         DBMS_LOB.APPEND (res, rec_all_tables.number_rows_expected);
         DBMS_LOB.APPEND (res, rec_all_tables.growth_expected);
         DBMS_LOB.APPEND (res, rec_all_tables.growth_interval);
         DBMS_LOB.APPEND (res, '</'||all_tables_prefix||':QuantitativeInfoCollection>');
       END IF;

       -- Diagrams
       IF (reportTemplate.reportType = 0 OR reportTemplate.useDiagrams = 1) THEN
         FOR rec_diagrams IN cur_diagrams(rec_all_tables.table_ovid, v_report_name) LOOP
            IF (cur_diagrams%ROWCOUNT = 1) THEN
              DBMS_LOB.APPEND (res,'<'||all_tables_prefix||':DiagramsCollection>');
            END IF;
              
              DBMS_LOB.APPEND (res, rec_diagrams.pdf_name);
       
            IF (cur_diagrams%ROWCOUNT = rec_diagrams.total_row_count) THEN
             DBMS_LOB.APPEND (res, '</'||all_tables_prefix||':DiagramsCollection>');
            END IF;
         END LOOP;
       END IF;

       -- Columns
       IF (reportTemplate.reportType = 0 OR reportTemplate.useTableColumns = 1) THEN
         FOR rec_columns IN cur_columns(rec_all_tables.table_ovid) LOOP
            IF (cur_columns%ROWCOUNT = 1) THEN
              DBMS_LOB.APPEND (res,'<'||all_tables_prefix||':ColumnsCollection>');
            END IF;

              DBMS_LOB.APPEND (res, '<'||all_tables_prefix||':ColumnDetails>');
              DBMS_LOB.APPEND (res, rec_columns.seq);
              DBMS_LOB.APPEND (res, rec_columns.column_name);
              DBMS_LOB.APPEND (res, rec_columns.pk);
              DBMS_LOB.APPEND (res, rec_columns.fk);
              DBMS_LOB.APPEND (res, rec_columns.m);
              IF (INSTR(LOWER(rec_columns.data_type),'unknown') = 0) THEN
                DBMS_LOB.APPEND (res, rec_columns.data_type);
              ELSE
                SELECT XMLElement(EVALNAME(all_tables_prefix || ':DataType'), '').getClobVal() INTO token_value FROM dual;
                DBMS_LOB.APPEND (res, token_value);
              END IF;
              DBMS_LOB.APPEND (res, rec_columns.dt_kind);
              DBMS_LOB.APPEND (res, rec_columns.domain_name);
              DBMS_LOB.APPEND (res, rec_columns.formula);
              DBMS_LOB.APPEND (res, rec_columns.security);
              DBMS_LOB.APPEND (res, rec_columns.abbreviation);
              DBMS_LOB.APPEND (res,'</'||all_tables_prefix||':ColumnDetails>');

            IF (cur_columns%ROWCOUNT = rec_columns.total_row_count) THEN
             DBMS_LOB.APPEND (res, '</'||all_tables_prefix||':ColumnsCollection>');
            END IF;
         END LOOP;
       END IF;

       -- Columns Comments
       IF (reportTemplate.reportType = 0 OR reportTemplate.useTableColumnsComments = 1) THEN
         FOR rec_columns_comments IN cur_columns_comments(rec_all_tables.table_ovid) LOOP
            IF (cur_columns_comments%ROWCOUNT = 1) THEN
              DBMS_LOB.APPEND (res,'<'||all_tables_prefix||':ColumnsCommentsCollection>');
            END IF;

            DBMS_LOB.APPEND (res, '<' || all_tables_prefix || ':ColumnCommentsDetails>');
            DBMS_LOB.APPEND (res, rec_columns_comments.seq);
            DBMS_LOB.APPEND (res, rec_columns_comments.column_name);
            DBMS_LOB.APPEND (res, rec_columns_comments.column_description);
            DBMS_LOB.APPEND (res, rec_columns_comments.column_notes);
            DBMS_LOB.APPEND (res,'</' || all_tables_prefix || ':ColumnCommentsDetails>');

            IF (cur_columns_comments%ROWCOUNT = rec_columns_comments.total_row_count) THEN
              DBMS_LOB.APPEND (res, '</'||all_tables_prefix||':ColumnsCommentsCollection>');
            END IF;
         END LOOP;
       END IF;

       -- Indexes
       IF (reportTemplate.reportType = 0 OR reportTemplate.useTableIndexes = 1) THEN
       		FOR rec_indexes IN cur_indexes(rec_all_tables.table_ovid) LOOP
       		   IF (cur_indexes%ROWCOUNT = 1) THEN
       		     DBMS_LOB.APPEND (res,'<'||all_tables_prefix||':IndexesCollection>');
       		   END IF;

       		     DBMS_LOB.APPEND (res, '<'||all_tables_prefix||':IndexDetails>');
       		     DBMS_LOB.APPEND (res, rec_indexes.idx_name);
       		     DBMS_LOB.APPEND (res, rec_indexes.state);
       		     DBMS_LOB.APPEND (res, rec_indexes.functional);
       		     DBMS_LOB.APPEND (res, rec_indexes.spatial);
       		     DBMS_LOB.APPEND (res, rec_indexes.expression);
       		     DBMS_LOB.APPEND (res, rec_indexes.col_name);
       		     DBMS_LOB.APPEND (res, rec_indexes.sort_order);
       		     DBMS_LOB.APPEND (res,'</'||all_tables_prefix||':IndexDetails>');

       		   IF (cur_indexes%ROWCOUNT = rec_indexes.total_row_count) THEN
       		    DBMS_LOB.APPEND (res, '</'||all_tables_prefix||':IndexesCollection>');
       		   END IF;
       		END LOOP;
       END IF;

       v_cc_created := FALSE;
       -- Constraints
       IF (reportTemplate.reportType = 0 OR reportTemplate.useTableConstraints = 1) THEN
         -- Table Level Constraints
         FOR rec_tl_constraints IN cur_tl_constraints(rec_all_tables.table_ovid) LOOP
            IF (cur_tl_constraints%ROWCOUNT = 1) THEN
              DBMS_LOB.APPEND (res,'<'||all_tables_prefix||':ConstraintsCollection>');
              v_cc_created := TRUE;
              DBMS_LOB.APPEND (res,'<'||all_tables_prefix||':TableLevelConstraintsCollection>');
            END IF;

            DBMS_LOB.APPEND (res, '<' || all_tables_prefix || ':TableLevelConstraintDetails>');
            DBMS_LOB.APPEND (res, rec_tl_constraints.c_type);
            DBMS_LOB.APPEND (res, rec_tl_constraints.c_name);
            DBMS_LOB.APPEND (res, rec_tl_constraints.c_details);
            DBMS_LOB.APPEND (res, '</' || all_tables_prefix || ':TableLevelConstraintDetails>');

            IF (cur_tl_constraints%ROWCOUNT = rec_tl_constraints.total_row_count) THEN
              DBMS_LOB.APPEND (res, '</'||all_tables_prefix||':TableLevelConstraintsCollection>');
            END IF;

         END LOOP;

         -- Column Level Constraints
         FOR rec_cl_constraints IN cur_cl_constraints(rec_all_tables.table_ovid) LOOP
            IF (cur_cl_constraints%ROWCOUNT = 1) THEN
              IF NOT v_cc_created THEN
                 DBMS_LOB.APPEND (res,'<'||all_tables_prefix||':ConstraintsCollection>');
                 v_cc_created := TRUE;
              END IF;

             DBMS_LOB.APPEND (res,'<'||all_tables_prefix||':ColumnLevelConstraintsCollection>');
             v_cc_created := TRUE;
            END IF;

             DBMS_LOB.APPEND (res, '<'||all_tables_prefix||':ConstraintDetails>');
             DBMS_LOB.APPEND (res, rec_cl_constraints.c_type);
             DBMS_LOB.APPEND (res, rec_cl_constraints.c_name);
             DBMS_LOB.APPEND (res, rec_cl_constraints.c_details);
             DBMS_LOB.APPEND (res,'</'||all_tables_prefix||':ConstraintDetails>');

            IF (cur_cl_constraints%ROWCOUNT = rec_cl_constraints.total_row_count) THEN
              DBMS_LOB.APPEND (res, '</'||all_tables_prefix||':ColumnLevelConstraintsCollection>');
            END IF;
         END LOOP;
         
         IF v_cc_created THEN
           DBMS_LOB.APPEND (res,'</'||all_tables_prefix||':ConstraintsCollection>');
         END IF;
       END IF;

       -- Foreign Keys Referring To
       IF (reportTemplate.reportType = 0 OR reportTemplate.useTableFKReferringTo = 1) THEN
         FOR rec_fk_referring_to IN cur_fk_referring_to(rec_all_tables.table_ovid) LOOP
            IF (cur_fk_referring_to%ROWCOUNT = 1) THEN
              DBMS_LOB.APPEND (res,'<'||all_tables_prefix||':FKRTCollection>');
            END IF;
         
             DBMS_LOB.APPEND (res, '<'||all_tables_prefix||':FKRTDetails>');
             DBMS_LOB.APPEND (res, rec_fk_referring_to.fk_name);
             DBMS_LOB.APPEND (res, rec_fk_referring_to.referring_to);
             DBMS_LOB.APPEND (res, rec_fk_referring_to.mandatory);
             DBMS_LOB.APPEND (res, rec_fk_referring_to.transferable);
             DBMS_LOB.APPEND (res, rec_fk_referring_to.in_arc);
             DBMS_LOB.APPEND (res, rec_fk_referring_to.col_name);
             DBMS_LOB.APPEND (res,'</'||all_tables_prefix||':FKRTDetails>');
            
            IF (cur_fk_referring_to%ROWCOUNT = rec_fk_referring_to.total_row_count) THEN
              DBMS_LOB.APPEND (res, '</'||all_tables_prefix||':FKRTCollection>');
            END IF;
         END LOOP;
      END IF;
         
       -- Foreign Keys Referred From
       IF (reportTemplate.reportType = 0 OR reportTemplate.useTableFKReferredFrom = 1) THEN         
         FOR rec_fk_referred_from IN cur_fk_referred_from(rec_all_tables.table_ovid) LOOP
            IF (cur_fk_referred_from%ROWCOUNT = 1) THEN
              DBMS_LOB.APPEND (res,'<'||all_tables_prefix||':FKRFCollection>');
            END IF;
           
             DBMS_LOB.APPEND (res, '<'||all_tables_prefix||':FKRFDetails>');
             DBMS_LOB.APPEND (res, rec_fk_referred_from.fk_name);
             DBMS_LOB.APPEND (res, rec_fk_referred_from.referred_from);
             DBMS_LOB.APPEND (res, rec_fk_referred_from.mandatory);
             DBMS_LOB.APPEND (res, rec_fk_referred_from.transferable);
             DBMS_LOB.APPEND (res, rec_fk_referred_from.in_arc);
             DBMS_LOB.APPEND (res, rec_fk_referred_from.col_name);
             DBMS_LOB.APPEND (res,'</'||all_tables_prefix||':FKRFDetails>');

            IF (cur_fk_referred_from%ROWCOUNT = rec_fk_referred_from.total_row_count) THEN
              DBMS_LOB.APPEND (res, '</'||all_tables_prefix||':FKRFCollection>');
            END IF;
         END LOOP;
       END IF;

      DBMS_LOB.APPEND (res,'</'||all_tables_prefix||':TableDetails>');

      IF (cur_all_tables%ROWCOUNT = rec_all_tables.total_row_count) THEN
          DBMS_LOB.APPEND (res,'</'||all_tables_prefix||':TablesCollection>');
      END IF;

   END LOOP;

  DBMS_LOB.APPEND (res,'</'||all_tables_prefix||':Tables>');
  
  UTL_FILE.PUT_LINE(log_file, TO_CHAR(SYSDATE,'yy.mm.dd hh:mi:ss') ||' '|| 'Gathering all tables data ended.');
	
RETURN res;
	
 EXCEPTION
  WHEN others THEN
   UTL_FILE.PUT_LINE(log_file, 'Gathering all tables Exception : : ' || SQLERRM);  
   UTL_FILE.PUT_LINE(log_file, 'Gathering all tables Exception : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  RETURN res;
  
END Gather_AllTables_Data;

FUNCTION Gather_SingleEntity_Data(v_entity_ovid IN VARCHAR2, reportTemplate IN REPORT_TEMPLATE, v_report_name IN VARCHAR2) RETURN CLOB IS 

res               CLOB;
v_notes           CLOB;
v_description     CLOB;
v_rel_total_count INTEGER;
token_value       CLOB;

CURSOR cur_general_data(v_e_ovid IN VARCHAR2) IS
 -- General data
 SELECT XMLElement(EVALNAME(single_entity_prefix || ':DesignName'),d.design_name).getClobVal()                                        design_name,
        XMLElement(EVALNAME(single_entity_prefix || ':VersionDate'),TO_CHAR(d.date_published,'dd.mm.yyyy hh24:mi:ss')).getClobVal()   version_date,
        XMLElement(EVALNAME(single_entity_prefix || ':VersionComment'),XMLCDATA(d.version_comments)).getClobVal()                     version_comment,
        XMLElement(EVALNAME(single_entity_prefix || ':ModelName'),m.model_name).getClobVal()                                          model_name
 FROM   dmrs_designs d, 
        dmrs_models m,
        dmrs_entities e
 WHERE  d.design_ovid = m.design_ovid
 AND    e.model_ovid = m.model_ovid
 AND    e.ovid = v_e_ovid;
rec_general_data cur_general_data%ROWTYPE;

CURSOR cur_entity(v_e_ovid IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(single_entity_prefix || ':EntityName'),e.entity_name).getClobVal()                                                                        entity_name,
        XMLElement(EVALNAME(single_entity_prefix || ':ClassificationTypeName'),e.classification_type_name).getClobVal()                                               classification_type_name,
        XMLElement(EVALNAME(single_entity_prefix || ':Abbreviation'),e.preferred_abbreviation).getClobVal()                                                           pref_abbreviation, 
        XMLElement(EVALNAME(single_entity_prefix || ':SuperType'),(SELECT e1.entity_name FROM  dmrs_entities e1 WHERE e.supertypeentity_ovid = e1.ovid)).getClobVal() super_type,
        XMLElement(EVALNAME(single_entity_prefix || ':Synonyms'), e.synonyms).getClobVal()                                                                            table_synonyms,
        XMLElement(EVALNAME(single_entity_prefix || ':ObjectTypeName'),e.structured_type_name).getClobVal()                                                           object_type_name,
        XMLElement(EVALNAME(single_entity_prefix || ':NumberOfAttributes'),e.number_data_elements).getClobVal()                                                       number_of_attributes, 
        XMLElement(EVALNAME(single_entity_prefix || ':NumberOfRowsMin'),e.min_volume).getClobVal()                                                                    number_rows_min, 
        XMLElement(EVALNAME(single_entity_prefix || ':NumberOfRowsMax'),e.max_volume).getClobVal()                                                                    number_rows_max, 
        XMLElement(EVALNAME(single_entity_prefix || ':ExpectedNumberOfRows'),e.expected_volume).getClobVal()                                                          expected_number_of_rows, 
        XMLElement(EVALNAME(single_entity_prefix || ':ExpectedGrowth'),e.growth_rate_percents).getClobVal()                                                           expected_growth,
        XMLElement(EVALNAME(single_entity_prefix || ':GrowthInterval'),e.growth_rate_interval).getClobVal()                                                           growth_interval
 FROM   dmrs_entities e
 WHERE  e.ovid = v_e_ovid;
rec_entity cur_entity%ROWTYPE;

CURSOR cur_mapped_tables(v_e_ovid IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(single_entity_prefix || ':TableName'),t.model_name||'.'||t.table_name).getClobVal() table_name,
        COUNT(t.table_name) over()                                total_row_count
 FROM   dmrs_entities e,
        dmrs_tables t,
        dmrs_mappings m
 WHERE  m.relational_object_ovid = t.ovid
 AND    m.logical_object_ovid = e.ovid
 AND    e.ovid = v_e_ovid;
rec_mapped_tables cur_mapped_tables%ROWTYPE;

-- Diagrams
CURSOR cur_diagrams(v_t_ovid IN VARCHAR2, v_rep_name IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(single_entity_prefix || ':Diagram'), 
          XMLElement(EVALNAME(single_entity_prefix || ':Name'), v_rep_name || '_files/' || REGEXP_REPLACE(SUBSTR(d.pdf_name, 1, INSTR(d.pdf_name, '.PDF')-1), '[^a-zA-Z1-9_]', '_') || '.pdf'),
          XMLElement(EVALNAME(single_entity_prefix || ':Suffix'), NULL)).getClobVal()                                                                                                            pdf_name,
        COUNT(d.pdf_name) over()                                                                                                                                                                 total_row_count
 FROM   dmrs_vdiagrams d,
       (SELECT diagram_ovid 
        FROM   dmrs_diagram_elements
        WHERE  ovid = v_t_ovid) b
 WHERE d.ovid = b.diagram_ovid
 AND   d.diagram_type = 'Subview'
 AND   d.is_display = 'N';
rec_diagrams cur_diagrams%ROWTYPE;

-- Attributes
CURSOR cur_attributes(v_e_ovid IN VARCHAR2) IS
 SELECT  XMLElement(EVALNAME(single_entity_prefix || ':Sequence'),a.sequence).getClobVal()                                                                                             seq, 
         XMLElement(EVALNAME(single_entity_prefix || ':AttributeName'),a.attribute_name).getClobVal()                                                                                  attr_name,
         XMLElement(EVALNAME(single_entity_prefix || ':DataTypeKind'),DECODE(a.datatype_kind,
                                                 'Domain',         'DOM',
                                                 'Logical Type',   'LT',
                                                 'Distinct Type',  'DT',
                                                 'Ref Struct Type','RST',
                                                 'Structured Type','ST',
                                                 'Collection Type','CT')                                                                                
                   ).getClobVal()                                                                                                                           dt_kind,
         XMLElement(EVALNAME(single_entity_prefix || ':DomainName'),DECODE(a.domain_name,'Unknown',null,a.domain_name)).getClobVal()                                                   domain_name,
         XMLElement(EVALNAME(single_entity_prefix || ':DataType'), 
            DECODE(a.datatype_kind, 
                  'Domain', a.logical_type_name ||' '||
                           DECODE (NVL(a.t_size,''),'',
                              DECODE(NVL(a.t_scale,0),0,
                                 DECODE(NVL(a.t_precision,0),0,null,'('|| DECODE(NVL(a.t_precision,0),0,null,a.t_precision) ||')'),
                                   '('|| DECODE(NVL(a.t_precision,0),0,null,a.t_precision) || ',' || DECODE(NVL(a.t_scale,0),0,null,a.t_scale)||')'),
                                   '('||TRIM(DECODE(a.t_size,'',null,a.t_size||' '||a.char_units ))||')'),
                   'Logical Type', a.logical_type_name  ||' '|| 
                           DECODE (NVL(a.t_size,''),'',
                              DECODE(NVL(a.t_scale,0),0,
                                 DECODE(NVL(a.t_precision,0),0,null,'('|| DECODE(NVL(a.t_precision,0),0,null,a.t_precision) ||')'),
                                   '('|| DECODE(NVL(a.t_precision,0),0,null,a.t_precision) || ',' || DECODE(NVL(a.t_scale,0),0,null,a.t_scale)||')'),
                                   '('||TRIM(DECODE(a.t_size,'',null,a.t_size||' '||a.char_units ))||')')
            )
          ).getClobVal()                                                                                                                                   data_type,
         XMLElement(EVALNAME(single_entity_prefix || ':PK'),a.pk_flag).getClobVal()                                                                                                    pk,
         XMLElement(EVALNAME(single_entity_prefix || ':FK'),a.fk_flag).getClobVal()                                                                                                    fk,
         XMLElement(EVALNAME(single_entity_prefix || ':M'),DECODE(a.mandatory,'N',' ',a.mandatory)).getClobVal()                                                                       m,
         XMLElement(EVALNAME(single_entity_prefix || ':Formula'),TRIM(a.formula||' '||a.default_value)).getClobVal()                                                                   formula,
         XMLElement(EVALNAME(single_entity_prefix || ':AttributeSynonyms'),a.synonyms).getClobVal()                                                                                    synonyms,
         XMLElement(EVALNAME(single_entity_prefix || ':PreferredAbbreviation'),a.preferred_abbreviation).getClobVal()                                                                  pref_abbr,
         COUNT(a.sequence) over()                                                                                                                           total_row_count
  FROM   dmrs_attributes a
  WHERE  a.container_ovid = v_e_ovid
  ORDER BY a.sequence;
rec_attributes cur_attributes%ROWTYPE;

-- Attributes Comments Data
CURSOR cur_attributes_comments(v_e_ovid IN VARCHAR2) IS
 SELECT a.seq                          seq, 
        a.attribute_name               attribute_name, 
        a.attribute_description        attribute_description, 
        a.attribute_notes              attribute_notes,
        COUNT(a.attribute_name) over() total_row_count
 FROM (
  SELECT XMLElement(EVALNAME(single_entity_prefix || ':AttributeCommentsSequence'),a.sequence).getStringVal()     seq,
         XMLElement(EVALNAME(single_entity_prefix || ':AttributeCommentsName'),a.attribute_name).getStringVal()   attribute_name,
         XMLElement(EVALNAME(single_entity_prefix || ':AttributeDescription'),XMLCDATA(
         NVL(
        (SELECT t.text comments_in_rdbms
         FROM   dmrs_large_text t
         WHERE  t.ovid = a.ovid
         AND    t.type='Comments'),
        (SELECT t.text comments_in_rdbms
         FROM   dmrs_large_text t
         WHERE  t.ovid = a.ovid
         AND    t.type='CommentsInRDBMS')))).getClobVal()                                                         attribute_description, 
        XMLElement(EVALNAME(single_entity_prefix || ':AttributeNotes'),XMLCDATA(
        (SELECT t.text comments_in_rdbms
         FROM   dmrs_large_text t
         WHERE  t.ovid = a.ovid
         AND    t.type='Note'))).getClobVal()                                                                     attribute_notes
  FROM   dmrs_entities e, 
         dmrs_attributes a
  WHERE  e.ovid = a.container_ovid
  and    e.ovid = v_e_ovid
  ORDER BY a.sequence
 ) a
 WHERE DBMS_LOB.getlength(attribute_description) > 0 OR DBMS_LOB.getlength(attribute_notes) > 0;
rec_attributes_comments cur_attributes_comments%ROWTYPE;

CURSOR cur_identifiers(v_e_ovid IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(single_entity_prefix || ':IdentifierName'),CASE WHEN ke.sequence>1 THEN ' ' ELSE ke.key_name END).getClobVal()                          nn,
        XMLElement(EVALNAME(single_entity_prefix || ':PrimaryIdentifier'),CASE WHEN ke.sequence>1 THEN ' ' ELSE DECODE(k.state,'Primary Key','Y') END).getClobVal() pi, 
        XMLElement(EVALNAME(single_entity_prefix || ':ElementName'),ke.element_name).getClobVal()                                                                   element_name,
        XMLElement(EVALNAME(single_entity_prefix || ':ElementType'),ke.type).getClobVal()                                                                           type,
        XMLElement(EVALNAME(single_entity_prefix || ':SourceLabel'),ke.source_label).getClobVal()                                                                   source_label,
        XMLElement(EVALNAME(single_entity_prefix || ':TargetLabel'),ke.target_label).getClobVal()                                                                   target_label,
        COUNT(ke.sequence) over()                                                                                                        total_row_count
 FROM   dmrs_keys          k,
        dmrs_key_elements ke
 WHERE  k.container_ovid = v_e_ovid
 AND   ke.key_ovid = k.ovid
 ORDER BY ke.sequence;
rec_identifiers cur_identifiers%ROWTYPE;

CURSOR cur_relationships(v_e_ovid IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(single_entity_prefix || ':SourceName'),r.target_entity_name).getClobVal()                                                                  source_name, 
        XMLElement(EVALNAME(single_entity_prefix || ':SourceRole'),r.source_label).getClobVal()                                                                        source_role,
        XMLElement(EVALNAME(single_entity_prefix || ':TargetRole'),r.target_label).getClobVal()                                                                        target_role,
        XMLElement(EVALNAME(single_entity_prefix || ':InArc'),DECODE(r.in_arc,'N','',r.in_arc)).getClobVal()                                                           in_arc,
        XMLElement(EVALNAME(single_entity_prefix || ':Cardinality'),
           DECODE(r.source_optional,'Y',0,'1') || '..' || r.sourceto_target_cardinality
           ||':'||
           DECODE(r.target_optional,'Y',0,'1') || '..' || r.targetto_source_cardinality
           ).getClobVal()                                                                                                                  cardinality,
        XMLElement(EVALNAME(single_entity_prefix || ':DominantRole'),DECODE(r.dominant_role,'None','')).getClobVal()                                                   dominant_role,
        XMLElement(EVALNAME(single_entity_prefix || ':Identifying'),DECODE(r.identifying,'N','',r.identifying)).getClobVal()                                           identifying,
        XMLElement(EVALNAME(single_entity_prefix || ':Transferable'),DECODE(r.transferable,'N','',r.transferable)).getClobVal()                                        transferable
 FROM   dmrs_relationships r
 WHERE  r.source_ovid  = v_e_ovid
 UNION ALL
 SELECT XMLElement(EVALNAME(single_entity_prefix || ':SourceName'),r.source_entity_name).getClobVal()                                                                  source_name, 
        XMLElement(EVALNAME(single_entity_prefix || ':SourceRole'),r.source_label).getClobVal()                                                                        source_role,
        XMLElement(EVALNAME(single_entity_prefix || ':TargetRole'),r.target_label).getClobVal()                                                                        target_role,
        XMLElement(EVALNAME(single_entity_prefix || ':InArc'),DECODE(r.in_arc,'N','',r.in_arc)).getClobVal()                                                           in_arc,
        XMLElement(EVALNAME(single_entity_prefix || ':Cardinality'),
           DECODE(r.source_optional,'Y',0,'1') || '..' || r.sourceto_target_cardinality
           ||':'||
           DECODE(r.target_optional,'Y',0,'1') || '..' || r.targetto_source_cardinality
           ).getClobVal()                                                                                                                  cardinality,
        XMLElement(EVALNAME(single_entity_prefix || ':DominantRole'),DECODE(r.dominant_role,'None','')).getClobVal()                                                   dominant_role,
        XMLElement(EVALNAME(single_entity_prefix || ':Identifying'),DECODE(r.identifying,'N','',r.identifying)).getClobVal()                                           identifying,
        XMLElement(EVALNAME(single_entity_prefix || ':Transferable'),DECODE(r.transferable,'N','',r.transferable)).getClobVal()                                        transferable
 FROM   dmrs_relationships r
 WHERE  r.target_ovid  = v_e_ovid;
rec_relationships cur_relationships%ROWTYPE;

CURSOR cur_incoming_processes(v_e_ovid IN VARCHAR2) IS
 SELECT  XMLElement(EVALNAME(single_entity_prefix || ':IncomingProcessName'), NVL(pe.process_name,' ')).getClobVal()  ipr_name,
         XMLElement(EVALNAME(single_entity_prefix || ':IncomingFlowName'), NVL(pe.flow_name,' ')).getClobVal()       ipr_flow_name,
         XMLElement(EVALNAME(single_entity_prefix || ':IncomingCRUDCode'), NVL(pe.crud_code,' ')).getClobVal()       ipr_crud_code,
         XMLElement(EVALNAME(single_entity_prefix || ':IncomingDFDName'), NVL(pe.dfd_name,' ')).getClobVal()         ipr_dfd_name,
         COUNT(pe.process_name) over()                                                    total_row_count
  FROM   dmrs_process_entities pe
  WHERE  pe.entity_ovid = v_e_ovid
  AND    pe.flow_direction = 'IN'
  ORDER BY pe.process_name;
rec_incoming_processes cur_incoming_processes%ROWTYPE;

CURSOR cur_outgoing_processes(v_e_ovid IN VARCHAR2) IS
  SELECT XMLElement(EVALNAME(single_entity_prefix || ':OutgoingProcessName'), pe.process_name).getClobVal() opr_name,
         XMLElement(EVALNAME(single_entity_prefix || ':OutgoingFlowName'), pe.flow_name).getClobVal()       opr_flow_name,
         XMLElement(EVALNAME(single_entity_prefix || ':OutgoingCRUDCode'), pe.crud_code).getClobVal()       opr_crud_code,
         XMLElement(EVALNAME(single_entity_prefix || ':OutgoingDFDName'), pe.dfd_name).getClobVal()         opr_dfd_name,
         COUNT(pe.process_name) over()                                           total_row_count
  FROM   dmrs_process_entities pe
  WHERE  pe.entity_ovid = v_e_ovid
  AND    pe.flow_direction = 'OUT'
  ORDER BY pe.process_name;
rec_outgoing_processes cur_outgoing_processes%ROWTYPE;

-- Constraints
CURSOR cur_constraints(v_e_ovid IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(single_entity_prefix || ':ContstraintType'), CASE WHEN rownum>1 THEN ''
                                              ELSE 'Attribute Level'
                                              END).getClobVal()                                        c_type,
        XMLElement(EVALNAME(single_entity_prefix || ':ALCConstraintName'), a.attribute_name || 
                                                DECODE((SELECT DISTINCT(constraint_name)
                                                        FROM dmrs_check_constraints 
                                                        WHERE a.ovid = dataelement_ovid),NULL,'',
                                               ' / '|| (SELECT  DISTINCT(constraint_name) 
                                                        FROM dmrs_check_constraints 
                                                        WHERE a.ovid = dataelement_ovid))).getClobVal() c_name,
        Gather_Constraint_Details_XML(a.ovid, single_entity_prefix)                                     c_details,
        COUNT(a.attribute_name) over()                                                                  total_row_count
 FROM   dmrs_attributes a
 WHERE a.container_ovid = v_e_ovid
 AND  (a.ovid IN (SELECT dataelement_ovid FROM dmrs_avt) OR 
       a.ovid IN (SELECT dataelement_ovid FROM dmrs_value_ranges) OR 
       a.ovid IN (SELECT dataelement_ovid FROM dmrs_check_constraints));
rec_constraints cur_constraints%ROWTYPE;

BEGIN

  UTL_FILE.PUT_LINE(log_file, TO_CHAR(SYSDATE,'yy.mm.dd hh:mi:ss') ||' '|| 'Gathering single entity data started ...');

  DBMS_LOB.CREATETEMPORARY(res, TRUE);

  DBMS_LOB.APPEND (res,'<' || single_entity_prefix || ':Entity xmlns:' || single_entity_prefix || '="http://oracle.com/datamodeler/reports/entity">');

   FOR rec_general_data IN cur_general_data(v_entity_ovid) LOOP
   
      DBMS_LOB.APPEND (res, rec_general_data.design_name);
      DBMS_LOB.APPEND (res, rec_general_data.version_date);
      DBMS_LOB.APPEND (res, rec_general_data.version_comment);
      DBMS_LOB.APPEND (res, rec_general_data.model_name);

   END LOOP;

   -- Mapped tables
   FOR rec_mapped_tables IN cur_mapped_tables(v_entity_ovid) LOOP
      IF (cur_mapped_tables%ROWCOUNT = 1) THEN
        DBMS_LOB.APPEND (res,'<' || single_entity_prefix || ':MappedTablesCollection>');
      END IF;

        DBMS_LOB.APPEND (res, '<' || single_entity_prefix || ':MappedTablesDetails>');
        DBMS_LOB.APPEND (res, rec_mapped_tables.table_name);
        DBMS_LOB.APPEND (res, '</' || single_entity_prefix || ':MappedTablesDetails>');

      IF (cur_mapped_tables%ROWCOUNT = rec_mapped_tables.total_row_count) THEN
        DBMS_LOB.APPEND (res, '</' || single_entity_prefix || ':MappedTablesCollection>');
      END IF;
   END LOOP;

   -- Description / Notes
   IF (reportTemplate.reportType = 0 OR reportTemplate.useDescriptionInfo = 1) THEN
   
    DBMS_LOB.APPEND (res, '<' || single_entity_prefix || ':DescriptionNotes>');
     
    SELECT  XMLElement(EVALNAME(single_entity_prefix || ':Description'), XMLCDATA(
              NVL((SELECT t.text comments_in_rdbms
                    FROM   dmrs_large_text t
                    WHERE  t.ovid = v_entity_ovid
                    AND    t.type='Comments'),
                   (SELECT t.text comments_in_rdbms
                    FROM   dmrs_large_text t
                    WHERE  t.ovid = v_entity_ovid
                    AND    t.type='CommentsInRDBMS')))).getClobVal(), 
            XMLElement(EVALNAME(single_entity_prefix || ':Notes'), XMLCDATA(
                    (SELECT t.text comments_in_rdbms
                    FROM   dmrs_large_text t
                    WHERE  t.ovid = v_entity_ovid
                    AND    t.type='Note'))).getClobVal()
    INTO    v_description, 
            v_notes
    FROM  dual;

    DBMS_LOB.APPEND (res, v_description);
    DBMS_LOB.APPEND (res, v_notes);

    DBMS_LOB.APPEND (res, '</' || single_entity_prefix || ':DescriptionNotes>');
     
   END IF;

   FOR rec_entity IN cur_entity(v_entity_ovid) LOOP
      DBMS_LOB.APPEND (res, rec_entity.entity_name);
      DBMS_LOB.APPEND (res, rec_entity.pref_abbreviation);      
      DBMS_LOB.APPEND (res, rec_entity.classification_type_name);
      DBMS_LOB.APPEND (res, rec_entity.object_type_name);
      DBMS_LOB.APPEND (res, rec_entity.super_type);
      DBMS_LOB.APPEND (res, rec_entity.table_synonyms);
      IF (reportTemplate.reportType = 0 OR reportTemplate.useQuantitativeInfo = 1) THEN
        DBMS_LOB.APPEND (res, '<' || single_entity_prefix || ':QuantitativeInfoCollection>');
        DBMS_LOB.APPEND (res, rec_entity.number_of_attributes);
        DBMS_LOB.APPEND (res, rec_entity.number_rows_min);
        DBMS_LOB.APPEND (res, rec_entity.number_rows_max);
        DBMS_LOB.APPEND (res, rec_entity.expected_number_of_rows);
        DBMS_LOB.APPEND (res, rec_entity.expected_growth);
        DBMS_LOB.APPEND (res, rec_entity.growth_interval);
        DBMS_LOB.APPEND (res, '</' || single_entity_prefix || ':QuantitativeInfoCollection>');
      END IF;
   END LOOP;

   -- Diagrams
   IF (reportTemplate.reportType = 0 OR reportTemplate.useDiagrams = 1) THEN
     FOR rec_diagrams IN cur_diagrams(v_entity_ovid, v_report_name) LOOP
        IF (cur_diagrams%ROWCOUNT = 1) THEN
          DBMS_LOB.APPEND (res,'<' || single_entity_prefix || ':DiagramsCollection>');
        END IF;
          
          DBMS_LOB.APPEND (res, rec_diagrams.pdf_name);

        IF (cur_diagrams%ROWCOUNT = rec_diagrams.total_row_count) THEN
         DBMS_LOB.APPEND (res, '</' || single_entity_prefix || ':DiagramsCollection>');
        END IF;
     END LOOP;
   END IF;

   -- Attributes
   IF (reportTemplate.reportType = 0 OR reportTemplate.useEntityAttributes = 1) THEN
     FOR rec_attributes IN cur_attributes(v_entity_ovid) LOOP
        IF (cur_attributes%ROWCOUNT = 1) THEN
          DBMS_LOB.APPEND (res,'<' || single_entity_prefix || ':AttributesCollection>');
        END IF;

          DBMS_LOB.APPEND (res, '<' || single_entity_prefix || ':AttributeDetails>');
          DBMS_LOB.APPEND (res, rec_attributes.seq);
          DBMS_LOB.APPEND (res, rec_attributes.attr_name);
          DBMS_LOB.APPEND (res, rec_attributes.pk);
          DBMS_LOB.APPEND (res, rec_attributes.fk);
          DBMS_LOB.APPEND (res, rec_attributes.m);
          IF (INSTR(LOWER(rec_attributes.data_type),'unknown') = 0) THEN
             DBMS_LOB.APPEND (res, rec_attributes.data_type);
          ELSE
             SELECT XMLElement(EVALNAME(single_entity_prefix || ':DataType'), '').getClobVal() INTO token_value FROM dual;
             DBMS_LOB.APPEND (res, token_value);
          END IF;
          DBMS_LOB.APPEND (res, rec_attributes.dt_kind);
          DBMS_LOB.APPEND (res, rec_attributes.domain_name);
          DBMS_LOB.APPEND (res, rec_attributes.formula);
          DBMS_LOB.APPEND (res, rec_attributes.pref_abbr);
          DBMS_LOB.APPEND (res, rec_attributes.synonyms);
          DBMS_LOB.APPEND (res,'</' || single_entity_prefix || ':AttributeDetails>');

        IF (cur_attributes%ROWCOUNT = rec_attributes.total_row_count) THEN
          DBMS_LOB.APPEND (res, '</' || single_entity_prefix || ':AttributesCollection>');
        END IF;
     END LOOP;
   END IF;

   -- Attribute Comments
   IF (reportTemplate.reportType = 0 OR reportTemplate.useEntityAttributesComments = 1) THEN
     FOR rec_attributes_comments IN cur_attributes_comments(v_entity_ovid) LOOP
        IF (cur_attributes_comments%ROWCOUNT = 1) THEN
          DBMS_LOB.APPEND (res,'<' || single_entity_prefix || ':AttributesCommentsCollection>');
        END IF;

          DBMS_LOB.APPEND (res, '<' || single_entity_prefix || ':AttributeCommentsDetails>');
          DBMS_LOB.APPEND (res, rec_attributes_comments.seq);
          DBMS_LOB.APPEND (res, rec_attributes_comments.attribute_name);
          DBMS_LOB.APPEND (res, rec_attributes_comments.attribute_description);
          DBMS_LOB.APPEND (res, rec_attributes_comments.attribute_notes);
          DBMS_LOB.APPEND (res,'</' || single_entity_prefix || ':AttributeCommentsDetails>');

        IF (cur_attributes_comments%ROWCOUNT = rec_attributes_comments.total_row_count) THEN
          DBMS_LOB.APPEND (res, '</' || single_entity_prefix || ':AttributesCommentsCollection>');
        END IF;
     END LOOP;
   END IF;

   -- Constraints
   IF (reportTemplate.reportType = 0 OR reportTemplate.useEntityConstraints = 1) THEN
     FOR rec_constraints IN cur_constraints(v_entity_ovid) LOOP
        IF (cur_constraints%ROWCOUNT = 1) THEN
           DBMS_LOB.APPEND (res,'<' || single_entity_prefix || ':ConstraintsCollection>');
        END IF;

          DBMS_LOB.APPEND (res,'<' || single_entity_prefix || ':ConstraintDetails>');
          DBMS_LOB.APPEND (res,rec_constraints.c_type);
          DBMS_LOB.APPEND (res,rec_constraints.c_name);
          DBMS_LOB.APPEND (res,rec_constraints.c_details);
          DBMS_LOB.APPEND (res,'</' || single_entity_prefix || ':ConstraintDetails>');

        IF (cur_constraints%ROWCOUNT = rec_constraints.total_row_count) THEN
            DBMS_LOB.APPEND (res,'</' || single_entity_prefix || ':ConstraintsCollection>');
        END IF;
     END LOOP;
   END IF;

   -- Identifiers
   IF (reportTemplate.reportType = 0 OR reportTemplate.useEntityIdentifiers = 1) THEN
     FOR rec_identifiers IN cur_identifiers(v_entity_ovid) LOOP
        IF (cur_identifiers%ROWCOUNT = 1) THEN
          DBMS_LOB.APPEND (res, '<' || single_entity_prefix || ':IdentifiersCollection>');
        END IF;

          DBMS_LOB.APPEND (res, '<' || single_entity_prefix || ':IdentifierDetails>');
          DBMS_LOB.APPEND (res, rec_identifiers.nn);
          DBMS_LOB.APPEND (res, rec_identifiers.pi);
          DBMS_LOB.APPEND (res, rec_identifiers.element_name);
          DBMS_LOB.APPEND (res, rec_identifiers.type);
          DBMS_LOB.APPEND (res, rec_identifiers.source_label);
          DBMS_LOB.APPEND (res, rec_identifiers.target_label);
          DBMS_LOB.APPEND (res, '</' || single_entity_prefix || ':IdentifierDetails>');

        IF (cur_identifiers%ROWCOUNT = rec_identifiers.total_row_count) THEN
           DBMS_LOB.APPEND (res, '</' || single_entity_prefix || ':IdentifiersCollection>');
        END IF;
     END LOOP;
   END IF;

   -- Relationships
   IF (reportTemplate.reportType = 0 OR reportTemplate.useEntityRelationships = 1) THEN
     -- Total count of relationships
     SELECT COUNT(1)
     INTO   v_rel_total_count
     FROM (
      SELECT r.ovid
      FROM   dmrs_relationships r,
             dmrs_entities      e
      WHERE  r.source_ovid  = e.ovid
      AND    e.ovid         = v_entity_ovid
      UNION ALL
      SELECT r.ovid
      FROM   dmrs_relationships r,
             dmrs_entities      e
      WHERE  r.target_ovid  = e.ovid
      AND    e.ovid         = v_entity_ovid);

     FOR rec_relationships IN cur_relationships(v_entity_ovid) LOOP
        IF (cur_relationships%ROWCOUNT = 1) THEN
           DBMS_LOB.APPEND (res, '<' || single_entity_prefix || ':RelationshipsCollection>');
        END IF;
     
           DBMS_LOB.APPEND (res, '<' || single_entity_prefix || ':RelationshipDetails>');
           DBMS_LOB.APPEND (res, rec_relationships.source_name);
           DBMS_LOB.APPEND (res, rec_relationships.source_role);
           DBMS_LOB.APPEND (res, rec_relationships.target_role);
           DBMS_LOB.APPEND (res, rec_relationships.in_arc);
           DBMS_LOB.APPEND (res, rec_relationships.cardinality);
           DBMS_LOB.APPEND (res, rec_relationships.dominant_role);
           DBMS_LOB.APPEND (res, rec_relationships.identifying);
           DBMS_LOB.APPEND (res, rec_relationships.transferable);
           DBMS_LOB.APPEND (res, '</' || single_entity_prefix || ':RelationshipDetails>');

        IF (cur_relationships%ROWCOUNT = v_rel_total_count) THEN
           DBMS_LOB.APPEND (res, '</' || single_entity_prefix || ':RelationshipsCollection>');
        END IF;
     
     END LOOP;
   END IF;

   -- Incoming Processes
   IF (reportTemplate.reportType = 0 OR reportTemplate.useEntityIncomingProcesses = 1) THEN
     FOR rec_incoming_processes IN cur_incoming_processes(v_entity_ovid) LOOP
        IF (cur_incoming_processes%ROWCOUNT = 1) THEN
          DBMS_LOB.APPEND (res, '<' || single_entity_prefix || ':IncomingProcessesCollection>');
        END IF;
          DBMS_LOB.APPEND (res, '<' || single_entity_prefix || ':IncomingProcessDetails>');
          DBMS_LOB.APPEND (res, rec_incoming_processes.ipr_name);
          DBMS_LOB.APPEND (res, rec_incoming_processes.ipr_flow_name);
          DBMS_LOB.APPEND (res, rec_incoming_processes.ipr_crud_code);
          DBMS_LOB.APPEND (res, rec_incoming_processes.ipr_dfd_name);
          DBMS_LOB.APPEND (res, '</' || single_entity_prefix || ':IncomingProcessDetails>');
        IF (cur_incoming_processes%ROWCOUNT = rec_incoming_processes.total_row_count) THEN
          DBMS_LOB.APPEND (res, '</' || single_entity_prefix || ':IncomingProcessesCollection>');
        END IF;
     END LOOP;
   END IF;

   -- Outgoing Processes
   IF (reportTemplate.reportType = 0 OR reportTemplate.useEntityOutgoingProcesses = 1) THEN
     FOR rec_outgoing_processes IN cur_outgoing_processes(v_entity_ovid) LOOP
        IF (cur_outgoing_processes%ROWCOUNT = 1) THEN
          DBMS_LOB.APPEND (res, '<' || single_entity_prefix || ':OutgoingProcessesCollection>');
        END IF;
          DBMS_LOB.APPEND (res, '<' || single_entity_prefix || ':OugoingProcessDetails>');
          DBMS_LOB.APPEND (res, rec_outgoing_processes.opr_name);
          DBMS_LOB.APPEND (res, rec_outgoing_processes.opr_flow_name);
          DBMS_LOB.APPEND (res, rec_outgoing_processes.opr_crud_code);
          DBMS_LOB.APPEND (res, rec_outgoing_processes.opr_dfd_name);
          DBMS_LOB.APPEND (res, '</' || single_entity_prefix || ':OugoingProcessDetails>');
        IF (cur_outgoing_processes%ROWCOUNT = rec_outgoing_processes.total_row_count) THEN
          DBMS_LOB.APPEND (res, '</' || single_entity_prefix || ':OutgoingProcessesCollection>');
        END IF;
     END LOOP;
  END IF;

  DBMS_LOB.APPEND (res,'</' || single_entity_prefix || ':Entity>');

  UTL_FILE.PUT_LINE(log_file, TO_CHAR(SYSDATE,'yy.mm.dd hh:mi:ss') ||' '|| 'Gathering single entity data ended');
  
RETURN res;

 EXCEPTION
 WHEN others THEN
  UTL_FILE.PUT_LINE(log_file, 'Pkg_Osdm_Utils.Gather_SingleEntity_Data Exception : ' || SQLERRM);  
  UTL_FILE.PUT_LINE(log_file, 'Pkg_Osdm_Utils.Gather_SingleEntity_Data Exception : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  RETURN res;
 
END Gather_SingleEntity_Data;

FUNCTION Gather_AllEntities_Data(v_model_ovid IN VARCHAR2, reportTemplate IN REPORT_TEMPLATE, objects IN OBJECTS_LIST, v_report_name IN VARCHAR2) RETURN CLOB IS 

res               CLOB;
v_notes           CLOB;
v_description     CLOB;
v_rel_total_count INTEGER;
token_value       CLOB;

CURSOR cur_general_data(v_m_ovid IN VARCHAR2) IS
 -- General data
 SELECT XMLElement(EVALNAME(all_entities_prefix || ':DesignName'),d.design_name).getClobVal()                                        design_name,
        XMLElement(EVALNAME(all_entities_prefix || ':VersionDate'),TO_CHAR(d.date_published,'dd.mm.yyyy hh24:mi:ss')).getClobVal()   version_date,
        XMLElement(EVALNAME(all_entities_prefix || ':VersionComment'),XMLCDATA(d.version_comments)).getClobVal()                     version_comment,
        XMLElement(EVALNAME(all_entities_prefix || ':ModelName'),m.model_name).getClobVal()                                          model_name
 FROM   dmrs_designs d, 
        dmrs_models m
 WHERE  d.design_ovid = m.design_ovid
 AND    m.model_ovid = v_model_ovid;
rec_general_data cur_general_data%ROWTYPE;

CURSOR cur_all_entities(v_m_ovid IN VARCHAR2) IS
 SELECT /*+ index(e ENTITIES_FK_IDXV1) */
        XMLElement(EVALNAME(all_entities_prefix || ':EntityName'),e.entity_name).getClobVal()                                                                        entity_name,
        XMLElement(EVALNAME(all_entities_prefix || ':EncodedEntityName'),e.ovid).getClobVal()																		 xml_ovid,
        XMLElement(EVALNAME(all_entities_prefix || ':ClassificationTypeName'),e.classification_type_name).getClobVal()                                               classification_type_name,
        XMLElement(EVALNAME(all_entities_prefix || ':Abbreviation'),e.preferred_abbreviation).getClobVal()                                                           pref_abbreviation, 
        XMLElement(EVALNAME(all_entities_prefix || ':SuperType'),(SELECT e1.entity_name FROM  dmrs_entities e1 WHERE e.supertypeentity_ovid = e1.ovid)).getClobVal() super_type,
        XMLElement(EVALNAME(all_entities_prefix || ':Synonyms'), e.synonyms).getClobVal()                                                                            table_synonyms,
        XMLElement(EVALNAME(all_entities_prefix || ':ObjectTypeName'),e.structured_type_name).getClobVal()                                                           object_type_name,
        XMLElement(EVALNAME(all_entities_prefix || ':NumberOfAttributes'),e.number_data_elements).getClobVal()                                                       number_of_attributes, 
        XMLElement(EVALNAME(all_entities_prefix || ':NumberOfRowsMin'),e.min_volume).getClobVal()                                                                    number_rows_min, 
        XMLElement(EVALNAME(all_entities_prefix || ':NumberOfRowsMax'),e.max_volume).getClobVal()                                                                    number_rows_max, 
        XMLElement(EVALNAME(all_entities_prefix || ':ExpectedNumberOfRows'),e.expected_volume).getClobVal()                                                          expected_number_of_rows, 
        XMLElement(EVALNAME(all_entities_prefix || ':ExpectedGrowth'),e.growth_rate_percents).getClobVal()                                                           expected_growth,
        XMLElement(EVALNAME(all_entities_prefix || ':GrowthInterval'),e.growth_rate_interval).getClobVal()                                                           growth_interval,
        e.ovid                                                                                                                             entity_ovid,
        COUNT(e.entity_name) over() total_row_count
 FROM   dmrs_entities    e
 WHERE  e.model_ovid = v_m_ovid
 AND    e.ovid MEMBER OF objects
 ORDER BY e.entity_name;
rec_all_entities cur_all_entities%ROWTYPE;

CURSOR cur_mapped_tables(v_e_ovid IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(all_entities_prefix || ':TableName'),t.model_name||'.'||t.table_name).getClobVal() table_name,
        COUNT(t.table_name) over()                                total_row_count
 FROM   dmrs_entities e,
        dmrs_tables t,
        dmrs_mappings m
 WHERE  m.relational_object_ovid = t.ovid
 AND    m.logical_object_ovid = e.ovid
 AND    e.ovid = v_e_ovid;
rec_mapped_tables cur_mapped_tables%ROWTYPE;

-- Diagrams
CURSOR cur_diagrams(v_t_ovid IN VARCHAR2, v_rep_name IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(all_entities_prefix || ':Diagram'), 
          XMLElement(EVALNAME(all_entities_prefix || ':Name'), v_rep_name || '_files/' || REGEXP_REPLACE(SUBSTR(d.pdf_name, 1, INSTR(d.pdf_name, '.PDF')-1), '[^a-zA-Z1-9_]', '_') || '.pdf'),
          XMLElement(EVALNAME(all_entities_prefix || ':Suffix'), NULL)).getClobVal()                                                                                                            pdf_name,
        COUNT(d.pdf_name) over()                                                                                                                                                                total_row_count
 FROM   dmrs_vdiagrams d,
       (SELECT diagram_ovid 
        FROM   dmrs_diagram_elements
        WHERE  ovid = v_t_ovid) b
 WHERE d.ovid = b.diagram_ovid
 AND   d.diagram_type = 'Subview'
 AND   d.is_display = 'N';
rec_diagrams cur_diagrams%ROWTYPE;

-- Attributes
CURSOR cur_attributes(v_e_ovid IN VARCHAR2) IS
 SELECT  XMLElement(EVALNAME(all_entities_prefix || ':Sequence'),a.sequence).getClobVal()                                                                                              seq, 
         XMLElement(EVALNAME(all_entities_prefix || ':AttributeName'),a.attribute_name).getClobVal()                                                                                  attr_name,
         XMLElement(EVALNAME(all_entities_prefix || ':DataTypeKind'),DECODE(a.datatype_kind,
                                                 'Domain',         'DOM',
                                                 'Logical Type',   'LT',
                                                 'Distinct Type',  'DT',
                                                 'Ref Struct Type','RST',
                                                 'Structured Type','ST',
                                                 'Collection Type','CT')                                                                                
                   ).getClobVal()                                                                                                                           dt_kind,
         XMLElement(EVALNAME(all_entities_prefix || ':DomainName'),DECODE(a.domain_name,'Unknown',null,a.domain_name)).getClobVal()                                                   domain_name,
         XMLElement(EVALNAME(all_entities_prefix || ':DataType'), 
            DECODE(a.datatype_kind, 
                  'Domain', a.logical_type_name ||' '||
                           DECODE (NVL(a.t_size,''),'',
                              DECODE(NVL(a.t_scale,0),0,
                                 DECODE(NVL(a.t_precision,0),0,null,'('|| DECODE(NVL(a.t_precision,0),0,null,a.t_precision) ||')'),
                                   '('|| DECODE(NVL(a.t_precision,0),0,null,a.t_precision) || ',' || DECODE(NVL(a.t_scale,0),0,null,a.t_scale)||')'),
                                   '('||TRIM(DECODE(a.t_size,'',null,a.t_size||' '||a.char_units ))||')'),
                   'Logical Type', a.logical_type_name  ||' '|| 
                           DECODE (NVL(a.t_size,''),'',
                              DECODE(NVL(a.t_scale,0),0,
                                 DECODE(NVL(a.t_precision,0),0,null,'('|| DECODE(NVL(a.t_precision,0),0,null,a.t_precision) ||')'),
                                   '('|| DECODE(NVL(a.t_precision,0),0,null,a.t_precision) || ',' || DECODE(NVL(a.t_scale,0),0,null,a.t_scale)||')'),
                                   '('||TRIM(DECODE(a.t_size,'',null,a.t_size||' '||a.char_units ))||')')
            )
          ).getClobVal()                                                                                                                                    data_type,
         XMLElement(EVALNAME(all_entities_prefix || ':PK'),a.pk_flag).getClobVal()                                                                                                    pk,
         XMLElement(EVALNAME(all_entities_prefix || ':FK'),a.fk_flag).getClobVal()                                                                                                    fk,
         XMLElement(EVALNAME(all_entities_prefix || ':M'),DECODE(a.mandatory,'N',' ',a.mandatory)).getClobVal()                                                                       m,
         XMLElement(EVALNAME(all_entities_prefix || ':Formula'),TRIM(a.formula||' '||a.default_value)).getClobVal()                                                                   formula,
         XMLElement(EVALNAME(all_entities_prefix || ':AttributeSynonyms'),a.synonyms).getClobVal()                                                                                    synonyms,
         XMLElement(EVALNAME(all_entities_prefix || ':PreferredAbbreviation'),a.preferred_abbreviation).getClobVal()                                                                  pref_abbr,
         COUNT(a.sequence) over()                                                                                                                           total_row_count
  FROM   dmrs_attributes a
  WHERE  a.container_ovid = v_e_ovid
  ORDER BY a.sequence;
rec_attributes cur_attributes%ROWTYPE;

-- Attributes Comments Data
CURSOR cur_attributes_comments(v_e_ovid IN VARCHAR2) IS
 SELECT a.seq                          seq, 
        a.attribute_name               attribute_name, 
        a.attribute_description        attribute_description, 
        a.attribute_notes              attribute_notes,
        COUNT(a.attribute_name) over() total_row_count
 FROM (
  SELECT XMLElement(EVALNAME(all_entities_prefix || ':AttributeCommentsSequence'),a.sequence).getStringVal()     seq,
         XMLElement(EVALNAME(all_entities_prefix || ':AttributeCommentsName'),a.attribute_name).getStringVal()   attribute_name,
         XMLElement(EVALNAME(all_entities_prefix || ':AttributeDescription'),XMLCDATA(
         NVL(
        (SELECT t.text comments_in_rdbms
         FROM   dmrs_large_text t
         WHERE  t.ovid = a.ovid
         AND    t.type='Comments'),
        (SELECT t.text comments_in_rdbms
         FROM   dmrs_large_text t
         WHERE  t.ovid = a.ovid
         AND    t.type='CommentsInRDBMS')))).getClobVal()                                                        attribute_description, 
         XMLElement(EVALNAME(all_entities_prefix || ':AttributeNotes'),XMLCDATA(
        (SELECT t.text comments_in_rdbms
         FROM   dmrs_large_text t
         WHERE  t.ovid = a.ovid
         AND    t.type='Note'))).getClobVal()                                                                    attribute_notes
  FROM   dmrs_entities e, 
         dmrs_attributes a
  WHERE  e.ovid = a.container_ovid
  and    e.ovid = v_e_ovid
  ORDER BY a.sequence
 ) a
 WHERE DBMS_LOB.getlength(attribute_description) > 0 OR DBMS_LOB.getlength(attribute_notes) > 0;
rec_attributes_comments cur_attributes_comments%ROWTYPE;

CURSOR cur_identifiers(v_e_ovid IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(all_entities_prefix || ':IdentifierName'),CASE WHEN ke.sequence>1 THEN ' ' ELSE ke.key_name END).getClobVal()                          nn,
        XMLElement(EVALNAME(all_entities_prefix || ':PrimaryIdentifier'),CASE WHEN ke.sequence>1 THEN ' ' ELSE DECODE(k.state,'Primary Key','Y') END).getClobVal() pi, 
        XMLElement(EVALNAME(all_entities_prefix || ':ElementName'),ke.element_name).getClobVal()                                                                   element_name,
        XMLElement(EVALNAME(all_entities_prefix || ':ElementType'),ke.type).getClobVal()                                                                           type,
        XMLElement(EVALNAME(all_entities_prefix || ':SourceLabel'),ke.source_label).getClobVal()                                                                   source_label,
        XMLElement(EVALNAME(all_entities_prefix || ':TargetLabel'),ke.target_label).getClobVal()                                                                   target_label,
        COUNT(ke.sequence) over()                                                                                                        total_row_count
 FROM   dmrs_keys          k,
        dmrs_key_elements ke
 WHERE  k.container_ovid = v_e_ovid
 AND   ke.key_ovid = k.ovid
 ORDER BY ke.sequence;
rec_identifiers cur_identifiers%ROWTYPE;

CURSOR cur_relationships(v_e_ovid IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(all_entities_prefix || ':SourceName'),r.target_entity_name).getClobVal()                                                                  source_name, 
        XMLElement(EVALNAME(all_entities_prefix || ':SourceRole'),r.source_label).getClobVal()                                                                        source_role,
        XMLElement(EVALNAME(all_entities_prefix || ':TargetRole'),r.target_label).getClobVal()                                                                        target_role,
        XMLElement(EVALNAME(all_entities_prefix || ':InArc'),DECODE(r.in_arc,'N','',r.in_arc)).getClobVal()                                                           in_arc,
        XMLElement(EVALNAME(all_entities_prefix || ':Cardinality'),
           DECODE(r.source_optional,'Y',0,'1') || '..' || r.sourceto_target_cardinality
           ||':'||
           DECODE(r.target_optional,'Y',0,'1') || '..' || r.targetto_source_cardinality
           ).getClobVal()                                                                                                                   cardinality,
        XMLElement(EVALNAME(all_entities_prefix || ':DominantRole'),DECODE(r.dominant_role,'None','')).getClobVal()                                                   dominant_role,
        XMLElement(EVALNAME(all_entities_prefix || ':Identifying'),DECODE(r.identifying,'N','',r.identifying)).getClobVal()                                           identifying,
        XMLElement(EVALNAME(all_entities_prefix || ':Transferable'),DECODE(r.transferable,'N','',r.transferable)).getClobVal()                                        transferable
 FROM   dmrs_relationships r
 WHERE  r.source_ovid  = v_e_ovid
 UNION ALL
 SELECT XMLElement(EVALNAME(all_entities_prefix || ':SourceName'),r.source_entity_name).getClobVal()                                                                  source_name, 
        XMLElement(EVALNAME(all_entities_prefix || ':SourceRole'),r.source_label).getClobVal()                                                                        source_role,
        XMLElement(EVALNAME(all_entities_prefix || ':TargetRole'),r.target_label).getClobVal()                                                                        target_role,
        XMLElement(EVALNAME(all_entities_prefix || ':InArc'),DECODE(r.in_arc,'N','',r.in_arc)).getClobVal()                                                           in_arc,
        XMLElement(EVALNAME(all_entities_prefix || ':Cardinality'),
           DECODE(r.source_optional,'Y',0,'1') || '..' || r.sourceto_target_cardinality
           ||':'||
           DECODE(r.target_optional,'Y',0,'1') || '..' || r.targetto_source_cardinality
           ).getClobVal()                                                                                                                   cardinality,
        XMLElement(EVALNAME(all_entities_prefix || ':DominantRole'),DECODE(r.dominant_role,'None','')).getClobVal()                                                   dominant_role,
        XMLElement(EVALNAME(all_entities_prefix || ':Identifying'),DECODE(r.identifying,'N','',r.identifying)).getClobVal()                                           identifying,
        XMLElement(EVALNAME(all_entities_prefix || ':Transferable'),DECODE(r.transferable,'N','',r.transferable)).getClobVal()                                        transferable
 FROM   dmrs_relationships r
 WHERE  r.target_ovid  = v_e_ovid;
rec_relationships cur_relationships%ROWTYPE;

CURSOR cur_incoming_processes(v_e_ovid IN VARCHAR2) IS
 SELECT  XMLElement(EVALNAME(all_entities_prefix || ':IncomingProcessName'), NVL(pe.process_name,' ')).getClobVal()  ipr_name,
         XMLElement(EVALNAME(all_entities_prefix || ':IncomingFlowName'), NVL(pe.flow_name,' ')).getClobVal()       ipr_flow_name,
         XMLElement(EVALNAME(all_entities_prefix || ':IncomingCRUDCode'), NVL(pe.crud_code,' ')).getClobVal()       ipr_crud_code,
         XMLElement(EVALNAME(all_entities_prefix || ':IncomingDFDName'), NVL(pe.dfd_name,' ')).getClobVal()         ipr_dfd_name,
         COUNT(pe.process_name) over()                                                    total_row_count
  FROM   dmrs_process_entities pe
  WHERE  pe.entity_ovid = v_e_ovid
  AND    pe.flow_direction = 'IN'
  ORDER BY pe.process_name;
rec_incoming_processes cur_incoming_processes%ROWTYPE;

CURSOR cur_outgoing_processes(v_e_ovid IN VARCHAR2) IS
  SELECT XMLElement(EVALNAME(all_entities_prefix || ':OutgoingProcessName'), pe.process_name).getClobVal() opr_name,
         XMLElement(EVALNAME(all_entities_prefix || ':OutgoingFlowName'), pe.flow_name).getClobVal()       opr_flow_name,
         XMLElement(EVALNAME(all_entities_prefix || ':OutgoingCRUDCode'), pe.crud_code).getClobVal()       opr_crud_code,
         XMLElement(EVALNAME(all_entities_prefix || ':OutgoingDFDName'), pe.dfd_name).getClobVal()         opr_dfd_name,
         COUNT(pe.process_name) over()                                           total_row_count
  FROM   dmrs_process_entities pe
  WHERE  pe.entity_ovid = v_e_ovid
  AND    pe.flow_direction = 'OUT'
  ORDER BY pe.process_name;
rec_outgoing_processes cur_outgoing_processes%ROWTYPE;

-- Constraints
CURSOR cur_constraints(v_e_ovid IN VARCHAR2) IS
SELECT XMLElement(EVALNAME(all_entities_prefix || ':ContstraintType'), CASE WHEN rownum>1 THEN ''
                                              ELSE 'Attribute Level'
                                              END).getClobVal()                                        c_type,
        XMLElement(EVALNAME(all_entities_prefix || ':ALCConstraintName'), a.attribute_name || 
                                                DECODE((SELECT DISTINCT(constraint_name)
                                                        FROM dmrs_check_constraints 
                                                        WHERE a.ovid = dataelement_ovid),NULL,'',
                                               ' / '|| (SELECT  DISTINCT(constraint_name) 
                                                        FROM dmrs_check_constraints 
                                                        WHERE a.ovid = dataelement_ovid))).getClobVal() c_name,
        Gather_Constraint_Details_XML(a.ovid, all_entities_prefix)                                      c_details,
        COUNT(a.attribute_name) over()                                                                  total_row_count
 FROM   dmrs_attributes a
 WHERE a.container_ovid = v_e_ovid
 AND  (a.ovid IN (SELECT dataelement_ovid FROM dmrs_avt) OR 
       a.ovid IN (SELECT dataelement_ovid FROM dmrs_value_ranges) OR 
       a.ovid IN (SELECT dataelement_ovid FROM dmrs_check_constraints));
rec_constraints cur_constraints%ROWTYPE;

BEGIN

  UTL_FILE.PUT_LINE(log_file, TO_CHAR(SYSDATE,'yy.mm.dd hh:mi:ss') ||' '|| 'Gathering data for all entities started ...');
  
  DBMS_LOB.CREATETEMPORARY(res, TRUE);

  DBMS_LOB.APPEND (res,'<' || all_entities_prefix || ':Entities xmlns:' || all_entities_prefix || '="http://oracle.com/datamodeler/reports/entities">');
  
  FOR rec_general_data IN cur_general_data(v_model_ovid) LOOP

    DBMS_LOB.APPEND (res, rec_general_data.design_name);
    DBMS_LOB.APPEND (res, rec_general_data.version_date);
    DBMS_LOB.APPEND (res, rec_general_data.version_comment);
    DBMS_LOB.APPEND (res, rec_general_data.model_name);

  END LOOP;
 
   FOR rec_all_entities IN cur_all_entities(v_model_ovid) LOOP

      IF (cur_all_entities%ROWCOUNT = 1) THEN
           DBMS_LOB.APPEND (res,'<' || all_entities_prefix || ':EntitiesCollection>');
      END IF;

      DBMS_LOB.APPEND (res,'<' || all_entities_prefix || ':EntityDetails>');

      -- Mapped tables
      FOR rec_mapped_tables IN cur_mapped_tables(rec_all_entities.entity_ovid) LOOP
        IF (cur_mapped_tables%ROWCOUNT = 1) THEN
          DBMS_LOB.APPEND (res,'<' || all_entities_prefix || ':MappedTablesCollection>');
        END IF;

         DBMS_LOB.APPEND (res, '<' || all_entities_prefix || ':MappedTablesDetails>');
         DBMS_LOB.APPEND (res, rec_mapped_tables.table_name);
         DBMS_LOB.APPEND (res, '</' || all_entities_prefix || ':MappedTablesDetails>');

        IF (cur_mapped_tables%ROWCOUNT = rec_mapped_tables.total_row_count) THEN
         DBMS_LOB.APPEND (res, '</' || all_entities_prefix || ':MappedTablesCollection>');
        END IF;
      END LOOP;

      -- Description / Notes
      IF (reportTemplate.reportType = 0 OR reportTemplate.useDescriptionInfo = 1) THEN
         
        DBMS_LOB.APPEND (res, '<' || all_entities_prefix || ':DescriptionNotes>');
         
        SELECT  XMLElement(EVALNAME(all_entities_prefix || ':Description'), XMLCDATA(
                  NVL((SELECT t.text comments_in_rdbms
                       FROM   dmrs_large_text t
                       WHERE  t.ovid = rec_all_entities.entity_ovid
                       AND    t.type='Comments'),
                      (SELECT t.text comments_in_rdbms
                       FROM   dmrs_large_text t
                       WHERE  t.ovid = rec_all_entities.entity_ovid
                       AND    t.type='CommentsInRDBMS')))).getClobVal(), 
                XMLElement(EVALNAME(all_entities_prefix || ':Notes'), XMLCDATA(
                      (SELECT t.text comments_in_rdbms
                       FROM   dmrs_large_text t
                       WHERE  t.ovid = rec_all_entities.entity_ovid
                       AND    t.type='Note'))).getClobVal()
        INTO    v_description, 
                v_notes
        FROM dual;

        DBMS_LOB.APPEND (res, v_description);
        DBMS_LOB.APPEND (res, v_notes);
        DBMS_LOB.APPEND (res, '</' || all_entities_prefix || ':DescriptionNotes>');

      END IF;
            
      DBMS_LOB.APPEND (res, rec_all_entities.entity_name);
      DBMS_LOB.APPEND (res, rec_all_entities.xml_ovid);
      DBMS_LOB.APPEND (res, rec_all_entities.pref_abbreviation);      
      DBMS_LOB.APPEND (res, rec_all_entities.classification_type_name);
      DBMS_LOB.APPEND (res, rec_all_entities.object_type_name);
      DBMS_LOB.APPEND (res, rec_all_entities.super_type);
      DBMS_LOB.APPEND (res, rec_all_entities.table_synonyms);

      IF (reportTemplate.reportType = 0 OR reportTemplate.useQuantitativeInfo = 1) THEN
        DBMS_LOB.APPEND (res, '<' || all_entities_prefix || ':QuantitativeInfoCollection>');
        DBMS_LOB.APPEND (res, rec_all_entities.number_of_attributes);
        DBMS_LOB.APPEND (res, rec_all_entities.number_rows_min);
        DBMS_LOB.APPEND (res, rec_all_entities.number_rows_max);
        DBMS_LOB.APPEND (res, rec_all_entities.expected_number_of_rows);
        DBMS_LOB.APPEND (res, rec_all_entities.expected_growth);
        DBMS_LOB.APPEND (res, rec_all_entities.growth_interval);
        DBMS_LOB.APPEND (res, '</' || all_entities_prefix || ':QuantitativeInfoCollection>');
      END IF;
      
       -- Diagrams
       IF (reportTemplate.reportType = 0 OR reportTemplate.useDiagrams = 1) THEN
         FOR rec_diagrams IN cur_diagrams(rec_all_entities.entity_ovid, v_report_name) LOOP
            IF (cur_diagrams%ROWCOUNT = 1) THEN
              DBMS_LOB.APPEND (res,'<' || all_entities_prefix || ':DiagramsCollection>');
            END IF;
              
              DBMS_LOB.APPEND (res, rec_diagrams.pdf_name);
       
            IF (cur_diagrams%ROWCOUNT = rec_diagrams.total_row_count) THEN
             DBMS_LOB.APPEND (res, '</' || all_entities_prefix || ':DiagramsCollection>');
            END IF;
         END LOOP;
       END IF;
      
      -- Attributes
      IF (reportTemplate.reportType = 0 OR reportTemplate.useEntityAttributes = 1) THEN
        FOR rec_attributes IN cur_attributes(rec_all_entities.entity_ovid) LOOP

           IF (cur_attributes%ROWCOUNT = 1) THEN
             DBMS_LOB.APPEND (res,'<' || all_entities_prefix || ':AttributesCollection>');
           END IF;

             DBMS_LOB.APPEND (res, '<' || all_entities_prefix || ':AttributeDetails>');
             DBMS_LOB.APPEND (res, rec_attributes.seq);
             DBMS_LOB.APPEND (res, rec_attributes.attr_name);
             DBMS_LOB.APPEND (res, rec_attributes.pk);
             DBMS_LOB.APPEND (res, rec_attributes.fk);
             DBMS_LOB.APPEND (res, rec_attributes.m);
             IF (INSTR(LOWER(rec_attributes.data_type),'unknown') = 0) THEN
                DBMS_LOB.APPEND (res, rec_attributes.data_type);
             ELSE
                SELECT XMLElement(EVALNAME(all_entities_prefix || ':DataType'), '').getClobVal() INTO token_value FROM dual;
                DBMS_LOB.APPEND (res, token_value);
             END IF;
             DBMS_LOB.APPEND (res, rec_attributes.dt_kind);
             DBMS_LOB.APPEND (res, rec_attributes.domain_name);
             DBMS_LOB.APPEND (res, rec_attributes.formula);
             DBMS_LOB.APPEND (res, rec_attributes.pref_abbr);
             DBMS_LOB.APPEND (res, rec_attributes.synonyms);
             DBMS_LOB.APPEND (res,'</' || all_entities_prefix || ':AttributeDetails>');

           IF (cur_attributes%ROWCOUNT = rec_attributes.total_row_count) THEN
            DBMS_LOB.APPEND (res, '</' || all_entities_prefix || ':AttributesCollection>');
           END IF;
        END LOOP;
      END IF;

      -- Attribute Comments
      IF (reportTemplate.reportType = 0 OR reportTemplate.useEntityAttributesComments = 1) THEN
        FOR rec_attributes_comments IN cur_attributes_comments(rec_all_entities.entity_ovid) LOOP
           IF (cur_attributes_comments%ROWCOUNT = 1) THEN
             DBMS_LOB.APPEND (res,'<' || all_entities_prefix || ':AttributesCommentsCollection>');
           END IF;

            DBMS_LOB.APPEND (res, '<' || all_entities_prefix || ':AttributeCommentsDetails>');
            DBMS_LOB.APPEND (res, rec_attributes_comments.seq);
            DBMS_LOB.APPEND (res, rec_attributes_comments.attribute_name);
            DBMS_LOB.APPEND (res, rec_attributes_comments.attribute_description);
            DBMS_LOB.APPEND (res, rec_attributes_comments.attribute_notes);
            DBMS_LOB.APPEND (res,'</' || all_entities_prefix || ':AttributeCommentsDetails>');

           IF (cur_attributes_comments%ROWCOUNT = rec_attributes_comments.total_row_count) THEN
             DBMS_LOB.APPEND (res, '</' || all_entities_prefix || ':AttributesCommentsCollection>');
           END IF;
        END LOOP;
      END IF;

      -- Constraints
      IF (reportTemplate.reportType = 0 OR reportTemplate.useEntityConstraints = 1) THEN
        FOR rec_constraints IN cur_constraints(rec_all_entities.entity_ovid) LOOP
           IF (cur_constraints%ROWCOUNT = 1) THEN
              DBMS_LOB.APPEND (res,'<' || all_entities_prefix || ':ConstraintsCollection>');
           END IF;

             DBMS_LOB.APPEND (res,'<' || all_entities_prefix || ':ConstraintDetails>');
             DBMS_LOB.APPEND (res,rec_constraints.c_type);
             DBMS_LOB.APPEND (res,rec_constraints.c_name);
             DBMS_LOB.APPEND (res,rec_constraints.c_details);
             DBMS_LOB.APPEND (res,'</' || all_entities_prefix || ':ConstraintDetails>');

           IF (cur_constraints%ROWCOUNT = rec_constraints.total_row_count) THEN
               DBMS_LOB.APPEND (res,'</' || all_entities_prefix || ':ConstraintsCollection>');
           END IF;
        END LOOP;
      END IF;

      -- Identifiers
      IF (reportTemplate.reportType = 0 OR reportTemplate.useEntityIdentifiers = 1) THEN
        FOR rec_identifiers IN cur_identifiers(rec_all_entities.entity_ovid) LOOP
           IF (cur_identifiers%ROWCOUNT = 1) THEN
             DBMS_LOB.APPEND (res, '<' || all_entities_prefix || ':IdentifiersCollection>');
           END IF;
          
             DBMS_LOB.APPEND (res, '<' || all_entities_prefix || ':IdentifierDetails>');
             DBMS_LOB.APPEND (res, rec_identifiers.nn);
             DBMS_LOB.APPEND (res, rec_identifiers.pi);
             DBMS_LOB.APPEND (res, rec_identifiers.element_name);
             DBMS_LOB.APPEND (res, rec_identifiers.type);
             DBMS_LOB.APPEND (res, rec_identifiers.source_label);
             DBMS_LOB.APPEND (res, rec_identifiers.target_label);
             DBMS_LOB.APPEND (res, '</' || all_entities_prefix || ':IdentifierDetails>');
        
           IF (cur_identifiers%ROWCOUNT = rec_identifiers.total_row_count) THEN
              DBMS_LOB.APPEND (res, '</' || all_entities_prefix || ':IdentifiersCollection>');
           END IF;
        END LOOP;
      END IF;

      -- Relationships
      IF (reportTemplate.reportType = 0 OR reportTemplate.useEntityRelationships = 1) THEN
        -- Total count of relationships
        SELECT COUNT(1)
        INTO   v_rel_total_count
        FROM (
         SELECT r.ovid
         FROM   dmrs_relationships r,
                dmrs_entities      e
         WHERE  r.source_ovid  = e.ovid
         AND    e.ovid         = rec_all_entities.entity_ovid
         UNION ALL
         SELECT r.ovid
         FROM   dmrs_relationships r,
                dmrs_entities      e
         WHERE  r.target_ovid  = e.ovid
         AND    e.ovid         = rec_all_entities.entity_ovid);

        FOR rec_relationships IN cur_relationships(rec_all_entities.entity_ovid) LOOP
           IF (cur_relationships%ROWCOUNT = 1) THEN
              DBMS_LOB.APPEND (res, '<' || all_entities_prefix || ':RelationshipsCollection>');
           END IF;

              DBMS_LOB.APPEND (res, '<' || all_entities_prefix || ':RelationshipDetails>');
              DBMS_LOB.APPEND (res, rec_relationships.source_name);
              DBMS_LOB.APPEND (res, rec_relationships.source_role);
              DBMS_LOB.APPEND (res, rec_relationships.target_role);
              DBMS_LOB.APPEND (res, rec_relationships.in_arc);
              DBMS_LOB.APPEND (res, rec_relationships.cardinality);
              DBMS_LOB.APPEND (res, rec_relationships.dominant_role);
              DBMS_LOB.APPEND (res, rec_relationships.identifying);
              DBMS_LOB.APPEND (res, rec_relationships.transferable);
              DBMS_LOB.APPEND (res, '</' || all_entities_prefix || ':RelationshipDetails>');
        
           IF (cur_relationships%ROWCOUNT = v_rel_total_count) THEN
              DBMS_LOB.APPEND (res, '</' || all_entities_prefix || ':RelationshipsCollection>');
           END IF;
        
        END LOOP;
      END IF;

      -- Incoming Processes
      IF (reportTemplate.reportType = 0 OR reportTemplate.useEntityIncomingProcesses = 1) THEN
        FOR rec_incoming_processes IN cur_incoming_processes(rec_all_entities.entity_ovid) LOOP
           IF (cur_incoming_processes%ROWCOUNT = 1) THEN
             DBMS_LOB.APPEND (res, '<' || all_entities_prefix || ':IncomingProcessesCollection>');
           END IF;
             DBMS_LOB.APPEND (res, '<' || all_entities_prefix || ':IncomingProcessDetails>');
             DBMS_LOB.APPEND (res, rec_incoming_processes.ipr_name);
             DBMS_LOB.APPEND (res, rec_incoming_processes.ipr_flow_name);
             DBMS_LOB.APPEND (res, rec_incoming_processes.ipr_crud_code);
             DBMS_LOB.APPEND (res, rec_incoming_processes.ipr_dfd_name);
             DBMS_LOB.APPEND (res, '</' || all_entities_prefix || ':IncomingProcessDetails>');
           IF (cur_incoming_processes%ROWCOUNT = rec_incoming_processes.total_row_count) THEN
             DBMS_LOB.APPEND (res, '</' || all_entities_prefix || ':IncomingProcessesCollection>');
           END IF;
        END LOOP;
      END IF;
      -- Outgoing Processes
      IF (reportTemplate.reportType = 0 OR reportTemplate.useEntityOutgoingProcesses = 1) THEN
        FOR rec_outgoing_processes IN cur_outgoing_processes(rec_all_entities.entity_ovid) LOOP
           IF (cur_outgoing_processes%ROWCOUNT = 1) THEN
             DBMS_LOB.APPEND (res, '<' || all_entities_prefix || ':OutgoingProcessesCollection>');
           END IF;
             DBMS_LOB.APPEND (res, '<' || all_entities_prefix || ':OugoingProcessDetails>');
             DBMS_LOB.APPEND (res, rec_outgoing_processes.opr_name);
             DBMS_LOB.APPEND (res, rec_outgoing_processes.opr_flow_name);
             DBMS_LOB.APPEND (res, rec_outgoing_processes.opr_crud_code);
             DBMS_LOB.APPEND (res, rec_outgoing_processes.opr_dfd_name);
             DBMS_LOB.APPEND (res, '</' || all_entities_prefix || ':OugoingProcessDetails>');
           IF (cur_outgoing_processes%ROWCOUNT = rec_outgoing_processes.total_row_count) THEN
             DBMS_LOB.APPEND (res, '</' || all_entities_prefix || ':OutgoingProcessesCollection>');
           END IF;
        END LOOP;
      END IF;

      DBMS_LOB.APPEND (res,'</' || all_entities_prefix || ':EntityDetails>');

      IF (cur_all_entities%ROWCOUNT = rec_all_entities.total_row_count) THEN
         DBMS_LOB.APPEND (res,'</' || all_entities_prefix || ':EntitiesCollection>');
      END IF;

   END LOOP;

  DBMS_LOB.APPEND (res,'</' || all_entities_prefix || ':Entities>');

  UTL_FILE.PUT_LINE(log_file, TO_CHAR(SYSDATE,'yy.mm.dd hh:mi:ss') ||' '|| 'Gathering data for all entities ended');  

RETURN res;
  
 EXCEPTION
 WHEN others THEN
  UTL_FILE.PUT_LINE(log_file, 'Pkg_Osdm_Utils.Gather_AllEntities_Data Exception : ' || SQLERRM);  
  UTL_FILE.PUT_LINE(log_file, 'Pkg_Osdm_Utils.Gather_AllEntities_Data Exception : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  RETURN res;
 
END Gather_AllEntities_Data;

FUNCTION Gather_Glossary_Data(v_glossary_ovid IN VARCHAR2) RETURN CLOB IS 

res CLOB;

CURSOR cur_glossary(v_g_ovid IN VARCHAR2) IS
 SELECT  /*+ index(g GLOSSARIES_OVID_IDX) */
         XMLElement(EVALNAME(glossary_prefix || ':GlossaryName'), g.glossary_name).getClobVal()                                      glossary_name,
         XMLElement(EVALNAME(glossary_prefix || ':Description'), XMLCDATA(g.description)).getClobVal()                               description,
         XMLElement(EVALNAME(glossary_prefix || ':FileName'), g.file_name).getStringVal()                                            file_name,
         XMLElement(EVALNAME(glossary_prefix || ':IncompleteModifiers'), DECODE(g.incomplete_modifiers,'N','','Y')).getStringVal()   inc_modifiers,
         XMLElement(EVALNAME(glossary_prefix || ':CaseSensitive'), DECODE(g.case_sensitive,'N','','Y')).getStringVal()               case_sensitive,
         XMLElement(EVALNAME(glossary_prefix || ':UniqueAbbreviations'), DECODE(g.unique_abbrevs,'N','','Y')).getStringVal()         unique_abbreviations,
         XMLElement(EVALNAME(glossary_prefix || ':SeparatorType'), g.separator_type).getStringVal()                                  separator_type,
         XMLElement(EVALNAME(glossary_prefix || ':SeparatorChar'), g.separator_char).getStringVal()                                  separator_char
 FROM    dmrs_glossaries g
 WHERE   g.glossary_ovid = v_g_ovid;
rec_glossary cur_glossary%ROWTYPE;

CURSOR cur_glossary_words(v_g_ovid IN VARCHAR2) IS
 SELECT /*+ index(g GLOSSARIES_OVID_IDX) */
        XMLElement(EVALNAME(glossary_prefix || ':TermName'), gt.term_name).getClobVal()                            term_name,
        XMLElement(EVALNAME(glossary_prefix || ':Plural'), gt.plural).getClobVal()                                 plural,
        XMLElement(EVALNAME(glossary_prefix || ':Abbreviation'), gt.abbrev).getClobVal()                           abbr,
        XMLElement(EVALNAME(glossary_prefix || ':AltAbbreviation'), gt.alt_abbrev).getClobVal()                    alt_abbr,
        XMLElement(EVALNAME(glossary_prefix || ':P'), DECODE(gt.prime_word,'N','',gt.prime_word)).getClobVal()     p_word,
        XMLElement(EVALNAME(glossary_prefix || ':C'), DECODE(gt.class_word,'N','',gt.class_word)).getClobVal()     c_word,
        XMLElement(EVALNAME(glossary_prefix || ':M'), DECODE(gt.modifier,'N','',gt.modifier)).getClobVal()         modifier,
        XMLElement(EVALNAME(glossary_prefix || ':Q'), DECODE(gt.qualifier,'N','',gt.qualifier)).getClobVal()       qualifier,
        XMLElement(EVALNAME(glossary_prefix || ':SDescription'), XMLCDATA(gt.short_description)).getClobVal()      description,
        COUNT(gt.term_name) over() total_row_count
 FROM   dmrs_glossaries g,
        dmrs_glossary_terms gt
 WHERE  g.glossary_ovid = gt.glossary_ovid
 AND    g.glossary_ovid = v_g_ovid;
rec_glossary_words cur_glossary_words%ROWTYPE;

BEGIN

  UTL_FILE.PUT_LINE(log_file, TO_CHAR(SYSDATE,'yy.mm.dd hh:mi:ss') ||' '|| 'Gathering glossary data started ...');
 
  DBMS_LOB.CREATETEMPORARY(res, TRUE);
  
  DBMS_LOB.APPEND (res,'<' || glossary_prefix || ':Glossary xmlns:' || glossary_prefix || '="http://oracle.com/datamodeler/reports/glossary">');
  
  FOR rec_glossary IN cur_glossary(v_glossary_ovid) LOOP
    DBMS_LOB.APPEND (res, rec_glossary.glossary_name);
    DBMS_LOB.APPEND (res, rec_glossary.description);
    DBMS_LOB.APPEND (res, rec_glossary.file_name);
    DBMS_LOB.APPEND (res, rec_glossary.inc_modifiers);
    DBMS_LOB.APPEND (res, rec_glossary.case_sensitive);
    DBMS_LOB.APPEND (res, rec_glossary.unique_abbreviations);
    DBMS_LOB.APPEND (res, rec_glossary.separator_type);
    DBMS_LOB.APPEND (res, rec_glossary.separator_char);
  END LOOP;

  FOR rec_glossary_words IN cur_glossary_words(v_glossary_ovid) LOOP
    IF (cur_glossary_words%ROWCOUNT = 1) THEN
      DBMS_LOB.APPEND (res, '<' || glossary_prefix || ':GlossaryCollection>');
    END IF;
      DBMS_LOB.APPEND (res, '<' || glossary_prefix || ':GlossaryDetail>');
      DBMS_LOB.APPEND (res, rec_glossary_words.term_name);
      DBMS_LOB.APPEND (res, rec_glossary_words.plural);
      DBMS_LOB.APPEND (res, rec_glossary_words.abbr);
      DBMS_LOB.APPEND (res, rec_glossary_words.alt_abbr);
      DBMS_LOB.APPEND (res, rec_glossary_words.p_word);
      DBMS_LOB.APPEND (res, rec_glossary_words.c_word);
      DBMS_LOB.APPEND (res, rec_glossary_words.modifier);
      DBMS_LOB.APPEND (res, rec_glossary_words.qualifier);
      DBMS_LOB.APPEND (res, rec_glossary_words.description);
      DBMS_LOB.APPEND (res, '</' || glossary_prefix || ':GlossaryDetail>');
    IF (cur_glossary_words%ROWCOUNT = rec_glossary_words.total_row_count) THEN
      DBMS_LOB.APPEND (res, '</' || glossary_prefix || ':GlossaryCollection>');
    END IF;
  END LOOP;

  DBMS_LOB.APPEND (res, '</' || glossary_prefix || ':Glossary>');
  
  UTL_FILE.PUT_LINE(log_file, TO_CHAR(SYSDATE,'yy.mm.dd hh:mi:ss') ||' '|| 'Gathering glossary data ended');
  
RETURN res;

  EXCEPTION
  WHEN others THEN
    UTL_FILE.PUT_LINE(log_file, 'Pkg_Osdm_Utils.Gather_Glossary_Data Exception : ' || SQLERRM);  
    UTL_FILE.PUT_LINE(log_file, 'Pkg_Osdm_Utils.Gather_Glossary_Data Exception : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  RETURN res;

END Gather_Glossary_Data;

FUNCTION Gather_SingleST_Data(v_str_type_ovid IN VARCHAR2, reportTemplate IN REPORT_TEMPLATE, v_report_name IN VARCHAR2) RETURN CLOB IS 

res               CLOB;
token_value       CLOB;
v_description     CLOB;
v_notes           CLOB;
v_rel_total_count INTEGER;
v_seq             INTEGER := 1;
p_model_name      VARCHAR2(100) :='_';
v_model_name      VARCHAR2(100) :='';
p_table_name      VARCHAR2(100) :='_';
v_table_name      VARCHAR2(100) :='';
p_entity_name     VARCHAR2(100) :='_';
v_entity_name     VARCHAR2(100) :='';

 -- General data
CURSOR cur_general_data(v_st_ovid IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(single_st_prefix || ':DesignName'),d.design_name).getClobVal()                                        design_name,
        XMLElement(EVALNAME(single_st_prefix || ':VersionDate'),TO_CHAR(d.date_published,'dd.mm.yyyy hh24:mi:ss')).getClobVal()   version_date,
        XMLElement(EVALNAME(single_st_prefix || ':VersionComment'),XMLCDATA(d.version_comments)).getClobVal()                     version_comment,
        XMLElement(EVALNAME(single_st_prefix || ':ModelName'),m.model_name).getClobVal()                                          model_name
 FROM   dmrs_designs d, 
        dmrs_models m,
        dmrs_structured_types st
 WHERE  d.design_ovid = m.design_ovid
 AND    st.model_ovid = m.model_ovid
 AND    st.structured_type_ovid = v_st_ovid;
rec_general_data cur_general_data%ROWTYPE;

-- Structured Type General Data
CURSOR cur_st(v_st_ovid IN VARCHAR2) IS
SELECT XMLElement(EVALNAME(single_st_prefix || ':STName'),st.structured_type_name).getClobVal()                                                                                     stName,
       XMLElement(EVALNAME(single_st_prefix || ':STSuperType'),(SELECT st1.structured_type_name 
                                           FROM  dmrs_structured_types st1 
                                           WHERE st.super_type_ovid = st1.structured_type_ovid)).getClobVal()                                                  super_type
FROM   dmrs_structured_types st
WHERE  st.structured_type_ovid = v_st_ovid;
rec_st cur_st%ROWTYPE;

-- Diagrams
CURSOR cur_diagrams(v_t_ovid IN VARCHAR2, v_rep_name IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(single_st_prefix || ':Diagram'), 
          XMLElement(EVALNAME(single_st_prefix || ':Name'), v_rep_name || '_files/' || REGEXP_REPLACE(SUBSTR(d.pdf_name, 1, INSTR(d.pdf_name, '.PDF')-1), '[^a-zA-Z1-9_]', '_') || '.pdf'),
          XMLElement(EVALNAME(single_st_prefix || ':Suffix'), NULL)).getClobVal()                                                                                                            pdf_name,
        COUNT(d.pdf_name) over()                                                                                                                                                             total_row_count
 FROM   dmrs_vdiagrams d,
       (SELECT diagram_ovid 
        FROM   dmrs_diagram_elements
        WHERE  ovid = v_t_ovid) b
 WHERE d.ovid = b.diagram_ovid
 AND   d.diagram_type = 'Subview'
 AND   d.is_display = 'N';
rec_diagrams cur_diagrams%ROWTYPE;

--Attributes
CURSOR cur_st_attr(v_st_ovid IN VARCHAR2) IS
SELECT  XMLElement(EVALNAME(single_st_prefix || ':AttributeName'), sta.attribute_name).getClobVal()                                                                                 attr_name,
        XMLElement(EVALNAME(single_st_prefix || ':M'),DECODE(sta.mandatory,'N','','Y')).getClobVal()                                                                                m,
        XMLElement(EVALNAME(single_st_prefix || ':DataTypeKind'),DECODE(sta.datatype_kind,                                                                                           
                                                 'Domain',         'DOM',
                                                 'Logical Type',   'LT',
                                                 'Distinct Type',  'DT',
                                                 'Ref Struct Type','RST',
                                                 'Structured Type','ST',
                                                 'Collection Type','CT')
                  ).getClobVal()                                                                                                                               dt_kind,
         XMLElement(EVALNAME(single_st_prefix || ':DataType'), 
            DECODE(sta.datatype_kind, 
                  'Domain', sta.type_name ||' '||
                           DECODE (NVL(sta.t_size,''),'',
                              DECODE(NVL(sta.t_scale,0),0,
                                 DECODE(NVL(sta.t_precision,0),0,null,'('|| DECODE(NVL(sta.t_precision,0),0,null,sta.t_precision) ||')'),
                                   '('|| DECODE(NVL(sta.t_precision,0),0,null,sta.t_precision) || ',' || DECODE(NVL(sta.t_scale,0),0,null,sta.t_scale)||')'),
                                   '('||TRIM(DECODE(sta.t_size,'',null,sta.t_size||' '||sta.char_units ))||')'),
                   'Logical Type', sta.type_name  ||' '|| 
                           DECODE (NVL(sta.t_size,''),'',
                              DECODE(NVL(sta.t_scale,0),0,
                                 DECODE(NVL(sta.t_precision,0),0,null,'('|| DECODE(NVL(sta.t_precision,0),0,null,sta.t_precision) ||')'),
                                   '('|| DECODE(NVL(sta.t_precision,0),0,null,sta.t_precision) || ',' || DECODE(NVL(sta.t_scale,0),0,null,sta.t_scale)||')'),
                                   '('||TRIM(DECODE(sta.t_size,'',null,sta.t_size||' '||sta.char_units ))||')')
            )).getClobVal()                                                                                                                                    data_type,
        XMLElement(EVALNAME(single_st_prefix || ':DomainName'),DECODE(sta.domain_name,'Unknown',null,sta.domain_name)).getClobVal()                                                 domain_name,
      COUNT(sta.attribute_name) over()                                                                                                                         total_row_count
FROM  dmrs_struct_type_attrs sta,
      dmrs_structured_types st
WHERE sta.structured_type_ovid = st.structured_type_ovid
AND   st.structured_type_ovid = v_st_ovid;
rec_st_attr cur_st_attr%ROWTYPE;

-- Attributes Comments Data
CURSOR cur_attributes_comments(v_st_ovid IN VARCHAR2) IS
 SELECT a.attribute_name               attribute_name, 
        a.attribute_description        attribute_description, 
        a.attribute_notes              attribute_notes,
        COUNT(a.attribute_name) over() total_row_count
 FROM (
  SELECT XMLElement(EVALNAME(single_st_prefix || ':AttributeCommentsName'),a.attribute_name).getStringVal()   attribute_name,
         XMLElement(EVALNAME(single_st_prefix || ':AttributeDescription'),XMLCDATA(
         NVL(
        (SELECT t.text comments_in_rdbms
         FROM   dmrs_large_text t
         WHERE  t.ovid = a.attribute_ovid
         AND    t.type='Comments'),
        (SELECT t.text comments_in_rdbms
         FROM   dmrs_large_text t
         WHERE  t.ovid = a.attribute_ovid
         AND    t.type='CommentsInRDBMS')))).getClobVal()                                                     attribute_description, 
        XMLElement(EVALNAME(single_st_prefix || ':AttributeNotes'),XMLCDATA(
        (SELECT t.text comments_in_rdbms
         FROM   dmrs_large_text t
         WHERE  t.ovid = a.attribute_ovid
         AND    t.type='Note'))).getClobVal()                                                                 attribute_notes
  FROM   dmrs_struct_type_attrs a
  WHERE  a.structured_type_ovid = v_st_ovid
 ) a
 WHERE DBMS_LOB.getlength(attribute_description) > 0 OR DBMS_LOB.getlength(attribute_notes) > 0;
rec_attributes_comments cur_attributes_comments%ROWTYPE;

-- Methods
CURSOR  cur_st_methods(v_st_ovid IN VARCHAR2) IS
SELECT  XMLElement(EVALNAME(single_st_prefix || ':MethodName'), m.method_name).getClobVal()                           m_name,
        XMLElement(EVALNAME(single_st_prefix || ':MethodConstructor'), DECODE(m.constructor,'N','','Y')).getClobVal() m_constr,
        XMLElement(EVALNAME(single_st_prefix || ':MethodOverriding'), DECODE(m.overriding,'N','','Y')).getClobVal()   m_overriding,
        XMLElement(EVALNAME(single_st_prefix || ':MethodOverridenMethod'), m.overridden_method_name).getClobVal()     m_om_name,
        XMLElement(EVALNAME(single_st_prefix || ':MethodReturnValue'), 
        (SELECT sp.type_name  ||' '|| 
                DECODE (NVL(sp.t_size,''),'',
                 DECODE(NVL(sp.t_scale,0),0,
                  DECODE(NVL(sp.t_precision,0),0,null,'('|| DECODE(NVL(sp.t_precision,0),0,null,sp.t_precision) ||')'),
                  '('|| DECODE(NVL(sp.t_precision,0),0,null,sp.t_precision) || ',' || DECODE(NVL(sp.t_scale,0),0,null,sp.t_scale)||')'),
                  '('||TRIM(DECODE(sp.t_size,'',null,sp.t_size ))||')')
         FROM   dmrs_struct_type_method_pars sp 
         WHERE  return_value= 'Y'
         AND    sp.method_ovid = m.method_ovid)).getClobVal()                                    m_return_type,        
        COUNT(m.method_name) over()                                                              total_row_count,
        m.method_ovid                                                                            method_ovid
FROM dmrs_struct_type_methods m,
     dmrs_structured_types st
WHERE m.structured_type_ovid = st.structured_type_ovid
AND   st.structured_type_ovid = v_st_ovid;
rec_st_methods cur_st_methods%ROWTYPE;

-- Method params
CURSOR cur_st_methods_p(v_m_ovid IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(single_st_prefix || ':ParameterName'), parameter_name).getClobVal()  param_name,
        --XMLElement("osdm_s_st:ParameterType", type_name).getClobVal()       param_type,
        XMLElement(EVALNAME(single_st_prefix || ':ParameterType'), 
        type_name  ||' '|| 
                DECODE (NVL(t_size,0),0,
                 DECODE(NVL(t_scale,0),0,
                  DECODE(NVL(t_precision,0),0,null,'('|| DECODE(NVL(t_precision,0),0,null,t_precision) ||')'),
                  '('|| DECODE(NVL(t_precision,0),0,null,t_precision) || ',' || DECODE(NVL(t_scale,0),0,null,t_scale)||')'),
                  '('||TRIM(DECODE(t_size,0,null,t_size ))||')')
        ).getClobVal()       param_type,
        COUNT(parameter_name) over()                                        total_row_count
 FROM   dmrs_struct_type_method_pars
 WHERE  method_ovid = v_m_ovid
 AND    return_value = 'N'
 ORDER BY seq;
rec_st_methods_p cur_st_methods_p%ROWTYPE;

-- Used In tables
CURSOR cur_used_in_tables(v_st_ovid IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(single_st_prefix || ':ModelName'), m.model_name).getClobVal()     model_name,
        XMLElement(EVALNAME(single_st_prefix || ':TableName'), t.table_name).getClobVal()     table_name,
        XMLElement(EVALNAME(single_st_prefix || ':ColumnName'), c.column_name).getClobVal()   column_name,
        COUNT(m.model_name) over()                                       total_row_count
 FROM   dmrs_tables t,
        dmrs_columns c,
        dmrs_structured_types st,
        dmrs_models  m
 WHERE  t.ovid = c.container_ovid
 AND    c.structured_type_ovid = st.structured_type_ovid
 AND    m.model_ovid = t.model_ovid
 AND    c.datatype_kind = 'Structured Type'
 AND    st.structured_type_ovid = v_st_ovid
 ORDER BY m.model_name,
          t.table_name,
          c.column_name;
rec_used_in_tables cur_used_in_tables%ROWTYPE;

-- Used In entities
CURSOR cur_used_in_entities(v_st_ovid IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(single_st_prefix || ':EntityName'), e.entity_name).getClobVal()        entity_name,
        XMLElement(EVALNAME(single_st_prefix || ':AttributeName'), a.attribute_name).getClobVal()  attribute_name,
        COUNT(e.entity_name) over()                                           total_row_count
 FROM   dmrs_entities e,
        dmrs_attributes a,
        dmrs_structured_types st
 WHERE  e.ovid = a.container_ovid
 AND    a.structured_type_ovid = st.structured_type_ovid
 AND    a.datatype_kind = 'Structured Type'
 AND    st.structured_type_ovid = v_st_ovid
 ORDER BY e.entity_name,
          a.attribute_name;
rec_used_in_entities cur_used_in_entities%ROWTYPE;

BEGIN

  UTL_FILE.PUT_LINE(log_file, TO_CHAR(SYSDATE,'yy.mm.dd hh:mi:ss') ||' '|| 'Gathering data for single structured type started ...');
  
  DBMS_LOB.CREATETEMPORARY(res, TRUE);

  DBMS_LOB.APPEND (res,'<' || single_st_prefix || ':StructuredType xmlns:' || single_st_prefix || '="http://oracle.com/datamodeler/reports/structuredtype">');
  
  FOR rec_general_data IN cur_general_data(v_str_type_ovid) LOOP

    DBMS_LOB.APPEND (res, rec_general_data.design_name);
    DBMS_LOB.APPEND (res, rec_general_data.version_date);
    DBMS_LOB.APPEND (res, rec_general_data.version_comment);
    DBMS_LOB.APPEND (res, rec_general_data.model_name);

  END LOOP;
  
   FOR rec_st IN cur_st(v_str_type_ovid) LOOP
      DBMS_LOB.APPEND (res, rec_st.stName);
      DBMS_LOB.APPEND (res, rec_st.super_type);
   END LOOP;
   
   -- Description / Notes
   IF (reportTemplate.reportType = 0 OR reportTemplate.useDescriptionInfo = 1) THEN

     DBMS_LOB.APPEND (res, '<' || single_st_prefix || ':DescriptionNotes>');
     
     SELECT XMLElement(EVALNAME(single_st_prefix || ':Description'), XMLCDATA(
              NVL((SELECT t.text comments_in_rdbms
                  FROM   dmrs_large_text t
                  WHERE  t.ovid = v_str_type_ovid
                  AND    t.type='Comments'),
                  (SELECT t.text comments_in_rdbms
                  FROM   dmrs_large_text t
                  WHERE  t.ovid = v_str_type_ovid
                  AND    t.type='CommentsInRDBMS')))).getClobVal(), 
            XMLElement(EVALNAME(single_st_prefix || ':Notes'), XMLCDATA(
                  (SELECT t.text comments_in_rdbms
                  FROM   dmrs_large_text t
                  WHERE  t.ovid = v_str_type_ovid
                  AND    t.type='Note'))).getClobVal()
     INTO   v_description, 
            v_notes
     FROM  dual;

    DBMS_LOB.APPEND (res, v_description);
    DBMS_LOB.APPEND (res, v_notes);
    DBMS_LOB.APPEND (res, '</' || single_st_prefix || ':DescriptionNotes>');
     
   END IF;
  
   -- Diagrams
   IF (reportTemplate.reportType = 0 OR reportTemplate.useDiagrams = 1) THEN
     FOR rec_diagrams IN cur_diagrams(v_str_type_ovid, v_report_name) LOOP
        IF (cur_diagrams%ROWCOUNT = 1) THEN
          DBMS_LOB.APPEND (res,'<' || single_st_prefix || ':DiagramsCollection>');
        END IF;
          
          DBMS_LOB.APPEND (res, rec_diagrams.pdf_name);

        IF (cur_diagrams%ROWCOUNT = rec_diagrams.total_row_count) THEN
         DBMS_LOB.APPEND (res, '</' || single_st_prefix || ':DiagramsCollection>');
        END IF;
     END LOOP;
   END IF;
  
   -- Attributes
   IF (reportTemplate.reportType = 0 OR reportTemplate.useSTAttributes = 1) THEN
     FOR rec_st_attr IN cur_st_attr(v_str_type_ovid) LOOP
        IF (cur_st_attr%ROWCOUNT = 1) THEN
          DBMS_LOB.APPEND (res,'<' || single_st_prefix || ':AttributesCollection>');
        END IF;

          DBMS_LOB.APPEND (res, '<' || single_st_prefix || ':AttributeDetails>');
          DBMS_LOB.APPEND (res, '<' || single_st_prefix || ':Sequence>' || TO_CHAR(v_seq) || '</' || single_st_prefix || ':Sequence>');
          DBMS_LOB.APPEND (res, rec_st_attr.attr_name);
          DBMS_LOB.APPEND (res, rec_st_attr.m);
          IF (INSTR(LOWER(rec_st_attr.data_type),'unknown') = 0) THEN
             DBMS_LOB.APPEND (res, rec_st_attr.data_type);
          ELSE
             SELECT XMLElement(EVALNAME(single_st_prefix || ':DataType'), '').getClobVal() INTO token_value FROM dual;
             DBMS_LOB.APPEND (res, token_value);
          END IF;
          DBMS_LOB.APPEND (res, rec_st_attr.dt_kind);
          DBMS_LOB.APPEND (res, rec_st_attr.domain_name);
          DBMS_LOB.APPEND (res,'</' || single_st_prefix || ':AttributeDetails>');

        IF (cur_st_attr%ROWCOUNT = rec_st_attr.total_row_count) THEN
          DBMS_LOB.APPEND (res, '</' || single_st_prefix || ':AttributesCollection>');
        END IF;
        v_seq := v_seq + 1;
     END LOOP;
   END IF;
  
   v_seq := 1;
   -- Attribute Comments
   IF (reportTemplate.reportType = 0 OR reportTemplate.useSTAttributesComments = 1) THEN
     FOR rec_attributes_comments IN cur_attributes_comments(v_str_type_ovid) LOOP
        IF (cur_attributes_comments%ROWCOUNT = 1) THEN
          DBMS_LOB.APPEND (res,'<' || single_st_prefix || ':AttributesCommentsCollection>');
        END IF;

          DBMS_LOB.APPEND (res, '<' || single_st_prefix || ':AttributeCommentsDetails>');
          DBMS_LOB.APPEND (res, '<' || single_st_prefix || ':AttributeCommentsSequence>' || TO_CHAR(v_seq) || '</' || single_st_prefix || ':AttributeCommentsSequence>');
          DBMS_LOB.APPEND (res, rec_attributes_comments.attribute_name);
          DBMS_LOB.APPEND (res, rec_attributes_comments.attribute_description);
          DBMS_LOB.APPEND (res, rec_attributes_comments.attribute_notes);
          DBMS_LOB.APPEND (res,'</' || single_st_prefix || ':AttributeCommentsDetails>');

        IF (cur_attributes_comments%ROWCOUNT = rec_attributes_comments.total_row_count) THEN
          DBMS_LOB.APPEND (res, '</' || single_st_prefix || ':AttributesCommentsCollection>');
        END IF;
        v_seq := v_seq + 1;
     END LOOP;
   END IF;

   v_seq := 1;
   IF (reportTemplate.reportType = 0 OR reportTemplate.useSTMethods = 1) THEN
     FOR rec_st_methods IN cur_st_methods(v_str_type_ovid) LOOP
        IF (cur_st_methods%ROWCOUNT = 1) THEN
          DBMS_LOB.APPEND (res,'<' || single_st_prefix || ':MethodsCollection>');
        END IF;
            
            DBMS_LOB.APPEND (res, '<' || single_st_prefix || ':MethodDetails>');
            DBMS_LOB.APPEND (res, '<' || single_st_prefix || ':MethodSequence>' || TO_CHAR(v_seq) || '</' || single_st_prefix || ':MethodSequence>');
            DBMS_LOB.APPEND (res, rec_st_methods.m_name);
            DBMS_LOB.APPEND (res, rec_st_methods.m_constr);
            DBMS_LOB.APPEND (res, rec_st_methods.m_overriding);
            DBMS_LOB.APPEND (res, rec_st_methods.m_om_name);
            DBMS_LOB.APPEND (res, rec_st_methods.m_return_type);
            
            FOR rec_st_methods_p IN cur_st_methods_p(rec_st_methods.method_ovid) LOOP
               IF (cur_st_methods_p%ROWCOUNT = 1) THEN
                 DBMS_LOB.APPEND (res,'<' || single_st_prefix || ':MethodParametersCollection>');
               END IF;

                 DBMS_LOB.APPEND (res, '<' || single_st_prefix || ':MethodParameterDetails>');
                 DBMS_LOB.APPEND (res, rec_st_methods_p.param_name);
                 DBMS_LOB.APPEND (res, rec_st_methods_p.param_type);
                 DBMS_LOB.APPEND (res, '</' || single_st_prefix || ':MethodParameterDetails>');

               IF (cur_st_methods_p%ROWCOUNT = rec_st_methods_p.total_row_count) THEN
                 DBMS_LOB.APPEND (res, '</' || single_st_prefix || ':MethodParametersCollection>');
               END IF;
            END LOOP;       
           
            DBMS_LOB.APPEND (res, '</' || single_st_prefix || ':MethodDetails>');
            
        IF (cur_st_methods%ROWCOUNT = rec_st_methods.total_row_count) THEN
          DBMS_LOB.APPEND (res, '</' || single_st_prefix || ':MethodsCollection>');
        END IF;
        v_seq := v_seq + 1;
     END LOOP;
   END IF;

   -- Used in tables
   IF (reportTemplate.reportType = 0 OR reportTemplate.useSTUsedInTables = 1) THEN
     FOR rec_used_in_tables IN cur_used_in_tables(v_str_type_ovid) LOOP
        IF (cur_used_in_tables%ROWCOUNT = 1) THEN
           DBMS_LOB.APPEND (res,'<' || single_st_prefix || ':TablesCollection>');
        END IF;
           DBMS_LOB.APPEND (res,'<' || single_st_prefix || ':TableDetails>');

           v_model_name := rec_used_in_tables.model_name;
           IF (v_model_name != p_model_name) THEN
             DBMS_LOB.APPEND (res,v_model_name);
             p_model_name := v_model_name;
           ELSE
             DBMS_LOB.APPEND (res,'<' || single_st_prefix || ':ModelName></' || single_st_prefix || ':ModelName>');
           END IF;

           v_table_name := rec_used_in_tables.table_name;
           IF (v_table_name != p_table_name) THEN
           DBMS_LOB.APPEND (res,v_table_name);
             p_table_name := v_table_name;
           ELSE
             DBMS_LOB.APPEND (res,'<' || single_st_prefix || ':TableName></' || single_st_prefix || ':TableName>');
           END IF;

           DBMS_LOB.APPEND (res,rec_used_in_tables.column_name);
           DBMS_LOB.APPEND (res,'</' || single_st_prefix || ':TableDetails>');
        IF (cur_used_in_tables%ROWCOUNT = rec_used_in_tables.total_row_count) THEN
           DBMS_LOB.APPEND (res, '</' || single_st_prefix || ':TablesCollection>');
        END IF;
     END LOOP;
   END IF;

   -- Used in entities
   IF (reportTemplate.reportType = 0 OR reportTemplate.useSTUsedInEntities = 1) THEN
     FOR rec_used_in_entities IN cur_used_in_entities(v_str_type_ovid) LOOP
        IF (cur_used_in_entities%ROWCOUNT = 1) THEN
           DBMS_LOB.APPEND (res,'<' || single_st_prefix || ':EntitiesCollection>');
        END IF;
           DBMS_LOB.APPEND (res,'<' || single_st_prefix || ':EntityDetails>');
          
           v_entity_name := rec_used_in_entities.entity_name;
           IF (v_entity_name != p_entity_name) THEN
             DBMS_LOB.APPEND (res,v_entity_name);
             p_entity_name := v_entity_name;
           ELSE
             DBMS_LOB.APPEND (res,'<' || single_st_prefix || ':EntityName></' || single_st_prefix || ':EntityName>');
           END IF;

           DBMS_LOB.APPEND (res,rec_used_in_entities.attribute_name);
           DBMS_LOB.APPEND (res,'</' || single_st_prefix || ':EntityDetails>');
        IF (cur_used_in_entities%ROWCOUNT = rec_used_in_entities.total_row_count) THEN
           DBMS_LOB.APPEND (res, '</' || single_st_prefix || ':EntitiesCollection>');
        END IF;
     END LOOP;
   END IF;

  DBMS_LOB.APPEND (res,'</' || single_st_prefix || ':StructuredType>');

  UTL_FILE.PUT_LINE(log_file, TO_CHAR(SYSDATE,'yy.mm.dd hh:mi:ss') ||' '|| 'Gathering data for single structured type ended');  

RETURN res;
  
 EXCEPTION
 WHEN others THEN
  UTL_FILE.PUT_LINE(log_file, 'Pkg_Osdm_Utils.Gather_SingleST_Data Exception : ' || SQLERRM);  
  UTL_FILE.PUT_LINE(log_file, 'Pkg_Osdm_Utils.Gather_SingleST_Data Exception : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  RETURN res;
 
END Gather_SingleST_Data;

FUNCTION Gather_AllST_Data(v_model_ovid IN VARCHAR2, reportTemplate IN REPORT_TEMPLATE, objects IN OBJECTS_LIST, v_report_name IN VARCHAR2) RETURN CLOB IS 

res               CLOB;
v_notes           CLOB;
v_description     CLOB;
v_rel_total_count INTEGER;
token_value       CLOB;
v_seq             INTEGER := 1;
p_model_name      VARCHAR2(100) :='_';
v_model_name      VARCHAR2(100) :='';
p_table_name      VARCHAR2(100) :='_';
v_table_name      VARCHAR2(100) :='';
p_entity_name     VARCHAR2(100) :='_';
v_entity_name     VARCHAR2(100) :='';

-- General data
CURSOR cur_general_data(v_m_ovid IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(all_st_prefix || ':DesignName'),d.design_name).getClobVal()                                        design_name,
        XMLElement(EVALNAME(all_st_prefix || ':VersionDate'),TO_CHAR(d.date_published,'dd.mm.yyyy hh24:mi:ss')).getClobVal()   version_date,
        XMLElement(EVALNAME(all_st_prefix || ':VersionComment'),XMLCDATA(d.version_comments)).getClobVal()                     version_comment,
        XMLElement(EVALNAME(all_st_prefix || ':ModelName'),m.model_name).getClobVal()                                          model_name
 FROM   dmrs_designs d, 
        dmrs_models m
 WHERE  d.design_ovid = m.design_ovid
 AND    m.model_ovid = v_model_ovid;
rec_general_data cur_general_data%ROWTYPE;

-- All structured types general data
CURSOR cur_all_st(v_m_ovid IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(all_st_prefix || ':STName'),st.structured_type_name).getClobVal()                                    st_name,
        XMLElement(EVALNAME(all_st_prefix || ':EncodedSTName'),st.structured_type_ovid).getClobVal()                             xml_ovid,
 		XMLElement(EVALNAME(all_st_prefix || ':STSuperType'),(SELECT st1.structured_type_name 
                                            FROM  dmrs_structured_types st1 
                                            WHERE st.super_type_ovid = st1.structured_type_ovid)).getClobVal() super_type,
        st.structured_type_ovid                                                                                					st_ovid,

        COUNT(st.structured_type_name) over()                                                                  					total_row_count
 FROM   dmrs_structured_types st
 WHERE  st.model_ovid = v_m_ovid
 AND    st.structured_type_ovid MEMBER OF objects
 ORDER BY st.structured_type_name;
rec_all_st cur_all_st%ROWTYPE;

-- Diagrams
CURSOR cur_diagrams(v_t_ovid IN VARCHAR2, v_rep_name IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(all_st_prefix || ':Diagram'), 
          XMLElement(EVALNAME(all_st_prefix || ':Name'), v_rep_name || '_files/' || REGEXP_REPLACE(SUBSTR(d.pdf_name, 1, INSTR(d.pdf_name, '.PDF')-1), '[^a-zA-Z1-9_]', '_') || '.pdf'),
          XMLElement(EVALNAME(all_st_prefix || ':Suffix'), NULL)).getClobVal()                                                                                                            pdf_name,
        COUNT(d.pdf_name) over()                                                                                                                                                          total_row_count
 FROM   dmrs_vdiagrams d,
       (SELECT diagram_ovid 
        FROM   dmrs_diagram_elements
        WHERE  ovid = v_t_ovid) b
 WHERE d.ovid = b.diagram_ovid
 AND   d.diagram_type = 'Subview'
 AND   d.is_display = 'N';
rec_diagrams cur_diagrams%ROWTYPE;

--Attributes
CURSOR cur_st_attr(v_st_ovid IN VARCHAR2) IS
SELECT  XMLElement(EVALNAME(all_st_prefix || ':AttributeName'), sta.attribute_name).getClobVal()                                                                                 attr_name,
        XMLElement(EVALNAME(all_st_prefix || ':M'),DECODE(sta.mandatory,'N','','Y')).getClobVal()                                                                                m,
        XMLElement(EVALNAME(all_st_prefix || ':DataTypeKind'),DECODE(sta.datatype_kind,                                                                                           
                                                 'Domain',         'DOM',
                                                 'Logical Type',   'LT',
                                                 'Distinct Type',  'DT',
                                                 'Ref Struct Type','RST',
                                                 'Structured Type','ST',
                                                 'Collection Type','CT')
                  ).getClobVal()                                                                                                                               dt_kind,
         XMLElement(EVALNAME(all_st_prefix || ':DataType'), 
            DECODE(sta.datatype_kind, 
                  'Domain', sta.type_name ||' '||
                           DECODE (NVL(sta.t_size,''),'',
                              DECODE(NVL(sta.t_scale,0),0,
                                 DECODE(NVL(sta.t_precision,0),0,null,'('|| DECODE(NVL(sta.t_precision,0),0,null,sta.t_precision) ||')'),
                                   '('|| DECODE(NVL(sta.t_precision,0),0,null,sta.t_precision) || ',' || DECODE(NVL(sta.t_scale,0),0,null,sta.t_scale)||')'),
                                   '('||TRIM(DECODE(sta.t_size,'',null,sta.t_size||' '||sta.char_units ))||')'),
                   'Logical Type', sta.type_name  ||' '|| 
                           DECODE (NVL(sta.t_size,''),'',
                              DECODE(NVL(sta.t_scale,0),0,
                                 DECODE(NVL(sta.t_precision,0),0,null,'('|| DECODE(NVL(sta.t_precision,0),0,null,sta.t_precision) ||')'),
                                   '('|| DECODE(NVL(sta.t_precision,0),0,null,sta.t_precision) || ',' || DECODE(NVL(sta.t_scale,0),0,null,sta.t_scale)||')'),
                                   '('||TRIM(DECODE(sta.t_size,'',null,sta.t_size||' '||sta.char_units ))||')')
            )).getClobVal()                                                                                                                                    data_type,
        XMLElement(EVALNAME(all_st_prefix || ':DomainName'),DECODE(sta.domain_name,'Unknown',null,sta.domain_name)).getClobVal()                                                 domain_name,
      COUNT(sta.attribute_name) over()                                                                                                                         total_row_count
FROM  dmrs_struct_type_attrs sta,
      dmrs_structured_types st
WHERE sta.structured_type_ovid = st.structured_type_ovid
AND   st.structured_type_ovid = v_st_ovid;
rec_st_attr cur_st_attr%ROWTYPE;

-- Attributes Comments Data
CURSOR cur_attributes_comments(v_st_ovid IN VARCHAR2) IS
 SELECT a.attribute_name                              attribute_name, 
        a.attribute_description                       attribute_description, 
        a.attribute_notes                             attribute_notes,
        COUNT(a.attribute_name) over()                total_row_count
 FROM (
  SELECT XMLElement(EVALNAME(all_st_prefix || ':AttributeCommentsName'),a.attribute_name).getStringVal()          attribute_name,
         XMLElement(EVALNAME(all_st_prefix || ':AttributeDescription'),XMLCDATA(
            NVL((SELECT t.text comments_in_rdbms
                 FROM   dmrs_large_text t
                 WHERE  t.ovid = a.attribute_ovid
                 AND    t.type='Comments'),
                (SELECT t.text comments_in_rdbms
                FROM   dmrs_large_text t
                WHERE  t.ovid = a.attribute_ovid
                AND    t.type='CommentsInRDBMS')))).getClobVal()                                                  attribute_description, 
         XMLElement(EVALNAME(all_st_prefix || ':AttributeNotes'),XMLCDATA(
                (SELECT t.text comments_in_rdbms
                FROM   dmrs_large_text t
                WHERE  t.ovid = a.attribute_ovid
                AND    t.type='Note'))).getClobVal()                                                              attribute_notes
  FROM   dmrs_struct_type_attrs a
  WHERE  a.structured_type_ovid = v_st_ovid
 ) a
 WHERE DBMS_LOB.getlength(attribute_description) > 0 OR DBMS_LOB.getlength(attribute_notes) > 0;
rec_attributes_comments cur_attributes_comments%ROWTYPE;

-- Methods
CURSOR  cur_st_methods(v_st_ovid IN VARCHAR2) IS
SELECT  XMLElement(EVALNAME(all_st_prefix || ':MethodName'), m.method_name).getClobVal()                           m_name,
        XMLElement(EVALNAME(all_st_prefix || ':MethodConstructor'), DECODE(m.constructor,'N','','Y')).getClobVal() m_constr,
        XMLElement(EVALNAME(all_st_prefix || ':MethodOverriding'), DECODE(m.overriding,'N','','Y')).getClobVal()   m_overriding,
        XMLElement(EVALNAME(all_st_prefix || ':MethodOverridenMethod'), m.overridden_method_name).getClobVal()     m_om_name,
        XMLElement(EVALNAME(all_st_prefix || ':MethodReturnValue'), 
        (SELECT sp.type_name  ||' '|| 
                DECODE (NVL(sp.t_size,''),'',
                 DECODE(NVL(sp.t_scale,0),0,
                  DECODE(NVL(sp.t_precision,0),0,null,'('|| DECODE(NVL(sp.t_precision,0),0,null,sp.t_precision) ||')'),
                  '('|| DECODE(NVL(sp.t_precision,0),0,null,sp.t_precision) || ',' || DECODE(NVL(sp.t_scale,0),0,null,sp.t_scale)||')'),
                  '('||TRIM(DECODE(sp.t_size,'',null,sp.t_size ))||')')
         FROM   dmrs_struct_type_method_pars sp 
         WHERE  return_value= 'Y'
         AND    sp.method_ovid = m.method_ovid)).getClobVal()                                    m_return_type,        
        COUNT(m.method_name) over()                                                              total_row_count,
        m.method_ovid                                                                            method_ovid
FROM dmrs_struct_type_methods m,
     dmrs_structured_types st
WHERE m.structured_type_ovid = st.structured_type_ovid
AND   st.structured_type_ovid = v_st_ovid;
rec_st_methods cur_st_methods%ROWTYPE;

-- Method params
CURSOR cur_st_methods_p(v_m_ovid IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(all_st_prefix || ':ParameterName'), parameter_name).getClobVal()  param_name,
        XMLElement(EVALNAME(all_st_prefix || ':ParameterType'), 
        type_name  ||' '|| 
                DECODE (NVL(t_size,0),0,
                 DECODE(NVL(t_scale,0),0,
                  DECODE(NVL(t_precision,0),0,null,'('|| DECODE(NVL(t_precision,0),0,null,t_precision) ||')'),
                  '('|| DECODE(NVL(t_precision,0),0,null,t_precision) || ',' || DECODE(NVL(t_scale,0),0,null,t_scale)||')'),
                  '('||TRIM(DECODE(t_size,0,null,t_size ))||')')
        ).getClobVal()       param_type,
        COUNT(parameter_name) over()                                        total_row_count
 FROM   dmrs_struct_type_method_pars
 WHERE  method_ovid = v_m_ovid
 AND    return_value = 'N'
 ORDER BY seq;
rec_st_methods_p cur_st_methods_p%ROWTYPE;

-- Used In tables
CURSOR cur_used_in_tables(v_st_ovid IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(all_st_prefix || ':ModelName'), m.model_name).getClobVal()     model_name,
        XMLElement(EVALNAME(all_st_prefix || ':TableName'), t.table_name).getClobVal()     table_name,
        XMLElement(EVALNAME(all_st_prefix || ':ColumnName'), c.column_name).getClobVal()   column_name,
        COUNT(m.model_name) over()                                       total_row_count
 FROM   dmrs_tables t,
        dmrs_columns c,
        dmrs_structured_types st,
        dmrs_models  m
 WHERE  t.ovid = c.container_ovid
 AND    c.structured_type_ovid = st.structured_type_ovid
 AND    m.model_ovid = t.model_ovid
 AND    c.datatype_kind = 'Structured Type'
 AND    st.structured_type_ovid = v_st_ovid
 ORDER BY m.model_name,
          t.table_name,
          c.column_name;
rec_used_in_tables cur_used_in_tables%ROWTYPE;

-- Used In entities
CURSOR cur_used_in_entities(v_st_ovid IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(all_st_prefix || ':EntityName'), e.entity_name).getClobVal()        entity_name,
        XMLElement(EVALNAME(all_st_prefix || ':AttributeName'), a.attribute_name).getClobVal()  attribute_name,
        COUNT(e.entity_name) over()                                           total_row_count
 FROM   dmrs_entities e,
        dmrs_attributes a,
        dmrs_structured_types st
 WHERE  e.ovid = a.container_ovid
 AND    a.structured_type_ovid = st.structured_type_ovid
 AND    a.datatype_kind = 'Structured Type'
 AND    st.structured_type_ovid = v_st_ovid
 ORDER BY e.entity_name,
          a.attribute_name;
rec_used_in_entities cur_used_in_entities%ROWTYPE;

BEGIN

  UTL_FILE.PUT_LINE(log_file, TO_CHAR(SYSDATE,'yy.mm.dd hh:mi:ss') ||' '|| 'Gathering data for all structured types started ...');
  
  DBMS_LOB.CREATETEMPORARY(res, TRUE);

  DBMS_LOB.APPEND (res,'<' || all_st_prefix || ':StructuredTypes xmlns:' || all_st_prefix || '="http://oracle.com/datamodeler/reports/structuredtypes">');
  
  FOR rec_general_data IN cur_general_data(v_model_ovid) LOOP

    DBMS_LOB.APPEND (res, rec_general_data.design_name);
    DBMS_LOB.APPEND (res, rec_general_data.version_date);
    DBMS_LOB.APPEND (res, rec_general_data.version_comment);
    DBMS_LOB.APPEND (res, rec_general_data.model_name);

  END LOOP;

  -- All structured types
  FOR rec_all_st IN cur_all_st(v_model_ovid) LOOP

      IF (cur_all_st%ROWCOUNT = 1) THEN
           DBMS_LOB.APPEND (res,'<' || all_st_prefix || ':STCollection>');
      END IF;
      
      DBMS_LOB.APPEND (res,'<' || all_st_prefix || ':STDetails>');

      DBMS_LOB.APPEND (res, rec_all_st.st_name);
      DBMS_LOB.APPEND (res, rec_all_st.xml_ovid);
      DBMS_LOB.APPEND (res, rec_all_st.super_type);
      
      -- Description / Notes
      IF (reportTemplate.reportType = 0 OR reportTemplate.useDescriptionInfo = 1) THEN
      
         DBMS_LOB.APPEND (res, '<' || all_st_prefix || ':DescriptionNotes>');
         
         SELECT XMLElement(EVALNAME(all_st_prefix || ':Description'), XMLCDATA(
                  NVL((SELECT t.text comments_in_rdbms
                      FROM   dmrs_large_text t
                      WHERE  t.ovid = rec_all_st.st_ovid
                      AND    t.type='Comments'),
                      (SELECT t.text comments_in_rdbms
                      FROM   dmrs_large_text t
                      WHERE  t.ovid = rec_all_st.st_ovid
                      AND    t.type='CommentsInRDBMS')))).getClobVal(), 
                XMLElement(EVALNAME(all_st_prefix || ':Notes'), XMLCDATA(
                      (SELECT t.text comments_in_rdbms
                      FROM   dmrs_large_text t
                      WHERE  t.ovid = rec_all_st.st_ovid
                      AND    t.type='Note'))).getClobVal()
         INTO   v_description, 
                v_notes
         FROM  dual;
        
        DBMS_LOB.APPEND (res, v_description);
        DBMS_LOB.APPEND (res, v_notes);
        DBMS_LOB.APPEND (res, '</' || all_st_prefix || ':DescriptionNotes>');
         
      END IF;
      
       -- Diagrams
       IF (reportTemplate.reportType = 0 OR reportTemplate.useDiagrams = 1) THEN
         FOR rec_diagrams IN cur_diagrams(rec_all_st.st_ovid, v_report_name) LOOP
            IF (cur_diagrams%ROWCOUNT = 1) THEN
              DBMS_LOB.APPEND (res,'<' || all_st_prefix || ':DiagramsCollection>');
            END IF;
              
              DBMS_LOB.APPEND (res, rec_diagrams.pdf_name);
       
            IF (cur_diagrams%ROWCOUNT = rec_diagrams.total_row_count) THEN
             DBMS_LOB.APPEND (res, '</' || all_st_prefix || ':DiagramsCollection>');
            END IF;
         END LOOP;
       END IF;

      v_seq := 1;
      -- Attributes
      IF (reportTemplate.reportType = 0 OR reportTemplate.useSTAttributes = 1) THEN
        FOR rec_st_attr IN cur_st_attr(rec_all_st.st_ovid) LOOP
           IF (cur_st_attr%ROWCOUNT = 1) THEN
             DBMS_LOB.APPEND (res,'<' || all_st_prefix || ':AttributesCollection>');
           END IF;
      
             DBMS_LOB.APPEND (res, '<' || all_st_prefix || ':AttributeDetails>');
             DBMS_LOB.APPEND (res, '<' || all_st_prefix || ':Sequence>' || TO_CHAR(v_seq) || '</' || all_st_prefix || ':Sequence>');
             DBMS_LOB.APPEND (res, rec_st_attr.attr_name);
             DBMS_LOB.APPEND (res, rec_st_attr.m);
             IF (INSTR(LOWER(rec_st_attr.data_type),'unknown') = 0) THEN
                DBMS_LOB.APPEND (res, rec_st_attr.data_type);
             ELSE
                SELECT XMLElement(EVALNAME(all_st_prefix || ':DataType'), '').getClobVal() INTO token_value FROM dual;
                DBMS_LOB.APPEND (res, token_value);
             END IF;
             DBMS_LOB.APPEND (res, rec_st_attr.dt_kind);
             DBMS_LOB.APPEND (res, rec_st_attr.domain_name);
             DBMS_LOB.APPEND (res,'</' || all_st_prefix || ':AttributeDetails>');
      
           IF (cur_st_attr%ROWCOUNT = rec_st_attr.total_row_count) THEN
             DBMS_LOB.APPEND (res, '</' || all_st_prefix || ':AttributesCollection>');
           END IF;
           v_seq := v_seq + 1;
        END LOOP;
      END IF;

      v_seq := 1;
      -- Attribute Comments
      IF (reportTemplate.reportType = 0 OR reportTemplate.useSTAttributesComments = 1) THEN
        FOR rec_attributes_comments IN cur_attributes_comments(rec_all_st.st_ovid) LOOP
           IF (cur_attributes_comments%ROWCOUNT = 1) THEN
             DBMS_LOB.APPEND (res,'<' || all_st_prefix || ':AttributesCommentsCollection>');
           END IF;
      
            DBMS_LOB.APPEND (res, '<' || all_st_prefix || ':AttributeCommentsDetails>');
            
            DBMS_LOB.APPEND (res, '<' || all_st_prefix || ':AttributeCommentsSequence>' || TO_CHAR(v_seq) || '</' || all_st_prefix || ':AttributeCommentsSequence>');
            DBMS_LOB.APPEND (res, rec_attributes_comments.attribute_name);
            DBMS_LOB.APPEND (res, rec_attributes_comments.attribute_description);
            DBMS_LOB.APPEND (res, rec_attributes_comments.attribute_notes); 
            DBMS_LOB.APPEND (res,'</' || all_st_prefix || ':AttributeCommentsDetails>');
      
           IF (cur_attributes_comments%ROWCOUNT = rec_attributes_comments.total_row_count) THEN
             DBMS_LOB.APPEND (res, '</' || all_st_prefix || ':AttributesCommentsCollection>');
           END IF;
           v_seq := v_seq + 1;
        END LOOP;
      END IF;

      v_seq := 1;
      IF (reportTemplate.reportType = 0 OR reportTemplate.useSTMethods = 1) THEN
        FOR rec_st_methods IN cur_st_methods(rec_all_st.st_ovid) LOOP
           IF (cur_st_methods%ROWCOUNT = 1) THEN
             DBMS_LOB.APPEND (res,'<' || all_st_prefix || ':MethodsCollection>');
           END IF;
               
               DBMS_LOB.APPEND (res, '<' || all_st_prefix || ':MethodDetails>');
               DBMS_LOB.APPEND (res, '<' || all_st_prefix || ':MethodSequence>' || TO_CHAR(v_seq) || '</' || all_st_prefix || ':MethodSequence>');
               DBMS_LOB.APPEND (res, rec_st_methods.m_name);
               DBMS_LOB.APPEND (res, rec_st_methods.m_constr);
               DBMS_LOB.APPEND (res, rec_st_methods.m_overriding);
               DBMS_LOB.APPEND (res, rec_st_methods.m_om_name);
               DBMS_LOB.APPEND (res, rec_st_methods.m_return_type);
               
               FOR rec_st_methods_p IN cur_st_methods_p(rec_st_methods.method_ovid) LOOP
                  IF (cur_st_methods_p%ROWCOUNT = 1) THEN
                    DBMS_LOB.APPEND (res,'<' || all_st_prefix || ':MethodParametersCollection>');
                  END IF;
      
                    DBMS_LOB.APPEND (res, '<' || all_st_prefix || ':MethodParameterDetails>');
                    DBMS_LOB.APPEND (res, rec_st_methods_p.param_name);
                    DBMS_LOB.APPEND (res, rec_st_methods_p.param_type);
                    DBMS_LOB.APPEND (res, '</' || all_st_prefix || ':MethodParameterDetails>');
      
                  IF (cur_st_methods_p%ROWCOUNT = rec_st_methods_p.total_row_count) THEN
                    DBMS_LOB.APPEND (res, '</' || all_st_prefix || ':MethodParametersCollection>');
                  END IF;
               END LOOP;       
              
               DBMS_LOB.APPEND (res, '</' || all_st_prefix || ':MethodDetails>');
               
           IF (cur_st_methods%ROWCOUNT = rec_st_methods.total_row_count) THEN
             DBMS_LOB.APPEND (res, '</' || all_st_prefix || ':MethodsCollection>');
           END IF;
           v_seq := v_seq + 1;
        END LOOP;
      END IF;

      -- Used in tables
      IF (reportTemplate.reportType = 0 OR reportTemplate.useSTUsedInTables = 1) THEN
        FOR rec_used_in_tables IN cur_used_in_tables(rec_all_st.st_ovid) LOOP
           IF (cur_used_in_tables%ROWCOUNT = 1) THEN
              DBMS_LOB.APPEND (res,'<' || all_st_prefix || ':TablesCollection>');
           END IF;
              DBMS_LOB.APPEND (res,'<' || all_st_prefix || ':TableDetails>');
      
              v_model_name := rec_used_in_tables.model_name;
              IF (v_model_name != p_model_name) THEN
                DBMS_LOB.APPEND (res,v_model_name);
                p_model_name := v_model_name;
              ELSE
                DBMS_LOB.APPEND (res,'<' || all_st_prefix || ':ModelName></' || all_st_prefix || ':ModelName>');
              END IF;
      
              v_table_name := rec_used_in_tables.table_name;
              IF (v_table_name != p_table_name) THEN
              DBMS_LOB.APPEND (res,v_table_name);
                p_table_name := v_table_name;
              ELSE
                DBMS_LOB.APPEND (res,'<' || all_st_prefix || ':TableName></' || all_st_prefix || ':TableName>');
              END IF;
      
              DBMS_LOB.APPEND (res,rec_used_in_tables.column_name);
              DBMS_LOB.APPEND (res,'</' || all_st_prefix || ':TableDetails>');
           IF (cur_used_in_tables%ROWCOUNT = rec_used_in_tables.total_row_count) THEN
              DBMS_LOB.APPEND (res, '</' || all_st_prefix || ':TablesCollection>');
           END IF;
        END LOOP;
      END IF;
      
      -- Used in entities
      IF (reportTemplate.reportType = 0 OR reportTemplate.useSTUsedInEntities = 1) THEN
        FOR rec_used_in_entities IN cur_used_in_entities(rec_all_st.st_ovid) LOOP
           IF (cur_used_in_entities%ROWCOUNT = 1) THEN
              DBMS_LOB.APPEND (res,'<' || all_st_prefix || ':EntitiesCollection>');
           END IF;
              DBMS_LOB.APPEND (res,'<' || all_st_prefix || ':EntityDetails>');
             
              v_entity_name := rec_used_in_entities.entity_name;
              IF (v_entity_name != p_entity_name) THEN
                DBMS_LOB.APPEND (res,v_entity_name);
                p_entity_name := v_entity_name;
              ELSE
                DBMS_LOB.APPEND (res,'<' || all_st_prefix || ':EntityName></' || all_st_prefix || ':EntityName>');
              END IF;
      
              DBMS_LOB.APPEND (res,rec_used_in_entities.attribute_name);
              DBMS_LOB.APPEND (res,'</' || all_st_prefix || ':EntityDetails>');
           IF (cur_used_in_entities%ROWCOUNT = rec_used_in_entities.total_row_count) THEN
              DBMS_LOB.APPEND (res, '</' || all_st_prefix || ':EntitiesCollection>');
           END IF;
        END LOOP;
      END IF;

      DBMS_LOB.APPEND (res,'</' || all_st_prefix || ':STDetails>');

      IF (cur_all_st%ROWCOUNT = rec_all_st.total_row_count) THEN
          DBMS_LOB.APPEND (res,'</' || all_st_prefix || ':STCollection>');
      END IF;

  END LOOP;
  
  DBMS_LOB.APPEND (res,'</' || all_st_prefix || ':StructuredTypes>');

  UTL_FILE.PUT_LINE(log_file, TO_CHAR(SYSDATE,'yy.mm.dd hh:mi:ss') ||' '|| 'Gathering data for all structured types ended');  

RETURN res;
  
 EXCEPTION
 WHEN others THEN
  UTL_FILE.PUT_LINE(log_file, 'Pkg_Osdm_Utils.Gather_AllST_Data Exception : ' || SQLERRM);  
  UTL_FILE.PUT_LINE(log_file, 'Pkg_Osdm_Utils.Gather_AllST_Data Exception : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  RETURN res;
 
END Gather_AllST_Data;

FUNCTION Gather_SingleCT_Data(v_ct_type_ovid IN VARCHAR2, reportTemplate IN REPORT_TEMPLATE) RETURN CLOB IS 

res               CLOB;
v_notes           CLOB;
v_description     CLOB;
v_rel_total_count INTEGER;
token_value       CLOB;
p_model_name      VARCHAR2(100) :='_';
v_model_name      VARCHAR2(100) :='';
p_table_name      VARCHAR2(100) :='_';
v_table_name      VARCHAR2(100) :='';
p_entity_name     VARCHAR2(100) :='_';
v_entity_name     VARCHAR2(100) :='';

-- General data
CURSOR cur_general_data(v_ct_ovid IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(single_ct_prefix || ':DesignName'),d.design_name).getClobVal()                                        design_name,
        XMLElement(EVALNAME(single_ct_prefix || ':VersionDate'),TO_CHAR(d.date_published,'dd.mm.yyyy hh24:mi:ss')).getClobVal()   version_date,
        XMLElement(EVALNAME(single_ct_prefix || ':VersionComment'),XMLCDATA(d.version_comments)).getClobVal()                     version_comment,
        XMLElement(EVALNAME(single_ct_prefix || ':ModelName'),m.model_name).getClobVal()                                          model_name
 FROM   dmrs_designs d, 
        dmrs_models m,
        dmrs_collection_types ct
 WHERE  d.design_ovid = m.design_ovid
 AND    ct.model_ovid = m.model_ovid
 AND    ct.collection_type_ovid = v_ct_ovid;
rec_general_data cur_general_data%ROWTYPE;

CURSOR cur_ct_data(v_ct_ovid IN VARCHAR2) IS
 SELECT  XMLElement(EVALNAME(single_ct_prefix || ':CTName'),ct.collection_type_name).getClobVal()                                                                                   ct_name,
         XMLElement(EVALNAME(single_ct_prefix || ':CTType'),ct.c_type).getClobVal()                                                                                                 ct_type,
         XMLElement(EVALNAME(single_ct_prefix || ':CTMaxElements'),ct.max_element).getClobVal()                                                                                     max_element,
         XMLElement(EVALNAME(single_ct_prefix || ':CTDataTypeKind'),DECODE(ct.datatype_kind,
                                                  'Domain',         'DOM',
                                                  'Logical Type',   'LT',
                                                  'Distinct Type',  'DT',
                                                  'Ref Struct Type','RST',
                                                  'Structured Type','ST',
                                                  'Collection Type','CT')
                   ).getClobVal()                                                                                                                               dt_kind,
          XMLElement(EVALNAME(single_ct_prefix || ':CTDataType'), 
             DECODE(ct.datatype_kind, 
                  'Domain', ct.dt_type ||' '||
                           DECODE (NVL(ct.t_size,''),'',
                              DECODE(NVL(ct.t_scale,0),0,
                                 DECODE(NVL(ct.t_precision,0),0,null,'('|| DECODE(NVL(ct.t_precision,0),0,null,ct.t_precision) ||')'),
                                   '('|| DECODE(NVL(ct.t_precision,0),0,null,ct.t_precision) || ',' || DECODE(NVL(ct.t_scale,0),0,null,ct.t_scale)||')'),
                                   '('||TRIM(DECODE(ct.t_size,'',null,ct.t_size||' '||ct.char_units ))||')'),
                   'Logical Type', ct.dt_type  ||' '|| 
                           DECODE (NVL(ct.t_size,''),'',
                              DECODE(NVL(ct.t_scale,0),0,
                                 DECODE(NVL(ct.t_precision,0),0,null,'('|| DECODE(NVL(ct.t_precision,0),0,null,ct.t_precision) ||')'),
                                   '('|| DECODE(NVL(ct.t_precision,0),0,null,ct.t_precision) || ',' || DECODE(NVL(ct.t_scale,0),0,null,ct.t_scale)||')'),
                                   '('||TRIM(DECODE(ct.t_size,'',null,ct.t_size||' '||ct.char_units ))||')')
             )).getClobVal()                                                                                                                                    data_type,
       XMLElement(EVALNAME(single_ct_prefix || ':CTDomainName'),DECODE(ct.domain_name,'Unknown',null,ct.domain_name)).getClobVal()                                                   domain_name
 FROM  dmrs_collection_types ct
 WHERE ct.collection_type_ovid = v_ct_ovid;
rec_ct_data cur_ct_data%ROWTYPE;

-- Used In tables
CURSOR cur_used_in_tables(v_ct_ovid IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(single_ct_prefix || ':ModelName'), m.model_name).getClobVal()     model_name,
        XMLElement(EVALNAME(single_ct_prefix || ':TableName'), t.table_name).getClobVal()     table_name,
        XMLElement(EVALNAME(single_ct_prefix || ':ColumnName'), c.column_name).getClobVal()   column_name,
        COUNT(m.model_name) over()                                       total_row_count
FROM   dmrs_tables t,
        dmrs_columns c,
        dmrs_collection_types ct,
        dmrs_models  m
 WHERE  t.ovid = c.container_ovid
 AND    c.collection_type_ovid = ct.collection_type_ovid
 AND    m.model_ovid = t.model_ovid
 AND    c.datatype_kind = 'Collection Type'
 AND    ct.collection_type_ovid = v_ct_ovid
 ORDER BY m.model_name,
          t.table_name,
          c.column_name;
rec_used_in_tables cur_used_in_tables%ROWTYPE;

-- Used In entities
CURSOR cur_used_in_entities(v_ct_ovid IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(single_ct_prefix || ':EntityName'), e.entity_name).getClobVal()        entity_name,
        XMLElement(EVALNAME(single_ct_prefix || ':AttributeName'), a.attribute_name).getClobVal()  attribute_name,
        COUNT(e.entity_name) over()                                           total_row_count
 FROM   dmrs_entities e,
        dmrs_attributes a,
        dmrs_collection_types ct
 WHERE  e.ovid = a.container_ovid
 AND    a.collection_type_ovid = ct.collection_type_ovid
 AND    a.datatype_kind = 'Collection Type'
 AND    ct.collection_type_ovid = v_ct_ovid
 ORDER BY e.entity_name,
          a.attribute_name;
rec_used_in_entities cur_used_in_entities%ROWTYPE;

BEGIN

  UTL_FILE.PUT_LINE(log_file, TO_CHAR(SYSDATE,'yy.mm.dd hh:mi:ss') ||' '|| 'Gathering data for single collection type started ...');
  
  DBMS_LOB.CREATETEMPORARY(res, TRUE);

  DBMS_LOB.APPEND (res,'<' || single_ct_prefix || ':CollectionType xmlns:' || single_ct_prefix || '="http://oracle.com/datamodeler/reports/collectiontype">');
  
  FOR rec_general_data IN cur_general_data(v_ct_type_ovid) LOOP

    DBMS_LOB.APPEND (res, rec_general_data.design_name);
    DBMS_LOB.APPEND (res, rec_general_data.version_date);
    DBMS_LOB.APPEND (res, rec_general_data.version_comment);
    DBMS_LOB.APPEND (res, rec_general_data.model_name);

  END LOOP;

   -- Description / Notes
   IF (reportTemplate.reportType = 0 OR reportTemplate.useDescriptionInfo = 1) THEN
      
      DBMS_LOB.APPEND (res, '<' || single_ct_prefix || ':DescriptionNotes>');
      
      SELECT  XMLElement(EVALNAME(single_ct_prefix || ':Description'), XMLCDATA(
                NVL((SELECT t.text comments_in_rdbms
                    FROM   dmrs_large_text t
                    WHERE  t.ovid = v_ct_type_ovid
                    AND    t.type='Comments'),
                    (SELECT t.text comments_in_rdbms
                    FROM   dmrs_large_text t
                    WHERE  t.ovid = v_ct_type_ovid
                    AND    t.type='CommentsInRDBMS')))).getClobVal(),
              XMLElement(EVALNAME(single_ct_prefix || ':Notes'), XMLCDATA(
                    (SELECT t.text comments_in_rdbms
                    FROM   dmrs_large_text t
                    WHERE  t.ovid = v_ct_type_ovid
                    AND    t.type='Note'))).getClobVal()
      INTO   v_description, 
             v_notes
      FROM  dual;

      DBMS_LOB.APPEND (res, v_description);
      DBMS_LOB.APPEND (res, v_notes);
      DBMS_LOB.APPEND (res, '</' || single_ct_prefix || ':DescriptionNotes>');
      
   END IF;

   FOR rec_ct_data IN cur_ct_data(v_ct_type_ovid) LOOP
      DBMS_LOB.APPEND (res, rec_ct_data.ct_name);
      DBMS_LOB.APPEND (res, rec_ct_data.ct_type);
      DBMS_LOB.APPEND (res, rec_ct_data.max_element);
      DBMS_LOB.APPEND (res, rec_ct_data.data_type);
      DBMS_LOB.APPEND (res, rec_ct_data.dt_kind);
      DBMS_LOB.APPEND (res, rec_ct_data.domain_name);
   END LOOP;

   -- Used in tables
   IF (reportTemplate.reportType = 0 OR reportTemplate.useCTUsedInTables = 1) THEN
     FOR rec_used_in_tables IN cur_used_in_tables(v_ct_type_ovid) LOOP
        IF (cur_used_in_tables%ROWCOUNT = 1) THEN
           DBMS_LOB.APPEND (res,'<' || single_ct_prefix || ':TablesCollection>');
        END IF;
           DBMS_LOB.APPEND (res,'<' || single_ct_prefix || ':TableDetails>');

           v_model_name := rec_used_in_tables.model_name;
           IF (v_model_name != p_model_name) THEN
             DBMS_LOB.APPEND (res,v_model_name);
             p_model_name := v_model_name;
           ELSE
             DBMS_LOB.APPEND (res,'<' || single_ct_prefix || ':ModelName></' || single_ct_prefix || ':ModelName>');
           END IF;

           v_table_name := rec_used_in_tables.table_name;
           IF (v_table_name != p_table_name) THEN
           DBMS_LOB.APPEND (res,v_table_name);
             p_table_name := v_table_name;
           ELSE
             DBMS_LOB.APPEND (res,'<' || single_ct_prefix || ':TableName></' || single_ct_prefix || ':TableName>');
           END IF;

           DBMS_LOB.APPEND (res,rec_used_in_tables.column_name);
           DBMS_LOB.APPEND (res,'</' || single_ct_prefix || ':TableDetails>');
        IF (cur_used_in_tables%ROWCOUNT = rec_used_in_tables.total_row_count) THEN
           DBMS_LOB.APPEND (res, '</' || single_ct_prefix || ':TablesCollection>');
        END IF;
     END LOOP;
   END IF;

   -- Used in entities
   IF (reportTemplate.reportType = 0 OR reportTemplate.useCTUsedInEntities = 1) THEN
     FOR rec_used_in_entities IN cur_used_in_entities(v_ct_type_ovid) LOOP
        IF (cur_used_in_entities%ROWCOUNT = 1) THEN
           DBMS_LOB.APPEND (res,'<' || single_ct_prefix || ':EntitiesCollection>');
        END IF;
           DBMS_LOB.APPEND (res,'<' || single_ct_prefix || ':EntityDetails>');
          
           v_entity_name := rec_used_in_entities.entity_name;
           IF (v_entity_name != p_entity_name) THEN
             DBMS_LOB.APPEND (res,v_entity_name);
             p_entity_name := v_entity_name;
           ELSE
             DBMS_LOB.APPEND (res,'<' || single_ct_prefix || ':EntityName></' || single_ct_prefix || ':EntityName>');
           END IF;

           DBMS_LOB.APPEND (res,rec_used_in_entities.attribute_name);
           DBMS_LOB.APPEND (res,'</' || single_ct_prefix || ':EntityDetails>');
        IF (cur_used_in_entities%ROWCOUNT = rec_used_in_entities.total_row_count) THEN
           DBMS_LOB.APPEND (res, '</' || single_ct_prefix || ':EntitiesCollection>');
        END IF;
     END LOOP;
   END IF;
  
  DBMS_LOB.APPEND (res,'</' || single_ct_prefix || ':CollectionType>');

  UTL_FILE.PUT_LINE(log_file, TO_CHAR(SYSDATE,'yy.mm.dd hh:mi:ss') ||' '|| 'Gathering data for single collection type ended');  

RETURN res;
  
 EXCEPTION
 WHEN others THEN
  UTL_FILE.PUT_LINE(log_file, 'Pkg_Osdm_Utils.Gather_SingleCT_Data Exception : ' || SQLERRM);  
  UTL_FILE.PUT_LINE(log_file, 'Pkg_Osdm_Utils.Gather_SingleCT_Data Exception : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  RETURN res;
 
END Gather_SingleCT_Data;

FUNCTION Gather_AllCT_Data(v_model_ovid IN VARCHAR2, reportTemplate IN REPORT_TEMPLATE, objects IN OBJECTS_LIST) RETURN CLOB IS 

res               CLOB;
v_notes           CLOB;
v_description     CLOB;
v_rel_total_count INTEGER;
token_value       CLOB;
p_model_name      VARCHAR2(100) :='_';
v_model_name      VARCHAR2(100) :='';
p_table_name      VARCHAR2(100) :='_';
v_table_name      VARCHAR2(100) :='';
p_entity_name     VARCHAR2(100) :='_';
v_entity_name     VARCHAR2(100) :='';

CURSOR cur_general_data(v_m_ovid IN VARCHAR2) IS
 -- General data
 SELECT XMLElement(EVALNAME(all_ct_prefix || ':DesignName'),d.design_name).getClobVal()                                        design_name,
        XMLElement(EVALNAME(all_ct_prefix || ':VersionDate'),TO_CHAR(d.date_published,'dd.mm.yyyy hh24:mi:ss')).getClobVal()   version_date,
        XMLElement(EVALNAME(all_ct_prefix || ':VersionComment'),XMLCDATA(d.version_comments)).getClobVal()                     version_comment,
        XMLElement(EVALNAME(all_ct_prefix || ':ModelName'),m.model_name).getClobVal()                                          model_name
 FROM   dmrs_designs d, 
        dmrs_models m
 WHERE  d.design_ovid = m.design_ovid
 AND    m.model_ovid = v_model_ovid;
rec_general_data cur_general_data%ROWTYPE;

-- All collection types data 
CURSOR cur_all_ct_data(v_m_ovid IN VARCHAR2) IS
 SELECT  XMLElement(EVALNAME(all_ct_prefix || ':CTName'),ct.collection_type_name).getClobVal()                                                                                   ct_name,
		 XMLElement(EVALNAME(all_ct_prefix || ':EncodedName'),ct.collection_type_ovid).getClobVal()                                                                              xml_ovid,
 		 XMLElement(EVALNAME(all_ct_prefix || ':CTType'),ct.c_type).getClobVal()                                                                                                 ct_type,
         XMLElement(EVALNAME(all_ct_prefix || ':CTMaxElements'),ct.max_element).getClobVal()                                                                                     max_element,
         XMLElement(EVALNAME(all_ct_prefix || ':CTDataTypeKind'),DECODE(ct.datatype_kind,
                                                  'Domain',         'DOM',
                                                  'Logical Type',   'LT',
                                                  'Distinct Type',  'DT',
                                                  'Ref Struct Type','RST',
                                                  'Structured Type','ST',
                                                  'Collection Type','CT')
                   ).getClobVal()                                                                                                                               dt_kind,
          XMLElement(EVALNAME(all_ct_prefix || ':CTDataType'), 
             DECODE(ct.datatype_kind, 
                  'Domain', ct.dt_type ||' '||
                           DECODE (NVL(ct.t_size,''),'',
                              DECODE(NVL(ct.t_scale,0),0,
                                 DECODE(NVL(ct.t_precision,0),0,null,'('|| DECODE(NVL(ct.t_precision,0),0,null,ct.t_precision) ||')'),
                                   '('|| DECODE(NVL(ct.t_precision,0),0,null,ct.t_precision) || ',' || DECODE(NVL(ct.t_scale,0),0,null,ct.t_scale)||')'),
                                   '('||TRIM(DECODE(ct.t_size,'',null,ct.t_size||' '||ct.char_units ))||')'),
                   'Logical Type', ct.dt_type  ||' '|| 
                           DECODE (NVL(ct.t_size,''),'',
                              DECODE(NVL(ct.t_scale,0),0,
                                 DECODE(NVL(ct.t_precision,0),0,null,'('|| DECODE(NVL(ct.t_precision,0),0,null,ct.t_precision) ||')'),
                                   '('|| DECODE(NVL(ct.t_precision,0),0,null,ct.t_precision) || ',' || DECODE(NVL(ct.t_scale,0),0,null,ct.t_scale)||')'),
                                   '('||TRIM(DECODE(ct.t_size,'',null,ct.t_size||' '||ct.char_units ))||')')
             )).getClobVal()                                                                                                                                    data_type,
       XMLElement(EVALNAME(all_ct_prefix || ':CTDomainName'),DECODE(ct.domain_name,'Unknown',null,ct.domain_name)).getClobVal()                                                   domain_name,
       ct.collection_type_ovid                                                                                                                                  ct_ovid,
       COUNT(ct.collection_type_name) over()                                                                                                                    total_row_count
 FROM  dmrs_collection_types ct
 WHERE ct.model_ovid = v_m_ovid
 AND   ct.collection_type_ovid MEMBER OF objects
 ORDER BY ct.collection_type_name;
rec_all_ct_data cur_all_ct_data%ROWTYPE;

-- Used In tables
CURSOR cur_used_in_tables(v_ct_ovid IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(all_ct_prefix || ':ModelName'), m.model_name).getClobVal()     model_name,
        XMLElement(EVALNAME(all_ct_prefix || ':TableName'), t.table_name).getClobVal()     table_name,
        XMLElement(EVALNAME(all_ct_prefix || ':ColumnName'), c.column_name).getClobVal()   column_name,
        COUNT(m.model_name) over()                                       total_row_count
FROM   dmrs_tables t,
        dmrs_columns c,
        dmrs_collection_types ct,
        dmrs_models  m
 WHERE  t.ovid = c.container_ovid
 AND    c.collection_type_ovid = ct.collection_type_ovid
 AND    m.model_ovid = t.model_ovid
 AND    c.datatype_kind = 'Collection Type'
 AND    ct.collection_type_ovid = v_ct_ovid
 ORDER BY m.model_name,
          t.table_name,
          c.column_name;
rec_used_in_tables cur_used_in_tables%ROWTYPE;

-- Used In entities
CURSOR cur_used_in_entities(v_ct_ovid IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(all_ct_prefix || ':EntityName'), e.entity_name).getClobVal()        entity_name,
        XMLElement(EVALNAME(all_ct_prefix || ':AttributeName'), a.attribute_name).getClobVal()  attribute_name,
        COUNT(e.entity_name) over()                                           total_row_count
 FROM   dmrs_entities e,
        dmrs_attributes a,
        dmrs_collection_types ct
 WHERE  e.ovid = a.container_ovid
 AND    a.collection_type_ovid = ct.collection_type_ovid
 AND    a.datatype_kind = 'Collection Type'
 AND    ct.collection_type_ovid = v_ct_ovid
 ORDER BY e.entity_name,
          a.attribute_name;
rec_used_in_entities cur_used_in_entities%ROWTYPE;

BEGIN

  UTL_FILE.PUT_LINE(log_file, TO_CHAR(SYSDATE,'yy.mm.dd hh:mi:ss') ||' '|| 'Gathering data for all collection types started ...');
  
  DBMS_LOB.CREATETEMPORARY(res, TRUE);

  DBMS_LOB.APPEND (res,'<' || all_ct_prefix || ':CollectionTypes xmlns:' || all_ct_prefix || '="http://oracle.com/datamodeler/reports/collectiontypes">');

  FOR rec_general_data IN cur_general_data(v_model_ovid) LOOP

    DBMS_LOB.APPEND (res, rec_general_data.design_name);
    DBMS_LOB.APPEND (res, rec_general_data.version_date);
    DBMS_LOB.APPEND (res, rec_general_data.version_comment);
    DBMS_LOB.APPEND (res, rec_general_data.model_name);

  END LOOP;
 
  -- All structured types
  FOR rec_all_ct_data IN cur_all_ct_data(v_model_ovid) LOOP

      IF (cur_all_ct_data%ROWCOUNT = 1) THEN
           DBMS_LOB.APPEND (res,'<' || all_ct_prefix || ':CTCollection>');
      END IF;
      
      DBMS_LOB.APPEND (res,'<' || all_ct_prefix || ':CTDetails>');

      -- Description / Notes
      IF (reportTemplate.reportType = 0 OR reportTemplate.useDescriptionInfo = 1) THEN
   
         DBMS_LOB.APPEND (res, '<' || all_ct_prefix || ':DescriptionNotes>');
      
         SELECT XMLElement(EVALNAME(all_ct_prefix || ':Description'), XMLCDATA(
                  NVL((SELECT t.text comments_in_rdbms
                      FROM   dmrs_large_text t
                      WHERE  t.ovid = rec_all_ct_data.ct_ovid
                      AND    t.type='Comments'),
                      (SELECT t.text comments_in_rdbms
                      FROM   dmrs_large_text t
                      WHERE  t.ovid = rec_all_ct_data.ct_ovid
                      AND    t.type='CommentsInRDBMS')))).getClobVal(),
                XMLElement(EVALNAME(all_ct_prefix || ':Notes'), XMLCDATA(
                      (SELECT t.text comments_in_rdbms
                      FROM   dmrs_large_text t
                      WHERE  t.ovid = rec_all_ct_data.ct_ovid
                      AND    t.type='Note'))).getClobVal()
         INTO   v_description, 
                v_notes
         FROM  dual;
         
        DBMS_LOB.APPEND (res, v_description);
        DBMS_LOB.APPEND (res, v_notes);
        DBMS_LOB.APPEND (res, '</' || all_ct_prefix || ':DescriptionNotes>');

      END IF;
      
      DBMS_LOB.APPEND (res, rec_all_ct_data.ct_name);
      DBMS_LOB.APPEND (res, rec_all_ct_data.xml_ovid);
      DBMS_LOB.APPEND (res, rec_all_ct_data.ct_type);
      DBMS_LOB.APPEND (res, rec_all_ct_data.max_element);
      DBMS_LOB.APPEND (res, rec_all_ct_data.dt_kind);
      DBMS_LOB.APPEND (res, rec_all_ct_data.data_type);
      DBMS_LOB.APPEND (res, rec_all_ct_data.domain_name);

      -- Used in tables
      IF (reportTemplate.reportType = 0 OR reportTemplate.useCTUsedInTables = 1) THEN
        FOR rec_used_in_tables IN cur_used_in_tables(rec_all_ct_data.ct_ovid) LOOP
           IF (cur_used_in_tables%ROWCOUNT = 1) THEN
              DBMS_LOB.APPEND (res,'<' || all_ct_prefix || ':TablesCollection>');
           END IF;
              DBMS_LOB.APPEND (res,'<' || all_ct_prefix || ':TableDetails>');
      
              v_model_name := rec_used_in_tables.model_name;
              IF (v_model_name != p_model_name) THEN
                DBMS_LOB.APPEND (res,v_model_name);
                p_model_name := v_model_name;
              ELSE
                DBMS_LOB.APPEND (res,'<' || all_ct_prefix || ':ModelName></' || all_ct_prefix || ':ModelName>');
              END IF;
      
              v_table_name := rec_used_in_tables.table_name;
              IF (v_table_name != p_table_name) THEN
              DBMS_LOB.APPEND (res,v_table_name);
                p_table_name := v_table_name;
              ELSE
                DBMS_LOB.APPEND (res,'<' || all_ct_prefix || ':TableName></' || all_ct_prefix || ':TableName>');
              END IF;
      
              DBMS_LOB.APPEND (res,rec_used_in_tables.column_name);
              DBMS_LOB.APPEND (res,'</' || all_ct_prefix || ':TableDetails>');
           IF (cur_used_in_tables%ROWCOUNT = rec_used_in_tables.total_row_count) THEN
              DBMS_LOB.APPEND (res, '</' || all_ct_prefix || ':TablesCollection>');
           END IF;
        END LOOP;
      END IF;
      
      -- Used in entities
      IF (reportTemplate.reportType = 0 OR reportTemplate.useCTUsedInEntities = 1) THEN
        FOR rec_used_in_entities IN cur_used_in_entities(rec_all_ct_data.ct_ovid) LOOP
           IF (cur_used_in_entities%ROWCOUNT = 1) THEN
              DBMS_LOB.APPEND (res,'<' || all_ct_prefix || ':EntitiesCollection>');
           END IF;
              DBMS_LOB.APPEND (res,'<' || all_ct_prefix || ':EntityDetails>');
             
              v_entity_name := rec_used_in_entities.entity_name;
              IF (v_entity_name != p_entity_name) THEN
                DBMS_LOB.APPEND (res,v_entity_name);
                p_entity_name := v_entity_name;
              ELSE
                DBMS_LOB.APPEND (res,'<' || all_ct_prefix || ':EntityName></' || all_ct_prefix || ':EntityName>');
              END IF;
      
              DBMS_LOB.APPEND (res,rec_used_in_entities.attribute_name);
              DBMS_LOB.APPEND (res,'</' || all_ct_prefix || ':EntityDetails>');
           IF (cur_used_in_entities%ROWCOUNT = rec_used_in_entities.total_row_count) THEN
              DBMS_LOB.APPEND (res, '</' || all_ct_prefix || ':EntitiesCollection>');
           END IF;
        END LOOP;
      END IF;
  
      DBMS_LOB.APPEND (res,'</' || all_ct_prefix || ':CTDetails>');

      IF (cur_all_ct_data%ROWCOUNT = rec_all_ct_data.total_row_count) THEN
          DBMS_LOB.APPEND (res,'</' || all_ct_prefix || ':CTCollection>');
      END IF;

  END LOOP;
  
  DBMS_LOB.APPEND (res,'</' || all_ct_prefix || ':CollectionTypes>');

  UTL_FILE.PUT_LINE(log_file, TO_CHAR(SYSDATE,'yy.mm.dd hh:mi:ss') ||' '|| 'Gathering data for all collection types ended');  

RETURN res;
  
 EXCEPTION
 WHEN others THEN
  UTL_FILE.PUT_LINE(log_file, 'Pkg_Osdm_Utils.Gather_AllCT_Data Exception : ' || SQLERRM);  
  UTL_FILE.PUT_LINE(log_file, 'Pkg_Osdm_Utils.Gather_AllCT_Data Exception : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  RETURN res;
 
END Gather_AllCT_Data;

FUNCTION Gather_SingleDT_Data(v_dt_type_ovid IN VARCHAR2, reportTemplate IN REPORT_TEMPLATE) RETURN CLOB IS 

res               CLOB;
v_notes           CLOB;
v_description     CLOB;
v_rel_total_count INTEGER;
token_value       CLOB;
p_model_name      VARCHAR2(100) :='_';
v_model_name      VARCHAR2(100) :='';
p_table_name      VARCHAR2(100) :='_';
v_table_name      VARCHAR2(100) :='';
p_entity_name     VARCHAR2(100) :='_';
v_entity_name     VARCHAR2(100) :='';

-- General data
CURSOR cur_general_data(v_dt_ovid IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(single_dt_prefix || ':DesignName'),d.design_name).getClobVal()                                        design_name,
        XMLElement(EVALNAME(single_dt_prefix || ':VersionDate'),TO_CHAR(d.date_published,'dd.mm.yyyy hh24:mi:ss')).getClobVal()   version_date,
        XMLElement(EVALNAME(single_dt_prefix || ':VersionComment'),XMLCDATA(d.version_comments)).getClobVal()                     version_comment,
        XMLElement(EVALNAME(single_dt_prefix || ':ModelName'),m.model_name).getClobVal()                                          model_name
 FROM   dmrs_designs d, 
        dmrs_models m,
        dmrs_distinct_types dt
 WHERE  d.design_ovid = m.design_ovid
 AND    dt.model_ovid = m.model_ovid
 AND    dt.distinct_type_ovid = v_dt_ovid;
rec_general_data cur_general_data%ROWTYPE;

-- Distinct type data
CURSOR cur_dt_data(v_ct_ovid IN VARCHAR2) IS
 SELECT  XMLElement(EVALNAME(single_dt_prefix || ':DTName'),dt.distinct_type_name).getClobVal()                             dt_name,
         XMLElement(EVALNAME(single_dt_prefix || ':DTLogicalType'),dt.logical_type_name).getClobVal()                       lt_type,
         XMLElement(EVALNAME(single_dt_prefix || ':DTSize'),DECODE(dt.t_size,'0','',dt.t_size)).getClobVal()                dt_size,
         XMLElement(EVALNAME(single_dt_prefix || ':DTPrecision'),DECODE(dt.t_precision,'0','',dt.t_precision)).getClobVal() dt_precision,
         XMLElement(EVALNAME(single_dt_prefix || ':DTScale'),DECODE(dt.t_scale,'0','',dt.t_scale)).getClobVal()             dt_scale
 FROM  dmrs_distinct_types dt
 WHERE dt.distinct_type_ovid = v_ct_ovid;
rec_dt_data cur_dt_data%ROWTYPE;

-- Used In tables
CURSOR cur_used_in_tables(v_dt_ovid IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(single_dt_prefix || ':ModelName'), m.model_name).getClobVal()     model_name,
        XMLElement(EVALNAME(single_dt_prefix || ':TableName'), t.table_name).getClobVal()     table_name,
        XMLElement(EVALNAME(single_dt_prefix || ':ColumnName'), c.column_name).getClobVal()   column_name,
        COUNT(m.model_name) over()                                       total_row_count
FROM   dmrs_tables t,
        dmrs_columns c,
        dmrs_distinct_types dt,
        dmrs_models  m
 WHERE  t.ovid = c.container_ovid
 AND    c.distinct_type_ovid = dt.distinct_type_ovid
 AND    m.model_ovid = t.model_ovid
 AND    c.datatype_kind = 'Distinct Type'
 AND    dt.distinct_type_ovid = v_dt_ovid
 ORDER BY m.model_name,
          t.table_name,
          c.column_name;
rec_used_in_tables cur_used_in_tables%ROWTYPE;

-- Used In entities
CURSOR cur_used_in_entities(v_dt_ovid IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(single_dt_prefix || ':EntityName'), e.entity_name).getClobVal()        entity_name,
        XMLElement(EVALNAME(single_dt_prefix || ':AttributeName'), a.attribute_name).getClobVal()  attribute_name,
        COUNT(e.entity_name) over()                                           total_row_count
 FROM   dmrs_entities e,
        dmrs_attributes a,
        dmrs_distinct_types dt
 WHERE  e.ovid = a.container_ovid
 AND    a.distinct_type_ovid = dt.distinct_type_ovid
 AND    a.datatype_kind = 'Distinct Type'
 AND    dt.distinct_type_ovid = v_dt_ovid
 ORDER BY e.entity_name,
          a.attribute_name;
rec_used_in_entities cur_used_in_entities%ROWTYPE;

BEGIN

  UTL_FILE.PUT_LINE(log_file, TO_CHAR(SYSDATE,'yy.mm.dd hh:mi:ss') ||' '|| 'Gathering data for single distinct type started ...');
  
  DBMS_LOB.CREATETEMPORARY(res, TRUE);

  DBMS_LOB.APPEND (res,'<' || single_dt_prefix || ':DistinctType xmlns:' || single_dt_prefix || '="http://oracle.com/datamodeler/reports/distincttype">');
  
  FOR rec_general_data IN cur_general_data(v_dt_type_ovid) LOOP

    DBMS_LOB.APPEND (res, rec_general_data.design_name);
    DBMS_LOB.APPEND (res, rec_general_data.version_date);
    DBMS_LOB.APPEND (res, rec_general_data.version_comment);  
    DBMS_LOB.APPEND (res, rec_general_data.model_name);

  END LOOP;

   -- Description / Notes
   IF (reportTemplate.reportType = 0 OR reportTemplate.useDescriptionInfo = 1) THEN
   
      DBMS_LOB.APPEND (res, '<' || single_dt_prefix || ':DescriptionNotes>');
      
      SELECT  XMLElement(EVALNAME(single_dt_prefix || ':Description'), XMLCDATA(
                NVL((SELECT t.text comments_in_rdbms
                    FROM   dmrs_large_text t
                    WHERE  t.ovid = v_dt_type_ovid
                    AND    t.type='Comments'),
                  (SELECT t.text comments_in_rdbms
                    FROM   dmrs_large_text t
                    WHERE  t.ovid = v_dt_type_ovid
                    AND    t.type='CommentsInRDBMS')))).getClobVal(), 
              XMLElement(EVALNAME(single_dt_prefix || ':Notes'), XMLCDATA(
                    (SELECT t.text comments_in_rdbms
                    FROM   dmrs_large_text t
                    WHERE  t.ovid = v_dt_type_ovid
                    AND    t.type='Note'))).getClobVal()
      INTO   v_description, 
             v_notes
      FROM  dual;

      DBMS_LOB.APPEND (res, v_description);
      DBMS_LOB.APPEND (res, v_notes);
      DBMS_LOB.APPEND (res, '</' || single_dt_prefix || ':DescriptionNotes>');
   
   END IF;
   
   FOR rec_dt_data IN cur_dt_data(v_dt_type_ovid) LOOP
      DBMS_LOB.APPEND (res, rec_dt_data.dt_name);
      DBMS_LOB.APPEND (res, rec_dt_data.lt_type);
      DBMS_LOB.APPEND (res, rec_dt_data.dt_size);
      DBMS_LOB.APPEND (res, rec_dt_data.dt_precision);
      DBMS_LOB.APPEND (res, rec_dt_data.dt_scale);
   END LOOP;

   -- Used in tables
   IF (reportTemplate.reportType = 0 OR reportTemplate.useDTUsedInTables = 1) THEN
     FOR rec_used_in_tables IN cur_used_in_tables(v_dt_type_ovid) LOOP
        IF (cur_used_in_tables%ROWCOUNT = 1) THEN
           DBMS_LOB.APPEND (res,'<' || single_dt_prefix || ':TablesCollection>');
        END IF;
           DBMS_LOB.APPEND (res,'<' || single_dt_prefix || ':TableDetails>');

           v_model_name := rec_used_in_tables.model_name;
           IF (v_model_name != p_model_name) THEN
             DBMS_LOB.APPEND (res,v_model_name);
             p_model_name := v_model_name;
           ELSE
             DBMS_LOB.APPEND (res,'<' || single_dt_prefix || ':ModelName></' || single_dt_prefix || ':ModelName>');
           END IF;

           v_table_name := rec_used_in_tables.table_name;
           IF (v_table_name != p_table_name) THEN
           DBMS_LOB.APPEND (res,v_table_name);
             p_table_name := v_table_name;
           ELSE
             DBMS_LOB.APPEND (res,'<' || single_dt_prefix || ':TableName></' || single_dt_prefix || ':TableName>');
           END IF;

           DBMS_LOB.APPEND (res,rec_used_in_tables.column_name);
           DBMS_LOB.APPEND (res,'</' || single_dt_prefix || ':TableDetails>');
        IF (cur_used_in_tables%ROWCOUNT = rec_used_in_tables.total_row_count) THEN
           DBMS_LOB.APPEND (res, '</' || single_dt_prefix || ':TablesCollection>');
        END IF;
     END LOOP;
   END IF;

   -- Used in entities
   IF (reportTemplate.reportType = 0 OR reportTemplate.useDTUsedInEntities = 1) THEN
     FOR rec_used_in_entities IN cur_used_in_entities(v_dt_type_ovid) LOOP
        IF (cur_used_in_entities%ROWCOUNT = 1) THEN
           DBMS_LOB.APPEND (res,'<' || single_dt_prefix || ':EntitiesCollection>');
        END IF;
           DBMS_LOB.APPEND (res,'<' || single_dt_prefix || ':EntityDetails>');
          
           v_entity_name := rec_used_in_entities.entity_name;
           IF (v_entity_name != p_entity_name) THEN
             DBMS_LOB.APPEND (res,v_entity_name);
             p_entity_name := v_entity_name;
           ELSE
             DBMS_LOB.APPEND (res,'<' || single_dt_prefix || ':EntityName></' || single_dt_prefix || ':EntityName>');
           END IF;

           DBMS_LOB.APPEND (res,rec_used_in_entities.attribute_name);
           DBMS_LOB.APPEND (res,'</' || single_dt_prefix || ':EntityDetails>');
        IF (cur_used_in_entities%ROWCOUNT = rec_used_in_entities.total_row_count) THEN
           DBMS_LOB.APPEND (res, '</' || single_dt_prefix || ':EntitiesCollection>');
        END IF;
     END LOOP;
   END IF;
  
  DBMS_LOB.APPEND (res,'</' || single_dt_prefix || ':DistinctType>');

  UTL_FILE.PUT_LINE(log_file, TO_CHAR(SYSDATE,'yy.mm.dd hh:mi:ss') ||' '|| 'Gathering data for single distinct type ended');  

RETURN res;
  
 EXCEPTION
 WHEN others THEN
  UTL_FILE.PUT_LINE(log_file, 'Pkg_Osdm_Utils.Gather_SingleDT_Data Exception : ' || SQLERRM);  
  UTL_FILE.PUT_LINE(log_file, 'Pkg_Osdm_Utils.Gather_SingleDT_Data Exception : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  RETURN res;
 
END Gather_SingleDT_Data;

FUNCTION Gather_AllDT_Data(v_model_ovid IN VARCHAR2, reportTemplate IN REPORT_TEMPLATE, objects IN OBJECTS_LIST) RETURN CLOB IS 

res               CLOB;
v_notes           CLOB;
v_description     CLOB;
v_rel_total_count INTEGER;
token_value       CLOB;
p_model_name      VARCHAR2(100) :='_';
v_model_name      VARCHAR2(100) :='';
p_table_name      VARCHAR2(100) :='_';
v_table_name      VARCHAR2(100) :='';
p_entity_name     VARCHAR2(100) :='_';
v_entity_name     VARCHAR2(100) :='';

CURSOR cur_general_data(v_m_ovid IN VARCHAR2) IS
 -- General data
 SELECT XMLElement(EVALNAME(all_dt_prefix || ':DesignName'),d.design_name).getClobVal()                                        design_name,
        XMLElement(EVALNAME(all_dt_prefix || ':VersionDate'),TO_CHAR(d.date_published,'dd.mm.yyyy hh24:mi:ss')).getClobVal()   version_date,
        XMLElement(EVALNAME(all_dt_prefix || ':VersionComment'),XMLCDATA(d.version_comments)).getClobVal()                     version_comment,
        XMLElement(EVALNAME(all_dt_prefix || ':ModelName'),m.model_name).getClobVal()                                          model_name
 FROM   dmrs_designs d, 
        dmrs_models m
 WHERE  d.design_ovid = m.design_ovid
 AND    m.model_ovid = v_model_ovid;
rec_general_data cur_general_data%ROWTYPE;

-- All distinct types data 
CURSOR cur_all_dt_data(v_m_ovid IN VARCHAR2) IS
 SELECT  XMLElement(EVALNAME(all_dt_prefix || ':DTName'),dt.distinct_type_name).getClobVal()                             dt_name,
		 XMLElement(EVALNAME(all_dt_prefix || ':EncodedName'),dt.distinct_type_ovid).getClobVal()   	                 xml_ovid,
		 XMLElement(EVALNAME(all_dt_prefix || ':DTLogicalType'),dt.logical_type_name).getClobVal()                       lt_type,
         XMLElement(EVALNAME(all_dt_prefix || ':DTSize'),DECODE(dt.t_size,'0','',dt.t_size)).getClobVal()                dt_size,
         XMLElement(EVALNAME(all_dt_prefix || ':DTPrecision'),DECODE(dt.t_precision,'0','',dt.t_precision)).getClobVal() dt_precision,
         XMLElement(EVALNAME(all_dt_prefix || ':DTScale'),DECODE(dt.t_scale,'0','',dt.t_scale)).getClobVal()             dt_scale,
         dt.distinct_type_ovid                                                                                           dt_ovid,
         COUNT(dt.distinct_type_name) over()                                                                             total_row_count
 FROM  dmrs_distinct_types dt
 WHERE dt.model_ovid = v_m_ovid
 AND   dt.distinct_type_ovid MEMBER OF objects
 ORDER BY dt.distinct_type_name;
rec_all_dt_data cur_all_dt_data%ROWTYPE;

-- Used In tables
CURSOR cur_used_in_tables(v_dt_ovid IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(all_dt_prefix || ':ModelName'), m.model_name).getClobVal()     model_name,
        XMLElement(EVALNAME(all_dt_prefix || ':TableName'), t.table_name).getClobVal()     table_name,
        XMLElement(EVALNAME(all_dt_prefix || ':ColumnName'), c.column_name).getClobVal()   column_name,
        COUNT(m.model_name) over()                                                         total_row_count
FROM   dmrs_tables t,
        dmrs_columns c,
        dmrs_distinct_types dt,
        dmrs_models  m
 WHERE  t.ovid = c.container_ovid
 AND    c.distinct_type_ovid = dt.distinct_type_ovid
 AND    m.model_ovid = t.model_ovid
 AND    c.datatype_kind = 'Distinct Type'
 AND    dt.distinct_type_ovid = v_dt_ovid
 ORDER BY m.model_name,
          t.table_name,
          c.column_name;
rec_used_in_tables cur_used_in_tables%ROWTYPE;

-- Used In entities
CURSOR cur_used_in_entities(v_dt_ovid IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(all_dt_prefix || ':EntityName'), e.entity_name).getClobVal()        entity_name,
        XMLElement(EVALNAME(all_dt_prefix || ':AttributeName'), a.attribute_name).getClobVal()  attribute_name,
        COUNT(e.entity_name) over()                                           total_row_count
 FROM   dmrs_entities e,
        dmrs_attributes a,
        dmrs_distinct_types dt
 WHERE  e.ovid = a.container_ovid
 AND    a.distinct_type_ovid = dt.distinct_type_ovid
 AND    a.datatype_kind = 'Distinct Type'
 AND    dt.distinct_type_ovid = v_dt_ovid
 ORDER BY e.entity_name,
          a.attribute_name;
rec_used_in_entities cur_used_in_entities%ROWTYPE;

BEGIN

  UTL_FILE.PUT_LINE(log_file, TO_CHAR(SYSDATE,'yy.mm.dd hh:mi:ss') ||' '|| 'Gathering data for all distinct types started ...');
  
  DBMS_LOB.CREATETEMPORARY(res, TRUE);

  DBMS_LOB.APPEND (res,'<' || all_dt_prefix || ':DistinctTypes xmlns:' || all_dt_prefix || '="http://oracle.com/datamodeler/reports/distincttypes">');

  FOR rec_general_data IN cur_general_data(v_model_ovid) LOOP

    DBMS_LOB.APPEND (res, rec_general_data.design_name);
    DBMS_LOB.APPEND (res, rec_general_data.version_date);
    DBMS_LOB.APPEND (res, rec_general_data.version_comment);
    DBMS_LOB.APPEND (res, rec_general_data.model_name);

  END LOOP;
  
  -- All distinct types
  FOR rec_all_dt_data IN cur_all_dt_data(v_model_ovid) LOOP

      IF (cur_all_dt_data%ROWCOUNT = 1) THEN
           DBMS_LOB.APPEND (res,'<' || all_dt_prefix || ':DTCollection>');
      END IF;
      
      DBMS_LOB.APPEND (res,'<' || all_dt_prefix || ':DTDetails>');

      -- Description / Notes
      IF (reportTemplate.reportType = 0 OR reportTemplate.useDescriptionInfo = 1) THEN
      
         DBMS_LOB.APPEND (res, '<' || all_dt_prefix || ':DescriptionNotes>');
         
         SELECT XMLElement(EVALNAME(all_dt_prefix || ':Description'), XMLCDATA(
                  NVL((SELECT t.text comments_in_rdbms
                      FROM   dmrs_large_text t
                      WHERE  t.ovid = rec_all_dt_data.dt_ovid
                      AND    t.type='Comments'),
                      (SELECT t.text comments_in_rdbms
                      FROM   dmrs_large_text t
                      WHERE  t.ovid = rec_all_dt_data.dt_ovid
                      AND    t.type='CommentsInRDBMS')))).getClobVal(), 
                XMLElement(EVALNAME(all_dt_prefix || ':Notes'), XMLCDATA(
                      (SELECT t.text comments_in_rdbms
                      FROM   dmrs_large_text t
                      WHERE  t.ovid = rec_all_dt_data.dt_ovid
                      AND    t.type='Note'))).getClobVal()
         INTO   v_description, 
                v_notes
         FROM  dual;
         
        DBMS_LOB.APPEND (res, v_description);
        DBMS_LOB.APPEND (res, v_notes);
        DBMS_LOB.APPEND (res, '</' || all_dt_prefix || ':DescriptionNotes>');
         
      END IF;
      
      DBMS_LOB.APPEND (res, rec_all_dt_data.dt_name);
      DBMS_LOB.APPEND (res, rec_all_dt_data.xml_ovid);
      DBMS_LOB.APPEND (res, rec_all_dt_data.lt_type);
      DBMS_LOB.APPEND (res, rec_all_dt_data.dt_size);
      DBMS_LOB.APPEND (res, rec_all_dt_data.dt_precision);
      DBMS_LOB.APPEND (res, rec_all_dt_data.dt_scale);

      -- Used in tables
      IF (reportTemplate.reportType = 0 OR reportTemplate.useDTUsedInTables = 1) THEN
        FOR rec_used_in_tables IN cur_used_in_tables(rec_all_dt_data.dt_ovid) LOOP
           IF (cur_used_in_tables%ROWCOUNT = 1) THEN
              DBMS_LOB.APPEND (res,'<' || all_dt_prefix || ':TablesCollection>');
           END IF;
              DBMS_LOB.APPEND (res,'<' || all_dt_prefix || ':TableDetails>');
      
              v_model_name := rec_used_in_tables.model_name;
              IF (v_model_name != p_model_name) THEN
                DBMS_LOB.APPEND (res,v_model_name);
                p_model_name := v_model_name;
              ELSE
                DBMS_LOB.APPEND (res,'<' || all_dt_prefix || ':ModelName></' || all_dt_prefix || ':ModelName>');
              END IF;
      
              v_table_name := rec_used_in_tables.table_name;
              IF (v_table_name != p_table_name) THEN
              DBMS_LOB.APPEND (res,v_table_name);
                p_table_name := v_table_name;
              ELSE
                DBMS_LOB.APPEND (res,'<' || all_dt_prefix || ':TableName></' || all_dt_prefix || ':TableName>');
              END IF;
      
              DBMS_LOB.APPEND (res,rec_used_in_tables.column_name);
              DBMS_LOB.APPEND (res,'</' || all_dt_prefix || ':TableDetails>');
           IF (cur_used_in_tables%ROWCOUNT = rec_used_in_tables.total_row_count) THEN
              DBMS_LOB.APPEND (res, '</' || all_dt_prefix || ':TablesCollection>');
           END IF;
        END LOOP;
      END IF;
      
      -- Used in entities
      IF (reportTemplate.reportType = 0 OR reportTemplate.useDTUsedInEntities = 1) THEN
        FOR rec_used_in_entities IN cur_used_in_entities(rec_all_dt_data.dt_ovid) LOOP
           IF (cur_used_in_entities%ROWCOUNT = 1) THEN
              DBMS_LOB.APPEND (res,'<' || all_dt_prefix || ':EntitiesCollection>');
           END IF;
              DBMS_LOB.APPEND (res,'<' || all_dt_prefix || ':EntityDetails>');
             
              v_entity_name := rec_used_in_entities.entity_name;
              IF (v_entity_name != p_entity_name) THEN
                DBMS_LOB.APPEND (res,v_entity_name);
                p_entity_name := v_entity_name;
              ELSE
                DBMS_LOB.APPEND (res,'<' || all_dt_prefix || ':EntityName></' || all_dt_prefix || ':EntityName>');
              END IF;
      
              DBMS_LOB.APPEND (res,rec_used_in_entities.attribute_name);
              DBMS_LOB.APPEND (res,'</' || all_dt_prefix || ':EntityDetails>');
           IF (cur_used_in_entities%ROWCOUNT = rec_used_in_entities.total_row_count) THEN
              DBMS_LOB.APPEND (res, '</' || all_dt_prefix || ':EntitiesCollection>');
           END IF;
        END LOOP;
      END IF;

      DBMS_LOB.APPEND (res,'</' || all_dt_prefix || ':DTDetails>');

      IF (cur_all_dt_data%ROWCOUNT = rec_all_dt_data.total_row_count) THEN
          DBMS_LOB.APPEND (res,'</' || all_dt_prefix || ':DTCollection>');
      END IF;

  END LOOP;
  
  DBMS_LOB.APPEND (res,'</' || all_dt_prefix || ':DistinctTypes>');

  UTL_FILE.PUT_LINE(log_file, TO_CHAR(SYSDATE,'yy.mm.dd hh:mi:ss') ||' '|| 'Gathering data for all distinct types ended');  

RETURN res;
  
 EXCEPTION
 WHEN others THEN
  UTL_FILE.PUT_LINE(log_file, 'Pkg_Osdm_Utils.Gather_AllDT_Data Exception : ' || SQLERRM);  
  UTL_FILE.PUT_LINE(log_file, 'Pkg_Osdm_Utils.Gather_AllDT_Data Exception : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  RETURN res;
 
END Gather_AllDT_Data;

FUNCTION Gather_CR_Data(v_design_ovid IN VARCHAR2, reportTemplate IN REPORT_TEMPLATE) RETURN CLOB IS 

res               CLOB;
v_notes           CLOB;
v_description     CLOB;
v_reason          CLOB;
v_imp_note        CLOB;
v_rel_total_count INTEGER;
token_value       CLOB;
p_model_name      VARCHAR2(100) :='_';
v_model_name      VARCHAR2(100) :='';

CURSOR cur_general_data(v_d_ovid IN VARCHAR2) IS
 -- General data
 SELECT XMLElement(EVALNAME(all_cr_prefix || ':DesignName'),d.design_name).getClobVal()                                        design_name,
        XMLElement(EVALNAME(all_cr_prefix || ':VersionDate'),TO_CHAR(d.date_published,'dd.mm.yyyy hh24:mi:ss')).getClobVal()   version_date,
        XMLElement(EVALNAME(all_cr_prefix || ':VersionComment'),XMLCDATA(d.version_comments)).getClobVal()                     version_comment
 FROM   dmrs_designs d
 WHERE  d.design_ovid = v_d_ovid;
rec_general_data cur_general_data%ROWTYPE;

CURSOR cur_all_cr(v_d_ovid IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(all_cr_prefix || ':CRName'),cr.change_request_name).getClobVal()                  cr_name,
		XMLElement(EVALNAME(all_cr_prefix || ':EncodedName'),cr.change_request_ovid).getClobVal()             xml_ovid,
 		XMLElement(EVALNAME(all_cr_prefix || ':CRReason'), XMLCDATA(cr.reason)).getClobVal()                  cr_reason,
        XMLElement(EVALNAME(all_cr_prefix || ':CRStatus'),cr.request_status).getClobVal()                     cr_status,
        XMLElement(EVALNAME(all_cr_prefix || ':CRCompleted'),cr.is_completed).getClobVal()                    cr_completed,
        XMLElement(EVALNAME(all_cr_prefix || ':CRRequestDate'),cr.request_date_string).getClobVal()           cr_req_date,
        XMLElement(EVALNAME(all_cr_prefix || ':CRCompletionDate'),cr.completion_date_string).getClobVal()     cr_compl_date,
        cr.change_request_ovid                                                                                cr_ovid,
        COUNT(cr.change_request_name) over()                                                                  total_row_count
 FROM   dmrs_change_requests cr
 WHERE  design_ovid = v_d_ovid;
rec_all_cr cur_all_cr%ROWTYPE;

--Impacted Objects
CURSOR cur_i_objects(v_cr_ovid IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(all_cr_prefix || ':ModelName'),cre.element_model_name).getClobVal()    model_name,
        XMLElement(EVALNAME(all_cr_prefix || ':TypeName'),cre.element_type).getClobVal()           type_name,
        XMLElement(EVALNAME(all_cr_prefix || ':ObjectName'),cre.element_name).getClobVal()         obj_name,
        COUNT(cre.element_name) over()                                         total_row_count
 FROM   dmrs_change_request_elements cre
 WHERE  cre.change_request_ovid = v_cr_ovid
 ORDER BY cre.element_model_name,
          cre.element_type,
          cre.element_name;
rec_i_objects cur_i_objects%ROWTYPE;

BEGIN

  UTL_FILE.PUT_LINE(log_file, TO_CHAR(SYSDATE,'yy.mm.dd hh:mi:ss') ||' '|| 'Gathering data for change requests started ...');
  
  DBMS_LOB.CREATETEMPORARY(res, TRUE);

  DBMS_LOB.APPEND (res,'<' || all_cr_prefix || ':ChangeRequests xmlns:' || all_cr_prefix || '="http://oracle.com/datamodeler/reports/changerequests">');  
  
  FOR rec_general_data IN cur_general_data(v_design_ovid) LOOP

    DBMS_LOB.APPEND (res, rec_general_data.design_name);
    DBMS_LOB.APPEND (res, rec_general_data.version_date);
    DBMS_LOB.APPEND (res, rec_general_data.version_comment);
     
  END LOOP;

  FOR rec_all_cr IN cur_all_cr(v_design_ovid) LOOP

      IF (cur_all_cr%ROWCOUNT = 1) THEN
           DBMS_LOB.APPEND (res,'<' || all_cr_prefix || ':CRCollection>');
      END IF;
      
      DBMS_LOB.APPEND (res,'<' || all_cr_prefix || ':CRDetails>');
      DBMS_LOB.APPEND (res,rec_all_cr.cr_name);
      DBMS_LOB.APPEND (res,rec_all_cr.xml_ovid);

      -- Comments / Notes / Implementation notes
      SELECT 
            XMLElement(EVALNAME(all_cr_prefix || ':CRComment'), XMLCDATA(
              NVL(
               (SELECT t.text comments_in_rdbms
                FROM   dmrs_large_text t
                WHERE  t.ovid = rec_all_cr.cr_ovid
                AND    t.type='Comments'),
               (SELECT t.text comments_in_rdbms
                FROM   dmrs_large_text t
                WHERE  t.ovid = rec_all_cr.cr_ovid
                AND    t.type='CommentsInRDBMS')))).getClobVal(),
            XMLElement(EVALNAME(all_cr_prefix || ':CRNotes'), XMLCDATA(
               (SELECT t.text comments_in_rdbms
                FROM   dmrs_large_text t
                WHERE  t.ovid = rec_all_cr.cr_ovid
                AND    t.type='Note'))).getClobVal(),

            XMLElement(EVALNAME(all_cr_prefix || ':CRImplementationNote'), XMLCDATA(
                (SELECT t.text comments_in_rdbms
                FROM   dmrs_large_text t
                WHERE  t.ovid = rec_all_cr.cr_ovid
                AND    t.type='Implementation Note'))).getClobVal()
      INTO  v_description, 
            v_notes,
            v_imp_note
      FROM  dual;

      DBMS_LOB.APPEND (res, v_description);
      DBMS_LOB.APPEND (res, v_notes);
      DBMS_LOB.APPEND (res,rec_all_cr.cr_reason);
      DBMS_LOB.APPEND (res,rec_all_cr.cr_status);
      DBMS_LOB.APPEND (res,rec_all_cr.cr_completed);
      DBMS_LOB.APPEND (res,rec_all_cr.cr_req_date);
      DBMS_LOB.APPEND (res,rec_all_cr.cr_compl_date);
      DBMS_LOB.APPEND (res, v_imp_note);

      -- Impacted Objects
      IF (reportTemplate.reportType = 0 OR reportTemplate.useCRImpactedObjects = 1) THEN
        FOR rec_i_objects IN cur_i_objects(rec_all_cr.cr_ovid) LOOP
                                                 
             IF (cur_i_objects%ROWCOUNT = 1) THEN
                DBMS_LOB.APPEND (res,'<' || all_cr_prefix || ':CRUsedInObjectCollection>');
             END IF;
                DBMS_LOB.APPEND (res,'<' || all_cr_prefix || ':CRUsedInObjectDetails>');
               
                v_model_name := rec_i_objects.model_name;
                IF (v_model_name != p_model_name) THEN
                  DBMS_LOB.APPEND (res,v_model_name);
                  p_model_name := v_model_name;
                ELSE
                  DBMS_LOB.APPEND (res,'<' || all_cr_prefix || ':ModelName></' || all_cr_prefix || ':ModelName>');
                END IF;
        
                DBMS_LOB.APPEND (res,rec_i_objects.type_name);
                DBMS_LOB.APPEND (res,rec_i_objects.obj_name);
                DBMS_LOB.APPEND (res,'</' || all_cr_prefix || ':CRUsedInObjectDetails>');
             IF (cur_i_objects%ROWCOUNT = rec_i_objects.total_row_count) THEN
                DBMS_LOB.APPEND (res, '</' || all_cr_prefix || ':CRUsedInObjectCollection>');
             END IF;
                                                                           
        END LOOP;
      END IF;
      DBMS_LOB.APPEND (res,'</' || all_cr_prefix || ':CRDetails>');

      IF (cur_all_cr%ROWCOUNT = rec_all_cr.total_row_count) THEN
          DBMS_LOB.APPEND (res,'</' || all_cr_prefix || ':CRCollection>');
      END IF;

  END LOOP;
  
  DBMS_LOB.APPEND (res,'</' || all_cr_prefix || ':ChangeRequests>');

  UTL_FILE.PUT_LINE(log_file, TO_CHAR(SYSDATE,'yy.mm.dd hh:mi:ss') ||' '|| 'Gathering data for change requests ended');  

RETURN res;
  
 EXCEPTION
 WHEN others THEN
  UTL_FILE.PUT_LINE(log_file, 'Pkg_Osdm_Utils.Gather_CR_Data Exception : ' || SQLERRM);  
  UTL_FILE.PUT_LINE(log_file, 'Pkg_Osdm_Utils.Gather_CR_Data Exception : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  RETURN res;
 
END Gather_CR_Data;

FUNCTION Gather_MR_Data(v_design_ovid IN VARCHAR2, reportTemplate IN REPORT_TEMPLATE) RETURN CLOB IS 

res               CLOB;
v_notes           CLOB;
v_comment         CLOB;
v_rel_total_count INTEGER;
token_value       CLOB;

CURSOR cur_general_data(v_d_ovid IN VARCHAR2) IS
 -- General data
 SELECT XMLElement(EVALNAME(all_mr_prefix || ':DesignName'),d.design_name).getClobVal()                                        design_name,
        XMLElement(EVALNAME(all_mr_prefix || ':VersionDate'),TO_CHAR(d.date_published,'dd.mm.yyyy hh24:mi:ss')).getClobVal()   version_date,
        XMLElement(EVALNAME(all_mr_prefix || ':VersionComment'), XMLCDATA(d.version_comments)).getClobVal()                    version_comment
 FROM   dmrs_designs d
 WHERE  d.design_ovid = v_d_ovid;
rec_general_data cur_general_data%ROWTYPE;

CURSOR cur_all_measurements(v_d_ovid IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(all_mr_prefix || ':MName'),mr.measurement_name).getClobVal()             m_name,
        XMLElement(EVALNAME(all_mr_prefix || ':MValue'),mr.measurement_value).getClobVal()           m_value,
        XMLElement(EVALNAME(all_mr_prefix || ':MType'),mr.measurement_type).getClobVal()             m_type,
        XMLElement(EVALNAME(all_mr_prefix || ':MUnit'),mr.measurement_unit).getClobVal()             m_unit,
        XMLElement(EVALNAME(all_mr_prefix || ':MCreationDate'),mr.measurement_cr_date).getClobVal()  m_cr_date,
        XMLElement(EVALNAME(all_mr_prefix || ':MEffectiveDate'),mr.measurement_ef_date).getClobVal() m_ef_date,
        XMLElement(EVALNAME(all_mr_prefix || ':ModelName'),mr.object_model).getClobVal()             obj_model_name,
        XMLElement(EVALNAME(all_mr_prefix || ':ObjectName'),mr.object_name).getClobVal()             object_name,
        XMLElement(EVALNAME(all_mr_prefix || ':TypeName'),mr.object_type).getClobVal()               object_type,
        mr.measurement_ovid                                                                          m_ovid,
        COUNT(mr.measurement_name) over()                                                            total_row_count
 FROM dmrs_measurements mr
 WHERE design_ovid = v_d_ovid;
rec_all_measurements cur_all_measurements%ROWTYPE;

BEGIN

  UTL_FILE.PUT_LINE(log_file, TO_CHAR(SYSDATE,'yy.mm.dd hh:mi:ss') ||' '|| 'Gathering data for measurements started ...');
  
  DBMS_LOB.CREATETEMPORARY(res, TRUE);

  DBMS_LOB.APPEND (res,'<' || all_mr_prefix || ':Measurements xmlns:' || all_mr_prefix || '="http://oracle.com/datamodeler/reports/measurements">');
  
  FOR rec_general_data IN cur_general_data(v_design_ovid) LOOP

    DBMS_LOB.APPEND (res, rec_general_data.design_name);
    DBMS_LOB.APPEND (res, rec_general_data.version_date);
    DBMS_LOB.APPEND (res, rec_general_data.version_comment);

  END LOOP;

  IF (reportTemplate.reportType = 0 OR reportTemplate.useMRImpactedObjects = 1) THEN
    FOR rec_all_measurements IN cur_all_measurements(v_design_ovid) LOOP

      IF (cur_all_measurements%ROWCOUNT = 1) THEN
        DBMS_LOB.APPEND (res,'<' || all_mr_prefix || ':MCollection>');
      END IF;
        DBMS_LOB.APPEND (res,'<' || all_mr_prefix || ':MDetails>');
        DBMS_LOB.APPEND (res,rec_all_measurements.m_name);
        
        -- Comment & Notes
        SELECT  XMLElement(EVALNAME(all_mr_prefix || ':MComment'),XMLCDATA(
                  NVL(( SELECT t.text comments_in_rdbms
                        FROM   dmrs_large_text t
                        WHERE  t.ovid = rec_all_measurements.m_ovid
                        AND    t.type='Comments'),
                        (SELECT t.text comments_in_rdbms
                        FROM   dmrs_large_text t
                        WHERE  t.ovid = rec_all_measurements.m_ovid
                        AND    t.type='CommentsInRDBMS')))).getClobVal(),
                XMLElement(EVALNAME(all_mr_prefix || ':MNotes'),XMLCDATA(
                       (SELECT t.text comments_in_rdbms
                        FROM   dmrs_large_text t
                        WHERE  t.ovid = rec_all_measurements.m_ovid
                        AND    t.type='Note'))).getClobVal()
        INTO  v_comment, 
              v_notes
        FROM dual;
        
        DBMS_LOB.APPEND (res,v_comment);
        DBMS_LOB.APPEND (res,v_notes);
        DBMS_LOB.APPEND (res,rec_all_measurements.m_value);
        DBMS_LOB.APPEND (res,rec_all_measurements.m_unit);
        DBMS_LOB.APPEND (res,rec_all_measurements.m_type);
        DBMS_LOB.APPEND (res,rec_all_measurements.m_cr_date);
        DBMS_LOB.APPEND (res,rec_all_measurements.m_ef_date);
        DBMS_LOB.APPEND (res,'<' || all_mr_prefix || ':MUsedInObjectCollection>');
        DBMS_LOB.APPEND (res,'<' || all_mr_prefix || ':MUsedInObjectDetails>');
        DBMS_LOB.APPEND (res,rec_all_measurements.obj_model_name);
        DBMS_LOB.APPEND (res,rec_all_measurements.object_type);
        DBMS_LOB.APPEND (res,rec_all_measurements.object_name);
        DBMS_LOB.APPEND (res,'</' || all_mr_prefix || ':MUsedInObjectDetails>');
        DBMS_LOB.APPEND (res,'</' || all_mr_prefix || ':MUsedInObjectCollection>');
        DBMS_LOB.APPEND (res,'</' || all_mr_prefix || ':MDetails>');

      IF (cur_all_measurements%ROWCOUNT = rec_all_measurements.total_row_count) THEN
          DBMS_LOB.APPEND (res,'</' || all_mr_prefix || ':MCollection>');
      END IF;

    END LOOP;
  END IF;
  
  DBMS_LOB.APPEND (res,'</' || all_mr_prefix || ':Measurements>');

  UTL_FILE.PUT_LINE(log_file, TO_CHAR(SYSDATE,'yy.mm.dd hh:mi:ss') ||' '|| 'Gathering data for measurements ended');  

RETURN res;
  
 EXCEPTION
 WHEN others THEN
  UTL_FILE.PUT_LINE(log_file, 'Pkg_Osdm_Utils.Gather_MR_Data Exception : ' || SQLERRM);  
  UTL_FILE.PUT_LINE(log_file, 'Pkg_Osdm_Utils.Gather_MR_Data Exception : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  RETURN res;
 
END Gather_MR_Data;

FUNCTION Gather_Constraint_Details_HTML(col_attr_ovid VARCHAR2) RETURN CLOB IS

clob_ CLOB;
clob_constraints CLOB;
clob_ranges CLOB;
clob_vl CLOB;

CURSOR cur_c_constraints(v_ovid IN VARCHAR2) IS
 SELECT constraint_name,
        text,
        database_type
 FROM   dmrs_check_constraints
 WHERE  dataelement_ovid = v_ovid
 ORDER BY sequence;
 rec_c_constraints cur_c_constraints % rowtype;

 CURSOR cur_ranges(v_ovid IN VARCHAR2) IS
 SELECT begin_value,
        end_value,
        short_description
 FROM   dmrs_value_ranges
 WHERE  dataelement_ovid = v_ovid
 ORDER BY sequence;
rec_ranges cur_ranges % rowtype;

CURSOR cur_valuelist_columns(v_ovid IN VARCHAR2) IS
 SELECT av.VALUE,
        av.short_description
 FROM   dmrs_avt av,
        dmrs_columns c
 WHERE  c.ovid = av.dataelement_ovid
 AND    av.dataelement_ovid = v_ovid;
rec_valuelist_columns cur_valuelist_columns % rowtype;

BEGIN

    FOR rec_c_constraints IN cur_c_constraints(col_attr_ovid) LOOP
      clob_constraints := clob_constraints 
                                           || '<tr><td>'
                                           || REPLACE(rec_c_constraints.text, Chr(10), '<br/>')
                                           || '</td><td align="center">' 
                                           || rec_c_constraints.database_type 
                                           || '</td></tr>';
    END LOOP;

    FOR rec_ranges IN cur_ranges(col_attr_ovid) LOOP
      clob_ranges := clob_ranges || '<tr><td align="right">' 
                                 || rec_ranges.begin_value 
                                 || '</td><td align="right">' 
                                 || rec_ranges.end_value 
                                 || '</td><td>' 
                                 || REPLACE(rec_ranges.short_description, Chr(10), '<br/>')
                                 || '</td></tr>';
    END LOOP;

    FOR rec_valuelist_columns IN cur_valuelist_columns(col_attr_ovid) LOOP
      clob_vl := clob_vl || '<tr><td align="right">' 
                         || rec_valuelist_columns.VALUE 
                         || '</td><td>' 
                         || REPLACE(rec_valuelist_columns.short_description, Chr(10), '<br/>')
                         || '</td></tr>';

    END LOOP;

    IF (clob_constraints IS NULL AND clob_ranges IS NULL AND clob_vl IS NULL) THEN
      RETURN '';
    ELSE
        
      clob_ := '<table class="inlineTable">';

      IF clob_constraints IS NOT NULL THEN
        clob_ := clob_ || '<tr><th>';
        clob_ := clob_ || '<table class="inlineTable">';
        clob_ := clob_ || '<tr><th colspan="3">Check Constraint</th></tr>';
        clob_ := clob_ || '<tr><th>Text</th><th>DB Type</th></tr>';
        clob_ := clob_ || clob_constraints;
        clob_ := clob_ || '</table>';
        clob_ := clob_ || '</th></tr>';
      END IF;

      IF clob_ranges IS NOT NULL THEN
        clob_ := clob_ || '<tr><th>';
        clob_ := clob_ || '<table class="inlineTable">';
        clob_ := clob_ || '<tr><th colspan="3">Ranges</th></tr>';
        clob_ := clob_ || '<tr><th>Begin Value</th><th>End Value</th><th>Description</th></tr>';
        clob_ := clob_ || clob_ranges;
        clob_ := clob_ || '</table>';
        clob_ := clob_ || '</th></tr>';
      END IF;

      IF clob_vl IS NOT NULL THEN
        clob_ := clob_ || '<tr><th>';
        clob_ := clob_ || '<table class="inlineTable">';
        clob_ := clob_ || '<tr><th colspan="2">Value List</th></tr>';
        clob_ := clob_ || '<tr><th>Value</th><th>Description</th></tr>';
        clob_ := clob_ || clob_vl;
        clob_ := clob_ || '</table>';
        clob_ := clob_ || '</th></tr>';
      END IF;

      clob_ := clob_ || '</table>';

      RETURN clob_;

    END IF;

EXCEPTION
 WHEN others THEN
  UTL_FILE.PUT_LINE(log_file, 'Pkg_Osdm_Utils.Gather_Constraint_Details_HTML Exception : ' || SQLERRM);  
  UTL_FILE.PUT_LINE(log_file, 'Pkg_Osdm_Utils.Gather_Constraint_Details_HTML Exception : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  RETURN clob_;
  
END Gather_Constraint_Details_HTML;

FUNCTION Gather_Domain_Constraints_HTML (domain_ovid VARCHAR2) RETURN CLOB IS

clob_            CLOB;
clob_constraints CLOB;
clob_ranges      CLOB;
clob_vl          CLOB;

CURSOR cur_c_constraints(v_c_ovid IN VARCHAR2) IS
 SELECT NVL(text,' ')           text,
        NVL(database_type,' ')  database_type
 FROM   dmrs_domain_check_constraints
 WHERE  domain_ovid = v_c_ovid
 ORDER BY sequence;
rec_c_constraints cur_c_constraints%rowtype;

CURSOR cur_ranges(v_c_ovid IN VARCHAR2) IS
 SELECT NVL(begin_value,' ')           begin_value,
        NVL(end_value, ' ')            end_value,
        NVL(short_description,' ')     short_description
 FROM   dmrs_domain_value_ranges
 WHERE  domain_ovid = v_c_ovid
 ORDER BY sequence;
rec_ranges cur_ranges%rowtype;

CURSOR cur_valuelist_columns(v_c_ovid IN VARCHAR2) IS
 SELECT NVL(av.value,' ')             value,
        NVL(av.short_description,' ') short_description
 FROM   dmrs_domain_avt av
 WHERE  av.domain_ovid = v_c_ovid;
rec_valuelist_columns cur_valuelist_columns%rowtype;

BEGIN
    
    DBMS_LOB.CREATETEMPORARY(clob_constraints, TRUE);
    DBMS_LOB.CREATETEMPORARY(clob_ranges, TRUE);
    DBMS_LOB.CREATETEMPORARY(clob_vl, TRUE);
    DBMS_LOB.CREATETEMPORARY(clob_, TRUE);
    
    FOR rec_c_constraints IN cur_c_constraints(domain_ovid) LOOP
        DBMS_LOB.APPEND (clob_constraints, '<tr><td>');
        DBMS_LOB.APPEND (clob_constraints, REPLACE(rec_c_constraints.text, Chr(10), '<br/>'));
        DBMS_LOB.APPEND (clob_constraints, '</td><td align="center">' );
        DBMS_LOB.APPEND (clob_constraints, rec_c_constraints.database_type );
        DBMS_LOB.APPEND (clob_constraints, '</td></tr>');
    END LOOP;

    FOR rec_ranges IN cur_ranges(domain_ovid) LOOP
        DBMS_LOB.APPEND (clob_ranges,'<tr><td align="right">');
        DBMS_LOB.APPEND (clob_ranges, rec_ranges.begin_value);
        DBMS_LOB.APPEND (clob_ranges,'</td><td align="right">');    
        DBMS_LOB.APPEND (clob_ranges, rec_ranges.end_value);
        DBMS_LOB.APPEND (clob_ranges,'</td><td>');
        DBMS_LOB.APPEND (clob_ranges,REPLACE(rec_ranges.short_description, Chr(10), '<br/>'));
        DBMS_LOB.APPEND (clob_ranges,'</td></tr>');
    END LOOP;

    FOR rec_valuelist_columns IN cur_valuelist_columns(domain_ovid) LOOP
        DBMS_LOB.APPEND (clob_vl,'<tr><td align="right">');
        DBMS_LOB.APPEND (clob_vl,rec_valuelist_columns.VALUE);
        DBMS_LOB.APPEND (clob_vl,'</td><td>'); 
        DBMS_LOB.APPEND (clob_vl,REPLACE(rec_valuelist_columns.short_description, Chr(10), '<br/>'));
        DBMS_LOB.APPEND (clob_vl,'</td></tr>');
    END LOOP;

    IF (clob_constraints IS NULL AND clob_ranges IS NULL AND clob_vl IS NULL) THEN
      RETURN '';
    ELSE

      DBMS_LOB.APPEND (clob_, '<table class="inlineTable">');

      IF clob_constraints IS NOT NULL THEN
         DBMS_LOB.APPEND (clob_,'<tr><th>');
         DBMS_LOB.APPEND (clob_,'<table class="inlineTable">');
         DBMS_LOB.APPEND (clob_,'<tr><th colspan="3">Check Constraint</th></tr>');
         DBMS_LOB.APPEND (clob_,'<tr><th>Text</th><th>DB Type</th></tr>');
         DBMS_LOB.APPEND (clob_,clob_constraints);
         DBMS_LOB.APPEND (clob_,'</table>');
         DBMS_LOB.APPEND (clob_,'</th></tr>');
      END IF;

      IF clob_ranges IS NOT NULL THEN
         DBMS_LOB.APPEND (clob_,'<tr><th>');
         DBMS_LOB.APPEND (clob_,'<table class="inlineTable">');
         DBMS_LOB.APPEND (clob_,'<tr><th colspan="3">Ranges</th></tr>');
         DBMS_LOB.APPEND (clob_,'<tr><th>Begin Value</th><th>End Value</th><th>Description</th></tr>');
         DBMS_LOB.APPEND (clob_,clob_ranges);
         DBMS_LOB.APPEND (clob_,'</table>');
         DBMS_LOB.APPEND (clob_,'</th></tr>');
      END IF;

      IF clob_vl IS NOT NULL THEN
         DBMS_LOB.APPEND (clob_,'<tr><th>');
         DBMS_LOB.APPEND (clob_,'<table class="inlineTable">');
         DBMS_LOB.APPEND (clob_,'<tr><th colspan="2">Value List</th></tr>');
         DBMS_LOB.APPEND (clob_,'<tr><th>Value</th><th>Description</th></tr>');
         DBMS_LOB.APPEND (clob_,clob_vl);
         DBMS_LOB.APPEND (clob_,'</table>');
         DBMS_LOB.APPEND (clob_,'</th></tr>');
      END IF;

      DBMS_LOB.APPEND (clob_,'</table>');
    END IF;

 RETURN clob_;
 
EXCEPTION
 WHEN others THEN
  UTL_FILE.PUT_LINE(log_file, 'Pkg_Osdm_Utils.Gather_Domain_Constraints_HTML Exception : : ' || SQLERRM);  
  UTL_FILE.PUT_LINE(log_file, 'Pkg_Osdm_Utils.Gather_Domain_Constraints_HTML Exception : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  RETURN clob_;

END Gather_Domain_Constraints_HTML;

FUNCTION Gather_Domain_Constraints_XML(domain_ovid VARCHAR2) RETURN CLOB IS

res          CLOB;
v_cc_created BOOLEAN := FALSE;

CURSOR cur_c_constraints(v_c_ovid IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(all_domains_prefix || ':Text'),d.text).getClobVal()                  text,
        XMLElement(EVALNAME(all_domains_prefix || ':DatabaseType'),d.database_type).getClobVal() database_type,
        COUNT(text) over()                                                                       total_row_count
 FROM   dmrs_domain_check_constraints d
 WHERE  d.domain_ovid = v_c_ovid
 ORDER BY d.database_type;
rec_c_constraints cur_c_constraints%rowtype;

CURSOR cur_ranges(v_c_ovid IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(all_domains_prefix || ':RangeBeginValue'),d.begin_value).getClobVal()             begin_value,
        XMLElement(EVALNAME(all_domains_prefix || ':RangeEndValue'),d.end_value).getClobVal()                 end_value,
        XMLElement(EVALNAME(all_domains_prefix || ':RangeShortDescription'),d.short_description).getClobVal() short_description,
        COUNT(begin_value) over() total_row_count
 FROM   dmrs_domain_value_ranges d
 WHERE  d.domain_ovid = v_c_ovid
 ORDER BY d.begin_value, 
          d.end_value,
          d.short_description;
rec_ranges cur_ranges%rowtype;

CURSOR cur_valuelist_columns(v_c_ovid IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(all_domains_prefix || ':VLValue'),av.value).getClobVal()                         v_value, 
        XMLElement(EVALNAME(all_domains_prefix || ':VLShortDescription'),av.short_description).getClobVal()  short_description,
        COUNT(value) over() total_row_count
 FROM   dmrs_domain_avt av
 WHERE  av.domain_ovid = v_c_ovid
 ORDER BY av.value, 
          av.short_description;
rec_valuelist_columns cur_valuelist_columns%rowtype;

BEGIN

    DBMS_LOB.CREATETEMPORARY(res, TRUE);

    FOR rec_ranges IN cur_ranges(domain_ovid) LOOP
       IF (cur_ranges%ROWCOUNT = 1) THEN
          IF NOT v_cc_created THEN 
            DBMS_LOB.APPEND (res, '<' || all_domains_prefix || ':ConstraintsCollection>');
            DBMS_LOB.APPEND (res, '<' || all_domains_prefix || ':ConstraintDetails>');
            v_cc_created := TRUE;
          END IF;
          DBMS_LOB.APPEND (res,'<' || all_domains_prefix || ':RangesCollection>');
       END IF;
          DBMS_LOB.APPEND (res,'<' || all_domains_prefix || ':RangeDetails>');
          DBMS_LOB.APPEND (res,rec_ranges.begin_value);
          DBMS_LOB.APPEND (res,rec_ranges.end_value);
          DBMS_LOB.APPEND (res,rec_ranges.short_description);
          DBMS_LOB.APPEND (res,'</' || all_domains_prefix || ':RangeDetails>');
       IF (cur_ranges%ROWCOUNT = rec_ranges.total_row_count) THEN
          DBMS_LOB.APPEND (res, '</' || all_domains_prefix || ':RangesCollection>');
       END IF;
    END LOOP;

    FOR rec_valuelist_columns IN cur_valuelist_columns(domain_ovid) LOOP
       IF (cur_valuelist_columns%ROWCOUNT = 1) THEN
          IF NOT v_cc_created THEN 
            DBMS_LOB.APPEND (res, '<' || all_domains_prefix || ':ConstraintsCollection>');
            DBMS_LOB.APPEND (res, '<' || all_domains_prefix || ':ConstraintDetails>');
            v_cc_created := TRUE;
          END IF;
          DBMS_LOB.APPEND (res,'<' || all_domains_prefix || ':ValueListsCollection>');
       END IF;
          DBMS_LOB.APPEND (res,'<' || all_domains_prefix || ':ValueListDetails>');
          DBMS_LOB.APPEND (res,rec_valuelist_columns.v_value);
          DBMS_LOB.APPEND (res,rec_valuelist_columns.short_description);
          DBMS_LOB.APPEND (res,'</' || all_domains_prefix || ':ValueListDetails>');
       IF (cur_valuelist_columns%ROWCOUNT = rec_valuelist_columns.total_row_count) THEN
          DBMS_LOB.APPEND (res, '</' || all_domains_prefix || ':ValueListsCollection>');
       END IF;
    END LOOP;
   
    FOR rec_c_constraints IN cur_c_constraints(domain_ovid) LOOP
       IF (cur_c_constraints%ROWCOUNT = 1) THEN
          IF NOT v_cc_created THEN 
            DBMS_LOB.APPEND (res, '<' || all_domains_prefix || ':ConstraintsCollection>');
            DBMS_LOB.APPEND (res, '<' || all_domains_prefix || ':ConstraintDetails>');
            v_cc_created := TRUE;
          END IF;
          DBMS_LOB.APPEND (res,'<' || all_domains_prefix || ':CheckConstraintsCollection>');
       END IF;
       
          DBMS_LOB.APPEND (res,'<' || all_domains_prefix || ':CheckConstraintDetails>');
          DBMS_LOB.APPEND (res,rec_c_constraints.text);
          DBMS_LOB.APPEND (res,rec_c_constraints.database_type);
          DBMS_LOB.APPEND (res,'</' || all_domains_prefix || ':CheckConstraintDetails>');
       IF (cur_c_constraints%ROWCOUNT = rec_c_constraints.total_row_count) THEN
          DBMS_LOB.APPEND (res, '</' || all_domains_prefix || ':CheckConstraintsCollection>');
       END IF;
    END LOOP;

    IF v_cc_created THEN 
       DBMS_LOB.APPEND (res, '</' || all_domains_prefix || ':ConstraintDetails>');
       DBMS_LOB.APPEND (res, '</' || all_domains_prefix || ':ConstraintsCollection>');
    END IF;

  RETURN res;

EXCEPTION
 WHEN others THEN
  UTL_FILE.PUT_LINE(log_file, 'Pkg_Osdm_Utils.Gather_Domain_Constraints_XML Exception : : ' || SQLERRM);  
  UTL_FILE.PUT_LINE(log_file, 'Pkg_Osdm_Utils.Gather_Domain_Constraints_XML Exception : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  RETURN res;
  
END Gather_Domain_Constraints_XML;

FUNCTION Gather_AllDomains_Data(v_obj_ovid IN VARCHAR2, reportTemplate IN REPORT_TEMPLATE) RETURN CLOB IS 

res          CLOB;
token_value  CLOB;
v_comment    CLOB;

-- Common Data
CURSOR cur_common_data(v_ovid IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(all_domains_prefix || ':DesignName'),d.design_name).getClobVal()                                      design_name,
        XMLElement(EVALNAME(all_domains_prefix || ':VersionDate'),TO_CHAR(d.date_published,'dd.mm.yyyy hh24:mi:ss')).getClobVal() version_date,
        XMLElement(EVALNAME(all_domains_prefix || ':VersionComment'),XMLCDATA(d.version_comments)).getClobVal()                   version_comment
 FROM   dmrs_designs d
 WHERE  d.design_ovid = v_ovid;
rec_common_data cur_common_data%ROWTYPE;

CURSOR cur_all_domains(v_o_ovid IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(all_domains_prefix || ':DomainName'), d.domain_name).getClobVal()                        domain_name, 
		XMLElement(EVALNAME(all_domains_prefix || ':EncodedName'), d.ovid).getClobVal()                        		 xml_ovid, 
 		XMLElement(EVALNAME(all_domains_prefix || ':Synonyms'), d.synonyms).getClobVal()                             synonyms,
        XMLElement(EVALNAME(all_domains_prefix || ':DataType'), d.native_type  ||' '||
           DECODE (NVL(d.t_size,''),'',
           DECODE(NVL(d.t_scale,0),0,
                DECODE(NVL(d.t_precision,0),0,null,'('|| DECODE(NVL(d.t_precision,0),0,null,d.t_precision) ||')'),
                        '('|| DECODE(NVL(d.t_precision,0),0,null,d.t_precision) || ',' || DECODE(NVL(d.t_scale,0),0,null,d.t_scale)||')'),
       '('||TRIM(DECODE(d.t_size,'',null,d.t_size||' '||d.char_units ))||')')).getClobVal()  data_type,
        XMLElement(EVALNAME(all_domains_prefix || ':LogicalType'), d.lt_name).getClobVal()                           lt_name,
        XMLElement(EVALNAME(all_domains_prefix || ':UnitOfMeasure'), d.unit_of_measure).getClobVal()                 unit_of_measure,
        XMLElement(EVALNAME(all_domains_prefix || ':DefaultValue'), d.default_value).getClobVal()                    default_value,
        Gather_Domain_Constraints_XML(d.ovid)                                               constraint_details,
        d.ovid                                                                              domain_ovid,
        COUNT(d.domain_name) over()                                                         total_row_count
 FROM   dmrs_domains d
 WHERE  d.design_ovid = v_o_ovid
 ORDER BY d. domain_name;
rec_all_domains cur_all_domains%ROWTYPE;

CURSOR cur_used_in_tables(v_d_ovid IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(all_domains_prefix || ':ModelName'), c.model_name).getClobVal()     model_name,
        XMLElement(EVALNAME(all_domains_prefix || ':TableName'), c.table_name).getClobVal()     table_name,
        XMLElement(EVALNAME(all_domains_prefix || ':ColumnName'), c.column_name).getClobVal()   column_name,
        COUNT(c.model_name) over()                                     total_row_count
 FROM   dmrs_columns c,
        dmrs_domains d
 WHERE  d.ovid = v_d_ovid
 AND    c.domain_ovid = d.ovid
 ORDER BY c.model_name,
          c.table_name,
          c.column_name;
rec_used_in_tables cur_used_in_tables%ROWTYPE;

CURSOR cur_used_in_entities(v_d_ovid IN VARCHAR2) IS
 SELECT XMLElement(EVALNAME(all_domains_prefix || ':EntityName'), a.entity_name).getClobVal()        entity_name,
        XMLElement(EVALNAME(all_domains_prefix || ':AttributeName'), a.attribute_name).getClobVal()  attribute_name,
        COUNT(a.entity_name) over()                                         total_row_count
 FROM   dmrs_attributes a,
        dmrs_domains d
 WHERE  d.ovid = v_d_ovid
 AND    a.domain_ovid = d.ovid
 ORDER BY a.entity_name,
          a.attribute_name;
rec_used_in_entities cur_used_in_entities%ROWTYPE;

BEGIN

  UTL_FILE.PUT_LINE(log_file, TO_CHAR(SYSDATE,'yy.mm.dd hh:mi:ss') ||' '|| 'Gathering all domains data started ...');

  DBMS_LOB.CREATETEMPORARY(res, TRUE);
 
  DBMS_LOB.APPEND (res,'<' || all_domains_prefix || ':Domains xmlns:' || all_domains_prefix || '="http://oracle.com/datamodeler/reports/domains">');

   -- Common Data
   FOR rec_common_data IN cur_common_data(v_obj_ovid) LOOP

      DBMS_LOB.APPEND (res, rec_common_data.design_name);
      DBMS_LOB.APPEND (res, rec_common_data.version_date);
      DBMS_LOB.APPEND (res, rec_common_data.version_comment);

   END LOOP;

   FOR rec_all_domains IN cur_all_domains(v_obj_ovid) LOOP
      IF (cur_all_domains%ROWCOUNT = 1) THEN
        DBMS_LOB.APPEND (res,'<' || all_domains_prefix || ':DomainsCollection>');
      END IF;

        DBMS_LOB.APPEND (res,'<' || all_domains_prefix || ':DomainDetails>');
         
        DBMS_LOB.APPEND (res,rec_all_domains.domain_name);
        DBMS_LOB.APPEND (res,rec_all_domains.xml_ovid);
        DBMS_LOB.APPEND (res,rec_all_domains.synonyms);
        DBMS_LOB.APPEND (res,rec_all_domains.data_type);
        DBMS_LOB.APPEND (res,rec_all_domains.lt_name);
        DBMS_LOB.APPEND (res,rec_all_domains.unit_of_measure);
        DBMS_LOB.APPEND (res,rec_all_domains.default_value);
        
        BEGIN
            SELECT  XMLElement(EVALNAME(all_domains_prefix || ':DomainComment'), XMLCDATA(lt.text)).getClobVal()
            INTO    v_comment
            FROM    dmrs_large_text lt
            WHERE   lt.ovid = rec_all_domains.domain_ovid;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                SELECT  XMLElement(EVALNAME(all_domains_prefix || ':DomainComment'), '').getClobVal()
                INTO    v_comment
                FROM    dual;
        END;
            
        DBMS_LOB.APPEND (res,v_comment);
      
        -- Constraints
        IF (reportTemplate.reportType = 0 OR reportTemplate.useDomainConstraints = 1) THEN
          DBMS_LOB.APPEND (res,rec_all_domains.constraint_details);
        END IF;

        -- Used in tables
        IF (reportTemplate.reportType = 0 OR reportTemplate.useDomainUsedInTables = 1) THEN
          FOR rec_used_in_tables IN cur_used_in_tables(rec_all_domains.domain_ovid) LOOP
             IF (cur_used_in_tables%ROWCOUNT = 1) THEN
                DBMS_LOB.APPEND (res,'<' || all_domains_prefix || ':TablesCollection>');
             END IF;
                DBMS_LOB.APPEND (res,'<' || all_domains_prefix || ':TableDetails>');
                DBMS_LOB.APPEND (res,rec_used_in_tables.model_name);
                DBMS_LOB.APPEND (res,rec_used_in_tables.table_name);
                DBMS_LOB.APPEND (res,rec_used_in_tables.column_name);
                DBMS_LOB.APPEND (res,'</' || all_domains_prefix || ':TableDetails>');
             IF (cur_used_in_tables%ROWCOUNT = rec_used_in_tables.total_row_count) THEN
                DBMS_LOB.APPEND (res, '</' || all_domains_prefix || ':TablesCollection>');
             END IF;
          END LOOP;
        END IF;

        -- Used in entities
        IF (reportTemplate.reportType = 0 OR reportTemplate.useDomainUsedInEntities = 1) THEN
          FOR rec_used_in_entities IN cur_used_in_entities(rec_all_domains.domain_ovid) LOOP
             IF (cur_used_in_entities%ROWCOUNT = 1) THEN
                DBMS_LOB.APPEND (res,'<' || all_domains_prefix || ':EntitiesCollection>');
             END IF;
                DBMS_LOB.APPEND (res,'<' || all_domains_prefix || ':EntityDetails>');
                DBMS_LOB.APPEND (res,rec_used_in_entities.entity_name);
                DBMS_LOB.APPEND (res,rec_used_in_entities.attribute_name);
                DBMS_LOB.APPEND (res,'</' || all_domains_prefix || ':EntityDetails>');
             IF (cur_used_in_entities%ROWCOUNT = rec_used_in_entities.total_row_count) THEN
                DBMS_LOB.APPEND (res, '</' || all_domains_prefix || ':EntitiesCollection>');
             END IF;
          END LOOP;
        END IF;

        DBMS_LOB.APPEND (res,'</' || all_domains_prefix || ':DomainDetails>');

      IF (cur_all_domains%ROWCOUNT = rec_all_domains.total_row_count) THEN
       DBMS_LOB.APPEND (res, '</' || all_domains_prefix || ':DomainsCollection>');
      END IF;
   END LOOP;

  DBMS_LOB.APPEND (res,'</' || all_domains_prefix || ':Domains>');
  
  UTL_FILE.PUT_LINE(log_file, TO_CHAR(SYSDATE,'yy.mm.dd hh:mi:ss') ||' '|| 'Gathering all domains data ended');

RETURN res;

EXCEPTION
 WHEN others THEN
  UTL_FILE.PUT_LINE(log_file, 'Pkg_Osdm_Utils.Gather_AllDomains_Data Exception : ' || SQLERRM);  
  UTL_FILE.PUT_LINE(log_file, 'Pkg_Osdm_Utils.Gather_AllDomains_Data Exception : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  RETURN res;
 
END Gather_AllDomains_Data;  

FUNCTION Create_Log_File(v_reports_dir IN VARCHAR2) RETURN NUMBER IS 

insufficient_privileges EXCEPTION;
PRAGMA EXCEPTION_INIT(insufficient_privileges, -01031);

BEGIN

 IF v_reports_dir IS NOT NULL THEN
  EXECUTE IMMEDIATE 'CREATE OR REPLACE DIRECTORY OSDDM_REPORTS_DIR AS '''|| v_reports_dir ||'''';
  EXECUTE IMMEDIATE 'GRANT READ, WRITE ON DIRECTORY OSDDM_REPORTS_DIR TO PUBLIC';
 END IF;

 log_file := UTL_FILE.Fopen('OSDDM_REPORTS_DIR','osddm_reports.log','w', 32767);

RETURN 0;

 EXCEPTION
  WHEN UTL_FILE.Invalid_Path THEN
   RETURN 1;
  WHEN  UTL_FILE.Read_Error OR UTL_FILE.Write_Error OR UTL_FILE.Access_Denied THEN 
   RETURN 2;
  WHEN insufficient_privileges THEN
   RETURN 3;

END Create_Log_File;

PROCEDURE Generate_Report(v_rep_id           IN NUMBER,
                          v_obj_ovid         IN VARCHAR2,
                          v_mode             IN NUMBER,
                          v_reports_dir      IN VARCHAR2,
                          v_report_name      IN VARCHAR2, 
                          reportTemplate     IN REPORT_TEMPLATE,
                          objects            IN OBJECTS_LIST,
                          v_raw_xml         OUT BFILE, 
                          v_status          OUT NUMBER, 
                          osddm_reports_dir OUT VARCHAR2,
                          v_diagrams        OUT SYS_REFCURSOR,
                          v_diagrams_svg    OUT SYS_REFCURSOR) IS

raw_xml_fn        CONSTANT VARCHAR2(20) := 'report_data_rs.xml';
res               CLOB;
db_data_clob      CLOB;
v_blob						BLOB;
v_blob_xml				BLOB;
v_dest_offset			INTEGER := 1;
v_src_offset			INTEGER := 1;
warning						INTEGER;
rseq              INTEGER;
nseq              INTEGER;
v_lang_context		NUMBER 	:= DBMS_LOB.Default_Lang_Ctx;
v_p_doc_xml_lngth NUMBER;
j_status          NUMBER;
db_version        VARCHAR2(100);

BEGIN

    v_status := Create_Log_File(v_reports_dir);

    IF (v_status = 0)  THEN

      DBMS_LOB.CREATETEMPORARY(v_blob, TRUE);
      DBMS_LOB.CREATETEMPORARY(v_blob_xml, TRUE);
      DBMS_LOB.CREATETEMPORARY(db_data_clob, TRUE);
      
      DBMS_LOB.APPEND (db_data_clob,'<?xml version = ''1.0'' encoding = ''UTF-8''?>');

      IF v_rep_id = 1 THEN
         DBMS_LOB.APPEND (db_data_clob, Gather_SingleTable_Data(v_obj_ovid, reportTemplate, v_report_name));
      ELSIF v_rep_id = 2 THEN
         DBMS_LOB.APPEND (db_data_clob, Gather_AllTables_Data(v_obj_ovid, reportTemplate, objects, v_report_name));
      ELSIF v_rep_id = 3 THEN
         DBMS_LOB.APPEND (db_data_clob, Gather_SingleEntity_Data(v_obj_ovid, reportTemplate, v_report_name));
      ELSIF v_rep_id = 4 THEN
         DBMS_LOB.APPEND (db_data_clob, Gather_AllEntities_Data(v_obj_ovid, reportTemplate, objects, v_report_name));
      ELSIF v_rep_id = 5 THEN
         DBMS_LOB.APPEND (db_data_clob, Gather_AllDomains_Data(v_obj_ovid, reportTemplate));
      ELSIF v_rep_id = 6 THEN
         DBMS_LOB.APPEND (db_data_clob, Gather_Glossary_Data(v_obj_ovid));
      ELSIF v_rep_id = 7 THEN
         DBMS_LOB.APPEND (db_data_clob, Gather_SingleST_Data(v_obj_ovid, reportTemplate, v_report_name));
      ELSIF v_rep_id = 8 THEN
         DBMS_LOB.APPEND (db_data_clob, Gather_AllST_Data(v_obj_ovid, reportTemplate, objects, v_report_name));
      ELSIF v_rep_id = 9 THEN
         DBMS_LOB.APPEND (db_data_clob, Gather_SingleCT_Data(v_obj_ovid, reportTemplate));
      ELSIF v_rep_id = 10 THEN
         DBMS_LOB.APPEND (db_data_clob, Gather_AllCT_Data(v_obj_ovid, reportTemplate, objects));
      ELSIF v_rep_id = 11 THEN
         DBMS_LOB.APPEND (db_data_clob, Gather_SingleDT_Data(v_obj_ovid, reportTemplate));
      ELSIF v_rep_id = 12 THEN
         DBMS_LOB.APPEND (db_data_clob, Gather_AllDT_Data(v_obj_ovid, reportTemplate, objects));
      ELSIF v_rep_id = 13 THEN
         DBMS_LOB.APPEND (db_data_clob, Gather_CR_Data(v_obj_ovid, reportTemplate));
      ELSIF v_rep_id = 14 THEN
         DBMS_LOB.APPEND (db_data_clob, Gather_MR_Data(v_obj_ovid, reportTemplate));
      END IF;
      
      -- Get the PDF diagrams if they are exported
      IF v_rep_id IN(2, 4, 8) THEN
		 -- All Tables, All Entities, All Structured Types
         OPEN v_diagrams FOR
             SELECT pdf_name,
                    diagram_pdf
             FROM   dmrs_vdiagrams
             WHERE  model_ovid = v_obj_ovid
             AND    diagram_type = 'Subview'
             AND    diagram_pdf IS NOT NULL
             AND    is_display = 'N';

      ELSIF v_rep_id IN (1, 3, 7) THEN
		 --Single Table, Single Entity, Single tructured Type
         OPEN v_diagrams FOR
             SELECT d.pdf_name,
                    d.diagram_pdf
             FROM   dmrs_vdiagrams d,
                   (SELECT diagram_ovid 
                    FROM   dmrs_diagram_elements
                    WHERE  ovid = v_obj_ovid) b
             WHERE d.ovid = b.diagram_ovid
             AND   d.diagram_type = 'Subview'
             AND   d.diagram_pdf IS NOT NULL
             AND   d.is_display = 'N';

      END IF;

      -- Get the SVG diagrams if they are exported
      IF v_rep_id IN(2, 4, 8) THEN
		 -- All Tables, All Entities, All Structured Types
         OPEN v_diagrams_svg FOR
             SELECT svg_name,
                    diagram_svg
             FROM   dmrs_vdiagrams
             WHERE  model_ovid = v_obj_ovid
             AND    diagram_type = 'Subview'
             AND    diagram_svg IS NOT NULL
             AND    is_display = 'N';

      ELSIF v_rep_id IN (1, 3, 7) THEN
		 --Single Table, Single Entity, Single tructured Type
         OPEN v_diagrams FOR
             SELECT d.svg_name,
                    d.diagram_svg
             FROM   dmrs_vdiagrams d,
                   (SELECT diagram_ovid 
                    FROM   dmrs_diagram_elements
                    WHERE  ovid = v_obj_ovid) b
             WHERE d.ovid = b.diagram_ovid
             AND   d.diagram_type = 'Subview'
             AND   d.diagram_svg IS NOT NULL
             AND   d.is_display = 'N';

      END IF;
      
	  SELECT banner
      INTO   db_version
      FROM   v$version
      WHERE  banner LIKE 'Oracle%';

      -- raw xml
      DBMS_LOB.CONVERTTOBLOB(v_blob_xml,
                             db_data_clob,
                             DBMS_LOB.LOBMAXSIZE,
                             v_dest_offset,
                             v_src_offset,
                             873, -- AL32UTF8
                             v_lang_context,
                             warning);
      Generate_OS_File(v_blob_xml, raw_xml_fn);
      v_raw_xml := BFILENAME('OSDDM_REPORTS_DIR', raw_xml_fn);

      UTL_FILE.fclose(log_file);

   END IF;

COMMIT;

   SELECT directory_path
   INTO   osddm_reports_dir
   FROM   all_directories
   WHERE  directory_name = 'OSDDM_REPORTS_DIR';

EXCEPTION

   WHEN others THEN
     ROLLBACK;
     IF (v_mode = 1) THEN
        UTL_FILE.PUT_LINE(log_file, 'Pkg_Osdm_Utils.Generate_Report Exception : ' || SQLERRM);  
        UTL_FILE.PUT_LINE(log_file, 'Pkg_Osdm_Utils.Generate_Report Exception : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        UTL_FILE.fclose(log_file);
     ELSIF (v_mode = 2) THEN
        htp.p('<br/>');
        htp.p('<br/>');
        htp.p('Error occured during report generation:');
        htp.p('<br/>');
        htp.p('Pkg_Osdm_Utils.Generate_Report Exception:');
        htp.p(sqlerrm);
        htp.p('<br/>');
        htp.p('For more details see the report generation log file in OSDDM_REPORTS_DIR directory.');
        UTL_FILE.PUT_LINE(log_file, 'Pkg_Osdm_Utils.Generate_Report Exception : ' || SQLERRM);  
        UTL_FILE.PUT_LINE(log_file, 'Pkg_Osdm_Utils.Generate_Report Exception : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
     END IF;
     
     IF UTL_FILE.is_open(log_file) THEN
        UTL_FILE.fclose(log_file);
     END IF;
     IF UTL_FILE.is_open(temp_file) THEN
        UTL_FILE.fclose(temp_file);
     END IF;

END Generate_Report;

END PKG_OSDM_UTILS;
/