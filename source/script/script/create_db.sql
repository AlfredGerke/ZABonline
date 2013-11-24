/*******************************************************************************
/* Author:  Alfred Gerke (AGE)                                                  
/* Date:    2012-03-17                                                          
/* Purpose: Grundsteinlegung des Datenmodelles für ZABonline (Wavemaker)    
/*                                                                              
/*******************************************************************************
/* - Das Script arbeitet mit Befehlen der SQL-Erweiterung für FireBird 2.5.x   
/* - Das Script ist für die Ausführung im IBExpert erstellt worden              
/* - Ein möglicher Connect zur Produktionsdatenbank sollte geschlossen werden   
/******************************************************************************/
/* History: 2012-03-17
/*          Gründung des Datenmodelles
/******************************************************************************/

/******************************************************************************/
/*        Following SET SQL DIALECT is just for the Database Comparer         
/******************************************************************************/
SET SQL DIALECT 3;

SET NAMES WIN1252;

/* An dieser Stelle muss die Client-DLL (Pfad und Name) überprüft werden      */
SET CLIENTLIB 'C:\Users\Alfred\Programme\Firebird_2_5\bin\fbclient.dll';

/* An dieser Stelle muss die IP, der Datenbankpfad, Name der Datanbank sowie Benutzerinformationen (User/Password) überführt werden */
CONNECT '127.0.0.1:ZABONLINEEMBEDDED' USER 'INSTALLER' PASSWORD 'installer';
/******************************************************************************/
/*                                  Exceptions                                   
/******************************************************************************/

CREATE EXCEPTION CANCEL_BY_UNKNOWN_REASON 'Abbruch aus unbekanntem Grund!';
CREATE EXCEPTION NO_LOGIN_ALLOWED 'Kein Login erlaubt!';
CREATE EXCEPTION UNKNOWN_USDERID 'Unbekannter Benutzer, kein Login erlaubt!';
CREATE EXCEPTION INVALID_SESSION_DATA 'Ungültige Sitzungsinformationen!';
CREATE EXCEPTION SESSION_IDLE_TIMEOUT 'Sitzungsruhezeit überschritten!';
CREATE EXCEPTION SESSION_LIFETIME_TIMEOUT 'Gültigkeitszeitraum der Sitzung abgelaufen!';
CREATE EXCEPTION ACCESS_DENIED 'Zugriff abgelehnt!';

COMMIT WORK;
/******************************************************************************/
/*                                  Domains                                   
/******************************************************************************/

CREATE DOMAIN DBOBJECTNAME24
VARCHAR(24);

COMMENT ON DOMAIN DBOBJECTNAME24 IS
'Datenbankobjekt mit max. 24 Zeichen';

CREATE DOMAIN DBOBJECTNAME32
VARCHAR(32);

COMMENT ON DOMAIN DBOBJECTNAME32 IS
'Datenbankobjekt mit max. 32 Zeichen';

CREATE DOMAIN DBOBJECTNAME15
VARCHAR(15);

COMMENT ON DOMAIN DBOBJECTNAME15 IS
'Datenbankobjekt mit max. 15 Zeichen';

CREATE DOMAIN CAPTION64
VARCHAR(64);

COMMENT ON DOMAIN CAPTION64 IS
'Caption mit max. 64 Zeichen';

CREATE DOMAIN CAPTION254
VARCHAR(254);

COMMENT ON DOMAIN CAPTION254 IS
'Caption mit max. 254 Zeichen';

CREATE DOMAIN USERNAME 
VARCHAR(31)
DEFAULT CURRENT_USER;

COMMENT ON DOMAIN USERNAME IS
'aktueller Benutzer';

CREATE DOMAIN BOOLEAN AS
SMALLINT
DEFAULT 0
NOT NULL
CHECK (VALUE IN (0,1));

COMMENT ON DOMAIN BOOLEAN IS
'0=False(Falsch) / 1=True(Wahr)';

COMMIT WORK;
/******************************************************************************/
/*                                 Sequences                                  
/******************************************************************************/

/* Standardsequences werden druch die SP: SP_CREATE_SEQUENCE erstellt */

/******************************************************************************/
/*                                   Roles                                   
/******************************************************************************/

/* Roles */
CREATE ROLE R_ZABGUEST;
COMMENT ON ROLE R_ZABGUEST IS
'Organisatorische Rolle für einen Zab-Gast';

CREATE ROLE R_WEBCONNECT;
COMMENT ON ROLE R_WEBCONNECT IS
'Organisatorische Rolle für einen Webserver';

CREATE ROLE R_ZABADMIN;
COMMENT ON ROLE R_ZABADMIN IS
'Organisatorische Rolle für einen Zab-Admin';

COMMIT WORK;
/******************************************************************************/
/*                                   Tables                                   
/******************************************************************************/

CREATE TABLE COUNTRY (
  ID               INTEGER NOT NULL,
  TAG_ID           INTEGER,    
  COUNTRY_CODE     VARCHAR(3) NOT NULL,
  COUNTRY_CAPTION  VARCHAR(254),
  CURRENCY_CODE    VARCHAR(3) NOT NULL,
  CURRENCY_CAPTION VARCHAR(254),
  AREA_CODE        VARCHAR(5) NOT NULL,
  DESCRIPTION      VARCHAR(2000),
  DONOTDELETE      BOOLEAN,
  SOFTDEL          BOOLEAN,   
  CRE_USER         VARCHAR(32) NOT NULL,
  CRE_DATE         TIMESTAMP NOT NULL,
  CHG_USER         VARCHAR(32),
  CHG_DATE         TIMESTAMP
);

COMMENT ON TABLE COUNTRY IS
'Einheiten zur Länderkennung'; 

COMMENT ON COLUMN COUNTRY.ID IS
'Primärschlüssel';

COMMENT ON COLUMN COUNTRY.TAG_ID IS
'Fremdschlüssel für Tags';

COMMENT ON COLUMN COUNTRY.COUNTRY_CODE IS
'Ländercode';

COMMENT ON COLUMN COUNTRY.COUNTRY_CAPTION IS
'Name des Landes';
 
COMMENT ON COLUMN COUNTRY.CURRENCY_CODE IS
'Währungscode';

COMMENT ON COLUMN COUNTRY.CURRENCY_CAPTION IS
'Name der Währung';

COMMENT ON COLUMN COUNTRY.AREA_CODE IS
'Ländervorwahl'; 

COMMENT ON COLUMN COUNTRY.DESCRIPTION IS
'Beschreibung';

COMMENT ON COLUMN COUNTRY.DONOTDELETE IS
'Löschflag ignorieren';

COMMENT ON COLUMN COUNTRY.SOFTDEL IS
'Löschflag';

COMMENT ON COLUMN COUNTRY.CRE_USER IS
'Erstellt von';

COMMENT ON COLUMN COUNTRY.CRE_DATE IS
'Erstellt am';

COMMENT ON COLUMN COUNTRY.CHG_USER IS
'Geändert von';

COMMENT ON COLUMN COUNTRY.CHG_DATE IS
'Geändert am';

/* Userview anlegen */
execute procedure SP_CREATE_USER_VIEW 'COUNTRY';                    
/* Sequence anlegen */
execute procedure SP_CREATE_SEQUNECE 'COUNTRY';
/* Trigger anlegen */
execute procedure SP_CREATE_TRIGGER_BI 'COUNTRY';
execute procedure SP_CREATE_TRIGGER_BU 'COUNTRY';
execute procedure SP_CREATE_TRIGGER_BD 'COUNTRY', 'DONOTDELETE'; 

CREATE TABLE TAG (
  ID           INTEGER NOT NULL,
  TAG          BLOB SUB_TYPE TEXT SEGMENT SIZE 16384 NOT NULL,
  SOFTDEL      BOOLEAN,   
  CRE_USER     VARCHAR(32) NOT NULL,
  CRE_DATE     TIMESTAMP NOT NULL,
  CHG_USER     VARCHAR(32),
  CHG_DATE     TIMESTAMP               
);

COMMENT ON TABLE TAG IS
'Tags für die Entwicklung'; 

COMMENT ON COLUMN TAG.ID IS
'Primärschlüssel';

COMMENT ON COLUMN TAG.TAG IS
'Blobfeld für XML-Daten';

COMMENT ON COLUMN TAG.SOFTDEL IS
'Löschflag';

COMMENT ON COLUMN TAG.CRE_USER IS
'Erstellt von';

COMMENT ON COLUMN TAG.CRE_DATE IS
'Erstellt am';

COMMENT ON COLUMN TAG.CHG_USER IS
'Geändert von';

COMMENT ON COLUMN TAG.CHG_DATE IS
'Geändert am';

/* Userview anlegen */
execute procedure SP_CREATE_USER_VIEW 'TAG';
/* Sequence anlegen */
execute procedure SP_CREATE_SEQUNECE 'TAG';
/* Trigger anlegen */
execute procedure SP_CREATE_TRIGGER_BI 'TAG';
execute procedure SP_CREATE_TRIGGER_BU 'TAG';

CREATE TABLE UPDATEHISTORY (
  ID           INTEGER NOT NULL,   
  NUMBER       INTEGER NOT NULL,
  SUBITEM      INTEGER NOT NULL,
  SCRIPT       VARCHAR(255) NOT NULL,
  DESCRIPTION  VARCHAR(2000),      
  CRE_USER     VARCHAR(32) NOT NULL,
  CRE_DATE     TIMESTAMP NOT NULL,
  CHG_USER     VARCHAR(32),
  CHG_DATE     TIMESTAMP
);

COMMENT ON TABLE UPDATEHISTORY IS
'Updatehistory'; 

COMMENT ON COLUMN UPDATEHISTORY.ID IS
'Primärschlüssel';

COMMENT ON COLUMN UPDATEHISTORY.NUMBER IS
'Aufsteigende Nummer';

COMMENT ON COLUMN UPDATEHISTORY.SUBITEM IS
'Aufsteigende Unternummer';

COMMENT ON COLUMN UPDATEHISTORY.SCRIPT IS
'Updatescript';

COMMENT ON COLUMN UPDATEHISTORY.DESCRIPTION IS
'Updatebeschreibung';

COMMENT ON COLUMN UPDATEHISTORY.CRE_USER IS
'Erstellt von';

COMMENT ON COLUMN UPDATEHISTORY.CRE_DATE IS
'Erstellt am';

COMMENT ON COLUMN UPDATEHISTORY.CHG_USER IS
'Geändert von';

COMMENT ON COLUMN UPDATEHISTORY.CHG_DATE IS
'Geändert am';

/* Userview anlegen */
execute procedure SP_CREATE_USER_VIEW 'UPDATEHISTORY';
/* Sequence anlegen */
execute procedure SP_CREATE_SEQUNECE 'UPDATEHISTORY';
/* Trigger anlegen */
execute procedure SP_CREATE_TRIGGER_BI 'UPDATEHISTORY';
execute procedure SP_CREATE_TRIGGER_BU 'UPDATEHISTORY';

CREATE TABLE TENANT (
  ID                   INTEGER NOT NULL,
  TAG_ID               INTEGER,
  COUNTRY_ID           INTEGER,
  SESSION_IDLE_TIME    INTEGER DEFAULT 30,
  SESSION_LIFETIME     INTEGER DEFAULT 1,  
  CAPTION              VARCHAR(64) NOT NULL,
  DESCRIPTION          VARCHAR(2000),
  DONOTDELETE          BOOLEAN,
  SOFTDEL              BOOLEAN,    
  CRE_USER             VARCHAR(32) NOT NULL,
  CRE_DATE             TIMESTAMP NOT NULL,
  CHG_USER             VARCHAR(32),
  CHG_DATE             TIMESTAMP    
);

COMMENT ON TABLE TENANT IS
'Mandanten'; 

COMMENT ON COLUMN TENANT.ID IS
'Primärschlüssel';

COMMENT ON COLUMN TENANT.TAG_ID IS
'Fremdschlüssel für Tags';

COMMENT ON COLUMN TENANT.COUNTRY_ID IS
'Fremdschlüssel für Ländercodes';

COMMENT ON COLUMN TENANT.SESSION_IDLE_TIME IS
'Ruhezeit einer Sitzung in Minuten';

COMMENT ON COLUMN TENANT.SESSION_LIFETIME IS
'Lebenszeit einer Sitzung in Tagen';

COMMENT ON COLUMN TENANT.CAPTION IS
'Bezeichnung';

