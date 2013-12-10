/*******************************************************************************
/* Author:  Alfred Gerke (AGE)                                                  
/* Date:    2013-06-13                                                        
/* Purpose: Grundsteinlegung des Datenmodelles für ZABonline (Wavemaker)    
/*                                                                              
/*******************************************************************************
/* - Das Script arbeitet mit Befehlen der SQL-Erweiterung für FireBird 2.5.x   
/* - Das Script ist für die Ausführung im IBExpert erstellt worden              
/* - Ein möglicher Connect zur ZABonline-DB sollte geschlossen werden   
/******************************************************************************/
/* History: 2013-06-13
/*          Administration erstellen
/******************************************************************************/

/******************************************************************************/
/*        Following SET SQL DIALECT is just for the Database Comparer         */
/******************************************************************************/
SET SQL DIALECT 3;

SET NAMES WIN1252;

/* An dieser Stelle muss die Client-DLL (Pfad und Name) überprüft werden      */
SET CLIENTLIB 'C:\Users\Alfred\Programme\Firebird_2_5\bin\fbclient.dll';

/* An dieser Stelle muss die IP, der Datenbankpfad, Name der Datanbank sowie Benutzerinformationen (User/Password) überführt werden */
CONNECT '127.0.0.1:ZABONLINEEMBEDDED' USER 'INSTALLER' PASSWORD 'installer';

/******************************************************************************/
/*                                 Insert into UPDATEHISTORY                                  
/******************************************************************************/

