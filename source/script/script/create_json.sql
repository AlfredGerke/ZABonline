/*******************************************************************************
/* Author:  Alfred Gerke (AGE)                                                  
/* Date:    2013-06-23                                                          
/* Purpose: JSON-Funktionalität für die DB    
/*          Die SPs wurden stark beeinflust durch die Implementierung von 
/*          JSON-Functions in PostgreSQL 9.4 
/*                                                                              
/*******************************************************************************
/* - Das Script arbeitet mit Befehlen der SQL-Erweiterung für FireBird 2.5.x   
/* - Das Script ist für die Ausführung im ISQL erstellt worden              
/* - Ein möglicher Connect zur ZABonline-DB sollte geschlossen werden 
/* - Die Installationstools müssen installiert worden sein  
/******************************************************************************/
/* History: 2013-06-23
/*          JSON-Schnittstelle für die DB
/******************************************************************************/

/******************************************************************************/
/*        Following SET SQL DIALECT is just for the Database Comparer         
/******************************************************************************/
SET SQL DIALECT 3;

SET NAMES WIN1252;

SET AUTODDL;

/* An dieser Stelle muss die IP, der Datenbankpfad, Name der Datanbank sowie Benutzerinformationen (User/Password) überführt werden */
CONNECT '127.0.0.1:ZABONLINEEMBEDDED' USER 'INSTALLER' PASSWORD 'installer';
/******************************************************************************/
/*                                  Exceptions                                   
/******************************************************************************/

/******************************************************************************/
/*                                  Domains                                   
/******************************************************************************/

/******************************************************************************/
/*                                 Sequences                                  
/******************************************************************************/

/* Standardsequences werden druch die SP: SP_CREATE_SEQUENCE erstellt */

CREATE SEQUENCE SEQ_TRANS_ID_FOR_JSON_SRV;
ALTER SEQUENCE SEQ_TRANS_ID_FOR_JSON_SRV RESTART WITH 0;

COMMIT WORK;
/******************************************************************************/
/*                                   Roles                                   
/******************************************************************************/

/******************************************************************************/
/*                                   Tables                                   
/******************************************************************************/

CREATE GLOBAL TEMPORARY TABLE TMP_CODE_FOR_JSON (
  ID            INTEGER NOT NULL,
  TRANS_ID      INTEGER NOT NULL,
  FIELDNAME     VARCHAR(32),
  FIELDVALUE    VARCHAR(4000),
  FIELDTYPE     SMALLINT
)
;

COMMENT ON TABLE TMP_CODE_FOR_JSON is
'';

COMMENT ON COLUMN TMP_CODE_FOR_JSON.ID is
'';

COMMENT ON COLUMN TMP_CODE_FOR_JSON.TRANS_ID is
'';

COMMENT ON COLUMN TMP_CODE_FOR_JSON.FIELDNAME is
'';

COMMENT ON COLUMN TMP_CODE_FOR_JSON.FIELDVALUE is
'';

COMMENT ON COLUMN TMP_CODE_FOR_JSON.FIELDTYPE is
'';  

/* Userview anlegen */
execute procedure SP_CREATE_USER_VIEW 'TMP_CODE_FOR_JSON', 0;
/* Sequence anlegen */
execute procedure SP_CREATE_SEQUNECE 'TMP_CODE_FOR_JSON';
/* Trigger anlegen */
execute procedure SP_CREATE_TRIGGER_BI 'TMP_CODE_FOR_JSON', 0;

COMMIT WORK;
/******************************************************************************/
/*                                Primary Keys                                
/******************************************************************************/

/******************************************************************************/
/*                                Foreign Keys                                
/******************************************************************************/

/******************************************************************************/
/*                                  Indices                                   
/******************************************************************************/

/******************************************************************************/
/*                                  Triggers                                  
/******************************************************************************/

/* Standardtrigger werden druch die SPs: SP_CREATE_TRIGGER_BI und SP_CREATE_TRIGGER_BU erstellt */

/******************************************************************************/
/*                             Stored Procedures                              
/******************************************************************************/

SET TERM ^ ;
/******************************************************************************/
/* Example aus PostgreSQL 9.4 
/* Description: Returns the row as JSON. Line feeds will be added between level 1 elements if pretty_bool is true.
/* Example: array_to_json('{{1,5},{99,100}}'::int[])
/* Example Result: {"f1":1,"f2":"foo"}                                          
/******************************************************************************/
CREATE OR ALTER PROCEDURE SP_DATA_TO_JSON(
  ADATASOURCE varchar(32), /* Name einer Tabelle oder View */
  AFIELDS varchar(2000) DEFAULT '*', /* Komma getrennt Liste der Felder für den JSON-String */
  AWHERECLAUSE varchar(2000) DEFAULT '1=1')     
returns(
  json_str varchar(2000))
as
declare variable original_field_name varchar(31);
declare variable transaction_id integer;
declare variable field_length smallint;
declare variable field_scale smallint;
declare variable field_type smallint;
declare variable field_source varchar(31);
begin
  if (exists(select 1 from RDB$RELATIONS where UPPER(RDB$RELATION_NAME)=UPPER(:ADATASOURCE))) then
  begin
    transaction_id = next value for SEQ_TRANS_ID_FOR_JSON_SRV;
    
    for 
      select 
        RDB$FIELD_NAME,
        RDB$FIELD_SOURCE  
      from 
        RDB$RELATION_FIELDS 
      where 
        UPPER(RDB$RELATION_NAME)=UPPER(:ADATASOURCE) 
      into 
        :original_field_name,
        :field_source
    do
    begin
      for 
        select
          RDB$FIELD_LENGTH,
          RDB$FIELD_SCALE,
          RDB$FIELD_TYPE   
        from
          RDB$FIELDS
        where
          (UPPER(RDB$FIELD_NAME) = UPPER(:field_source))        
        into
          :field_length,
          :field_scale,
          :field_type
      do
      begin
        /*
         *
         *         
        Datatype: BLOB - Fieldtype: 261
        Datatype: CHAR - Fieldtype: 14
        Datatype: CSTRING - Fieldtype: 40
        Datatype: D_FLOAT - Fieldtype: 11
        Datatype: DOUBLE - Fieldtype: 27
        Datatype: FLOAT - Fieldtype: 10
        Datatype: INT64 - Fieldtype: 16
        Datatype: INTEGER - Fieldtype: 8
        Datatype: QUAD - Fieldtype: 9
        Datatype: SMALLINT - Fieldtype: 7
        Datatype: DATE - Fieldtype: 12
        Datatype: TIME - Fieldtype: 13
        Datatype: TIMESTAMP - Fieldtype: 35
        Datatype: VARCHAR - Fieldtype: 37
         *
         *
         */
         
      end                    
    end
  end 
    
  suspend;
end^

COMMENT ON PROCEDURE SP_DATA_TO_JSON IS
'Jede Zeile einer Datenquelle als JSON-String ausgeben'^
                          
SET TERM ; ^

COMMIT WORK;
/******************************************************************************/
/*                                 Grants                                 
/******************************************************************************/

/* Users */
GRANT EXECUTE ON PROCEDURE SP_DATA_TO_JSON TO INSTALLER;

COMMIT WORK;
/******************************************************************************/
/*                                 Input                                  
/******************************************************************************/

input 'json_0001.sql';

COMMIT WORK;
/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/