COMMENT ON COLUMN TENANT.DESCRIPTION IS
'Beschreibung';

COMMENT ON COLUMN TENANT.DONOTDELETE IS
'Löschflag ignorieren';

COMMENT ON COLUMN TENANT.SOFTDEL IS
'Löschflag';

COMMENT ON COLUMN TENANT.CRE_USER IS
'Erstellt von';

COMMENT ON COLUMN TENANT.CRE_DATE IS
'Erstellt am';

COMMENT ON COLUMN TENANT.CHG_USER IS
'Geändert von';

COMMENT ON COLUMN TENANT.CHG_DATE IS
'Geändert am';

/* Userview anlegen */
execute procedure SP_CREATE_USER_VIEW 'TENANT';
/* Sequence anlegen */
execute procedure SP_CREATE_SEQUNECE 'TENANT';
/* Trigger anlegen */
execute procedure SP_CREATE_TRIGGER_BI 'TENANT';
execute procedure SP_CREATE_TRIGGER_BU 'TENANT';
execute procedure SP_CREATE_TRIGGER_BD 'TENANT', 'DONOTDELETE';

CREATE TABLE ROLES (
  ID                  INTEGER NOT NULL,
  TAG_ID              INTEGER,    
  CAPTION             VARCHAR(64),
  DESCRIPTION         VARCHAR(2000),
  IS_ADMIN            BOOLEAN,
  SETUP               BOOLEAN,
  MEMBERS             BOOLEAN,
  ACTIVITY_RECORDING  BOOLEAN,
  SEPA                BOOLEAN,
  BILLING             BOOLEAN,
  IMPORT              BOOLEAN,
  EXPORT              BOOLEAN,
  REFERENCE_DATA      BOOLEAN,
  REPORTING           BOOLEAN,
  MISC                BOOLEAN,
  FILERESOURCE        BOOLEAN,
  CLOSESESSION        BOOLEAN DEFAULT 1,
  FIND                BOOLEAN DEFAULT 1,
  DONOTDELETE         BOOLEAN,
  SOFTDEL             BOOLEAN,    
  CRE_USER            VARCHAR(32) NOT NULL,
  CRE_DATE            TIMESTAMP NOT NULL,
  CHG_USER            VARCHAR(32),
  CHG_DATE            TIMESTAMP    
);

COMMENT ON TABLE ROLES IS
'Rollen'; 

COMMENT ON COLUMN ROLES.ID IS
'Primärschlüssel';

COMMENT ON COLUMN ROLES.TAG_ID IS
'Fremdschlüssel für Tags';

COMMENT ON COLUMN ROLES.CAPTION IS
'Bezeichnung';

COMMENT ON COLUMN ROLES.DESCRIPTION IS
'Beschreibung';

COMMENT ON COLUMN ROLES.IS_ADMIN IS
'Vollzugriff';

COMMENT ON COLUMN ROLES.SETUP IS
'Einstellungen verwalten';

COMMENT ON COLUMN ROLES.MEMBERS IS
'Mitglieder verwalten';

COMMENT ON COLUMN ROLES.ACTIVITY_RECORDING IS
'Leistungsdaten verwalten';

COMMENT ON COLUMN ROLES.SEPA IS
'Datenträgeraustausch durchführen';

COMMENT ON COLUMN ROLES.BILLING IS
'Abrechnung durchführen';

COMMENT ON COLUMN ROLES.IMPORT IS
'Import-Daten verarbeiten (z.B. RL-Daten)';

COMMENT ON COLUMN ROLES.EXPORT IS
'Daten exportieren';

COMMENT ON COLUMN ROLES.REFERENCE_DATA IS
'Stammdaten verwalten';

COMMENT ON COLUMN ROLES.REPORTING IS
'Reports erstellen';

COMMENT ON COLUMN ROLES.MISC IS
'Verschiedenes (z.B. Uniquename)';

COMMENT ON COLUMN ROLES.FILERESOURCE IS
'Bearbeiten von Dateiquellen';

COMMENT ON COLUMN ROLES.FIND IS
'Suche starten';

COMMENT ON COLUMN ROLES.CLOSESESSION IS
'Sitzung schließen';

COMMENT ON COLUMN ROLES.DONOTDELETE IS
'Löschflag ignorieren';

COMMENT ON COLUMN ROLES.SOFTDEL IS
'Löschflag';

COMMENT ON COLUMN ROLES.CRE_USER IS
'Erstellt von';

COMMENT ON COLUMN ROLES.CRE_DATE IS
'Erstellt am';

COMMENT ON COLUMN ROLES.CHG_USER IS
'Geändert von';

COMMENT ON COLUMN ROLES.CHG_DATE IS
'Geändert am';

/* Userview anlegen */
execute procedure SP_CREATE_USER_VIEW 'ROLES';
/* Sequence anlegen */
execute procedure SP_CREATE_SEQUNECE 'ROLES';
/* Trigger anlegen */
execute procedure SP_CREATE_TRIGGER_BI 'ROLES';
execute procedure SP_CREATE_TRIGGER_BU 'ROLES';
execute procedure SP_CREATE_TRIGGER_BD 'ROLES', 'DONOTDELETE';

CREATE TABLE REGISTRY (
  KEYNAME  VARCHAR(256) NOT NULL,    
  SECTION  VARCHAR(64) NOT NULL,
  IDENT    VARCHAR(64) NOT NULL,
  "VALUE"    VARCHAR(2000) NOT NULL
);

COMMENT ON TABLE REGISTRY IS
'Registry'; 

COMMENT ON COLUMN REGISTRY.KEYNAME IS
'Haupschlüssel, z.B.: Username';
    
COMMENT ON COLUMN REGISTRY.SECTION IS
'Section';

COMMENT ON COLUMN REGISTRY.IDENT IS
'Ident';

COMMENT ON COLUMN REGISTRY."VALUE" IS
'Datenwert';

/* Userview anlegen */
execute procedure SP_CREATE_USER_VIEW 'REGISTRY';
/* Die Registry hat keine Standardsequence und -trigger */

CREATE TABLE SESSION (
  ID            INTEGER NOT NULL,        
  USER_ID       INTEGER NOT NULL,
  SESSION_ID    VARCHAR(128) NOT NULL,
  TAG_ID        INTEGER,        
  EXPIRY_DATE   TIMESTAMP NOT NULL,
  LAST_REVIEWED TIMESTAMP NOT NULL,
  IP            VARCHAR(64),
  CLOSED        BOOLEAN,
  REACTIVATED   INTEGER DEFAULT 0,
  SOFTDEL       BOOLEAN,        
  CRE_USER      VARCHAR(32) NOT NULL,
  CRE_DATE      TIMESTAMP NOT NULL,
  CHG_USER      VARCHAR(32),
  CHG_DATE      TIMESTAMP    
);

COMMENT ON TABLE SESSION IS
'Sitzungen'; 

COMMENT ON COLUMN SESSION.ID IS
'Primärschlüssel';

COMMENT ON COLUMN SESSION.USER_ID IS
'Fremdschlüssel aus USER';

COMMENT ON COLUMN SESSION.SESSION_ID IS
'SessionID, z.B.: GUID';

COMMENT ON COLUMN SESSION.TAG_ID IS
'Fremdschlüssel für Tags';
    
COMMENT ON COLUMN SESSION.EXPIRY_DATE IS
'Ablaufdatum für eine Sitzung';

COMMENT ON COLUMN SESSION.LAST_REVIEWED IS
'Zuletzt verwendet';

COMMENT ON COLUMN SESSION.IP IS
'IP des Benutzers';

COMMENT ON COLUMN SESSION.CLOSED IS
'Wenn True (1) Sitzung geschlossen';

COMMENT ON COLUMN SESSION.REACTIVATED IS
'Anzahl der Wiedereröffnungen einer Sitzung in Verbingung mit einem User';

COMMENT ON COLUMN SESSION.SOFTDEL IS
'Löschflag';

COMMENT ON COLUMN SESSION.CRE_USER IS
'Erstellt von';

COMMENT ON COLUMN SESSION.CRE_DATE IS
'Erstellt am';

COMMENT ON COLUMN SESSION.CHG_USER IS
'Geändert von';

COMMENT ON COLUMN SESSION.CHG_DATE IS
'Geändert am';

/* Userview anlegen */
execute procedure SP_CREATE_USER_VIEW 'SESSION';
/* Sequence anlegen */
execute procedure SP_CREATE_SEQUNECE 'SESSION';
/* Trigger anlegen */
execute procedure SP_CREATE_TRIGGER_BI 'SESSION';
execute procedure SP_CREATE_TRIGGER_BU 'SESSION';

CREATE TABLE USERS (
  ID           INTEGER NOT NULL,
  ROLE_ID      INTEGER NOT NULL,    
  TENANT_ID    INTEGER NOT NULL,
  TAG_ID       INTEGER,    
  USERNAME     VARCHAR(256) NOT NULL,
  PASSWORD     VARCHAR(512) NOT NULL,
  FIRST_NAME   VARCHAR(256),
  NAME         VARCHAR(256),
  EMAIL        VARCHAR(127),
  ALLOW_LOGIN  BOOLEAN,
  DONOTDELETE  BOOLEAN,
  SOFTDEL      BOOLEAN,    
  CRE_USER     VARCHAR(32) NOT NULL,
  CRE_DATE     TIMESTAMP NOT NULL,
  CHG_USER     VARCHAR(32),
  CHG_DATE     TIMESTAMP    
);

COMMENT ON TABLE USERS IS
'Benutzer'; 

COMMENT ON COLUMN USERS.ID IS
'Primärschlüssel';

COMMENT ON COLUMN USERS.ROLE_ID IS
'Fremdschlüssel aus ROLES';

COMMENT ON COLUMN USERS.TENANT_ID IS
'Fremdschlüssel aus TENANT';

COMMENT ON COLUMN USERS.TAG_ID IS
'Fremdschlüssel für Tags';

COMMENT ON COLUMN USERS.USERNAME IS
'Benutzername';

COMMENT ON COLUMN USERS.PASSWORD IS
'Passwort';

COMMENT ON COLUMN USERS.FIRST_NAME IS
'Vorname';

COMMENT ON COLUMN USERS.NAME IS
'Nachname';

COMMENT ON COLUMN USERS.EMAIL IS
'Emailadresse';

COMMENT ON COLUMN USERS.ALLOW_LOGIN IS
'Login erlaubt';
    
COMMENT ON COLUMN USERS.DONOTDELETE IS
'Löschflag ignorieren';
    
COMMENT ON COLUMN USERS.SOFTDEL IS
'Löschflag';
    
COMMENT ON COLUMN USERS.CRE_USER IS
'Erstellt von';

COMMENT ON COLUMN USERS.CRE_DATE IS
'Erstellt am';

COMMENT ON COLUMN USERS.CHG_USER IS
'Geändert von';

COMMENT ON COLUMN USERS.CHG_DATE IS
'Geändert am';

/* Userview anlegen */
execute procedure SP_CREATE_USER_VIEW 'USERS';
/* Sequence anlegen */
execute procedure SP_CREATE_SEQUNECE 'USERS';
/* Trigger anlegen */
execute procedure SP_CREATE_TRIGGER_BI 'USERS';
execute procedure SP_CREATE_TRIGGER_BU 'USERS';
execute procedure SP_CREATE_TRIGGER_BD 'USERS', 'DONOTDELETE';

CREATE TABLE DATATYPE(
  ID           INTEGER NOT NULL,
  TAG_ID       INTEGER,
  CODE         DBOBJECTNAME32 NOT NULL,
  DESCRIPTION  VARCHAR(2000),
  DONOTDELETE  BOOLEAN,
  SOFTDEL      BOOLEAN,    
  CRE_USER     VARCHAR(32) NOT NULL,
  CRE_DATE     TIMESTAMP NOT NULL,
  CHG_USER     VARCHAR(32),
  CHG_DATE     TIMESTAMP
);

COMMENT ON TABLE DATATYPE IS
'Datentyp / Domaine'; 

COMMENT ON COLUMN DATATYPE.ID IS
'Primärschlüssel';

COMMENT ON COLUMN DATATYPE.TAG_ID IS
'Fremdschlüssel für Tags';
    
COMMENT ON COLUMN DATATYPE.CODE IS
'Datentype / Domaine';
    
