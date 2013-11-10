/******************************************************************************/
/* Author:  Alfred Gerke (AGE)
/* Date:    2013-03-31
/* Purpose: Dieses Script setzt eine neu erstellte Produktionsdatenbank Version 
/*          2.0x voraus.
/*          Diese Scripte werden zum Testen von SPs verwendet                                                                                                       
/******************************************************************************/
/* - Das Script arbeitet mit Befehlen der SQL-Erweiterung für FireBird 2.0.6   
/* - Das Script ist für die Ausführung im IBExpert erstellt worden            
/* - Ein Connect zur Produktionsdatenbank muss hergestellt werden 
/* - Es müssen alle notwendigen Create- und Updatescripte eingespielt worden sein
/******************************************************************************/
/* History: 2013-03-31
/*          Entwicklungsdaten für Betriebsinformationen
/******************************************************************************/

/******************************************************************************/
/*                                 Insert into REGISTRY                                  
/******************************************************************************/

SET TERM ^ ; /* definiert den Begin eines Ausführungsblockes */
EXECUTE BLOCK AS
DECLARE key_section varchar(128);
DECLARE section varchar(128);
DECLARE ident varchar(128);
DECLARE value_for_ident varchar(255);
BEGIN
  
  key_section = 'GENERATE';  
  ident = 'FIX_TABLENAME';
  
  section = 'FACTORY_DATA';
  value_for_ident = 'FACTORY_DATA';
  execute procedure SP_WRITESTRING :key_section, :section, :ident, :value_for_ident;
  
  section = 'PERSON';
  value_for_ident = 'PERSON_DATA';
  execute procedure SP_WRITESTRING :key_section, :section, :ident, :value_for_ident;
  
  section = 'ADDRESS';
  value_for_ident = 'ADDRESS_DATA';
  execute procedure SP_WRITESTRING :key_section, :section, :ident, :value_for_ident;
  
  section = 'CONTACT';
  value_for_ident = 'CONTACT_DATA';
  execute procedure SP_WRITESTRING :key_section, :section, :ident, :value_for_ident;      

END^        
SET TERM ; ^ /* definiert das Ende eines Ausführungsblockes */
/******************************************************************************/
/*                                 Insert into CATEGORY                                  
/******************************************************************************/

