/*******************************************************************************
/* Author:  Alfred Gerke (AGE)                                                  
/* Date:    2012-05-06                                                          
/* Purpose: Grundsteinlegung des Datenmodelles für ZABonline (Wavemaker)    
/*                                                                              
/*******************************************************************************
/* - Das Script arbeitet mit Befehlen der SQL-Erweiterung für FireBird 2.5.x   
/* - Das Script ist für die Ausführung im ISQL erstellt worden              
/* - Ein möglicher Connect zur ZABonline-DB sollte geschlossen werden   
/******************************************************************************/
/* History: 2012-05-06
/*          Testumgebung für Testproc anlegen
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
/*                                 Insert into UPDATEHISTORY                                  
/******************************************************************************/

SET TERM ^ ; /* definiert den Begin eines Ausführungsblockes */
EXECUTE BLOCK AS
DECLARE number varchar(2000);
DECLARE subitem varchar(2000);
DECLARE script varchar(255);
DECLARE description varchar(2000);
BEGIN
  number = '2';
  subitem = '0';
  script = 'create_testproc_env.sql';
  description = 'Testumgebung für Testproc anlegen';
  
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
CREATE EXCEPTION RAISE_TESTPROC 'Exception durch Testframework ausgelöst';

COMMIT WORK;
/******************************************************************************/
/*                                 Sequences                                  
/******************************************************************************/

/* Standardsequences werden druch die SP: SP_CREATE_SEQUENCE erstellt */

/******************************************************************************/
/*                                  Tables                                   
/******************************************************************************/

CREATE TABLE DATA_BY_TESTPROC (
  ID                    INTEGER NOT NULL,
  SESSION_ID            VARCHAR(254),
  USER_ID               VARCHAR(254),
  IP                    VARCHAR(254),
  TENANT_ID             INTEGER,
  INTEGER_BY_PARAM      INTEGER,
  SMALLINT_BY_PARAM     SMALLINT,
  VARCHAR254_BY_PARAM   VARCHAR(254),
  VARCHAR2000_BY_PARAM  VARCHAR(2000),
  DATE_BY_PARAM         DATE,
  TRIGGERT_BY_PROC      VARCHAR(2000),
  DESCRIPTION           VARCHAR(2000),
  SOFTDEL               BOOLEAN,    
  CRE_USER              VARCHAR(32) NOT NULL,
  CRE_DATE              TIMESTAMP NOT NULL,
  CHG_USER              VARCHAR(32),
  CHG_DATE              TIMESTAMP
);

COMMENT ON TABLE DATA_BY_TESTPROC IS
'Daten aus SP_TESTPROC'; 

COMMENT ON COLUMN DATA_BY_TESTPROC.ID IS
'Primärschlüssel';

COMMENT ON COLUMN DATA_BY_TESTPROC.INTEGER_BY_PARAM IS
'Parameter AINTEGER';

COMMENT ON COLUMN DATA_BY_TESTPROC.SMALLINT_BY_PARAM IS
'Parameter ASMALLINT';

COMMENT ON COLUMN DATA_BY_TESTPROC.VARCHAR254_BY_PARAM IS
'Paramater AVARCHAR254';

COMMENT ON COLUMN DATA_BY_TESTPROC.VARCHAR2000_BY_PARAM IS
'Paramater AVARCHAR2000';

COMMENT ON COLUMN DATA_BY_TESTPROC.DATE_BY_PARAM IS
'Parameter ADATE';

COMMENT ON COLUMN DATA_BY_TESTPROC.TRIGGERT_BY_PROC IS
'Name der SP';

COMMENT ON COLUMN DATA_BY_TESTPROC.DESCRIPTION IS
'Beschreibung der Daten';

COMMENT ON COLUMN DATA_BY_TESTPROC.TENANT_ID IS
'Fremdschlüssel Mandant';

COMMENT ON COLUMN DATA_BY_TESTPROC.SESSION_ID IS
'Sitzungsidentification';

COMMENT ON COLUMN DATA_BY_TESTPROC.USER_ID IS
'Anmeldename';

COMMENT ON COLUMN DATA_BY_TESTPROC.IP IS
'IP der Verbindung';

COMMENT ON COLUMN DATA_BY_TESTPROC.SOFTDEL IS
'Löschflag';

COMMENT ON COLUMN DATA_BY_TESTPROC.CRE_USER IS
'Erstellt von';

COMMENT ON COLUMN DATA_BY_TESTPROC.CRE_DATE IS
'Erstellt am';

COMMENT ON COLUMN DATA_BY_TESTPROC.CHG_USER IS
'Geändert von';

COMMENT ON COLUMN DATA_BY_TESTPROC.CHG_DATE IS
'Geändert am';

COMMIT WORK;