COMMENT ON COLUMN DATATYPE.DESCRIPTION IS
'Beschreibung zum Datentype / zur Domaine';   
    
COMMENT ON COLUMN DATATYPE.DONOTDELETE IS
'Löschflag ignorieren';
    
COMMENT ON COLUMN DATATYPE.SOFTDEL IS
'Löschflag';
    
COMMENT ON COLUMN DATATYPE.CRE_USER IS
'Erstellt von';

COMMENT ON COLUMN DATATYPE.CRE_DATE IS
'Erstellt am';

COMMENT ON COLUMN DATATYPE.CHG_USER IS
'Geändert von';

COMMENT ON COLUMN DATATYPE.CHG_DATE IS
'Geändert am';

/* Userview anlegen */
execute procedure SP_CREATE_USER_VIEW 'DATATYPE';
/* Sequence anlegen */
execute procedure SP_CREATE_SEQUNECE 'DATATYPE';
/* Trigger anlegen */
execute procedure SP_CREATE_TRIGGER_BI 'DATATYPE';
execute procedure SP_CREATE_TRIGGER_BU 'DATATYPE';
execute procedure SP_CREATE_TRIGGER_BD 'DATATYPE', 'DONOTDELETE';

COMMIT WORK;
/******************************************************************************/
/*                                Primary Keys                                
/******************************************************************************/

ALTER TABLE TAG ADD CONSTRAINT PK_TAG PRIMARY KEY (ID);
ALTER TABLE UPDATEHISTORY ADD CONSTRAINT PK_UPDATEHISTORY PRIMARY KEY (ID);
ALTER TABLE ROLES ADD CONSTRAINT PK_ROLES PRIMARY KEY (ID);
ALTER TABLE REGISTRY ADD CONSTRAINT PK_REGISTRY PRIMARY KEY(KEYNAME, SECTION, IDENT);
ALTER TABLE USERS ADD CONSTRAINT PK_USERS PRIMARY KEY (ID);
ALTER TABLE SESSION ADD CONSTRAINT PK_SESSION PRIMARY KEY (ID);
ALTER TABLE TENANT ADD CONSTRAINT PK_TENANT PRIMARY KEY (ID);
ALTER TABLE COUNTRY ADD CONSTRAINT PK_COUNTRY PRIMARY KEY (ID);
ALTER TABLE DATATYPE ADD CONSTRAINT PK_DATATYPE PRIMARY KEY (ID);

COMMIT WORK;
/******************************************************************************/
/*                                Foreign Keys                                
/******************************************************************************/

ALTER TABLE USERS ADD CONSTRAINT FK_USERS_ROLES FOREIGN KEY (ROLE_ID) REFERENCES ROLES(ID) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE USERS ADD CONSTRAINT FK_USER_TENANT FOREIGN KEY (TENANT_ID) REFERENCES TENANT(ID) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE USERS ADD CONSTRAINT FK_USERS_TAG FOREIGN KEY (TAG_ID) REFERENCES TAG(ID) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE SESSION ADD CONSTRAINT FK_SESSION_USER FOREIGN KEY (USER_ID) REFERENCES USERS(ID) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE SESSION ADD CONSTRAINT FK_SESSION_TAG FOREIGN KEY (TAG_ID) REFERENCES TAG(ID) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE TENANT ADD CONSTRAINT FK_TENANT_TAG FOREIGN KEY (TAG_ID) REFERENCES TAG(ID) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE TENANT ADD CONSTRAINT FK_TENANT_COUNTRY FOREIGN KEY (COUNTRY_ID) REFERENCES COUNTRY(ID) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE ROLES ADD CONSTRAINT FK_ROLES_TAG FOREIGN KEY (TAG_ID) REFERENCES TAG(ID) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE COUNTRY ADD CONSTRAINT FK_COUNTRY_TAG FOREIGN KEY (TAG_ID) REFERENCES TAG(ID) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE DATATYPE ADD CONSTRAINT FK_DATATYPE_TAG FOREIGN KEY (TAG_ID) REFERENCES TAG(ID) ON DELETE SET NULL ON UPDATE CASCADE;

COMMIT WORK;
/******************************************************************************/
/*                                  Indices                                   
/******************************************************************************/

ALTER TABLE DATATYPE ADD CONSTRAINT UNQ_DATATYPE_CODE UNIQUE (CODE) USING INDEX ALT_DATATYPE_CODE;
ALTER TABLE ROLES ADD CONSTRAINT UNQ_ROLES_CAPTION UNIQUE (CAPTION) USING INDEX ALT_ROLES_CAPTION;

COMMIT WORK;
/******************************************************************************/
/*                                  Indices                                   
/******************************************************************************/

CREATE UNIQUE INDEX ALT_COUNTRY_CODE ON COUNTRY (COUNTRY_CODE);
CREATE UNIQUE INDEX ALT_COURRENCY_CODE ON COUNTRY (CURRENCY_CODE);
CREATE UNIQUE INDEX ALT_COUNTRY ON COUNTRY (COUNTRY_CODE, CURRENCY_CODE);
CREATE UNIQUE INDEX ALT_SESSION ON SESSION (USER_ID, SESSION_ID);
CREATE UNIQUE INDEX ALT_USERNAME ON USERS (USERNAME);

COMMIT WORK;
/******************************************************************************/
/*                                  Triggers                                  
/******************************************************************************/

/* Standardtrigger werden druch die SPs: SP_CREATE_TRIGGER_BI und SP_CREATE_TRIGGER_BU erstellt */

/* Trigger: SESSION_BU1 */
SET TERM ^ ;

CREATE OR ALTER TRIGGER SESSION_BU1 FOR SESSION
ACTIVE BEFORE UPDATE POSITION 1
AS
begin
  if ((old.CLOSED = 1) and (new.CLOSED = 0)) then
  begin
    new.REACTIVATED = old.REACTIVATED + 1;
  end  
end
^

COMMENT ON TRIGGER SESSION_BU1 IS 
'Before-Update-Trigger erhöht den Zähler für Reaktivierungen einer Sitzung für die Tabelle Session'^

SET TERM ; ^

COMMIT WORK;
/******************************************************************************/
/*                             Stored Procedures                              
/******************************************************************************/

SET TERM ^ ;

CREATE OR ALTER PROCEDURE SP_CHECKGRANT (
  AUSERNAME VARCHAR(254),
  AGRANT VARCHAR(64))
RETURNS (
  success smallint)
AS
declare variable is_admin integer;
declare variable role_id integer;
declare variable is_granted integer;
BEGIN
  success = 0;
  
  select ROLE_ID from V_USERS where USERNAME=:AUSERNAME into :role_id;
  
  if (exists(select 1 from V_ROLES where ID=:role_id and IS_ADMIN=1)) then 
  begin
    success = 1;
  end 
  else
  begin
    execute statement 'select ' || AGRANT || ' from V_ROLES where ID=' || role_id into :is_granted;
    
    if ((is_granted = 0) or (is_granted is null)) then
    begin
      EXCEPTION ACCESS_DENIED;
    end
    else
    begin
      success = 1;
    end    
  end 

  suspend;
END^

COMMENT ON PROCEDURE SP_CHECKGRANT IS
'Überprüft die Rechte eines Users'^

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_CHECKGRANT'^

/* Da SP_READINTEGER zum Zeitpunkt dieser ersten Declarierung von SP_TOUCHSESSION noch nicht bekannt ist,
   SP_TOUCHSESSION aber noch vor der Declarierung von SP_READINTEGER bekannt sein muss, 
   wird hier die SP_TOUCHSESSION  ohne den Aufruf von SP_READINTEGER ergänzt.
   Im Abschnitt für zirkuläre Verbinungen (am Ende dieses Scriptes) wird SP_TOUCHSESSION um den Aufruf von SP_READINTEGER ergänzt */

CREATE OR ALTER PROCEDURE SP_TOUCHSESSION (
  ASESSIONID VARCHAR(128),
  AUSERNAME VARCHAR(256),
  AIP VARCHAR(64),
  ABYREGSESSION smallint = 0)
RETURNS (
  success smallint)  
AS
declare variable user_id integer;
declare variable tenant_id integer;
declare variable expire_date date;
declare variable last_reviewed time;
declare variable allow_login smallint;
declare variable session_idle_time integer;
declare variable session_lifetime integer;
declare variable do_register_closed_session smallint;
begin
  success = 0;       
  expire_date = null;
  last_reviewed = null;
  user_id = 0;
  do_register_closed_session = 0;
  
  select ID, TENANT_ID, ALLOW_LOGIN from V_USERS where USERNAME=:AUSERNAME into :user_id, :tenant_id, :allow_login;
  
  if ((user_id > 0) and (allow_login = 1)) then
  begin 
    if (exists(select 1 from V_SESSION where SESSION_ID=:ASESSIONID and USER_ID=:user_id and CLOSED=0)) then
    begin    
      select EXPIRY_DATE, LAST_REVIEWED from V_SESSION where SESSION_ID=:ASESSIONID and USER_ID=:user_id into :expire_date, :last_reviewed;
      select SESSION_IDLE_TIME, SESSION_LIFETIME from V_TENANT where ID=:tenant_id into :session_idle_time, :session_lifetime;
      
      if ((current_time - last_reviewed) > (session_idle_time*60)) then
      begin
        success = 0;
        
        EXCEPTION SESSION_IDLE_TIMEOUT;
        
        suspend;      
      end
      
      if ((current_date - expire_date) >= session_lifetime) then
      begin
        success = 0; 
      
        EXCEPTION SESSION_LIFETIME_TIMEOUT;
        
        suspend;
      end
        
      update
        V_SESSION
      set
        LAST_REVIEWED=current_timestamp
      where
        SESSION_ID=:ASESSIONID
        and
        USER_ID=:user_id;
        
      success = 1;  
    end
    else
    begin
      if (exists(select 1 from V_SESSION where SESSION_ID=:ASESSIONID and CLOSED=0)) then
      begin
        success = 0;
        
        EXCEPTION INVALID_SESSION_DATA;
        
        suspend;      
      end
      else
      begin    
        if (ABYREGSESSION = 1) then
        begin
          if (do_register_closed_session = 1) then
          begin
            expire_date = current_date + 1;
            last_reviewed = current_timestamp;
            
            if (exists(select 1 from V_SESSION where SESSION_ID=:ASESSIONID and USER_ID=:user_id and CLOSED=1)) then
            begin
              update
                V_SESSION
              set
                EXPIRY_DATE = :expire_date,
                LAST_REVIEWED = :last_reviewed,
                CLOSED = 0
              where
                SESSION_ID=:ASESSIONID 
              and 
                USER_ID=:user_id 
              and 
                CLOSED=1;
              
              success = 1;  
            end
            else
            begin            
              insert
              into
              V_SESSION (
                USER_ID,
                SESSION_ID,       
                EXPIRY_DATE,
                LAST_REVIEWED,
                IP)
              values (
                :user_id,
                :ASESSIONID,
                :expire_date,
                :last_reviewed,
                :AIP
              );
              
              success = 1;
            end                    
          end
          else
          begin
            success = 0;
            
            EXCEPTION INVALID_SESSION_DATA;
            
            suspend;        
          end
        end
        else
        begin
          success = 0;
          
          EXCEPTION INVALID_SESSION_DATA;
          
          suspend;
        end
      end         
    end
  end
  else
  begin 
    if ((user_id < 1) or (user_id is null)) then
    begin
      success = 0;
      
      EXCEPTION UNKNOWN_USDERID;
      
      suspend; 
    end
    
    if ((allow_login <> 1) or (allow_login is null)) then
    begin
      success = 0;
      
      EXCEPTION NO_LOGIN_ALLOWED;
      
      suspend;     
    end 
    
    EXCEPTION CANCEL_BY_UNKNOWN_REASON; 
  end
  
  suspend;
end^

COMMENT ON PROCEDURE SP_TOUCHSESSION IS
'Berührt eine Sitzung'^

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_TOUCHSESSION'^

CREATE OR ALTER PROCEDURE SP_CHECKGRANT_BY_SVR (
  ASESSION_ID VARCHAR(254),  
  AUSERNAME VARCHAR(254),
  AIP VARCHAR(254),
  AGRANT VARCHAR(64))
RETURNS (
  success smallint)