SET TERM ^ ; /* definiert den Begin eines Ausführungsblockes */
EXECUTE BLOCK AS
DECLARE key_section varchar(128);
DECLARE section varchar(128);
DECLARE ident varchar(128);
DECLARE default_for_ident varchar(255);
DECLARE value_by_ident varchar(255);
DECLARE default_country_id integer;
DECLARE titel_id integer;
DECLARE salutation_id integer;
DECLARE person_id integer;
DECLARE bank_id integer;
DECLARE code DBOBJECTNAME32;
DECLARE desc varchar(2000);
DECLARE do_not_delete BOOLEAN;
BEGIN

  key_section = 'GENERAL';
  section = 'DEFAULT';
  ident = 'COUNTRYCODE';
  default_for_ident = '';
  select RESULT from SP_READSTRING(:key_section, :section, :ident, :default_for_ident) into :value_by_ident;

  select ID from COUNTRY where COUNTRY_CODE=:value_by_ident into :default_country_id; 

  INSERT INTO CATEGORY (COUNTRY_ID, LABEL, CAPTION, DESCRIPTION)
                VALUES (:default_country_id, 'FIELDDEF', 'Beitragsdaten', 'Informationen zu Beitragsdaten gruppieren');
  INSERT INTO CATEGORY (COUNTRY_ID, LABEL, CAPTION, DESCRIPTION)
                VALUES (:default_country_id, 'FIELDDEF', 'Betriebsdaten', 'Informationen zu Betriebsdaten gruppieren');
  INSERT INTO CATEGORY (COUNTRY_ID, LABEL, CAPTION, DESCRIPTION)
                VALUES (:default_country_id, 'FIELDDEF', 'Ehrenämter', 'Informationen zu Ehrenämter gruppieren');
                
  desc = 'Domaine: Personennummer';
  code = 'PERSONNUMBER';
  do_not_delete = 0;
  INSERT INTO DATATYPE (CODE, DESCRIPTION, DONOTDELETE) VALUES(:code, :desc, :do_not_delete);
  
  desc = 'Domaine: Betriebsnummer';
  code = 'FACTORYNUMBER';
  do_not_delete = 0;
  INSERT INTO DATATYPE (CODE, DESCRIPTION, DONOTDELETE) VALUES(:code, :desc, :do_not_delete); 
  
  INSERT INTO FIELD_STORE (TENANT_ID, CATEGORY_ID, LABEL, CODE, NAME, DATA_TYPE, TYPE_LENGTH, TYPE_SCALE, MANDATORY, IS_FOREIGN_KEY, IS_LOOKUP, REFERENCE_TABLE, LOOKUP_CAPTION_FIELD, LOOKUP_REF_ID_FIELD, UNIQUE_IDX_NAME, IS_CALCULATED, CALC_SP_NAME, IS_VISIBLE, DESCRIPTION, DONOTDELETE)
  VALUES (1, 1, 'CALCULATE', 'BEW_FL', 'Bewirtschaftete Fläche', 'NUMERIC', 14, 4, 0, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, 1, 'Feld wird Teil der Kalkulation/Buchhaltung und nicht des Datenblattes', 0);
  
  INSERT INTO FIELD_STORE (TENANT_ID, CATEGORY_ID, LABEL, CODE, NAME, DATA_TYPE, TYPE_LENGTH, TYPE_SCALE, MANDATORY, IS_FOREIGN_KEY, IS_LOOKUP, REFERENCE_TABLE, LOOKUP_CAPTION_FIELD, LOOKUP_REF_ID_FIELD, UNIQUE_IDX_NAME, IS_CALCULATED, CALC_SP_NAME, IS_VISIBLE, DESCRIPTION, DONOTDELETE)
  VALUES (1, 1, 'CALCULATE', 'EUR_BEW_FL', 'EUR pro ha Fläche', 'NUMERIC', 14, 3, 0, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, 1, 'Feld wird Teil der Kalkulation/Buchhaltung und nicht des Datenblattes', 0);  

  INSERT INTO FIELD_STORE (TENANT_ID, CATEGORY_ID, LABEL, CODE, NAME, DATA_TYPE, TYPE_LENGTH, TYPE_SCALE, MANDATORY, IS_FOREIGN_KEY, IS_LOOKUP, REFERENCE_TABLE, LOOKUP_CAPTION_FIELD, LOOKUP_REF_ID_FIELD, UNIQUE_IDX_NAME, IS_CALCULATED, CALC_SP_NAME, IS_VISIBLE, DESCRIPTION, DONOTDELETE)
  VALUES (1, 1, 'CALCULATE', 'VERP_FL', 'Verpachtete Fläche', 'NUMERIC', 14, 4, 0, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, 1, 'Feld wird Teil der Kalkulation/Buchhaltung und nicht des Datenblattes', 0);
  
  INSERT INTO FIELD_STORE (TENANT_ID, CATEGORY_ID, LABEL, CODE, NAME, DATA_TYPE, TYPE_LENGTH, TYPE_SCALE, MANDATORY, IS_FOREIGN_KEY, IS_LOOKUP, REFERENCE_TABLE, LOOKUP_CAPTION_FIELD, LOOKUP_REF_ID_FIELD, UNIQUE_IDX_NAME, IS_CALCULATED, CALC_SP_NAME, IS_VISIBLE, DESCRIPTION, DONOTDELETE)
  VALUES (1, 1, 'CALCULATE', 'EUR_VERP_FL', 'EUR pro ha Fläche', 'NUMERIC', 14, 3, 0, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, 1, 'Feld wird Teil der Kalkulation/Buchhaltung und nicht des Datenblattes', 0);  

  INSERT INTO FIELD_STORE (TENANT_ID, CATEGORY_ID, LABEL, CODE, NAME, DATA_TYPE, TYPE_LENGTH, TYPE_SCALE, MANDATORY, IS_FOREIGN_KEY, IS_LOOKUP, REFERENCE_TABLE, LOOKUP_CAPTION_FIELD, LOOKUP_REF_ID_FIELD, UNIQUE_IDX_NAME, IS_CALCULATED, CALC_SP_NAME, IS_VISIBLE, DESCRIPTION, DONOTDELETE)
  VALUES (1, 1, 'CALCULATE', 'CALC_BEW_FL', 'Beitrag insges. bew. Fläche', 'NUMERIC', 14, 3, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 'SP_CALC_BEW_FL', 1, 'Feld wird Teil der Kalkulation/Buchhaltung und nicht des Datenblattes', 0);

  INSERT INTO FIELD_STORE (TENANT_ID, CATEGORY_ID, LABEL, CODE, NAME, DATA_TYPE, TYPE_LENGTH, TYPE_SCALE, MANDATORY, IS_FOREIGN_KEY, IS_LOOKUP, REFERENCE_TABLE, LOOKUP_CAPTION_FIELD, LOOKUP_REF_ID_FIELD, UNIQUE_IDX_NAME, IS_CALCULATED, CALC_SP_NAME, IS_VISIBLE, DESCRIPTION, DONOTDELETE)
  VALUES (1, 1, 'CALCULATE', 'CALC_VERP_FL', 'Beitrag insges. verp. Fläche', 'NUMERIC', 14, 3, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 'SP_CALC_VERP_FL', 1, 'Feld wird Teil der Kalkulation/Buchhaltung und nicht des Datenblattes', 0);

  INSERT INTO FIELD_STORE (TENANT_ID, CATEGORY_ID, LABEL, CODE, NAME, DATA_TYPE, TYPE_LENGTH, TYPE_SCALE, MANDATORY, IS_FOREIGN_KEY, IS_LOOKUP, REFERENCE_TABLE, LOOKUP_CAPTION_FIELD, LOOKUP_REF_ID_FIELD, UNIQUE_IDX_NAME, IS_CALCULATED, CALC_SP_NAME, IS_VISIBLE, DESCRIPTION, DONOTDELETE)
  VALUES (1, 1, 'CALCULATE', 'GRUND_BTRG', 'Grundbeitrag', 'NUMERIC', 14, 3, 0, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, 1, 'Feld wird Teil der Kalkulation/Buchhaltung und nicht des Datenblattes', 0);

  INSERT INTO FIELD_STORE (TENANT_ID, CATEGORY_ID, LABEL, CODE, NAME, DATA_TYPE, TYPE_LENGTH, TYPE_SCALE, MANDATORY, IS_FOREIGN_KEY, IS_LOOKUP, REFERENCE_TABLE, LOOKUP_CAPTION_FIELD, LOOKUP_REF_ID_FIELD, UNIQUE_IDX_NAME, IS_CALCULATED, CALC_SP_NAME, IS_VISIBLE, DESCRIPTION, DONOTDELETE)
  VALUES (1, 1, 'CALCULATE', 'ALT_BTRG', 'Altenbeitrag', 'NUMERIC', 14, 3, 0, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, 1, 'Feld wird Teil der Kalkulation/Buchhaltung und nicht des Datenblattes', 0);

  INSERT INTO FIELD_STORE (TENANT_ID, CATEGORY_ID, LABEL, CODE, NAME, DATA_TYPE, TYPE_LENGTH, TYPE_SCALE, MANDATORY, IS_FOREIGN_KEY, IS_LOOKUP, REFERENCE_TABLE, LOOKUP_CAPTION_FIELD, LOOKUP_REF_ID_FIELD, UNIQUE_IDX_NAME, IS_CALCULATED, CALC_SP_NAME, IS_VISIBLE, DESCRIPTION, DONOTDELETE)
  VALUES (1, 1, 'CALCULATE', 'MIND_BTRG', 'Mindestbeitrag', 'NUMERIC', 14, 3, 0, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, 1, 'Feld wird Teil der Kalkulation/Buchhaltung und nicht des Datenblattes', 0);

  INSERT INTO FIELD_STORE (TENANT_ID, CATEGORY_ID, LABEL, CODE, NAME, DATA_TYPE, TYPE_LENGTH, TYPE_SCALE, MANDATORY, IS_FOREIGN_KEY, IS_LOOKUP, REFERENCE_TABLE, LOOKUP_CAPTION_FIELD, LOOKUP_REF_ID_FIELD, UNIQUE_IDX_NAME, IS_CALCULATED, CALC_SP_NAME, IS_VISIBLE, DESCRIPTION, DONOTDELETE)
  VALUES (1, 1, 'CALCULATE', 'SONDER_BTRG', 'Sonderbeitrag', 'NUMERIC', 14, 3, 0, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, 1, 'Feld wird Teil der Kalkulation/Buchhaltung und nicht des Datenblattes', 0);

  INSERT INTO FIELD_STORE (TENANT_ID, CATEGORY_ID, LABEL, CODE, NAME, DATA_TYPE, TYPE_LENGTH, TYPE_SCALE, MANDATORY, IS_FOREIGN_KEY, IS_LOOKUP, REFERENCE_TABLE, LOOKUP_CAPTION_FIELD, LOOKUP_REF_ID_FIELD, UNIQUE_IDX_NAME, IS_CALCULATED, CALC_SP_NAME, IS_VISIBLE, DESCRIPTION, DONOTDELETE)
  VALUES (1, 1, 'CALCULATE', 'LZ_BTRG', 'LZ-Zeitung', 'NUMERIC', 14, 3, 0, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, 1, 'Feld wird Teil der Kalkulation/Buchhaltung und nicht des Datenblattes', 0);
    
  INSERT INTO TABLE_STORE (ID, TENANT_ID, TAG_ID, CATEGORY_ID, LABEL, TABLE_NAME, DESCRIPTION, DONOTDELETE, SOFTDEL)
  VALUES (1, 1, NULL, NULL, 'CONTACT_DATA', 'TESTTABLE1', 'Desc für TESTTABLE1', 0, 0);
  
  INSERT INTO DATASHEET (ID, TENANT_ID, TAG_ID, TABLE_STORE_ID, CAPTION, DESCRIPTION, SOFTDEL)
  VALUES (1, 1, NULL, 1, 'Kontaktdaten1', NULL, 0);
  
  INSERT INTO DATASHEET (ID, TENANT_ID, TAG_ID, TABLE_STORE_ID, CAPTION, DESCRIPTION, SOFTDEL)
  VALUES (2, 1, NULL, 1, 'Kontaktdaten2', NULL, 0);

COMMIT WORK;
  

COMMIT WORK;
  
              
END^        
SET TERM ; ^ /* definiert das Ende eines Ausführungsblockes */
/******************************************************************************/
/******************************************************************************/                                  
/******************************************************************************/