/* Userview anlegen */
execute procedure SP_CREATE_USER_VIEW 'DATA_BY_TESTPROC';
/* Sequence anlegen */
execute procedure SP_CREATE_SEQUNECE 'DATA_BY_TESTPROC';
/* Trigger anlegen */
execute procedure SP_CREATE_TRIGGER_BI 'DATA_BY_TESTPROC';
execute procedure SP_CREATE_TRIGGER_BU 'DATA_BY_TESTPROC';

COMMIT WORK;
/******************************************************************************/
/*                                  Views                                   
/******************************************************************************/

/* USER-Views werden druch die SP: SP_CREATE_USER_VIEW erstellt */

/******************************************************************************/
/*                                Primary Keys                               
/******************************************************************************/

ALTER TABLE DATA_BY_TESTPROC ADD CONSTRAINT PK_DATA_BY_TESTPROC PRIMARY KEY (ID);

COMMIT WORK;
/******************************************************************************/
/*                                Foreign Keys                                
/******************************************************************************/

ALTER TABLE DATA_BY_TESTPROC ADD CONSTRAINT FK_DATA_BY_TESTPROC FOREIGN KEY (TENANT_ID) REFERENCES TENANT(ID) ON DELETE CASCADE ON UPDATE CASCADE;
                                                                                                                                 
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

CREATE OR ALTER PROCEDURE SP_TESTPROC (
  ASESSION_ID varchar(254),  
  AUSERNAME varchar(254),
  AIP varchar(254),
  ATENANT_ID integer,      
  AINTEGER integer,
  ASMALLINT smallint,
  AVARCHAR254 varchar(254),
  AVARCHAR2000 varchar(2000),
  ADATE date
  )
RETURNS (
  success smallint,
  code smallint,
  info varchar(2000))
AS
declare variable counter integer;
declare variable loop_count integer;
declare variable do_raise_exception integer;
declare variable success_by_touchsession smallint;
begin
  code = 0;
  info = '{"kind": 0, "result": null}';
  success = 0; 

  do_raise_exception = 0;
  loop_count = 0;
  counter = 0;
  
  select success from SP_TOUCHSESSION(:ASESSION_ID, :AUSERNAME, :AIP) into :success_by_touchsession;
  
  if (success_by_touchsession = 1) then
  begin
    select RESULT from SP_READINTEGER('TEST', 'STORED_PROCEDURES', 'LOOP_COUNT', 10000) into :counter;
    select RESULT from SP_READINTEGER('TEST', 'STORED_PROCEDURES', 'DO_RAISE_EXCEPTION', 0) into :do_raise_exception;
    
    while (loop_count < counter) do
    begin
      insert
      into 
      V_DATA_BY_TESTPROC (
        SESSION_ID,
        USER_ID,
        IP,
        TENANT_ID,
        INTEGER_BY_PARAM,
        SMALLINT_BY_PARAM,
        VARCHAR254_BY_PARAM,
        VARCHAR2000_BY_PARAM,
        DATE_BY_PARAM,
        TRIGGERT_BY_PROC)
      values (
        :ASESSION_ID,
        :AUSERNAME,
        :AIP,
        :ATENANT_ID,
        :AINTEGER,
        :ASMALLINT,
        :AVARCHAR254,
        :AVARCHAR2000,
        :ADATE,
        'SP_TESTPROC');
      loop_count = loop_count + 1;  
    end    
  
    if (do_raise_exception = 1) then
    begin
      EXCEPTION RAISE_TESTPROC;
      
      suspend;
    end
    else
    begin
      code = 1;
      /* mögliche Variation */
      /* info = '{"list": [{"name": "Gerke", "dataValue": "Alfred", "id": 1}, {"name": "Gerke2", "dataValue": "Alfred2", "id": 2}, {"name": "Gerke3", "dataValue": "Alfred3", "id": 3}]}'; */
      info = '[{"name": "Gerke", "dataValue": "Alfred", "id": 1}, {"name": "Gerke2", "dataValue": "Alfred2", "id": 2}, {"name": "Gerke3", "dataValue": "Alfred3", "id": 3}]';
      success = 1;   
    end
  end 

  suspend;
end
^
COMMENT ON PROCEDURE SP_TESTPROC IS
'Test-SP für erste Webservice-Tests'^

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_TESTPROC'^

SET TERM ; ^
 

COMMIT WORK;
/******************************************************************************/
/*                                 Grants 
/******************************************************************************/

/* Users */

/* Views */

/* Tables */

/* SPs */
GRANT INSERT ON V_DATA_BY_TESTPROC TO SP_TESTPROC; 
GRANT EXECUTE ON PROCEDURE SP_READINTEGER TO SP_TESTPROC; 

/* Roles */

COMMIT WORK;
/******************************************************************************/
/*                                 Input                                  
/******************************************************************************/

input 'data_0003.sql';

COMMIT WORK;
/******************************************************************************/
/******************************************************************************/
/******************************************************************************/