AS
declare variable success_by_touchsession smallint;
declare variable result_by_func smallint;
begin
  success = 0; 

  select success from SP_TOUCHSESSION(:ASESSION_ID, :AUSERNAME, :AIP) into :success_by_touchsession;
  
  if (success_by_touchsession = 1) then
  begin
    select success from SP_CHECKGRANT(:AUSERNAME, :AGRANT) into :result_by_func;
    
    if (result_by_func is null) then
    begin
      success = 0;
    end
    else
    begin
      success = result_by_func;
    end
  end
  else
  begin
    success = 0;  
  end
  
  suspend;
end^

COMMENT ON PROCEDURE SP_CHECKGRANT_BY_SVR IS
'Webservice-SP für SP_CHECKGRANT'^

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_CHECKGRANT_BY_SVR'^

CREATE OR ALTER PROCEDURE SP_REGISTERSESSION (
  ASESSIONID VARCHAR(128),
  AUSERNAME VARCHAR(256),
  AIP VARCHAR(64))
RETURNS (
  success smallint)  
AS
declare variable user_id integer;
declare variable expire_date date;
declare variable last_reviewed timestamp;
declare variable allow_login smallint;
begin
  success = 0;       
  expire_date = current_date + 1;
  last_reviewed = current_timestamp;
  user_id = 0;
  
  select ID, ALLOW_LOGIN from V_USERS where USERNAME=:AUSERNAME into :user_id, :allow_login;
  
  if ((user_id > 0) and (allow_login = 1)) then
  begin 
    if (exists(select 1 from V_SESSION where SESSION_ID=:ASESSIONID)) then
    begin
      select success from SP_TOUCHSESSION(:ASESSIONID, :AUSERNAME, :AIP, 1) into :success;
    end
    else
    begin
      insert
      into
      V_SESSION (
        USER_ID,
        SESSION_ID,       
        EXPIRY_DATE,
        LAST_REVIEWED,
        IP)
      values (
        :user_id,
        :ASESSIONID,
        :expire_date,
        :last_reviewed,
        :AIP
      );
      
      success = 1;
    end
  end
  else
  begin 
    if (user_id < 1) then
    begin
      success = 0;
      
      EXCEPTION UNKNOWN_USDERID;
      
      suspend; 
    end
    
    if (allow_login <> 1) then
    begin
      success = 0;
      
      EXCEPTION NO_LOGIN_ALLOWED;
      
      suspend;     
    end 
  end
  
  suspend;
end^

COMMENT ON PROCEDURE SP_REGISTERSESSION IS
'Registriert und eröffnet eine Sitzung'^

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_REGISTERSESSION'^

CREATE OR ALTER PROCEDURE SP_READFLOAT (
    AKEY VARCHAR(256),
    ASECTION VARCHAR(64),
    AIDENT VARCHAR(64),
    ADEFAULT FLOAT)
RETURNS (
    RESULT FLOAT)
AS
begin
  if (exists(select 1 from V_REGISTRY where keyname=:AKEY and section=:ASECTION and ident=:AIDENT)) then
  begin
    select cast("VALUE" as float) from V_REGISTRY where keyname=:AKEY and section=:ASECTION and ident=:AIDENT into RESULT;
  end
  else
  begin
    RESULT = ADEFAULT;
  end  
  suspend;
end^

COMMENT ON PROCEDURE SP_READFLOAT IS
'Liest einen Float aus der Registry'^

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_READFLOAT'^

CREATE OR ALTER PROCEDURE SP_READFLOAT_BY_SRV (
  ASESSION_ID varchar(254),  
  AUSERNAME varchar(254),
  AIP varchar(254),
  AKEY VARCHAR(256),
  ASECTION VARCHAR(64),
  AIDENT VARCHAR(64),
  ADEFAULT FLOAT)
RETURNS (
  success smallint,
  code smallint,
  info varchar(2000))
AS
declare variable success_by_touchsession smallint;
declare variable result_by_func float;
declare variable success_by_grant smallint;
begin
  code = 0;
  info = '{"kind": 0, "result": null}';
  success = 0; 
  
  result_by_func = ADEFAULT;

  select success from SP_TOUCHSESSION(:ASESSION_ID, :AUSERNAME, :AIP) into :success_by_touchsession;
  
  if (success_by_touchsession = 1) then
  begin
    select success from SP_CHECKGRANT(:AUSERNAME, 'SETUP') into :success_by_grant;
    
    if (success_by_grant = 1) then
    begin
      select result from SP_READFLOAT(:AKEY, :ASECTION, :AIDENT, :ADEFAULT) into :result_by_func;
      
      if (:result_by_func is null) then
      begin
        info = '{"kind": 0, "result": null}';
      end
      else
      begin
        code = 1;
        info = '{"kind": 0, "result": ' || :result_by_func || '}';
        success = 1;
      end
    end
    else
    begin
      info = '{"kind": 0, "result": null}';
    end
  end
  else
  begin
    info = '{"kind": 0, "result": null}';  
  end
  
  suspend;
end^

COMMENT ON PROCEDURE SP_READFLOAT_BY_SRV IS
'Webservice-SP für SP_READFLOAT'^

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_READFLOAT_BY_SRV'^

CREATE OR ALTER PROCEDURE SP_READINTEGER (
  AKEY VARCHAR(256),
  ASECTION VARCHAR(64),
  AIDENT VARCHAR(64),
  ADEFAULT INTEGER)
RETURNS (
  RESULT INTEGER)
AS
begin
  if (exists(select 1 from V_REGISTRY where keyname=:AKEY and section=:ASECTION and ident=:AIDENT)) then
  begin
    select cast("VALUE" as integer) from V_REGISTRY where keyname=:AKEY and section=:ASECTION and ident=:AIDENT into RESULT;
  end
  else
  begin
    RESULT = ADEFAULT;
  end  
  suspend;
end^

COMMENT ON PROCEDURE SP_READINTEGER IS
'Liest einen Integer aus der Registry'^

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_READINTEGER'^

CREATE OR ALTER PROCEDURE SP_READINTEGER_BY_SRV (
  ASESSION_ID varchar(254),  
  AUSERNAME varchar(254),
  AIP varchar(254),
  AKEY VARCHAR(256),
  ASECTION VARCHAR(64),
  AIDENT VARCHAR(64),
  ADEFAULT INTEGER)
RETURNS (
  success smallint,
  code smallint,
  info varchar(2000))
AS
declare variable success_by_touchsession smallint;
declare variable result_by_func integer;
declare variable success_by_grant smallint;
begin
  code = 0;
  info = '{"kind": 0, "result": null}';
  success = 0; 
  
  result_by_func = ADEFAULT;

  select success from SP_TOUCHSESSION(:ASESSION_ID, :AUSERNAME, :AIP) into :success_by_touchsession;
  
  if (success_by_touchsession = 1) then
  begin
    select success from SP_CHECKGRANT(:AUSERNAME, 'SETUP') into :success_by_grant;
    
    if (success_by_grant = 1) then
    begin
      select result from SP_READINTEGER(:AKEY, :ASECTION, :AIDENT, :ADEFAULT) into :result_by_func;
      
      if (:result_by_func is null) then
      begin
        info = '{"kind": 0, "result": null}';
      end
      else
      begin
        code = 1;
        info = '{"kind": 0, "result": ' || :result_by_func || '}';
        success = 1;
      end
    end
    else
    begin
      info = '{"kind": 0, "result": null}';
    end
  end
  else
  begin
    info = '{"kind": 0, "result": null}';  
  end  
  
  suspend;
end^

COMMENT ON PROCEDURE SP_READINTEGER_BY_SRV IS
'Webservice-SP für SP_READINTEGER'^

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_READINTEGER_BY_SRV'^

CREATE OR ALTER PROCEDURE SP_READSECTION (
  AKEY VARCHAR(256),
  ASECTION VARCHAR(64))
RETURNS (
  AIDENT VARCHAR(64),
  AVALUE VARCHAR(2000))
AS
begin
  for select ident, "VALUE" from V_REGISTRY where keyname=:AKEY and section=:ASECTION into :AIDENT, :AVALUE do
  suspend;
end^

COMMENT ON PROCEDURE SP_READSECTION IS
'Liest eine Section aus der Registry'^

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_READSECTION'^

CREATE OR ALTER PROCEDURE SP_READSECTION_BY_SRV (
  ASESSION_ID varchar(254),  
  AUSERNAME varchar(254),
  AIP varchar(254),
  AKEY VARCHAR(256),
  ASECTION VARCHAR(64))
RETURNS (
  success smallint,
  code smallint,
  info varchar(2000))
AS
declare variable success_by_touchsession smallint;
declare variable result_ident varchar(64);
declare variable result_value varchar(2000);
declare variable result_info varchar(2000);
declare variable success_by_grant smallint;
begin
  code = 0;
  info = '{"kind": 0, "result": null}';
  success = 0; 

  select success from SP_TOUCHSESSION(:ASESSION_ID, :AUSERNAME, :AIP) into :success_by_touchsession;
  
  if (success_by_touchsession = 1) then
  begin
    select success from SP_CHECKGRANT(:AUSERNAME, 'SETUP') into :success_by_grant;
    
    if (success_by_grant = 1) then
    begin  
      /* Format der Liste
        [{"ident": "bla bla", "value": "bla bla"}, {"ident": "bla bla", "value": "bla bla"}, {"ident": "bla bla", "value": "bla bla"}]
      */  
      result_info = '[';
      for select ident, "VALUE" from V_REGISTRY where keyname=:AKEY and section=:ASECTION into :result_ident, :result_value do
      begin
        if (result_info <> '[') then
        begin
          result_info = result_info || ', ';
        end
        
        result_info = result_info || '{"ident": "' || :result_ident || '", "value": "' || :result_value || '"}';
      end
      result_info = result_info || ']';
      code = 1;
      info = result_info;
      success = 1;
    end
    else
    begin
      info = '{"kind": 0, "result": null}';    
    end    
  end
  else
  begin
    info = '{"kind": 0, "result": null}';  
  end
  
  suspend;
end^

COMMENT ON PROCEDURE SP_READSECTION_BY_SRV IS
'Webservice-SP für SP_READSECTION'^

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_READSECTION_BY_SRV'^

CREATE OR ALTER PROCEDURE SP_READSECTIONS (
  AKEY VARCHAR(256))
RETURNS (
  ASECTION VARCHAR(64))
AS
begin
  for select distinct section from V_REGISTRY where keyname=:AKEY into :ASECTION do
  suspend;
end^

COMMENT ON PROCEDURE SP_READSECTIONS IS
'Liest alle Sectionen aus der Registry'^

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_READSECTIONS'^

CREATE OR ALTER PROCEDURE SP_READSECTIONS_BY_SRV (
  ASESSION_ID varchar(254),  
  AUSERNAME varchar(254),
  AIP varchar(254),
  AKEY VARCHAR(256))
RETURNS (
  success smallint,
  code smallint,
  info varchar(2000))
AS
declare variable success_by_touchsession smallint;
declare variable result_section varchar(64);
declare variable result_info varchar(2000);
declare variable success_by_grant smallint;
begin
  code = 0;
  info = '{"kind": 0, "result": null}';
  success = 0; 

  select success from SP_TOUCHSESSION(:ASESSION_ID, :AUSERNAME, :AIP) into :success_by_touchsession;
  
  if (success_by_touchsession = 1) then
  begin
    select success from SP_CHECKGRANT(:AUSERNAME, 'SETUP') into :success_by_grant;
    
    if (success_by_grant = 1) then
    begin  
      /* Format der Liste
        [{"section": "bla bla"}, {"section": "bla bla"}, {"section": "bla bla"}]
      */  
      result_info = '[';
      for select distinct section from V_REGISTRY where keyname=:AKEY into :result_section do
      begin
        if (result_info <> '[') then
        begin
          result_info = result_info || ', ';
        end
        
        result_info = result_info || '{"section": "' || :result_section || '"}';
      end
      result_info = result_info || ']';
      code = 1;
      info = result_info;
      success = 1;
    end
    else
    begin
      info = '{"kind": 0, "result": null}';
    end
  end
  else
  begin
    info = '{"kind": 0, "result": null}';  
  end
  
  suspend;
end^

COMMENT ON PROCEDURE SP_READSECTIONS_BY_SRV IS
'Webservice-SP für SP_READSECTIONS'^

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_READSECTIONS_BY_SRV'^

CREATE OR ALTER PROCEDURE SP_READSTRING (
  AKEY VARCHAR(256),
  ASECTION VARCHAR(64),
  AIDENT VARCHAR(64),
  ADEFAULT VARCHAR(2000))