SET TERM ^ ; /* definiert den Begin eines Ausführungsblockes */
EXECUTE BLOCK AS
DECLARE number varchar(2000);
DECLARE subitem varchar(2000);
DECLARE script varchar(255);
DECLARE description varchar(2000);
BEGIN
  number = '5';
  subitem = '0';
  script = 'create_find.sql';
  description = 'Suche organisieren';
  
  if (exists(select 1 from RDB$RELATIONS where RDB$RELATION_NAME='UPDATEHISTORY')) then
  begin   
    execute statement 'INSERT INTO UPDATEHISTORY(NUMBER, SUBITEM, SCRIPT, DESCRIPTION) VALUES ( ''' || :number ||''', ''' || :subitem ||''', ''' || :script || ''', ''' || :description || ''');';
  end  

END^        
SET TERM ; ^ /* definiert das Ende eines Ausführungsblockes */

COMMIT WORK;
/******************************************************************************/
/*                                 Eyxception                                  
/******************************************************************************/

/******************************************************************************/
/*                                  Domains                                   
/******************************************************************************/

/******************************************************************************/
/*                                 Sequences                                  
/******************************************************************************/

/* Standardsequences werden druch die SP: SP_CREATE_SEQUENCE erstellt */

/******************************************************************************/
/*                                  Tables                                   
/******************************************************************************/

CREATE TABLE STAT_SIMPLE_ATTEMPT (
  ID               INTEGER NOT NULL,
  TENANT_ID        INTEGER,
  CATEGORY_ID      INTEGER,
  ATTEMPT          VARCHAR(2000),
  SOFTDEL          BOOLEAN,   
  CRE_USER         VARCHAR(32) NOT NULL,
  CRE_DATE         TIMESTAMP NOT NULL,
  CHG_USER         VARCHAR(32),
  CHG_DATE         TIMESTAMP
);

COMMENT ON TABLE STAT_SIMPLE_ATTEMPT IS
'Statistik über einfache Anfrageformulierungen'; 

COMMENT ON COLUMN STAT_SIMPLE_ATTEMPT.ID IS
'Primärschlüssel';

COMMENT ON COLUMN STAT_SIMPLE_ATTEMPT.TENANT_ID IS
'Fremdschlüssel Mandant';

COMMENT ON COLUMN STAT_SIMPLE_ATTEMPT.CATEGORY_ID IS
'Fremdschlüssel Kategorie';

COMMENT ON COLUMN STAT_SIMPLE_ATTEMPT.ATTEMPT IS
'Erfolgreiche Anfrage';

COMMENT ON COLUMN STAT_SIMPLE_ATTEMPT.SOFTDEL IS
'Löschflag';

COMMENT ON COLUMN STAT_SIMPLE_ATTEMPT.CRE_USER IS
'Erstellt von';

COMMENT ON COLUMN STAT_SIMPLE_ATTEMPT.CRE_DATE IS
'Erstellt am';

COMMENT ON COLUMN STAT_SIMPLE_ATTEMPT.CHG_USER IS
'Geändert von';

COMMENT ON COLUMN STAT_SIMPLE_ATTEMPT.CHG_DATE IS
'Geändert am';

/* Userview anlegen */
execute procedure SP_CREATE_USER_VIEW 'STAT_SIMPLE_ATTEMPT';
/* Sequence anlegen */
execute procedure SP_CREATE_SEQUNECE 'STAT_SIMPLE_ATTEMPT';
/* Trigger anlegen */
execute procedure SP_CREATE_TRIGGER_BI 'STAT_SIMPLE_ATTEMPT';
execute procedure SP_CREATE_TRIGGER_BU 'STAT_SIMPLE_ATTEMPT';

COMMIT WORK;
/******************************************************************************/
/*                                  ALTER                                   
/******************************************************************************/

/* Tables */
ALTER TABLE TENANT
  ADD MAX_COUNT_BY_SIMPLE_ATTEMPT INTEGER DEFAULT 5;

COMMENT ON COLUMN TENANT.MAX_COUNT_BY_SIMPLE_ATTEMPT IS
'Max. Anzahl Vorschläge bei einfacher Suche'; 

/* Userview aktualisieren */
execute procedure SP_CREATE_USER_VIEW 'TENANT';

/* SPs */
SET TERM ^ ;

CREATE OR ALTER PROCEDURE SP_INSERT_TENANT (
  ACAPTION varchar(64), /* Pflichtfeld */
  ADESCRIPTION varchar(2000),  
  AFACTORYDATAID integer,
  APERSONDATAID integer,
  ACONTACTDATAID integer,
  AADDRESSDATAID integer,
  ACOUNTRYCODEID integer,
  ASESSIONIDLETIME integer, /* Pflichtfeld */
  ASESSIONLIFETIME integer, /* Pflichtfeld */
  AMAXATTEMPT integer) /* Pflichtfeld */  
RETURNS (
  success smallint,
  message varchar(254),
  tenant_id integer)
AS
begin
  success = 0;
  message = 'FAILD_BY_UNKNOWN_REASON';
  tenant_id = -1;
  
  if (exists(select 1 from V_TENANT where Upper(CAPTION)=Upper(:ACAPTION))) then
  begin
    message = 'DUPLICATE_TENANT_NOT_ALLOWED';
    suspend;
    Exit;    
  end
                                  
  select SEQ_ID from SP_GET_SEQUENCEID_BY_IDENT('TENANT') into :tenant_id;

  if ((tenant_id <> -1) and (tenant_id is not null)) then
  begin
    insert
    into
      V_TENANT
      (
        ID,
        CAPTION,
        DESCRIPTION,    
        DATASHEET_FACTORY_DATA_ID,
        DATASHEET_PERSON_ID,
        DATASHEET_CONTACT_ID,
        DATASHEET_ADDRESS_ID,        
        COUNTRY_ID,
        SESSION_IDLE_TIME,
        SESSION_LIFETIME,
        MAX_COUNT_BY_SIMPLE_ATTEMPT                
      )
    values
      (
        :tenant_id,
        :ACAPTION,
        :ADESCRIPTION,
        :AFACTORYDATAID,
        :APERSONDATAID,
        :ACONTACTDATAID,
        :AADDRESSDATAID,
        :ACOUNTRYCODEID,
        :ASESSIONIDLETIME,
        :ASESSIONLIFETIME,
        :AMAXATTEMPT
      );  

    message = '';
    success = 1;      
  end  
  else
  begin
    message = 'NO_VALID_TENANT_ID';
    success = 0;
    suspend;
    Exit;     
  end
  
  suspend;
end^

SET TERM ; ^

COMMIT WORK;
/******************************************************************************/
/*                                  Views                                   
/******************************************************************************/

/* USER-Views werden druch die SP: SP_CREATE_USER_VIEW erstellt */

/******************************************************************************/
/*                                Primary Keys                               
/******************************************************************************/

ALTER TABLE STAT_SIMPLE_ATTEMPT ADD CONSTRAINT PK_STAT_SIMPLE_ATTEMPT PRIMARY KEY (ID);

COMMIT WORK;
/******************************************************************************/
/*                                Foreign Keys                                
/******************************************************************************/

ALTER TABLE STAT_SIMPLE_ATTEMPT ADD CONSTRAINT FK_STAT_SIMPLE_ATTEMPT_TENANT FOREIGN KEY (TENANT_ID) REFERENCES TENANT(ID) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE STAT_SIMPLE_ATTEMPT ADD CONSTRAINT FK_STAT_SIMPLE_ATTEMPT_CAT FOREIGN KEY (CATEGORY_ID) REFERENCES CATEGORY(ID) ON DELETE CASCADE ON UPDATE CASCADE;

COMMIT WORK;
/******************************************************************************/
/*                                  Indices                                   
/******************************************************************************/

/******************************************************************************/
/*                                  Triggers                                  
/******************************************************************************/

/* Standardrigger werden druch die SPs: SP_CREATE_TRIGGER_BI und SP_CREATE_TRIGGER_BU erstellt */

/******************************************************************************/
/*                             Stored Procedures                              
/******************************************************************************/

SET TERM ^ ;

CREATE OR ALTER PROCEDURE SP_START_FIND (
  AATTEMPT varchar(2000))  /* Pflichtfeld */
RETURNS (
  success smallint,
  code smallint,
  info varchar(2000))
AS
declare variable message varchar(254);
declare variable user_id Integer;
begin
  success = 0;
  code = 0;
  info = '{"result": null}';  

    
    /* success = 1; -> success sollte nur durch die Insert-SPs auf 1 gesetzt werden */
    code = 1;
    if (success = 1) then
    begin
      info = '{"kind": 3, "publish": "ADD_USER_SUCCEEDED", "message": "ADD_USER_SUCCEEDED"}';
    end  
    else
    begin
      success = 0;
      info = '{"kind": 1, "publish": "FAILD_BY_OBSCURE_PROCESSING", "message": "FAILD_BY_OBSCURE_PROCESSING"}';
    end                                    

  suspend;
end
^

COMMENT ON PROCEDURE SP_START_FIND IS
'Überprüft Eingaben und startet die Suche'^

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_START_FIND'^

CREATE OR ALTER PROCEDURE SP_START_FIND_BY_SRV (
  ASESSION_ID varchar(254),    
  AUSERNAME varchar(254),
  AIP varchar(254),
  AATTEMPT varchar(2000)) 
RETURNS (
  success smallint,
  code smallint,
  info varchar(2000))
AS
declare variable success_by_touchsession smallint;
declare variable success_by_grant smallint;
begin
  success = 0;
  code = 0;
  info = '{"result": null}';

  select success from SP_TOUCHSESSION(:ASESSION_ID, :AUSERNAME, :AIP) into :success_by_touchsession;
  
  if (success_by_touchsession = 1) then
  begin
    select success from SP_CHECKGRANT(:AUSERNAME, 'FIND') into :success_by_grant;
    
    if (success_by_grant = 1) then
    begin
      /* Wenn der JSON-String im Feld INFO zu lang wird, wird von der SP zwei oder mehrere Datensätze erzeugt.
         Aus diesem Grund wird die SP über eine FOR-Loop abgefragt
      */
      for select success, code, info from SP_START_FIND(:AATTEMPT) into :success, :code, :info do
      begin
        suspend;
      end 
    end
    else
    begin
      info = '{"kind": 1, "publish": "NO_GRANT_FOR_START_FIND", "message": "NO_GRANT_FOR_START_FIND"}';
      
      suspend;
    end
  end
  else
  begin
    info = '{"kind": 1, "publish": "CANCEL_PROCESS_BY_SESSIONMANAGEMENT", "message": "CANCEL_PROCESS_BY_SESSIONMANAGEMENT"}';
    
    suspend;
  end
end
^

COMMENT ON PROCEDURE SP_START_FIND_BY_SRV IS
'Überprüft Sitzungsverwaltung und ruft SP_START_FIND auf'^

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_START_FIND_BY_SRV'^

SET TERM ; ^

COMMIT WORK;
/******************************************************************************/
/*                                 Zirkuläre Verbinungen auflösen                                  
/******************************************************************************/

/******************************************************************************/
/*                                 Grants 
/******************************************************************************/

/* Users */

/* Views */

/* Tables */

/* SPs */
GRANT EXECUTE ON PROCEDURE SP_TOUCHSESSION TO SP_START_FIND_BY_SRV;
GRANT EXECUTE ON PROCEDURE SP_CHECKGRANT TO SP_START_FIND_BY_SRV;
GRANT EXECUTE ON PROCEDURE SP_ADD_USER TO SP_START_FIND_BY_SRV;

/* Roles */

COMMIT WORK;
/******************************************************************************/
/*                                 Input                                  
/******************************************************************************/

input 'data_0005.sql';

COMMIT WORK;
/******************************************************************************/
/******************************************************************************/
/******************************************************************************/