RETURNS (
  RESULT VARCHAR(2000))
AS
begin
  if (exists(select 1 from V_REGISTRY where keyname=:AKEY and section=:ASECTION and ident=:AIDENT)) then
  begin
    select "VALUE" from V_REGISTRY where keyname=:AKEY and section=:ASECTION and ident=:AIDENT into RESULT;
  end
  else
  begin
    RESULT = ADEFAULT;
  end  
  suspend;
end^

COMMENT ON PROCEDURE SP_READSTRING IS
'Liest einen String aus der Registry'^

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_READSTRING'^

CREATE OR ALTER PROCEDURE SP_READSTRING_BY_SRV (
  ASESSION_ID varchar(254),  
  AUSERNAME varchar(254),
  AIP varchar(254),
  AKEY VARCHAR(256),
  ASECTION VARCHAR(64),
  AIDENT VARCHAR(64),
  ADEFAULT VARCHAR(2000))
RETURNS (
  success smallint,
  code smallint,
  info varchar(2000))
AS
declare variable success_by_touchsession smallint;
declare variable result_by_func varchar(2000);
declare variable success_by_grant smallint;
begin
  code = 0;
  info = '{"kind": 0, "result": null}';
  success = 0; 
  
  result_by_func = ADEFAULT;

  select success from SP_TOUCHSESSION(:ASESSION_ID, :AUSERNAME, :AIP) into :success_by_touchsession;
  
  if (success_by_touchsession = 1) then
  begin
    select success from SP_CHECKGRANT(:AUSERNAME, 'SETUP') into :success_by_grant;
    
    if (success_by_grant = 1) then
    begin
      select result from SP_READINTEGER(:AKEY, :ASECTION, :AIDENT, :ADEFAULT) into :result_by_func;
      
      if (:result_by_func is null) then
      begin
        info = '{"result": null}';
      end
      else
      begin
        code = 1;
        info = '{"kind": 0, "result": "' || :result_by_func || '"}';
        success = 1;
      end
    end
    else
    begin
      info = '{"kind": 0, "result": null}';
    end
  end
  else
  begin
    info = '{"kind": 0, "result": null}';  
  end
  
  suspend;
end^

COMMENT ON PROCEDURE SP_READSTRING_BY_SRV IS
'Webservice-SP für SP_READSTRING'^

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_READSTRING_BY_SRV'^

CREATE OR ALTER PROCEDURE SP_WRITEFLOAT (
  AKEY VARCHAR(256),
  ASECTION VARCHAR(64),
  AIDENT VARCHAR(64),
  AVALUE FLOAT)
AS
begin
  if (exists(select 1 from V_REGISTRY where keyname=:AKEY and section=:ASECTION and ident=:AIDENT)) then
  begin
    update V_REGISTRY set "VALUE"=cast(:AVALUE as varchar(255)) where keyname=:AKEY and section=:ASECTION and ident=:AIDENT;
  end
  else
  begin
    insert into V_REGISTRY (keyname, section, ident, "VALUE") values (:AKEY, :ASECTION, :AIDENT, cast(:AVALUE as varchar(255)));
  end
  suspend;
end^

COMMENT ON PROCEDURE SP_WRITEFLOAT IS
'Schreibt einen Float in die Registry'^

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_WRITEFLOAT'^

CREATE OR ALTER PROCEDURE SP_WRITEFLOAT_BY_SRV (
  ASESSION_ID varchar(254),  
  AUSERNAME varchar(254),
  AIP varchar(254),
  AKEY VARCHAR(256),
  ASECTION VARCHAR(64),
  AIDENT VARCHAR(64),
  AVALUE FLOAT)
RETURNS (
  success smallint)
AS
declare variable success_by_touchsession smallint;
declare variable success_by_grant smallint;
begin
  success = 0; 
  
  select success from SP_TOUCHSESSION(:ASESSION_ID, :AUSERNAME, :AIP) into :success_by_touchsession;
  
  if (success_by_touchsession = 1) then
  begin
    select success from SP_CHECKGRANT(:AUSERNAME, 'SETUP') into :success_by_grant;
    
    if (success_by_grant = 1) then
    begin
      execute procedure SP_WRITEFLOAT :AKEY, :ASECTION, :AIDENT, :AVALUE;   
      
      success = 1;
    end
    else
    begin
      success = 0;
    end    
  end
  else
  begin
    success = 0;
  end
  
  suspend;
end^

COMMENT ON PROCEDURE SP_WRITEFLOAT_BY_SRV IS
'Webservice-SP für SP_WRITEFLOAT'^

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_WRITEFLOAT_BY_SRV'^

CREATE OR ALTER PROCEDURE SP_WRITEINTEGER (
  AKEY VARCHAR(256),
  ASECTION VARCHAR(64),
  AIDENT VARCHAR(64),
  AVALUE INTEGER)
AS
begin
  if (exists(select 1 from V_REGISTRY where keyname=:AKEY and section=:ASECTION and ident=:AIDENT)) then
  begin
    update V_REGISTRY set "VALUE"=cast(:AVALUE as varchar(255)) where keyname=:AKEY and section=:ASECTION and ident=:AIDENT;
  end
  else
  begin
    insert into V_REGISTRY (keyname, section, ident, "VALUE") values (:AKEY, :ASECTION, :AIDENT, cast(:AVALUE as varchar(255)));
  end
  suspend;
end^

COMMENT ON PROCEDURE SP_WRITEINTEGER IS
'Schreibt einen Integer in die Registry'^

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_WRITEINTEGER'^

CREATE OR ALTER PROCEDURE SP_WRITEINTEGER_BY_SRV (
  ASESSION_ID varchar(254),  
  AUSERNAME varchar(254),
  AIP varchar(254),
  AKEY VARCHAR(256),
  ASECTION VARCHAR(64),
  AIDENT VARCHAR(64),
  AVALUE INTEGER)
RETURNS (
  success smallint)
AS
declare variable success_by_touchsession smallint;
declare variable success_by_grant smallint;
begin
  success = 0; 
  
  select success from SP_TOUCHSESSION(:ASESSION_ID, :AUSERNAME, :AIP) into :success_by_touchsession;
  
  if (success_by_touchsession = 1) then
  begin
    select success from SP_CHECKGRANT(:AUSERNAME, 'SETUP') into :success_by_grant;
    
    if (success_by_grant = 1) then
    begin
      execute procedure SP_WRITEINTEGER :AKEY, :ASECTION, :AIDENT, :AVALUE;   
      
      success = 1;
    end
    else
    begin
      success = 0;
    end    
  end
  else
  begin
    success = 0;
  end
  
  suspend;
end^

COMMENT ON PROCEDURE SP_WRITEINTEGER_BY_SRV IS
'Webservice-SP für SP_WRITEINTEGER'^
                                                                                
execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_WRITEINTEGER_BY_SRV'^
                                                                                
CREATE OR ALTER PROCEDURE SP_WRITESTRING (
  AKEY VARCHAR(256),
  ASECTION VARCHAR(64),
  AIDENT VARCHAR(64),
  AVALUE VARCHAR(2000))
AS
begin
  if (exists(select 1 from V_REGISTRY where keyname=:AKEY and section=:ASECTION and ident=:AIDENT)) then
  begin
    update V_REGISTRY set "VALUE"=:AVALUE where keyname=:AKEY and section=:ASECTION and ident=:AIDENT;
  end
  else
  begin
    insert into V_REGISTRY (keyname, section, ident, "VALUE") values (:AKEY, :ASECTION, :AIDENT, :AVALUE);
  end
  suspend;
end^

COMMENT ON PROCEDURE SP_WRITESTRING IS
'Schreibt einen String in die Registry'^

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_WRITESTRING'^

CREATE OR ALTER PROCEDURE SP_WRITESTRING_BY_SRV (
  ASESSION_ID varchar(254),  
  AUSERNAME varchar(254),
  AIP varchar(254),
  AKEY VARCHAR(256),
  ASECTION VARCHAR(64),
  AIDENT VARCHAR(64),
  AVALUE VARCHAR(2000))
RETURNS (
  success smallint)
AS
declare variable success_by_touchsession smallint;
declare variable success_by_grant smallint;
begin
  success = 0; 
  
  select success from SP_TOUCHSESSION(:ASESSION_ID, :AUSERNAME, :AIP) into :success_by_touchsession;
  
  if (success_by_touchsession = 1) then
  begin
    select success from SP_CHECKGRANT(:AUSERNAME, 'SETUP') into :success_by_grant;
    
    if (success_by_grant = 1) then
    begin  
      execute procedure SP_WRITESTRING :AKEY, :ASECTION, :AIDENT, :AVALUE;   
      
      success = 1;
    end
    else
    begin
      success = 0;
    end    
  end
  else
  begin
    success = 0;
  end
  
  suspend;
end^

COMMENT ON PROCEDURE SP_WRITESTRING_BY_SRV IS
'Webservice-SP für SP_WRITESTRING'^

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_WRITESTRING_BY_SRV'^

CREATE OR ALTER PROCEDURE SP_DBVERSION
RETURNS (
  dbversion varchar(15))  
AS
declare variable key_section varchar(128);
declare variable section varchar(128);
declare variable ident varchar(128);
declare variable value_for_default varchar(255);
declare variable value_for_default_int integer;
declare variable major_version varchar(10);
declare variable minor_version varchar(10);
declare variable release_version varchar(100);
declare variable do_format integer;
begin
  major_version = '';
  minor_version = '';
  release_version = '';
  do_format = 0;

  key_section = 'GENERAL';
  section = 'DBMODEL';
  ident = 'VERSION';
  value_for_default = '0';
  select RESULT from SP_READSTRING(:key_section, :section, :ident, :value_for_default) into :major_version;
  
  key_section = 'GENERAL';
  section = 'DEFAULT';
  ident = 'DO_FORMAT_DBVERSION';
  value_for_default_int = 0;
  select RESULT from SP_READINTEGER(:key_section, :section, :ident, :value_for_default_int) into :do_format; 
  
  select NUMBER, SUBITEM from V_UPDATEHISTORY where NUMBER = (select max(NUMBER) from V_UPDATEHISTORY) into :minor_version, :release_version;
  
  if ((major_version = '') or (major_version is null) or (minor_version = '') or (minor_version is null) or (release_version = '') or (release_version is null)) then
  begin
    dbversion = 'NOVERSION';
  end  
  else
  begin
    if (do_format = 1) then
    begin
      dbversion = LPad(major_version, 3, '0') || '.' || LPad(minor_version, 3, '0') || '.' || LPad(release_version, 5, '0');
    end
    else
    begin
      dbversion = major_version || '.' || minor_version || '.' || release_version;
    end
  end
  
  suspend;
end^

COMMENT ON PROCEDURE SP_DBVERSION IS
'Ermittelt die DB-Version im einfachem Format'^

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_DBVERSION'^

CREATE OR ALTER PROCEDURE SP_GET_DBVERSION
RETURNS (
  success smallint,
  code smallint,
  info varchar(2000))  
AS
declare variable db_version varchar(200);
begin
  code = 0;
  info = '{key: value}';
  success = 0; 

  select dbversion from SP_DBVERSION into :db_version;
  
  code = 1;
  info = '{"kind": 0, "dbversion": "' || db_version || '"}';
  success = 1;
  
  suspend;
end^

COMMENT ON PROCEDURE SP_GET_DBVERSION IS
'Ermittelt die DB-Version im JSON Format'^

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_GET_DBVERSION'^

CREATE OR ALTER PROCEDURE SP_CLOSESESSION (
  ASESSIONID VARCHAR(128),
  AUSERNAME VARCHAR(256),
  AIP VARCHAR(64))
RETURNS (
  success smallint)  
AS
declare variable success_by_touchsession smallint;
declare variable success_by_grant smallint;
begin
  success = 0; 
  
  select success from SP_TOUCHSESSION(:ASESSIONID, :AUSERNAME, :AIP) into :success_by_touchsession;
  
  if (success_by_touchsession = 1) then
  begin
    select success from SP_CHECKGRANT(:AUSERNAME, 'CLOSESESSION') into :success_by_grant;
    
    if (success_by_grant = 1) then
    begin  
     update
        V_SESSION
      set
        CLOSED=1
      where
        SESSION_ID=:ASESSIONID;           
      
      success = 1;
    end
    else
    begin
      success = 0;
    end    
  end
  else
  begin
    success = 0;
  end
  
  suspend;
end^

COMMENT ON PROCEDURE SP_CLOSESESSION IS
'Schließt eine Sitzung'^

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_CLOSESESSION'^

CREATE OR ALTER PROCEDURE SP_CREATE_CATALOG_TABLE (
  ATABLENAME DBOBJECTNAME24,
  ACOMMENT VARCHAR(254) DEFAULT 'ZABonline')
RETURNS (
  success smallint)
AS
declare variable sql_stmt varchar(2000);
declare variable relation_name DBOBJECTNAME24;
declare variable cat_comment varchar(254);
BEGIN
  relation_name = Upper(ATABLENAME);
  cat_comment = ACOMMENT;

  if (exists(select 1 from RDB$RELATIONS where RDB$RELATION_NAME=:relation_name)) then
  begin
    success = 0;
  end
  else
  begin
    sql_stmt = 'CREATE TABLE ' || :relation_name || ' (
    ID           INTEGER NOT NULL,
    TAG_ID       INTEGER,
    COUNTRY_ID   INTEGER,
    CAPTION      VARCHAR(254) NOT NULL,
    DESCRIPTION  VARCHAR(2000),
    DONOTDELETE  BOOLEAN,
    SOFTDEL      BOOLEAN,
    CRE_USER     VARCHAR(32) NOT NULL,
    CRE_DATE     TIMESTAMP NOT NULL,
    CHG_USER     VARCHAR(32),
    CHG_DATE     TIMESTAMP
)';
    execute statement sql_stmt;
    
    sql_stmt = 'COMMENT ON TABLE ' || :relation_name || ' IS ''Katalog: ' || :relation_name || ' für ' || :cat_comment || ' (created by SP_CREATE_CATALOG_TABLE)''';
    execute statement sql_stmt;
    
    sql_stmt = 'COMMENT ON COLUMN ' || :relation_name || '.ID IS ''Primärschlüssel''';
    execute statement sql_stmt;

    sql_stmt = 'COMMENT ON COLUMN ' || :relation_name || '.TAG_ID IS ''Fremdschlüssel für Tags''';
    execute statement sql_stmt;

    sql_stmt = 'COMMENT ON COLUMN ' || :relation_name || '.COUNTRY_ID IS ''Fremdschlüssel für Ländercodes''';
    execute statement sql_stmt;

    sql_stmt = 'COMMENT ON COLUMN ' || :relation_name || '.CAPTION IS ''Bezeichnung''';
    execute statement sql_stmt;

    sql_stmt = 'COMMENT ON COLUMN ' || :relation_name || '.DESCRIPTION IS ''Beschreibung''';
    execute statement sql_stmt;

    sql_stmt = 'COMMENT ON COLUMN ' || :relation_name || '.DONOTDELETE IS ''Löschflag ignorieren''';
    execute statement sql_stmt;

    sql_stmt = 'COMMENT ON COLUMN ' || :relation_name || '.SOFTDEL IS ''Löschflag''';
    execute statement sql_stmt;

    sql_stmt = 'COMMENT ON COLUMN ' || :relation_name || '.CRE_USER IS ''Erstellt von''';
    execute statement sql_stmt;

    sql_stmt = 'COMMENT ON COLUMN ' || :relation_name || '.CRE_DATE IS ''Erstellt am''';
    execute statement sql_stmt;

    sql_stmt = 'COMMENT ON COLUMN ' || :relation_name || '.CHG_USER IS ''Geändert von''';
    execute statement sql_stmt;

    sql_stmt = 'COMMENT ON COLUMN ' || :relation_name || '.CHG_DATE IS ''Geändert am''';    
    execute statement sql_stmt;    
          
    sql_stmt = 'ALTER TABLE ' || :relation_name || ' ADD CONSTRAINT PK_' || :relation_name ||' PRIMARY KEY (ID)';      
    execute statement sql_stmt;
    
    sql_stmt = 'ALTER TABLE ' || :relation_name || ' ADD CONSTRAINT FK_' || :relation_name || '_COUNTRY FOREIGN KEY (COUNTRY_ID) REFERENCES COUNTRY (ID) ON DELETE SET NULL ON UPDATE CASCADE';
    execute statement sql_stmt;
        
    sql_stmt = 'ALTER TABLE ' || :relation_name || ' ADD CONSTRAINT FK_' || :relation_name || '_TYPE_TAG FOREIGN KEY (TAG_ID) REFERENCES TAG (ID) ON DELETE SET NULL ON UPDATE CASCADE';
    execute statement sql_stmt;  
    
    sql_stmt = 'CREATE UNIQUE INDEX ALT_' || :relation_name || ' ON ' || :relation_name || '(COUNTRY_ID, CAPTION)';
    execute statement sql_stmt;  
    
    sql_stmt = 'COMMENT ON INDEX ALT_' || :relation_name || ' IS ''(created by SP_CREATE_CATALOG_TABLE)''';
    execute statement sql_stmt;
    
    sql_stmt = 'CREATE INDEX IDX_' || :relation_name || '_SI ON ' || :relation_name || '(SOFTDEL)';
    execute statement sql_stmt;  
    
    sql_stmt = 'COMMENT ON INDEX IDX_' || :relation_name || '_SI IS ''(created by SP_CREATE_CATALOG_TABLE)''';
    execute statement sql_stmt;    
              
    success = 1;  
  end      

  suspend;
END^

COMMENT ON PROCEDURE SP_CREATE_CATALOG_TABLE IS
'Erstellt einen Katalog'^
    
execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_CREATE_CATALOG_TABLE'^

CREATE OR ALTER PROCEDURE SP_CREATE_ZABCATALOG (
  ATABLENAME DBOBJECTNAME24,
  ACOMMENT VARCHAR(254) DEFAULT 'ZABonline')
RETURNS (
  success smallint)  
AS
declare variable relation_name DBOBJECTNAME24;
declare variable cat_comment varchar(254);
BEGIN
  relation_name = Upper(ATABLENAME);
  cat_comment = ACOMMENT;

  /* Katalog anlegen */
  select success from SP_CREATE_CATALOG_TABLE(:relation_name, :cat_comment) into :success;
  
  /* Namen des Kataloges registrieren */
  if (success = 1) then
  begin
    insert
    into
    V_ADM_CATALOGS
    (
      CAPTION,
      DESCRIPTION
    )
    values
    (
      :relation_name,
      :cat_comment
    );
  end
  
  /* Userview anlegen */
  if (success = 1) then
  begin
    select success from SP_CREATE_USER_VIEW(:relation_name) into :success;
  end
  
  /* Sequence anlegen */
  if (success = 1) then
  begin  
    select success from SP_CREATE_SEQUNECE(:relation_name) into :success;
    /* passend zur Sequence eine Zugriffs-SP einrichten */
    if (success = 1) then
    begin
      select success from SP_CREATE_SEQUENCE_GETTER(:relation_name) into :success;
    end
  end

  /* passend zum Katalog eine Insert-Routine einrichten */
  if (success = 1) then
  begin
    select success from SP_CREATE_CATALOG_SETTER(:relation_name) into :success;
  end
    
  /* Trigger anlegen */
  if (success = 1) then
  begin  
    select success from SP_CREATE_TRIGGER_BI(:relation_name) into :success;
  end
  
  if (success = 1) then
  begin  
    select success from SP_CREATE_TRIGGER_BU(:relation_name) into :success;
  end
  
  if (success = 1) then
  begin  
    select success from SP_CREATE_TRIGGER_BD(:relation_name, 'DONOTDELETE') into :success;
  end

  suspend;
END^

COMMENT ON PROCEDURE SP_CREATE_ZABCATALOG IS
'Legt einen Katalog mit all seinen Datenbankobjekten an'^

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_CREATE_ZABCATALOG'^

CREATE OR ALTER PROCEDURE SP_CREATE_RELATION_TABLE (
  ALEFT_TABLENAME DBOBJECTNAME24,
  ARIGHT_TABLENAME DBOBJECTNAME24, 
  ADO_CREATE_PRIMARY_KEY BOOLEAN)
RETURNS (
  success smallint,
  relation_name DBOBJECTNAME32)
AS
declare variable sql_stmt varchar(2000);
declare variable left_relation_name DBOBJECTNAME24;
declare variable right_relation_name DBOBJECTNAME24;
declare variable left_id_name DBOBJECTNAME32;
declare variable right_id_name DBOBJECTNAME32;
declare variable do_create_primary_key BOOLEAN;
declare variable short_relation_name varchar(6);
declare variable right_fk_relation_name DBOBJECTNAME32;
declare variable left_fk_relation_name DBOBJECTNAME32;
declare variable short_relation_name_counter integer;
BEGIN
  left_relation_name = Upper(ALEFT_TABLENAME);
  right_relation_name = Upper(ARIGHT_TABLENAME);
  left_id_name = left_relation_name || '_ID';
  right_id_name = right_relation_name || '_ID';
  do_create_primary_key = ADO_CREATE_PRIMARY_KEY;
  
  short_relation_name = Upper(substring(left_relation_name from 1 for 1) || substring(right_relation_name from 1 for 1));
  
  relation_name = 'REL_' || left_relation_name || '_' || right_relation_name;

  if (exists(select 1 from RDB$RELATIONS where RDB$RELATION_NAME=:relation_name)) then
  begin
    success = 0;
  end
  else
  begin
    sql_stmt = 'CREATE TABLE ' || :relation_name || ' (
    ' || :left_id_name || ' INTEGER NOT NULL,
    ' || :right_id_name || ' INTEGER NOT NULL
)';
    execute statement sql_stmt; 

    sql_stmt = 'COMMENT ON TABLE ' || :relation_name || ' IS 
''Relation zwischen den Tabellen ' || :left_relation_name || ' und ' || :right_relation_name || '(created by SP_CREATE_RELATION_TABLE)''';
    execute statement sql_stmt;
    
    sql_stmt = 'COMMENT ON COLUMN ' || :relation_name || '.' || :left_id_name || ' IS 
''Fremschlüssel aus der Tabelle ' || :left_relation_name || '''';
    execute statement sql_stmt;
    
    sql_stmt = 'COMMENT ON COLUMN ' || :relation_name || '.' || :right_id_name || ' IS 
''Fremschlüssel aus der Tabelle ' || :right_relation_name || '''';
    execute statement sql_stmt;
    
    if (do_create_primary_key = 1) then
    begin
      sql_stmt = 'ALTER TABLE ' || :relation_name || ' ADD CONSTRAINT PK_' || :relation_name || ' PRIMARY KEY (' || :left_id_name || ', ' || :right_id_name || ')';
      execute statement sql_stmt;
    end
    
    left_fk_relation_name = 'FK_REL_' || :short_relation_name || '_' || :left_relation_name;
    short_relation_name_counter = 0;
    while (exists(select 1 from RDB$RELATION_CONSTRAINTS where RDB$CONSTRAINT_NAME =:left_fk_relation_name)) do
    begin
      short_relation_name_counter = short_relation_name_counter + 1;  
      short_relation_name = short_relation_name || CAST(short_relation_name_counter AS varchar(4));
      left_fk_relation_name = 'FK_REL_' || :short_relation_name || '_' || :left_relation_name;
    end 
    
    sql_stmt = 'ALTER TABLE ' || :relation_name || ' ADD CONSTRAINT ' || :left_fk_relation_name || ' FOREIGN KEY (' || :left_id_name || ') REFERENCES ' || :left_relation_name || ' (ID) ON DELETE CASCADE ON UPDATE CASCADE';
    execute statement sql_stmt;
        
    right_fk_relation_name = 'FK_REL_' || :short_relation_name || '_' || :right_relation_name;
    short_relation_name_counter = 0;
    while (exists(select 1 from RDB$RELATION_CONSTRAINTS where RDB$CONSTRAINT_NAME =:right_fk_relation_name)) do
    begin
      short_relation_name_counter = short_relation_name_counter + 1;  
      short_relation_name = short_relation_name || CAST(short_relation_name_counter AS varchar(4));
      right_fk_relation_name = 'FK_REL_' || :short_relation_name || '_' || :right_relation_name;
    end
            
    sql_stmt = 'ALTER TABLE ' || :relation_name || ' ADD CONSTRAINT ' || :right_fk_relation_name || ' FOREIGN KEY (' || :right_id_name || ') REFERENCES ' || :right_relation_name || ' (ID) ON DELETE CASCADE ON UPDATE CASCADE';
    execute statement sql_stmt;

    sql_stmt = 'CREATE UNIQUE INDEX ALT_' || :left_relation_name || '_' || :right_relation_name || ' ON ' || :relation_name || ' (' || :left_id_name || ', ' || :right_id_name || ')';
    execute statement sql_stmt;  

    sql_stmt = 'COMMENT ON INDEX ALT_' || :left_relation_name || '_' || :right_relation_name || ' IS ''(created by SP_CREATE_RELATION_TABLE)''';
    execute statement sql_stmt;
  
    success = 1;
  end  

  suspend;
END^

COMMENT ON PROCEDURE SP_CREATE_RELATION_TABLE IS
'Legt eine Relation an'^

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_CREATE_RELATION_TABLE'^

CREATE OR ALTER PROCEDURE SP_CREATE_ZABRELATION (
  ALEFT_TABLENAME DBOBJECTNAME24,
  ARIGHT_TABLENAME DBOBJECTNAME24, 
  ADO_CREATE_PRIMARY_KEY BOOLEAN)
RETURNS (
  success smallint)  
AS
declare variable left_relation_name DBOBJECTNAME24;
declare variable right_relation_name DBOBJECTNAME24;
declare variable do_create_primary_key BOOLEAN;
declare variable relation_name DBOBJECTNAME32;
BEGIN
  left_relation_name = ALEFT_TABLENAME;
  right_relation_name = ARIGHT_TABLENAME;
  do_create_primary_key = ADO_CREATE_PRIMARY_KEY;

  /* Relation anlegen */
  select success, relation_name from SP_CREATE_RELATION_TABLE(:left_relation_name, :right_relation_name, :do_create_primary_key) into :success, :relation_name;
  
  /* Userview anlegen */
  if (success = 1) then
  begin
    select success from SP_CREATE_USER_VIEW(:relation_name) into :success;
  end
  
  /* Relationen haben keine Standardsequence und -trigger */

  suspend;
END^

COMMENT ON PROCEDURE SP_CREATE_ZABRELATION IS
'Legt eine Relation mit all seinen Datenbankobjekten an'^

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_CREATE_ZABRELATION'^

/* keine automatischen Grants vergeben da SP_CREATE_ALL_SIMPLE_INDEX nur bei der Installation angewendet werden soll */ 

CREATE OR ALTER PROCEDURE SP_CHK_DATA_BY_ADD_CATALOGITEM (
  ATENANT_ID integer,
  ADONOTDELETE smallint,
  ACATALOG VARCHAR(31), /* Plichtfeld */
  ACOUNTRY_ID integer, /* Pflichtfeld */
  ACAPTION  VARCHAR(254), /* Pflichtfeld */
  ADESC VARCHAR(2000))
returns (
    success smallint,
    code smallint,
    info varchar(2000))
as
begin 
  success = 0;
  code = 0;
  info = '{"result": null}';
  
  if (ATENANT_ID is null) then
  begin
    code = 1;
    info = '{"kind": 1, "publish": "NO_MANDATORY_MANDANT_ID_BY_NEWCATALOGITEM", "message": "NO_MANDATORY_MANDANT_ID"}';
    suspend;
    Exit;
  end
  else
  begin  
    if (not exists(select 1 from V_TENANT where ID=:ATENANT_ID)) then
    begin
      code = 1;
      info = '{"kind": 1, "publish": "NO_VALID_MANDANT_ID_BY_NEWCATALOGITEM", "message": "NO_VALID_MANDANT_ID"}';
      suspend;
      Exit;  
    end
  end

  if (ADONOTDELETE  not in (0,1)) then
  begin
    code = 1;
    info = '{"kind": 1, "publish": "NO_VALID_DONOTLOGIN_BY_NEWCATALOGITEM", "message": "NO_VALID_DONOTLOGIN"}';
    suspend;
    Exit;  
  end  

  if (ACATALOG is null) then
  begin
    code = 1;
    info = '{"kind": 1, "publish": "NO_MANDATORY_CATALOG_BY_NEWCATALOGITEM", "message": "NO_MANDATORY_CATALOG"}';
    suspend;
    Exit;    
  end
  else
  begin
    if (not exists(select 1 from V_ADM_CATALOGS where Upper(CAPTION)=Upper(:ACATALOG))) then
    begin
      code = 1;
      info = '{"kind": 1, "publish": "NO_CATALOGTABLE_BY_NEWCATALOGITEM", "message": "UNKNOWN_CATALOG"}';
      suspend;
      Exit;    
    end
  end
  
  if (ACOUNTRY_ID is null) then
  begin
    code = 1;
    info = '{"kind": 1, "publish": "NO_MANDATORY_COUNTRY_ID_BY_NEWCATALOGITEM", "message": "NO_MANDATORY_COUNTRY_ID"}';
    suspend;
    Exit;
  end
  else
  begin
    if (not exists(select 1 from V_COUNTRY where ID=:ACOUNTRY_ID)) then
    begin
      code = 1;
      info = '{"kind": 1, "publish": "NO_VALID_COUNTRY_ID_BY_NEWCATALOGITEM", "message": "NO_VALID_COUNTRY_ID"}';
      suspend;
      Exit;  
    end  
  end

  if ((ACAPTION is null) or (Trim(ACAPTION) = '')) then
  begin
    code = 1;
    info = '{"kind": 1, "publish": "NO_MANDATORY_CAPTION_BY_NEWCATALOGITEM", "message": "NO_MANDATORY_CAPTION"}';
    suspend;
    Exit;    
  end
  
  if ((ADESC is null) or (Trim(ADESC) = '')) then
  begin
    code = 1;
    info = '{"kind": 1, "publish": "NO_MANDATORY_DESCRIPTION_BY_NEWCATALOGITEM", "message": "NO_MANDATORY_DESCRIPTION"}';
    suspend;
    Exit;    
  end
  
  success = 1;
  
  suspend;
end^

COMMENT ON PROCEDURE SP_CHK_DATA_BY_ADD_CATALOGITEM IS
'Eingabedaten für einen Katalog überprüfen'^

CREATE OR ALTER PROCEDURE SP_INSERT_CATALOGITEM (
  ATENANTID integer,
  ADONOTDELETE smallint,
  ACATALOG VARCHAR(31), /* Plichtfeld */
  ACOUNTRYID integer, /* Pflichtfeld */
  ACAPTION  VARCHAR(254), /* Pflichtfeld */
  ADESC VARCHAR(2000))
returns (
    success smallint,
    "MESSAGE" varchar(254),
    catalog_item_id integer)
as
declare variable sql_stmt varchar(2000);
declare variable found smallint;
begin
  success = 0;
  message = 'FAILD_BY_UNKNOWN_REASON';
  catalog_item_id = -1;
  sql_stmt = '';
  found = 0;
  
  sql_stmt = 'select 1 from V_' || Upper(:ACATALOG) || ' where COUNTRY_ID=' || :ACOUNTRYID || ' and Upper(CAPTION)="' || Upper(ACAPTION) || '"';
  execute statement sql_stmt into :found;
  if (found = 1) then  
  begin
    message = 'DUPLICATE_CATALOGCAPTION_NOT_ALLOWED';
    suspend;
    Exit;      
  end
                        
  sql_stmt = 'execute procedure GET_' || Upper(:ACATALOG) || '_ID';
  execute statement sql_stmt into :catalog_item_id;                       

  if ((catalog_item_id <> -1) and (catalog_item_id is not null)) then
  begin
    sql_stmt = 'execute procedure SET_' 
      || Upper(:ACATALOG) 
      || ' (' 
      || :catalog_item_id 
      || ', ' 
      || :ACOUNTRYID 
      || ', ''' 
      || :ACAPTION 
      || ''', ''' 
      || :ADESC 
      || ''', '
      || :ADONOTDELETE
      || ')';
    execute statement sql_stmt into :success;

    if (success = 0) then
    begin
      message = 'INSERT_BY_SETTER_FAILD';
    end
    else
    begin
      message = '';
    end   
  end  
  else
  begin
    message = 'NO_VALID_USER_ID';
    success = 0;
    suspend;
    Exit;     
  end
  
  suspend;
end^

COMMENT ON PROCEDURE SP_INSERT_CATALOGITEM IS
'Katalogeintrag einfügen'^

CREATE OR ALTER PROCEDURE SP_ADDCATALOGITEM (
  ATENANTID integer,
  ADONOTDELETE smallint,
  ACATALOG VARCHAR(31), /* Plichtfeld */
  ACOUNTRYID integer, /* Pflichtfeld */
  ACAPTION  VARCHAR(254), /* Pflichtfeld */
  ADESC VARCHAR(2000))
RETURNS (
  success smallint,
  code smallint,
  info varchar(2000))
AS
declare variable msg varchar(254);
declare variable catalog_item_id integer;
begin
  success = 0;
  code = 0;
  info = '{"result": null}';
  
  /* Es werden alle Pflichtfelder überprüft */
  select
    success, 
    code, 
    info 
  from 
    SP_CHK_DATA_BY_ADD_CATALOGITEM(:ATENANTID,
      :ADONOTDELETE,
      :ACATALOG,
      :ACOUNTRYID,
      :ACAPTION,
      :ADESC) 
  into 
    :success, 
    :code, 
    :info;

  if (success = 1) then
  begin
    success = 0;
    code = 0;
    info = '{"result": null}';
    
    select
      success,
      message,
      catalog_item_id      
    from
      SP_INSERT_CATALOGITEM(:ATENANTID,
        :ADONOTDELETE,
        :ACATALOG,
        :ACOUNTRYID,
        :ACAPTION,
        :ADESC)
    into
      :success,
      :msg,
      :catalog_item_id;
      
    /* Rückgabe auswerten */     
    if (success = 0) then
    begin
      code = 1;
      info = '{"kind": 2, "publish": "INSERT_BY_CATALOGITEM_FAILD_BY_NEWCATLOGITEM", "list": [{"message": "INSERT_BY_CATALOGITEM_FAILD"}, {"message": "' || :msg || '"}]}';
      suspend;
      Exit;
    end
    
    /* success = 1; -> success sollte nur durch die Insert-SPs auf 1 gesetzt werden */
    code = 1;
    if (success = 1) then
    begin
      info = '{"kind": 3, "publish": "ADD_CATALOGITEM_SUCCEEDED", "message": "ADD_CATALOGITEM_SUCCEEDED"}';
    end  
    else
    begin
      success = 0;
      info = '{"kind": 1, "publish": "FAILD_BY_OBSCURE_PROCESSING", "message": "FAILD_BY_OBSCURE_PROCESSING"}';
    end                                   
  end  

  suspend;  
end
^

COMMENT ON PROCEDURE SP_ADDCATALOGITEM IS
'Überprüft Eingaben und legt Katalogeintrag an'^

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_ADD_SP_ADDCATALOGITEM'^

CREATE OR ALTER PROCEDURE SP_ADDCATALOGITEM_BY_SRV (
  ASESSION_ID VARCHAR(128),
  AUSERNAME VARCHAR(256),
  AIP VARCHAR(64),
  ATENANT_ID integer,
  ADONOTDELETE smallint,
  ACATALOG VARCHAR(31), /* Plichtfeld */
  ACOUNTRY_ID integer, /* Pflichtfeld */
  ACAPTION  VARCHAR(254), /* Pflichtfeld */
  ADESC VARCHAR(2000))
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
    select success from SP_CHECKGRANT(:AUSERNAME, 'REFERENCE_DATA') into :success_by_grant;
    
    if (success_by_grant = 1) then
    begin
      /* Wenn der JSON-String im Feld INFO zu lang wird, wird von der SP zwei oder mehrere Datensätze erzeugt.
         Aus diesem Grund wird die SP über eine FOR-Loop abgefragt
      */
      for 
      select 
        success, 
        code, 
        info 
      from 
        SP_ADDCATALOGITEM (:ATENANT_ID,
          :ADONOTDELETE,
          :ACATALOG,
          :ACOUNTRY_ID,
          :ACAPTION,
          :ADESC) 
      into 
        :success, 
        :code, 
        :info 
      do
      begin
        suspend;
      end 
    end
    else
    begin
      info = '{"kind": 1, "publish": "NO_GRANT_FOR_ADD_CATALOGITEM", "message": "NO_GRANT_FOR_ADD_CATALOGITEM"}';
      
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

COMMENT ON PROCEDURE SP_ADDCATALOGITEM_BY_SRV IS
'Überprüft Sitzungsverwaltung und ruft SP_ADDCATALOGITEM auf'^

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_ADDCATALOGITEM_BY_SRV'^

SET TERM ; ^

COMMIT WORK;
/******************************************************************************/
/*                                 Zirkuläre Verbinungen auflösen                                  
/******************************************************************************/

SET TERM ^ ;

/* Da SP_READINTEGER zum Zeitpunkt der ersten Declarierung von SP_TOUCHSESSION noch nicht bekannt ist,
   SP_TOUCHSESSION aber noch vor der Declarierung von SP_READINTEGER bekannt sein muss, 
   wird hier die SP_TOUCHSESSION um den Aufruf von SP_READINTEGER ergänzt */
     
CREATE OR ALTER PROCEDURE SP_TOUCHSESSION (
  ASESSIONID VARCHAR(128),
  AUSERNAME VARCHAR(256),
  AIP VARCHAR(64),
  ABYREGSESSION smallint = 0)
RETURNS (
  success smallint)  
AS
declare variable user_id integer;
declare variable tenant_id integer;
declare variable expire_date date;
declare variable last_reviewed time;
declare variable allow_login smallint;
declare variable session_idle_time integer;
declare variable session_lifetime integer;
declare variable do_register_closed_session smallint;
begin
  success = 0;       
  expire_date = null;
  last_reviewed = null;
  user_id = 0;
  do_register_closed_session = 0;
  
  select ID, TENANT_ID, ALLOW_LOGIN from V_USERS where USERNAME=:AUSERNAME into :user_id, :tenant_id, :allow_login;
  
  if ((user_id > 0) and (allow_login = 1)) then
  begin 
    if (exists(select 1 from V_SESSION where SESSION_ID=:ASESSIONID and USER_ID=:user_id and CLOSED=0)) then
    begin    
      select EXPIRY_DATE, LAST_REVIEWED from V_SESSION where SESSION_ID=:ASESSIONID and USER_ID=:user_id into :expire_date, :last_reviewed;
      select SESSION_IDLE_TIME, SESSION_LIFETIME from V_TENANT where ID=:tenant_id into :session_idle_time, :session_lifetime;
      
      if ((current_time - last_reviewed) > (session_idle_time*60)) then
      begin
        success = 0;
        
        EXCEPTION SESSION_IDLE_TIMEOUT;
        
        suspend;      
      end
      
      if ((current_date - expire_date) >= session_lifetime) then
      begin
        success = 0; 
      
        EXCEPTION SESSION_LIFETIME_TIMEOUT;
        
        suspend;
      end
        
      update
        V_SESSION
      set
        LAST_REVIEWED=current_timestamp
      where
        SESSION_ID=:ASESSIONID
      and
        USER_ID=:user_id;
        
      success = 1;  
    end
    else
    begin
      if (exists(select 1 from V_SESSION where SESSION_ID=:ASESSIONID and CLOSED=0)) then
      begin
        success = 0;
        
        EXCEPTION INVALID_SESSION_DATA;
        
        suspend;      
      end
      else
      begin    
        if (ABYREGSESSION = 1) then
        begin
          select result from SP_READINTEGER('GENERAL', 'SP_TOUCHSESSION', 'DO_REGISTER_CLOSED_SESSION', 0) into :do_register_closed_session;
          
          if (do_register_closed_session = 1) then
          begin
            expire_date = current_date + 1;
            last_reviewed = current_timestamp;
            
            if (exists(select 1 from V_SESSION where SESSION_ID=:ASESSIONID and USER_ID=:user_id and CLOSED=1)) then
            begin
              update
                V_SESSION
              set
                EXPIRY_DATE = :expire_date,
                LAST_REVIEWED = :last_reviewed,
                CLOSED = 0
              where
                SESSION_ID=:ASESSIONID 
              and 
                USER_ID=:user_id 
              and 
                CLOSED=1;
              
              success = 1;  
            end
            else
            begin            
              insert
              into
              V_SESSION (
                USER_ID,
                SESSION_ID,       
                EXPIRY_DATE,
                LAST_REVIEWED,
                IP)
              values (
                :user_id,
                :ASESSIONID,
                :expire_date,
                :last_reviewed,
                :AIP
              );
              
              success = 1;
            end                    
          end
          else
          begin
            success = 0;
            
            EXCEPTION INVALID_SESSION_DATA;
            
            suspend;        
          end
        end
        else
        begin
          success = 0;
          
          EXCEPTION INVALID_SESSION_DATA;
          
          suspend;
        end
      end         
    end
  end
  else
  begin 
    if ((user_id < 1) or (user_id is null)) then
    begin
      success = 0;
      
      EXCEPTION UNKNOWN_USDERID;
      
      suspend; 
    end
    
    if ((allow_login <> 1) or (allow_login is null)) then
    begin
      success = 0;
      
      EXCEPTION NO_LOGIN_ALLOWED;
      
      suspend;     
    end 
    
    EXCEPTION CANCEL_BY_UNKNOWN_REASON; 
  end
  
  suspend;
end^

SET TERM ; ^

COMMIT WORK;
/******************************************************************************/
/*                                 Grants                                 
/******************************************************************************/

/* Users */
GRANT R_WEBCONNECT TO WEBCONNECT;
GRANT R_ZABGUEST TO WEBCONNECT;

/* Views */

/* Tables */

/* SPs */
GRANT SELECT ON V_REGISTRY TO PROCEDURE SP_READFLOAT;
GRANT SELECT ON V_REGISTRY TO PROCEDURE SP_READINTEGER;
GRANT SELECT ON V_REGISTRY TO PROCEDURE SP_READSECTION;
GRANT SELECT ON V_REGISTRY TO PROCEDURE SP_READSECTIONS;
GRANT SELECT ON V_REGISTRY TO PROCEDURE SP_READSTRING;
GRANT SELECT, INSERT, UPDATE ON V_REGISTRY TO PROCEDURE SP_WRITEFLOAT;
GRANT SELECT, INSERT, UPDATE ON V_REGISTRY TO PROCEDURE SP_WRITEINTEGER;
GRANT SELECT, INSERT, UPDATE ON V_REGISTRY TO PROCEDURE SP_WRITESTRING;
GRANT EXECUTE ON PROCEDURE SP_READSTRING TO PROCEDURE SP_DBVERSION;
GRANT EXECUTE ON PROCEDURE SP_READINTEGER TO PROCEDURE SP_DBVERSION;

GRANT SELECT ON V_UPDATEHISTORY TO PROCEDURE SP_DBVERSION;
GRANT EXECUTE ON PROCEDURE SP_DBVERSION TO PROCEDURE SP_GET_DBVERSION;

GRANT SELECT ON V_TENANT TO PROCEDURE SP_TOUCHSESSION;
GRANT SELECT ON V_USERS TO PROCEDURE SP_TOUCHSESSION;
GRANT SELECT, INSERT, UPDATE on V_SESSION TO PROCEDURE SP_TOUCHSESSION;
GRANT EXECUTE ON PROCEDURE SP_READINTEGER TO PROCEDURE SP_TOUCHSESSION; 

GRANT SELECT ON V_USERS TO PROCEDURE SP_REGISTERSESSION;
GRANT SELECT, INSERT, UPDATE on V_SESSION TO PROCEDURE SP_REGISTERSESSION;
GRANT EXECUTE ON PROCEDURE SP_TOUCHSESSION TO PROCEDURE SP_REGISTERSESSION;

GRANT SELECT ON V_USERS TO PROCEDURE SP_CLOSESESSION; 
GRANT SELECT, INSERT, UPDATE on V_SESSION TO PROCEDURE SP_CLOSESESSION;
GRANT EXECUTE ON PROCEDURE SP_TOUCHSESSION TO PROCEDURE SP_CLOSESESSION;
GRANT EXECUTE ON PROCEDURE SP_CHECKGRANT TO PROCEDURE SP_CLOSESESSION;

GRANT EXECUTE ON PROCEDURE SP_TOUCHSESSION TO PROCEDURE SP_READFLOAT_BY_SRV;
GRANT EXECUTE ON PROCEDURE SP_READFLOAT TO PROCEDURE SP_READFLOAT_BY_SRV;

GRANT EXECUTE ON PROCEDURE SP_TOUCHSESSION TO PROCEDURE SP_READINTEGER_BY_SRV;
GRANT EXECUTE ON PROCEDURE SP_READINTEGER TO PROCEDURE SP_READINTEGER_BY_SRV;

GRANT EXECUTE ON PROCEDURE SP_TOUCHSESSION TO PROCEDURE SP_READSTRING_BY_SRV;
GRANT EXECUTE ON PROCEDURE SP_READSTRING TO PROCEDURE SP_READSTRING_BY_SRV;

GRANT EXECUTE ON PROCEDURE SP_TOUCHSESSION TO PROCEDURE SP_WRITEFLOAT_BY_SRV;
GRANT EXECUTE ON PROCEDURE SP_WRITEFLOAT TO PROCEDURE SP_WRITEFLOAT_BY_SRV;

GRANT EXECUTE ON PROCEDURE SP_TOUCHSESSION TO PROCEDURE SP_WRITEINTEGER_BY_SRV;
GRANT EXECUTE ON PROCEDURE SP_WRITEINTEGER TO PROCEDURE SP_WRITEINTEGER_BY_SRV;

GRANT EXECUTE ON PROCEDURE SP_TOUCHSESSION TO PROCEDURE SP_WRITESTRING_BY_SRV;
GRANT EXECUTE ON PROCEDURE SP_WRITESTRING TO PROCEDURE SP_WRITESTRING_BY_SRV;

GRANT EXECUTE ON PROCEDURE SP_TOUCHSESSION TO PROCEDURE SP_READSECTION_BY_SRV;
GRANT SELECT ON V_REGISTRY TO PROCEDURE SP_READSECTION_BY_SRV;

GRANT EXECUTE ON PROCEDURE SP_TOUCHSESSION TO PROCEDURE SP_READSECTIONS_BY_SRV;
GRANT SELECT ON V_REGISTRY TO PROCEDURE SP_READSECTIONS_BY_SRV;

GRANT EXECUTE ON PROCEDURE SP_TOUCHSESSION TO PROCEDURE SP_CHECKGRANT_BY_SVR;
GRANT EXECUTE ON PROCEDURE SP_CHECKGRANT TO PROCEDURE SP_CHECKGRANT_BY_SVR;
GRANT SELECT ON V_ROLES TO PROCEDURE SP_CHECKGRANT;

  
GRANT EXECUTE ON PROCEDURE SP_TOUCHSESSION TO PROCEDURE SP_ADDCATALOGITEM_BY_SRV;
GRANT EXECUTE ON PROCEDURE SP_CHECKGRANT TO PROCEDURE SP_ADDCATALOGITEM_BY_SRV;
GRANT EXECUTE ON PROCEDURE SP_ADDCATALOGITEM TO PROCEDURE SP_ADDCATALOGITEM_BY_SRV;

GRANT EXECUTE ON PROCEDURE SP_CHK_DATA_BY_ADD_CATALOGITEM TO PROCEDURE SP_ADDCATALOGITEM;
GRANT EXECUTE ON PROCEDURE SP_INSERT_CATALOGITEM TO PROCEDURE SP_ADDCATALOGITEM;

GRANT EXECUTE ON PROCEDURE SP_CREATE_SEQUENCE_GETTER TO PROCEDURE SP_CREATE_ZABCATALOG;
GRANT EXECUTE ON PROCEDURE SP_CREATE_CATALOG_SETTER TO PROCEDURE SP_CREATE_ZABCATALOG;


/* Roles */
/* zusätzliche Rechte um Zugriff auf das Sessionmanagement zu erlangen */
GRANT UPDATE, INSERT ON V_SESSION TO R_ZABGUEST;

COMMIT WORK;
/******************************************************************************/
/*                   Erst jetzt stehen ZABCATALOGE zur Verfügung
/******************************************************************************/

/* Katalog: JSON_KIND komplett über SP erstellen */
execute procedure SP_CREATE_ZABCATALOG 'JSON_KIND';

COMMIT WORK;
/******************************************************************************/
/*                                 Input                                  
/******************************************************************************/

input 'data_0001.sql';

COMMIT WORK;
/******************************************************************************/
/******************************************************************************/
/******************************************************************************/
