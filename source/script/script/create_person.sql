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
/*          Personendaten erstellen
/*          2014-04-05
/*          Scripte auf ISQL optimiert
/******************************************************************************/
SET SQL DIALECT 3;

SET NAMES WIN1252;

SET AUTODDL;

/* An dieser Stelle muss die IP, der Datenbankpfad, Name der Datanbank sowie Benutzerinformationen (User/Password) überführt werden */
CONNECT '127.0.0.1:ZABONLINEEMBEDDED' USER 'SYSDBA' PASSWORD 'masterkey'; 
/******************************************************************************/
/*                                 Insert into OMEGA$UPDATEHISTORY                                  
/******************************************************************************/

SET TERM ^ ; /* definiert den Begin eines Ausführungsblockes */
EXECUTE BLOCK AS
DECLARE number varchar(2000);
DECLARE subitem varchar(2000);
DECLARE script varchar(255);
DECLARE description varchar(2000);
BEGIN
  number = '1';
  subitem = '0';
  script = 'create_person.sql';
  description = 'Personendaten erstellen';
  
  if (exists(select 1 from RDB$RELATIONS where RDB$RELATION_NAME='UPDATEHISTORY')) then
  begin   
    execute statement 'INSERT INTO UPDATEHISTORY(NUMBER, SUBITEM, SCRIPT, DESCRIPTION) VALUES ( ''' || :number ||''', ''' || :subitem ||''', ''' || :script || ''', ''' || :description || ''');';
  end  

END^        
SET TERM ; ^ /* definiert das Ende eines Ausführungsblockes */

COMMIT WORK;
/******************************************************************************/
/*                                  Domains                                   
/******************************************************************************/

CREATE DOMAIN PERSONNUMBER AS
VARCHAR(64);

COMMENT ON DOMAIN PERSONNUMBER IS
'Personennummer';

CREATE DOMAIN LABEL AS
VARCHAR(64)
DEFAULT 'UNKNOWN'
NOT NULL
CHECK (VALUE IN ('UNKNOWN', 
'GENERAL', 
'CALCULATE',
'FIELDDEF',
'ACCOUNTING', 
'PERSON_DATA',
'FACTORY_DATA',
'CONTACT_DATA',
'ADDRESS_DATA',
'FIND'));

COMMENT ON DOMAIN LABEL IS
'Kennzeichnungen für die Gruppierung in diversen Tabellen';

CREATE DOMAIN MIME_TYPE AS
VARCHAR(254);
/*NOT NULL;*/

COMMENT ON DOMAIN MIME_TYPE IS
'Mimetype nach RFC 2046';

CREATE DOMAIN MIME_SUBTYPE AS
VARCHAR(254);
/*NOT NULL;*/

COMMENT ON DOMAIN MIME_SUBTYPE IS
'Subtype nach RFC 2046';

CREATE DOMAIN ACCESS_MODE AS
VARCHAR(64)
NOT NULL
CHECK (VALUE IN ('UNKNOWN', 'INSERT', 'UPDATE', 'DELETE'));

COMMENT ON DOMAIN ACCESS_MODE IS
'UNKNOWN=unbekannt / INSERT=Einfügen / UPDATE=Aktualisieren / DELETE=Löschen';

CREATE DOMAIN RELATION_TYPE AS
VARCHAR(32)
DEFAULT 'UNKNOWN'
NOT NULL
CHECK (VALUE IN ('UNKNOWN', 'BY_PERSON'));

COMMENT ON DOMAIN RELATION_TYPE IS
'UNKNOWN=unbekannt / BY_PERSON=Bezug zur Person';

CREATE DOMAIN UNIQUE_NAME AS
VARCHAR(254);

COMMENT ON DOMAIN UNIQUE_NAME IS
'Eindeutiger Name vom System ermittel';

COMMIT WORK;
/******************************************************************************/
/*                                 Sequences                                  
/******************************************************************************/

/* Standardsequences werden druch die SP: SP_CREATE_SEQUENCE erstellt */

/* Sequence für den eindeutigen Namen anlegen */
CREATE SEQUENCE SEQ_UNIQUENAME_IDX;
ALTER SEQUENCE SEQ_UNIQUENAME_IDX RESTART WITH 0;
COMMENT ON SEQUENCE SEQ_UNIQUENAME_IDX IS 'Eindeutiger Index für die Namenserweiterung von eindeutigen Namen eines Dokumentes';
  
COMMIT WORK;
/******************************************************************************/
/*                                   Tables                                   
/******************************************************************************/

CREATE TABLE DOCUMENT (
  ID               INTEGER NOT NULL,
  TENANT_ID        INTEGER NOT NULL,    
  TAG_ID           INTEGER,    
  UNIQUE_NAME      VARCHAR(254) NOT NULL UNIQUE,
  REAL_NAME        VARCHAR(254) NOT NULL,
  MIME_TYPE        MIME_TYPE,
  MIME_SUBTYPE     MIME_SUBTYPE,
  DATA_OBJECT      BLOB SUB_TYPE 0 SEGMENT SIZE 16384,    
  DESCRIPTION      VARCHAR(2000),
  SOFTDEL          DN_BOOLEAN,    
  CRE_USER         VARCHAR(32) NOT NULL,
  CRE_DATE         TIMESTAMP NOT NULL,
  CHG_USER         VARCHAR(32),
  CHG_DATE         TIMESTAMP           
);

COMMENT ON TABLE DOCUMENT IS
'Binärdaten (Dokumente/Bilder/etc.)'; 

COMMENT ON COLUMN DOCUMENT.ID IS
'Primärschlüssel';

COMMENT ON COLUMN DOCUMENT.TENANT_ID IS
'Fremdschlüssel Mandant';

COMMENT ON COLUMN DOCUMENT.TAG_ID IS
'Fremdschlüssel für Tags';

COMMENT ON COLUMN DOCUMENT.UNIQUE_NAME IS
'Eindeutiger Name des Dokumentes';

COMMENT ON COLUMN DOCUMENT.REAL_NAME IS
'Echter Name';

COMMENT ON COLUMN DOCUMENT.MIME_TYPE IS
'Mimetype nach RFC 2046';

COMMENT ON COLUMN DOCUMENT.MIME_SUBTYPE IS
'Subtype nach RFC 2046';
    
COMMENT ON COLUMN DOCUMENT.DATA_OBJECT IS
'Binärdaten';

COMMENT ON COLUMN DOCUMENT.DESCRIPTION IS
'Dokumentenbschreibung'; 

COMMENT ON COLUMN DOCUMENT.SOFTDEL IS
'Löschflag';

COMMENT ON COLUMN DOCUMENT.CRE_USER IS
'Erstellt von';

COMMENT ON COLUMN DOCUMENT.CRE_DATE IS
'Erstellt am';

COMMENT ON COLUMN DOCUMENT.CHG_USER IS
'Geändert von';

COMMENT ON COLUMN DOCUMENT.CHG_DATE IS
'Geändert am';
/* Das Erstellen von Tabellen immer committen */
COMMIT WORK;

/* Userview anlegen */
execute procedure SP_CREATE_USER_VIEW 'DOCUMENT';
/* Sequence anlegen */
execute procedure SP_CREATE_SEQUNECE 'DOCUMENT';
/* Trigger anlegen */
execute procedure SP_CREATE_TRIGGER_BI 'DOCUMENT';
execute procedure SP_CREATE_TRIGGER_BU 'DOCUMENT';

CREATE TABLE PERSON (
  ID                         INTEGER NOT NULL,
  TENANT_ID                  INTEGER NOT NULL,    
  TAG_ID                     INTEGER,
  MARRIED_TO_ID              INTEGER,
  TITEL_ID                   INTEGER NOT NULL,
  SALUTATION_ID              INTEGER NOT NULL,
  PICTURE_ID                 INTEGER,
  PERSONNUMBER               PERSONNUMBER,
  FIRSTNAME                  VARCHAR(126),
  NAME1                      VARCHAR(126) NOT NULL,
  NAME2                      VARCHAR(126),
  NAME3                      VARCHAR(126),
  IS_MARRIED                 DN_BOOLEAN, 
  MARRIED_SINCE              DATE,
  MARRIAGE_PARTNER_FIRSTNAME VARCHAR(126),
  MARRIAGE_PARTNER_NAME1     VARCHAR(126),
  SALUTATION1                VARCHAR(126),
  SALUTATION2                VARCHAR(126),
  DAY_OF_BIRTH               DATE, 
  ISPRIVATE                  DN_BOOLEAN,     
  DESCRIPTION                BLOB SUB_TYPE TEXT SEGMENT SIZE 16384,
  SOFTDEL                    DN_BOOLEAN,    
  CRE_USER                   VARCHAR(32) NOT NULL,
  CRE_DATE                   TIMESTAMP NOT NULL,
  CHG_USER                   VARCHAR(32),
  CHG_DATE                   TIMESTAMP
);

COMMENT ON TABLE PERSON IS
'Personendaten'; 

COMMENT ON COLUMN PERSON.ID IS
'Primärschlüssel';

COMMENT ON COLUMN PERSON.TENANT_ID IS
'Fremdschlüssel Mandant';

COMMENT ON COLUMN PERSON.TAG_ID IS
'Fremdschlüssel für Tags';

COMMENT ON COLUMN PERSON.SALUTATION_ID IS
'Fremdschlüssel für Standardanreden'; 

COMMENT ON COLUMN PERSON.MARRIED_TO_ID IS
'Fremdschlüssel für Personendaten (für Ehepartner)';

COMMENT ON COLUMN PERSON.TITEL_ID IS
'Fremdschlüssel für Titel)';

COMMENT ON COLUMN PERSON.PICTURE_ID IS
'Fremdschlüssel zu einem Bild'; 

COMMENT ON COLUMN PERSON.PERSONNUMBER IS
'Personennummer'; 

COMMENT ON COLUMN PERSON.FIRSTNAME IS
'Vorname'; 

COMMENT ON COLUMN PERSON.NAME1 IS
'Name'; 

COMMENT ON COLUMN PERSON.NAME2 IS
'Name'; 

COMMENT ON COLUMN PERSON.NAME3 IS
'Name'; 

COMMENT ON COLUMN PERSON.IS_MARRIED IS
'Verheiratet'; 
 
COMMENT ON COLUMN PERSON.MARRIED_SINCE IS
'Verheiratet seit'; 

COMMENT ON COLUMN PERSON.MARRIAGE_PARTNER_FIRSTNAME IS
'Vorname Ehepartner'; 

COMMENT ON COLUMN PERSON.MARRIAGE_PARTNER_NAME1 IS
'Name Ehepartner'; 

COMMENT ON COLUMN PERSON.SALUTATION1 IS
'Anrede'; 

COMMENT ON COLUMN PERSON.SALUTATION2 IS
'Anrede'; 

COMMENT ON COLUMN PERSON.DAY_OF_BIRTH IS
'Geburtstag'; 
 
COMMENT ON COLUMN PERSON.ISPRIVATE IS
'Ist Privat'; 
 
COMMENT ON COLUMN PERSON.DESCRIPTION IS
'Presonenbschreibung'; 

COMMENT ON COLUMN PERSON.SOFTDEL IS
'Löschflag';

COMMENT ON COLUMN PERSON.CRE_USER IS
'Erstellt von';

COMMENT ON COLUMN PERSON.CRE_DATE IS
'Erstellt am';

COMMENT ON COLUMN PERSON.CHG_USER IS
'Geändert von';

COMMENT ON COLUMN PERSON.CHG_DATE IS
'Geändert am';
/* Das Erstellen von Tabellen immer committen */
COMMIT WORK;

/* Userview anlegen */
execute procedure SP_CREATE_USER_VIEW 'PERSON';
/* Sequence anlegen */
execute procedure SP_CREATE_SEQUNECE 'PERSON';
/* Trigger anlegen */
execute procedure SP_CREATE_TRIGGER_BI 'PERSON';
execute procedure SP_CREATE_TRIGGER_BU 'PERSON';

/* Katalog: TITEL komplett über SP erstellen */
execute procedure SP_CREATE_ZABCATALOG 'TITEL';
/* Das Erstellen von Tabellen immer committen */
COMMIT WORK;

/* Katalog: SALUTATION komplett über SP erstellen */
execute procedure SP_CREATE_ZABCATALOG 'SALUTATION';
/* Das Erstellen von Tabellen immer committen */
COMMIT WORK;

CREATE TABLE CONTACT (
  ID               INTEGER NOT NULL,
  TENANT_ID        INTEGER NOT NULL, 
  CONTACT_TYPE_ID  INTEGER NOT NULL,      
  TAG_ID           INTEGER,
  AREA_CODE        VARCHAR(5),
  PHONE            INTEGER,
  PHONE_FMT        VARCHAR(127),
  FAX              INTEGER,
  FAX_FMT          VARCHAR(127),
  WWW              VARCHAR(254),
  EMAIL            VARCHAR(254), 
  SKYPE            VARCHAR(32),
  MESSANGERNAME    VARCHAR(32),
  SOFTDEL          DN_BOOLEAN,    
  CRE_USER         VARCHAR(32) NOT NULL,
  CRE_DATE         TIMESTAMP NOT NULL,
  CHG_USER         VARCHAR(32),
  CHG_DATE         TIMESTAMP    
);

COMMENT ON TABLE CONTACT IS
'Kontaktdaten'; 

COMMENT ON COLUMN CONTACT.ID IS
'Primärschlüssel';

COMMENT ON COLUMN CONTACT.TENANT_ID IS
'Fremdschlüssel Mandant';

COMMENT ON COLUMN CONTACT.CONTACT_TYPE_ID IS
'Fremdschlüssel für einen Standardkontakttyp';

COMMENT ON COLUMN CONTACT.TAG_ID IS
'Fremdschlüssel für Tags';

COMMENT ON COLUMN CONTACT.AREA_CODE IS
'Internationale Vorwahl (z. B.: +49)';

COMMENT ON COLUMN CONTACT.PHONE IS
'Telefonnummer als numerischer Wert';

COMMENT ON COLUMN CONTACT.PHONE_FMT IS
'Telefonnummer fomatiert als Zeichenkette';

COMMENT ON COLUMN CONTACT.FAX IS
'Faxnummer als numerischer Wert';

COMMENT ON COLUMN CONTACT.FAX_FMT IS
'Faxnummer formatiert als Zeichenkette';

COMMENT ON COLUMN CONTACT.WWW IS
'URL';

COMMENT ON COLUMN CONTACT.EMAIL IS
'Mailadresse';
 
COMMENT ON COLUMN CONTACT.SKYPE IS
'Skypename';

COMMENT ON COLUMN CONTACT.MESSANGERNAME IS
'Messangername';

COMMENT ON COLUMN CONTACT.SOFTDEL IS
'Löschflag';

COMMENT ON COLUMN CONTACT.CRE_USER IS
'Erstellt von';

COMMENT ON COLUMN CONTACT.CRE_DATE IS
'Erstellt am';

COMMENT ON COLUMN CONTACT.CHG_USER IS
'Geändert von';

COMMENT ON COLUMN CONTACT.CHG_DATE IS
'Geändert am';
/* Das Erstellen von Tabellen immer committen */
COMMIT WORK;

/* Userview anlegen */
execute procedure SP_CREATE_USER_VIEW 'CONTACT';
/* Sequence anlegen */
execute procedure SP_CREATE_SEQUNECE 'CONTACT';
/* Trigger anlegen */
execute procedure SP_CREATE_TRIGGER_BI 'CONTACT';
execute procedure SP_CREATE_TRIGGER_BU 'CONTACT';

/* Katalog: CONTACT_TYPE komplett über SP erstellen */
execute procedure SP_CREATE_ZABCATALOG 'CONTACT_TYPE';
/* Das Erstellen von Tabellen immer committen */
COMMIT WORK;

CREATE TABLE ADDRESS (
  ID                  INTEGER NOT NULL,
  TENANT_ID           INTEGER NOT NULL,
  ADDRESS_TYPE_ID     INTEGER NOT NULL,
  TAG_ID              INTEGER,        
  STREET              VARCHAR(254),
  STREET_ADDRESS_FROM VARCHAR(127),
  STREET_ADDRESS_TO   VARCHAR(127),
  CITY                VARCHAR(254) NOT NULL,
  DISTRICT            VARCHAR(254),
  ZIPCODE             INTEGER, 
  POST_OFFICE_BOX     VARCHAR(254),
  ISPOSTADDRESS       DN_BOOLEAN,
  ISPRIVATE           DN_BOOLEAN,        
  SOFTDEL             DN_BOOLEAN,    
  CRE_USER            VARCHAR(32) NOT NULL,
  CRE_DATE            TIMESTAMP NOT NULL,
  CHG_USER            VARCHAR(32),
  CHG_DATE            TIMESTAMP    
);

COMMENT ON TABLE ADDRESS IS
'Adressdaten'; 

COMMENT ON COLUMN ADDRESS.ID IS
'Primärschlüssel';

COMMENT ON COLUMN ADDRESS.TENANT_ID IS
'Fremdschlüssel Mandant';

COMMENT ON COLUMN ADDRESS.ADDRESS_TYPE_ID IS
'Fremdschlüssel für einen Adresstyp';

COMMENT ON COLUMN ADDRESS.TAG_ID IS
'Fremdschlüssel für Tags';

COMMENT ON COLUMN ADDRESS.STREET IS
'Straßenname';

COMMENT ON COLUMN ADDRESS.STREET_ADDRESS_FROM IS
'Hausnummer von';

COMMENT ON COLUMN ADDRESS.STREET_ADDRESS_TO IS
'Hausnummer bis';

COMMENT ON COLUMN ADDRESS.CITY IS
'Stadt';

COMMENT ON COLUMN ADDRESS.DISTRICT IS
'Ortsteil';

COMMENT ON COLUMN ADDRESS.ZIPCODE IS
'PLZ';
 
COMMENT ON COLUMN ADDRESS.POST_OFFICE_BOX IS
'Postfach';

COMMENT ON COLUMN ADDRESS.ISPOSTADDRESS IS
'Ist Postanschrift';

COMMENT ON COLUMN ADDRESS.ISPRIVATE IS
'Ist Privat';

COMMENT ON COLUMN ADDRESS.SOFTDEL IS
'Löschflag';

COMMENT ON COLUMN ADDRESS.CRE_USER IS
'Erstellt von';

COMMENT ON COLUMN ADDRESS.CRE_DATE IS
'Erstellt am';

COMMENT ON COLUMN ADDRESS.CHG_USER IS
'Geändert von';

COMMENT ON COLUMN ADDRESS.CHG_DATE IS
'Geändert am';
/* Das Erstellen von Tabellen immer committen */
COMMIT WORK;

/* Userview anlegen */
execute procedure SP_CREATE_USER_VIEW 'ADDRESS';
/* Sequence anlegen */
execute procedure SP_CREATE_SEQUNECE 'ADDRESS';
/* Trigger anlegen */
execute procedure SP_CREATE_TRIGGER_BI 'ADDRESS';
execute procedure SP_CREATE_TRIGGER_BU 'ADDRESS';

/* Katalog: ADDRESS_TYPE komplett über SP erstellen */
execute procedure SP_CREATE_ZABCATALOG 'ADDRESS_TYPE';
/* Das Erstellen von Tabellen immer committen */
COMMIT WORK;

CREATE TABLE BANK (
  ID           INTEGER NOT NULL,
  TENANT_ID    INTEGER NOT NULL,
  TAG_ID       INTEGER,
  CAPTION      VARCHAR(254),
  BLZ          INTEGER,
  BLZ_FMT      VARCHAR(10),       
  KTO          INTEGER,
  KTO_FMT      VARCHAR(10),
  IBAN         VARCHAR(30),
  BIC          VARCHAR(11),
  SOFTDEL      DN_BOOLEAN,    
  CRE_USER     VARCHAR(32) NOT NULL,
  CRE_DATE     TIMESTAMP NOT NULL,
  CHG_USER     VARCHAR(32),
  CHG_DATE     TIMESTAMP
);

COMMENT ON TABLE BANK IS
'Bankdaten'; 

COMMENT ON COLUMN BANK.TENANT_ID IS
'Fremdschlüssel Mandant';

COMMENT ON COLUMN BANK.ID IS
'Primärschlüssel';

COMMENT ON COLUMN BANK.TAG_ID IS
'Fremdschlüssel für Tags';

COMMENT ON COLUMN BANK.CAPTION IS
'Kontoinhaber';

COMMENT ON COLUMN BANK.BLZ IS
'Bankleitzahl';

COMMENT ON COLUMN BANK.BLZ_FMT IS
'Bankleitzahl formatiert';

COMMENT ON COLUMN BANK.KTO IS
'Kontonummer';

COMMENT ON COLUMN BANK.KTO_FMT IS
'Kontonummer formatier';

COMMENT ON COLUMN BANK.IBAN IS
'Weltweit gültige Kontonummer';

COMMENT ON COLUMN BANK.BIC IS
'Bank Identifier Code';

COMMENT ON COLUMN BANK.SOFTDEL IS
'Löschflag';

COMMENT ON COLUMN BANK.CRE_USER IS
'Erstellt von';

COMMENT ON COLUMN BANK.CRE_DATE IS
'Erstellt am';

COMMENT ON COLUMN BANK.CHG_USER IS
'Geändert von';

COMMENT ON COLUMN BANK.CHG_DATE IS
'Geändert am';
/* Das Erstellen von Tabellen immer committen */
COMMIT WORK;

/* Userview anlegen */
execute procedure SP_CREATE_USER_VIEW 'BANK';
/* Sequence anlegen */
execute procedure SP_CREATE_SEQUNECE 'BANK';
/* Trigger anlegen */
execute procedure SP_CREATE_TRIGGER_BI 'BANK';
execute procedure SP_CREATE_TRIGGER_BU 'BANK';

CREATE TABLE CATEGORY (
  ID               INTEGER NOT NULL,
  TAG_ID           INTEGER,
  COUNTRY_ID       INTEGER,
  LABEL            LABEL,    
  CAPTION          VARCHAR(254) NOT NULL,
  DESCRIPTION      VARCHAR(2000),
  DONOTDELETE      DN_BOOLEAN,    
  SOFTDEL          DN_BOOLEAN,    
  CRE_USER         VARCHAR(32) NOT NULL,
  CRE_DATE         TIMESTAMP NOT NULL,
  CHG_USER         VARCHAR(32),
  CHG_DATE         TIMESTAMP
);

COMMENT ON TABLE CATEGORY IS
'Kategorien'; 

COMMENT ON COLUMN CATEGORY.ID IS
'Primärschlüssel';

COMMENT ON COLUMN CATEGORY.TAG_ID IS
'Fremdschlüssel für Tags';

COMMENT ON COLUMN CATEGORY.LABEL IS
'Gruppierung über ein Label';

COMMENT ON COLUMN CATEGORY.COUNTRY_ID IS
'Fremdschlüssel für Ländercodes';

COMMENT ON COLUMN CATEGORY.CAPTION IS
'Bezeichnung';

COMMENT ON COLUMN CATEGORY.DESCRIPTION IS
'Beschreibung';

COMMENT ON COLUMN CATEGORY.DONOTDELETE IS
'Löschflag ignorieren';

COMMENT ON COLUMN CATEGORY.SOFTDEL IS
'Löschflag';

COMMENT ON COLUMN CATEGORY.CRE_USER IS
'Erstellt von';

COMMENT ON COLUMN CATEGORY.CRE_DATE IS
'Erstellt am';

COMMENT ON COLUMN CATEGORY.CHG_USER IS
'Geändert von';

COMMENT ON COLUMN CATEGORY.CHG_DATE IS
'Geändert am';
/* Das Erstellen von Tabellen immer committen */
COMMIT WORK;

/* Userview anlegen */
execute procedure SP_CREATE_USER_VIEW 'CATEGORY';
/* Sequence anlegen */
execute procedure SP_CREATE_SEQUNECE 'CATEGORY';
/* Trigger anlegen */
execute procedure SP_CREATE_TRIGGER_BI 'CATEGORY';
execute procedure SP_CREATE_TRIGGER_BU 'CATEGORY';
execute procedure SP_CREATE_TRIGGER_BD 'CATEGORY', 'DONOTDELETE';

COMMIT WORK;
/******************************************************************************/
/*                                  ALTER                                   
/******************************************************************************/

/* Tables */

ALTER TABLE USERS
  ADD PERSON_ID INTEGER;
  
COMMENT ON COLUMN USERS.PERSON_ID IS
'Fremdschlüssel aus PERSON'; 
  
/* Userview aktualisieren */
execute procedure SP_CREATE_USER_VIEW 'USERS';
  
COMMIT WORK;
/******************************************************************************/
/*                                Primary Keys                                
/******************************************************************************/

ALTER TABLE DOCUMENT ADD CONSTRAINT PK_DOCUMENT PRIMARY KEY (ID);
ALTER TABLE PERSON ADD CONSTRAINT PK_PERSON PRIMARY KEY (ID);
ALTER TABLE CONTACT ADD CONSTRAINT PK_CONTACT PRIMARY KEY (ID);
/* wird von SP_CREATE_ZABCATALOG erstellt */
/* ALTER TABLE CONTACT_TYPE ADD CONSTRAINT PK_CONTACT_TYPE PRIMARY KEY (ID); */
ALTER TABLE ADDRESS ADD CONSTRAINT PK_ADDRESS PRIMARY KEY (ID);
/* wird von SP_CREATE_ZABCATALOG erstellt */
/* ALTER TABLE ADDRESS_TYPE ADD CONSTRAINT PK_ADDRESS_TYPE PRIMARY KEY (ID); */
ALTER TABLE BANK ADD CONSTRAINT PK_BANK PRIMARY KEY (ID);
/* wird von SP_CREATE_ZABCATALOG erstellt */
/* ALTER TABLE SALUTATION ADD CONSTRAINT PK_SALUTATION PRIMARY KEY (ID); */
/* wird von SP_CREATE_ZABCATALOG erstellt */
/*ALTER TABLE TITEL ADD CONSTRAINT PK_TITEL PRIMARY KEY (ID);*/
ALTER TABLE CATEGORY ADD CONSTRAINT PK_CATEGORY PRIMARY KEY (ID);

COMMIT WORK;
/******************************************************************************/
/*                                Foreign Keys                                
/******************************************************************************/

ALTER TABLE DOCUMENT ADD CONSTRAINT FK_DOCUMENT_TAG FOREIGN KEY (TAG_ID) REFERENCES TAG(ID) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE PERSON ADD CONSTRAINT FK_PERSON_PICTURE FOREIGN KEY (PICTURE_ID) REFERENCES DOCUMENT(ID) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE PERSON ADD CONSTRAINT FK_PERSON_TENANT FOREIGN KEY (TENANT_ID) REFERENCES TENANT(ID) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE PERSON ADD CONSTRAINT FK_PERSON_PARTNER FOREIGN KEY (MARRIED_TO_ID) REFERENCES PERSON(ID) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE PERSON ADD CONSTRAINT FK_PERSON_TITEL FOREIGN KEY (TITEL_ID) REFERENCES TITEL(ID) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE PERSON ADD CONSTRAINT FK_PERSON_SALUTATION FOREIGN KEY (SALUTATION_ID) REFERENCES SALUTATION(ID) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE PERSON ADD CONSTRAINT FK_PERSON_TAG FOREIGN KEY (TAG_ID) REFERENCES TAG(ID) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE CONTACT ADD CONSTRAINT FK_CONTACT_TENANT FOREIGN KEY (TENANT_ID) REFERENCES TENANT(ID) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE CONTACT ADD CONSTRAINT FK_CONTACT_TYPE FOREIGN KEY (CONTACT_TYPE_ID) REFERENCES CONTACT_TYPE(ID) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE CONTACT ADD CONSTRAINT FK_CONTACT_TAG FOREIGN KEY (TAG_ID) REFERENCES TAG(ID) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE ADDRESS ADD CONSTRAINT FK_ADDRESS_TENANT FOREIGN KEY (TENANT_ID) REFERENCES TENANT(ID) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE ADDRESS ADD CONSTRAINT FK_ADDRESS_TYPE FOREIGN KEY (ADDRESS_TYPE_ID) REFERENCES ADDRESS_TYPE(ID) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE ADDRESS ADD CONSTRAINT FK_ADDRESS_TAG FOREIGN KEY (TAG_ID) REFERENCES TAG(ID) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE BANK ADD CONSTRAINT FK_BANK_TENANT FOREIGN KEY (TENANT_ID) REFERENCES TENANT(ID) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE BANK ADD CONSTRAINT FK_BANK_TAG FOREIGN KEY (TAG_ID) REFERENCES TAG(ID) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE CATEGORY ADD CONSTRAINT FK_CATEGORY_COUNTRY FOREIGN KEY (COUNTRY_ID) REFERENCES COUNTRY(ID) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE CATEGORY ADD CONSTRAINT FK_CATEGORY_TAG FOREIGN KEY (TAG_ID) REFERENCES TAG(ID) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE USERS ADD CONSTRAINT FK_USERS_PERSON FOREIGN KEY (PERSON_ID) REFERENCES PERSON(ID) ON DELETE SET NULL ON UPDATE CASCADE;
                                                                                                                                 
COMMIT WORK;
/******************************************************************************/
/*                                  Indices                                   
/******************************************************************************/

CREATE UNIQUE INDEX ALT_DOCUMENT ON DOCUMENT(UNIQUE_NAME);

COMMIT WORK;
/******************************************************************************/
/*                             Relations                              
/******************************************************************************/

/* nach dem alle Datenbankobjekte angelegt wurden dürfen erst die Relationen generiert werden */

execute procedure SP_CREATE_ZABRELATION 'PERSON', 'CONTACT', 1;
execute procedure SP_CREATE_ZABRELATION 'PERSON', 'ADDRESS', 1;
execute procedure SP_CREATE_ZABRELATION 'PERSON', 'BANK', 1;
execute procedure SP_CREATE_ZABRELATION 'PERSON', 'CATEGORY', 1;

COMMIT WORK;
/******************************************************************************/
/*                                  Triggers                                  
/******************************************************************************/

/* Standardtrigger werden druch die SPs: SP_CREATE_TRIGGER_BI und SP_CREATE_TRIGGER_BU erstellt */

/******************************************************************************/
/*                                  Views                                   
/******************************************************************************/

/* USER-Views werden druch die SP: SP_CREATE_USER_VIEW erstellt */
      
/* Relationsviews */
CREATE OR ALTER VIEW V_REL_PERSON(PERSON_ID, 
  TENANT_ID, 
  TAG_ID,   
  TITEL_ID, 
  TITEL_CAPTION,
  SALUTATION_ID,
  SALUTATION,
  SALUTATION_LONG,   
  SALUTATION1, 
  SALUTATION2,   
  PICTURE_ID,
  PIC_UNIQUE_NAME,
  PIC_REAL_NAME,   
  PERSONNUMBER,
  FIRSTNAME, 
  NAME1, 
  NAME2, 
  NAME3, 
  DAY_OF_BIRTH, 
  ISPRIVATE,     
  MARRIED_TO_ID, 
  IS_MARRIED, 
  MARRIED_SINCE, 
  MARRIAGE_PARTNER_FIRSTNAME, 
  MARRIAGE_PARTNER_NAME1, 
  DESCRIPTION)
AS
SELECT
  /* IDs */
  V_P.ID AS PERSON_ID, 
  V_P.TENANT_ID AS TENANT_ID, 
  V_P.TAG_ID AS TAG_ID,   
  /* Titel */
  V_P.TITEL_ID AS TITEL_ID, 
  V_T.CAPTION AS TITEL_CAPTION,
  /* Anrede */
  V_P.SALUTATION_ID AS SALUTATION_ID,
  V_S.CAPTION AS SALUTATION,
  V_S.DESCRIPTION AS SALUTATION_LONG,   
  V_P.SALUTATION1 AS SALUTATION1, 
  V_P.SALUTATION2 AS SALUTATION2,   
  /* Bild */
  V_P.PICTURE_ID AS PICTURE_ID,
  V_D.UNIQUE_NAME AS PIC_UNIQUE_NAME,
  V_D.REAL_NAME AS PIC_REAL_NAME,   
  /* Person */
  V_P.PERSONNUMBER AS PERSONNUMBER,
  V_P.FIRSTNAME AS FIRSTNAME, 
  V_P.NAME1 AS NAME1, 
  V_P.NAME2 AS NAME2, 
  V_P.NAME3 AS NAME3, 
  V_P.DAY_OF_BIRTH AS DAY_OF_BIRTH, 
  V_P.ISPRIVATE AS ISPRIVATE,     
  /* Verheiratet */  
  V_P.MARRIED_TO_ID AS MARRIED_TO_ID, 
  V_P.IS_MARRIED AS IS_MARRIED, 
  V_P.MARRIED_SINCE AS MARRIED_SINCE, 
  V_P.MARRIAGE_PARTNER_FIRSTNAME AS MARRIAGE_PARTNER_FIRSTNAME, 
  V_P.MARRIAGE_PARTNER_NAME1 AS MARRIAGE_PARTNER_NAME1, 
  /* Freitext */
  V_P.DESCRIPTION AS DESCRIPTION  
FROM
  V_PERSON V_P
    left outer join V_TITEL V_T on (V_P.TITEL_ID=V_T.ID)
    left outer join V_SALUTATION V_S on (V_P.SALUTATION_ID=V_S.ID)
    left outer join V_DOCUMENT V_D on (V_P.PICTURE_ID=V_D.ID);

COMMENT ON VIEW V_REL_PERSON IS
'Anrede-, Titel- und Binärdaten kombiniert mit Personendaten';

COMMIT WORK;

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'SELECT', 'V_REL_PERSON';

CREATE OR ALTER VIEW V_REL_ADDRESS_BY_PERSON (PERSON_ID,
  TENANT_ID,
  ADDRESS_ID,
  ADDRESS_TYPE_ID,
  ADDRESS_TYPE_CAPTION,
  STREET,
  STREET_ADDRESS_FROM,
  STREET_ADDRESS_TO,
  CITY,
  DISTRICT,
  ZIPCODE,
  POST_OFFICE_BOX,
  ISPOSTADDRESS,
  ISPRIVATE)
AS
SELECT
  distinct
  V_P.ID AS PERSON_ID,
  V_P.TENANT_ID AS TENANT_ID,
  V_A.ID AS ADDRESS_ID,
  V_A.ADDRESS_TYPE_ID AS ADDRESS_TYPE_ID,
  V_ADT.CAPTION AS ADDRESS_TYPE_CAPTION,
  V_A.STREET AS STREET,
  V_A.STREET_ADDRESS_FROM AS STREET_ADDRESS_FROM,
  V_A.STREET_ADDRESS_TO AS STREET_ADDRESS_TO,
  V_A.CITY AS CITY,
  V_A.DISTRICT AS DISTRICT,
  V_A.ZIPCODE AS ZIPCODE,
  V_A.POST_OFFICE_BOX AS POST_OFFICE_BOX,
  V_A.ISPOSTADDRESS AS ISPOSTADDRESS,
  V_A.ISPRIVATE AS ISPRIVATE
FROM
  V_PERSON V_P,
  V_REL_PERSON_ADDRESS V_RPA,
  V_ADDRESS V_A
    left outer join V_ADDRESS_TYPE V_ADT on (V_A.ADDRESS_TYPE_ID=V_ADT.ID)
WHERE
  ((V_RPA.PERSON_ID=V_P.ID)
   and
   (V_RPA.ADDRESS_ID=V_A.ID));
   
COMMENT ON VIEW V_REL_ADDRESS_BY_PERSON IS
'Adressdaten kombiniert mit Personendaten';

COMMIT WORK;

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'SELECT', 'V_REL_ADDRESS_BY_PERSON';

CREATE OR ALTER VIEW V_REL_CONTACT_BY_PERSON (PERSON_ID,
  TENANT_ID,
  CONTACT_ID,
  CONTACT_TYPE_ID,
  CONTACT_TYPE_CAPTION,
  AREA_CODE,
  PHONE,
  PHONE_FMT,
  FAX,
  FAX_FMT,
  WWW,
  EMAIL,
  SKYPE,
  MESSANGERNAME)
AS
SELECT
  distinct
  V_P.ID AS PERSON_ID,
  V_P.TENANT_ID AS TENANT_ID,
  V_C.ID AS CONTACT_ID,
  V_C.CONTACT_TYPE_ID AS CONTACT_TYPE_ID,
  V_CT.CAPTION AS CONTACT_TYPE_CAPTION,
  V_C.AREA_CODE AS AREA_CODE,
  V_C.PHONE AS PHONE,
  V_C.PHONE_FMT AS PHONE_FMT,
  V_C.FAX AS FAX,
  V_C.FAX_FMT AS FAX_FMT,
  V_C.WWW AS WWW,
  V_C.EMAIL AS EMAIL,
  V_C.SKYPE AS SKYPE,
  V_C.MESSANGERNAME AS MESSANGERNAME   
FROM
  V_PERSON V_P,
  V_REL_PERSON_CONTACT V_RPC,
  V_CONTACT V_C
    left outer join V_CONTACT_TYPE V_CT on (V_C.CONTACT_TYPE_ID=V_CT.ID)
WHERE
  ((V_RPC.PERSON_ID=V_P.ID)
   and
   (V_RPC.CONTACT_ID=V_C.ID));
   
COMMENT ON VIEW V_REL_CONTACT_BY_PERSON IS
'Kontaktdaten kombiniert mit Personendaten';   

COMMIT WORK;

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'SELECT', 'V_REL_CONTACT_BY_PERSON';

CREATE OR ALTER VIEW V_REL_BANK_BY_PERSON (PERSON_ID,
  TENANT_ID,
  BANK_ID,
  CAPTION,
  BLZ,
  BLZ_FMT,
  KTO,
  KTO_FMT,
  IBAN,
  BIC)
AS
SELECT
  distinct
  V_P.ID AS PERSON_ID,
  V_P.TENANT_ID AS TENANT_ID,
  V_B.ID AS BANK_ID,
  V_B.CAPTION AS CAPTION,
  V_B.BLZ AS BLZ,
  V_B.BLZ_FMT AS BLZ_FMT,
  V_B.KTO AS KTO,
  V_B.KTO_FMT AS KTO_FMT,
  V_B.IBAN AS IBAN,
  V_B.BIC AS BIC   
FROM
  V_PERSON V_P,
  V_REL_PERSON_BANK V_RPB,
  V_BANK V_B
WHERE
  ((V_RPB.PERSON_ID=V_P.ID)
   and
   (V_RPB.BANK_ID=V_B.ID));
   
COMMENT ON VIEW V_REL_BANK_BY_PERSON IS
'Bankdaten kombiniert mit Personendaten';   

COMMIT WORK;

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'SELECT', 'V_REL_BANK_BY_PERSON';

CREATE OR ALTER VIEW V_REL_ADDRESSBOOKITEM_DETAILS(PERSON_ID, 
  TENANT_ID, 
  TAG_ID,   
  TITEL_ID, 
  TITEL_CAPTION,
  SALUTATION_ID,
  SALUTATION,
  SALUTATION_LONG,   
  SALUTATION1, 
  SALUTATION2,      
  PERSONNUMBER,
  FIRSTNAME, 
  NAME1, 
  NAME2, 
  NAME3, 
  DAY_OF_BIRTH, 
  ISPRIVATE,     
  MARRIED_TO_ID, 
  ISMARRIED, 
  MARRIED_SINCE, 
  MARRIAGE_PARTNER_FIRSTNAME, 
  MARRIAGE_PARTNER_NAME1, 
  /* ADDRESS */
  ADDRESS_ID,
  ADDRESS_TYPE_ID,
  ADDRESS_TYPE_CAPTION,
  STREET,
  STREET_ADDRESS_FROM,
  STREET_ADDRESS_TO,
  CITY,
  DISTRICT,
  ZIPCODE,
  POST_OFFICE_BOX,
  ISPOSTADDRESS,
  ISPRIVATE_ADDRESS,
  CONTACT_ID,
  CONTACT_TYPE_ID,
  CONTACT_TYPE_CAPTION,
  AREA_CODE,
  PHONE,
  PHONE_FMT,
  FAX,
  FAX_FMT,
  WWW,
  EMAIL,
  SKYPE,
  MESSANGERNAME,    
  BANK_ID,
  CAPTION,
  BLZ,
  BLZ_FMT,
  KTO,
  KTO_FMT,
  IBAN,
  BIC,    
  DESCRIPTION,        
  PICTURE_ID,
  PIC_UNIQUE_NAME,
  PIC_REAL_NAME)
AS
SELECT 
  /* PERSON */
  V_RP.PERSON_ID AS PERSON_ID, 
  V_RP.TENANT_ID AS TENANT_ID, 
  V_RP.TAG_ID AS TAG_ID,   
  V_RP.TITEL_ID AS TITEL_ID, 
  V_RP.TITEL_CAPTION AS TITEL_CAPTION,
  V_RP.SALUTATION_ID AS SALUTATION_ID,
  V_RP.SALUTATION AS SALUTATION,
  V_RP.SALUTATION_LONG AS SALUTATION_LONG,   
  V_RP.SALUTATION1 AS SALUTATION1, 
  V_RP.SALUTATION2 AS SALUTATION2,
  V_RP.PERSONNUMBER AS PERSONNUMBER,      
  V_RP.FIRSTNAME AS FIRSTNAME, 
  V_RP.NAME1 AS NAME1, 
  V_RP.NAME2 AS NAME2, 
  V_RP.NAME3 AS NAME3, 
  V_RP.DAY_OF_BIRTH AS DAY_OF_BIRTH, 
  V_RP.ISPRIVATE AS ISPRIVATE,     
  V_RP.MARRIED_TO_ID AS MARRIED_TO_ID, 
  V_RP.IS_MARRIED AS ISMARRIED, 
  V_RP.MARRIED_SINCE AS MARRIED_SINCE, 
  V_RP.MARRIAGE_PARTNER_FIRSTNAME AS MARRIAGE_PARTNER_FIRSTNAME, 
  V_RP.MARRIAGE_PARTNER_NAME1 AS MARRIAGE_PARTNER_NAME1, 
  /* ADDRESS */
  V_RABP.ADDRESS_ID AS ADDRESS_ID,
  V_RABP.ADDRESS_TYPE_ID AS ADDRESS_TYPE_ID,
  V_RABP.ADDRESS_TYPE_CAPTION AS ADDRESS_TYPE_CAPTION,
  V_RABP.STREET AS STREET,
  V_RABP.STREET_ADDRESS_FROM AS STREET_ADDRESS_FROM,
  V_RABP.STREET_ADDRESS_TO AS STREET_ADDRESS_TO,
  V_RABP.CITY AS CITY,
  V_RABP.DISTRICT AS DISTRICT,
  V_RABP.ZIPCODE AS ZIPCODE,
  V_RABP.POST_OFFICE_BOX AS POST_OFFICE_BOX,
  V_RABP.ISPOSTADDRESS AS ISPOSTADDRESS,
  V_RABP.ISPRIVATE AS ISPRIVATE_ADDRESS,
  /* CONTACT */
  V_RCBP.CONTACT_ID AS CONTACT_ID,
  V_RCBP.CONTACT_TYPE_ID AS CONTACT_TYPE_ID,
  V_RCBP.CONTACT_TYPE_CAPTION AS CONTACT_TYPE_CAPTION,
  V_RCBP.AREA_CODE AS AREA_CODE,
  V_RCBP.PHONE AS PHONE,
  V_RCBP.PHONE_FMT AS PHONE_FMT,
  V_RCBP.FAX AS FAX,
  V_RCBP.FAX_FMT AS FAX_FMT,
  V_RCBP.WWW AS WWW,
  V_RCBP.EMAIL AS EMAIL,
  V_RCBP.SKYPE AS SKYPE,
  V_RCBP.MESSANGERNAME AS MESSANGERNAME,    
  /* BANK */
  V_RBBP.BANK_ID AS BANK_ID,
  V_RBBP.CAPTION AS CAPTION,
  V_RBBP.BLZ AS BLZ,
  V_RBBP.BLZ_FMT AS BLZ_FMT,
  V_RBBP.KTO AS KTO,
  V_RBBP.KTO_FMT AS KTO_FMT,
  V_RBBP.IBAN AS IBAN,
  V_RBBP.BIC AS BIC,    
  /* INFO */
  V_RP.DESCRIPTION AS DESCRIPTION,        
  /* PICTURE */
  V_RP.PICTURE_ID AS PICTURE_ID,
  V_RP.PIC_UNIQUE_NAME AS PIC_UNIQUE_NAME,
  V_RP.PIC_REAL_NAME AS PIC_REAL_NAME         
FROM 
  V_REL_PERSON V_RP
    left outer join V_REL_ADDRESS_BY_PERSON V_RABP on (V_RP.PERSON_ID = V_RABP.PERSON_ID)
    left outer join V_REL_CONTACT_BY_PERSON V_RCBP on (V_RP.PERSON_ID = V_RCBP.PERSON_ID)
    left outer join V_REL_BANK_BY_PERSON V_RBBP on (V_RP.PERSON_ID = V_RBBP.PERSON_ID);    

COMMENT ON VIEW V_REL_ADDRESSBOOKITEM_DETAILS IS
'Adress-, Kontakt- und Bankdaten kompiniert mit Personendaten';

COMMIT WORK;

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'SELECT', 'V_REL_ADDRESSBOOKITEM_DETAILS';

COMMIT WORK;
/******************************************************************************/
/*                             Stored Procedures                              
/******************************************************************************/

SET TERM ^ ;

CREATE OR ALTER PROCEDURE SP_UNIQUENAME (
  ATENANT_ID integer,
  ACUSTOM_EXT varchar(64))
RETURNS (
    UNIQUENAME UNIQUE_NAME)
as
declare variable idx integer;
declare variable version varchar(15);
declare variable short_name varchar(64);
declare variable long_name varchar(254);
declare variable tenant_as_str varchar(10);
declare variable idx_as_str varchar(10); 
declare variable substitute varchar(10);
declare variable key_section varchar(128);
declare variable section varchar(128);
declare variable ident varchar(128);
declare variable value_for_default varchar(255);
begin
  select SEQ_ID from SP_GET_SEQUENCEID_BY_IDENT('UNIQUENAMEIDX') into :idx;
  select dbversion from SP_DBVERSION into :version;

  key_section = 'GENERAL'; 
  section = 'UNIQUENAME';
  ident = 'FIXPART';
  value_for_default = 'unique';
  select Result from SP_READSTRING(:key_section, :section, :ident, :value_for_default) into :short_name;

  ident = 'SUBSTITUE';
  value_for_default = '_';  
  select Result from SP_READSTRING(:key_section, :section, :ident, :value_for_default) into :substitute;
    
  tenant_as_str = LPad(Cast(ATENANT_ID as varchar(10)), 4, '0'); 
  idx_as_str = LPad(Cast(idx as varchar(10)), 9, '0');
  long_name =  short_name || '_' || version || '_' || tenant_as_str || '_' || idx_as_str;
  long_name = Replace(long_name, '.', substitute);
  
  if (Trim(ACUSTOM_EXT) <> '')then
  begin
    UNIQUENAME = long_name || ACUSTOM_EXT;
  end
  else
  begin
    UNIQUENAME = long_name;
  end

  suspend;
end^

COMMENT ON PROCEDURE SP_UNIQUENAME IS
'Eindeutigen Namen ermitteln'^

COMMIT WORK^

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_UNIQUENAME'^

CREATE OR ALTER PROCEDURE SP_GET_UNIQUENAME (
  ATENANT_ID integer,
  ACUSTOM_EXT varchar(64))
RETURNS (
  success smallint,
  code smallint,
  info varchar(2000))
AS
declare variable success_by_touchsession smallint;
declare variable success_by_grant smallint;
declare variable unique_name varchar(254);
begin
  success = 0;
  code = 0;
  info = '{"key": value}';
 
  select UNIQUENAME from SP_UNIQUENAME(:ATENANT_ID, :ACUSTOM_EXT) into :unique_name;

  code = 1;
  info = '{"kind": 0, "uniquename": "' || unique_name || '"}';
  success = 1;

  suspend;
end
^  

COMMENT ON PROCEDURE SP_GET_UNIQUENAME IS
'Ermittelt einen eindeutigen Namen im JSON Format'^

COMMIT WORK^

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_GET_UNIQUENAME'^

CREATE OR ALTER PROCEDURE SP_GET_UNIQUENAME_BY_SRV (
  ASESSION_ID varchar(254),  
  AUSERNAME varchar(254),
  AIP varchar(254),
  ATENANT_ID integer,
  ACUSTOM_EXT varchar(64))
RETURNS (
  success smallint,
  code smallint,
  info varchar(2000))
AS
declare variable success_by_touchsession smallint;
declare variable success_by_grant smallint;
declare variable unique_name varchar(254);
begin
  success = 0;
  code = 0;
  info = '{"result": null}';

  select success from SP_TOUCHSESSION(:ASESSION_ID, :AUSERNAME, :AIP) into :success_by_touchsession;
  
  if (success_by_touchsession = 1) then
  begin
    select success from SP_CHECKGRANT(:AUSERNAME, 'MISC') into :success_by_grant;
    
    if (success_by_grant = 1) then
    begin
      select success, code, info from SP_GET_UNIQUENAME(:ATENANT_ID, :ACUSTOM_EXT) into :success, :code, :info;
      
      suspend;
    end
    else
    begin
      info = '{"kind": 1, "publish": "NO_GRANT_FOR_MISC", "message": "NO_GRANT_FOR_MISC"}';
      
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

COMMENT ON PROCEDURE SP_GET_UNIQUENAME_BY_SRV IS
'Checked die Sitzungsverwaltung und ruf SP_GET_UNIQENAME auf'^

COMMIT WORK^

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_GET_UNIQUENAME_BY_SRV'^

CREATE OR ALTER PROCEDURE SP_CHK_DATA_BY_ADD_ADDRESSITEM (
  ATENANT_ID integer,  /* Pflichtfeld */
  ASALUTATION_ID integer, /* Pflichtfeld */
  AALTSALUTATION varchar(126),
  ATITEL_ID integer, /* Pflichtfeld */
  AFIRSTNAME varchar(126),
  ANAME varchar(126), /* Pflichtfeld */
  ANAME2 varchar(126),
  ADAY_OF_BIRTH date,
  AISPRIVATE_PERSON smallint,
  /* Ehepartner */
  AISMARRIED  smallint, /* wenn true werden daten zum Ehepartner erwartet */
  AMARRIED_TO_ID integer, 
  AMARRIED_SINCE date,
  AMARRIAGE_PARTNER_FIRSTNAME varchar(126),
  AMARRIAGE_PARTNER_NAME1 varchar(126), /* wenn verheiratet: Pflichtfeld */ 
  /* Adresse */
  AADDRESSDATAPRESENT smallint, /* wenn true werden Daten zur Addresse erwatet */
  AADDRESS_TYPE_ID integer, /* wenn Adresse: Pflichtfeld */
  ADISTRICT varchar(254),
  AZIPCODE integer, /* wenn Adresse: Pflichtfeld */
  ACITY varchar(254), /* wenn Adresse: Pflichtfeld */
  APOST_OFFICE_BOX varchar(254),        
  ASTREET varchar(254), /* wenn Adresse: Pflichtfeld */
  ASTREET_ADDRESS_FROM varchar(127), /* wenn Adresse: Pflichtfeld */
  ASTREET_ADDRESS_TO varchar(127),
  AISPOSTADDRESS smallint,
  AISPRIVATE_ADDRESS smallint,
  /* Kontaktdaten */
  ACONTACTDATAPRESENT smallint, /* wenn true werden Daten zu Kontakten erwatet */
  ACONTACT_TYPE_ID integer, /* wenn Kontaktdaten: Pflichtfeld */      
  AAREA_CODE varchar(5),
  APHONE_FMT varchar(127), /* wenn Kontaktdaten: mindestens ein weiteres Kontdaktdatenfeld als Pflichtfeld */
  AFAX_FMT varchar(127), /* wenn Kontaktdaten: mindestens ein weiteres Kontdaktdatenfeld als Pflichtfeld */
  AWWW varchar(254), /* wenn Kontaktdaten: mindestens ein weiteres Kontdaktdatenfeld als Pflichtfeld */
  AEMAIL varchar(254), /* wenn Kontaktdaten: mindestens ein weiteres Kontdaktdatenfeld als Pflichtfeld */ 
  ASKYPE varchar(32), /* wenn Kontaktdaten: mindestens ein weiteres Kontdaktdatenfeld als Pflichtfeld */
  AMESSANGERNAME varchar(32), /* wenn Kontaktdaten: mindestens ein weiteres Kontdaktdatenfeld als Pflichtfeld */
  /* Bankinformationen */  
  ABANKDATAPRESENT smallint, /* wenn true werden Daten zur Bankverbindung erwatet */
  ADEPOSITOR varchar(254), /* wenn Bankdaten: Pflichtfeld */
  ABLZ_FMT varchar(10), /* wenn Bankdaten: Pflichtfeld */       
  AKTO_FMT varchar(10), /* wenn Bankdaten: Pflichtfeld */
  AIBAN varchar(30),
  ABIC varchar(11), 
  /* Info */
  AINFODATAPRESENT smallint, /* wenn true werden Informationen erwatet */
  AINFO BLOB SUB_TYPE TEXT SEGMENT SIZE 16384,
  /* Photo */
  APHOTOPRESENT smallint,
  APHOTO_UNIQUE_NAME varchar(254),
  APHOTO_REAL_NAME varchar(254)/* wenn true wird ein Foto erwatet */)
RETURNS (
  success smallint,
  code smallint,
  info varchar(2000))
AS
begin
  success = 0;
  code = 0;
  info = '{"result": null}';
  
  if (ATENANT_ID is null) then
  begin
    code = 1;
    info = '{"kind": 1, "publish": "NO_MANDATORY_MANDANT_ID", "message": "NO_MANDATORY_MANDANT_ID"}';
    suspend;
    Exit;
  end
  
  if (not exists(select 1 from V_TENANT where ID=:ATENANT_ID)) then
  begin
    code = 1;
    info = '{"kind": 1, "publish": "NO_VALID_MANDANT_ID", "message": "NO_VALID_MANDANT_ID"}';
    suspend;
    Exit;  
  end
  
  if (ASALUTATION_ID is null) then
  begin
    code = 1;
    info = '{"kind": 1, "publish": "NO_MANDATORY_SALUTATION_ID", "message": "NO_MANDATORY_SALUTATION_ID"}';
    suspend;
    Exit;  
  end
  
  if (ATITEL_ID is null) then
  begin
    code = 1;
    info = '{"kind": 1, "publish": "NO_MANDATORY_TITEL_ID", "message": "NO_MANDATORY_TITEL_ID"}';
    suspend;
    Exit;  
  end
  
  if (ANAME is null) then
  begin
    code = 1;
    info = '{"kind": 1, "publish": "NO_MANDATORY_PERSON_NAME", "message": "NO_MANDATORY_PERSON_NAME"}';
    suspend;
    Exit;  
  end
  
  if (AISMARRIED is null) then
  begin
  end
  
  if (AISMARRIED not in (0,1)) then
  begin
    code = 1;
    info = '{"kind": 1, "publish": "NO_VALID_MARRIAGE_DATA_FLAG", "message": "NO_VALID_MARRIAGE_DATA_FLAG"}';
    suspend;
    Exit;  
  end
  
  if (AISMARRIED = 1) then
  begin 
    if (AMARRIAGE_PARTNER_NAME1 is null) then
    begin
      code = 1;
      info = '{"kind": 1, "publish": "NO_MANDATORY_MARRIAGE_PARTNER_NAME", "message": "NO_MANDATORY_MARRIAGE_PARTNER_NAME"}';
      suspend;
      Exit;    
    end
  end
  
  if (AADDRESSDATAPRESENT is null) then
  begin
    code = 1;
    info = '{"kind": 1, "publish": "NO_MANDATORY_ADDRESS_DATA_FLAG", "message": "NO_MANDATORY_ADDRESS_DATA_FLAG"}';
    suspend;
    Exit;      
  end
    
  if (AADDRESSDATAPRESENT not in (0,1)) then
  begin
    code = 1;
    info = '{"kind": 1, "publish": "NO_VALID_ADDRESS_DATA_FLAG", "message": "NO_VALID_ADDRESS_DATA_FLAG"}';
    suspend;
    Exit;  
  end
  
  if (AADDRESSDATAPRESENT = 1) then
  begin
    if (AADDRESS_TYPE_ID is null) then
    begin
      code = 1;
      info = '{"kind": 1, "publish": "NO_MANDATORY_ADDRESS_TYPE_ID", "message": "NO_MANDATORY_ADDRESS_TYPE_ID"}';
      suspend;
      Exit;    
    end
    
    if (AZIPCODE is null) then
    begin
      code = 1;
      info = '{"kind": 1, "publish": "NO_MANDATORY_ZIPCODE", "message": "NO_MANDATORY_ZIPCODE"}';
      suspend;
      Exit;    
    end
    
    if (ACITY is null) then
    begin
      code = 1;
      info = '{"kind": 1, "publish": "NO_MANDATORY_CITY", "message": "NO_MANDATORY_CITY"}';
      suspend;
      Exit;    
    end
    
    if (ASTREET is null) then
    begin
      code = 1;
      info = '{"kind": 1, "publish": "NO_MANDATORY_STREET", "message": "NO_MANDATORY_STREET"}';
      suspend;
      Exit;       
    end
    
    if (ASTREET_ADDRESS_FROM is null) then
    begin
      code = 1;
      info = '{"kind": 1, "publish": "NO_MANDATORY_STREET_ADDRESS_FROM", "message": "NO_MANDATORY_STREET_ADDRESS_FROM"}';
      suspend;
      Exit;       
    end
  end

  if (ACONTACTDATAPRESENT is null) then
  begin
    code = 1;
    info = '{"kind": 1, "publish": "NO_MANDATORY_CONTACT_DATA_FLAG", "message": "NO_MANDATORY_CONTACT_DATA_FLAG"}';
    suspend;
    Exit;      
  end
  
  if (ACONTACTDATAPRESENT not in (0,1)) then
  begin
    code = 1;
    info = '{"kind": 1, "publish": "NO_VALID_CONTACT_DATA_FLAG", "message": "NO_VALID_CONTACT_DATA_FLAG"}';
    suspend;
    Exit;  
  end
  
  if (ACONTACTDATAPRESENT = 1) then
  begin
    if (ACONTACT_TYPE_ID is null) then
    begin
      code = 1;
      info = '{"kind": 1, "publish": "NO_MANDATORY_CONTACT_TYPE_ID", "message": "NO_MANDATORY_CONTACT_TYPE_ID"}';
      suspend;
      Exit;       
    end
    
    if ((APHONE_FMT is null) and 
        (AFAX_FMT is null) and 
        (AWWW is null) and 
        (AEMAIL is null) and 
        (ASKYPE is null) and 
        (AMESSANGERNAME is null)) then
    begin
      code = 1;
      info = '{"kind": 1, "publish": "NO_MANDATORY_CONTACT_DATA", "message": "NO_MANDATORY_CONTACT_DATA"}';
      suspend;
      Exit;    
    end
  end
    
  if (ABANKDATAPRESENT is null) then
  begin
    code = 1;
    info = '{"kind": 1, "publish": "NO_MANDATORY_BANK_DATA_FLAG", "message": "NO_MANDATORY_BANK_DATA_FLAG"}';
    suspend;
    Exit;      
  end
      
  if (ABANKDATAPRESENT not in (0,1)) then
  begin
    code = 1;
    info = '{"kind": 1, "publish": "NO_VALID_BANK_DATA_FLAG", "message": "NO_VALID_BANK_DATA_FLAG"}';
    suspend;
    Exit;  
  end
      
  if (ABANKDATAPRESENT = 1) then
  begin
    if (ADEPOSITOR is null) then
    begin
      code = 1;
      info = '{"kind": 1, "publish": "NO_MANDATORY_DEPOSITOR", "message": "NO_MANDATORY_DEPOSITOR"}';
      suspend;
      Exit;    
    end
    
    if (ABLZ_FMT is null) then
    begin
      code = 1;
      info = '{"kind": 1, "publish": "NO_MANDATORY_BLZ_FMT", "message": "NO_MANDATORY_BLZ_FMT"}';
      suspend;
      Exit;    
    end
    
    if (AKTO_FMT is null) then
    begin
      code = 1;
      info = '{"kind": 1, "publish": "NO_MANDATORY_KTO_FMT", "message": "NO_MANDATORY_KTO_FMT"}';
      suspend;
      Exit;    
    end
  
  end
  
  if (AINFODATAPRESENT is null) then
  begin
    code = 1;
    info = '{"kind": 1, "publish": "NO_MANDATORY_INFO_DATA_FLAG", "message": "NO_MANDATORY_INFO_DATA_FLAG"}';
    suspend;
    Exit;      
  end
  
  if (AINFODATAPRESENT not in (0,1)) then
  begin
    code = 1;
    info = '{"kind": 1, "publish": "NO_VALID_INFO_DATA_FLAG", "message": "NO_VALID_INFO_DATA_FLAG"}';
    suspend;
    Exit;  
  end
  
  if (AINFODATAPRESENT = 1) then
  begin
    if (AINFO is null) then
    begin
      code = 1;
      info = '{"kind": 1, "publish": "NO_MANDATORY_INFO_DATA", "message": "NO_MANDATORY_INFO_DATA"}';
      suspend;
      Exit;    
    end
  end
  
  if (APHOTOPRESENT is null) then
  begin
    code = 1;
    info = '{"kind": 1, "publish": "NO_MANDATORY_PHOTO_DATA_FLAG", "message": "NO_MANDATORY_PHOTO_DATA_FLAG"}';
    suspend;
    Exit;      
  end  
    
  if (APHOTOPRESENT not in (0,1)) then
  begin
    code = 1;
    info = '{"kind": 1, "publish": "NO_VALID_PHOTO_DATA_FLAG", "message": "NO_VALID_PHOTO_DATA_FLAG"}';
    suspend;
    Exit;  
  end
      
  if (APHOTOPRESENT = 1) then
  begin    
    if (APHOTO_REAL_NAME is null) then
    begin
      code = 1;
      info = '{"kind": 1, "publish": "NO_MANDATORY_PHOTO_REAL_NAME", "message": "NO_MANDATORY_PHOTO_REAL_NAME"}';
      suspend;
      Exit;    
    end
    
    /*
     * Stand 2013-03-24: entweder wird der eindeutige Name vom Client oder vom JavaService oder aber in der INSERT-SP erstellt 
     * daher hier keine Abprüfung auf not null     
     *     
    if (APHOTO_UNIQUE_NAME is null) then
    begin
      code = 1;
      info = '{"kind": 1, "publish": "NO_MANDATORY_PHOTO_UNIQUE_NAME", "message": "NO_MANDATORY_PHOTO_UNIQUE_NAME"}';
      suspend;
      Exit;    
    end
    *
    *
    */            
  end

  /* Kein Exit bis hierhin */
  success = 1;
    
  suspend;
end
^

COMMENT ON PROCEDURE SP_CHK_DATA_BY_ADD_ADDRESSITEM IS
'Überprüft alle logischen Inhalte für einen Addressbucheintrag'^

COMMIT WORK^

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_CHK_DATA_BY_ADD_ADDRESSITEM'^

CREATE OR ALTER PROCEDURE SP_INSERT_PERSON(
  ATENANT_ID integer,  /* Pflichtfeld */
  ASALUTATION_ID integer, /* Pflichtfeld */
  AALTSALUTATION varchar(126),
  ATITEL_ID integer, /* Pflichtfeld */
  AFIRSTNAME varchar(126),
  ANAME varchar(126), /* Pflichtfeld */
  ANAME2 varchar(126),
  ADAY_OF_BIRTH date,
  AISPRIVATE_PERSON smallint,
  /* Ehepartner */
  AISMARRIED  smallint, /* wenn true werden daten zum Ehepartner erwartet */
  AMARRIED_TO_ID integer, 
  AMARRIED_SINCE date,
  AMARRIAGE_PARTNER_FIRSTNAME varchar(126),
  AMARRIAGE_PARTNER_NAME1 varchar(126), /* wenn verheiratet: Pflichtfeld */ 
  AINFODATAPRESENT smallint, /* wenn true werden Informationen erwatet */
  AINFO BLOB SUB_TYPE TEXT SEGMENT SIZE 16384,
  ADODUPLICATES smallint)
RETURNS(
  success smallint,
  message varchar(254),
  person_id integer)
AS
declare variable do_insert smallint;
begin
  success = 0;
  message = 'FAILD_BY_UNKNOWN_REASON';
  person_id = -1;
  do_insert = -1;
  
  /* 1. Üeberprüfen ob Personendaten vorhanden; wenn ja, dann vorhandene Daten updaten ansonsten insert */ 
  if (ADODUPLICATES = 1) then
  begin  
    /* 
      Stand 2013-03-16: keine Überprüfung von Duplikaten bei Personendaten
      do_insert = 0 /* Duplikat vorhanden, PersonenId ermittelt
    */    
  end
  
  /* 
    Wenn die Person noch nicht vorhanden (klein Duplikat) und somit keine PersonenId ermittelt wurde,
    muss eine neue ID erstellt werden
  */
  if (person_id = -1) then
  begin
    select SEQ_ID from SP_GET_SEQUENCEID_BY_IDENT('PERSON') into :person_id;
    do_insert = 1;
  end
  
  if ((person_id <> -1) and (person_id is not null)) then
  begin
    if (do_insert not in (0,1)) then
    begin
      success = 0;
      message = 'FAILD_BY_OBSCURE_PROCESSING';
      suspend;
      Exit;
    end

    if (do_insert = 1) then
    begin
      insert 
      into
        V_PERSON
        (
          ID,
          TENANT_ID,
          SALUTATION_ID,
          SALUTATION1,
          TITEL_ID,
          FIRSTNAME,
          NAME1,
          NAME2,
          DAY_OF_BIRTH,
          ISPRIVATE    
        )
      values
        (
          :person_id,
          :ATENANT_ID,
          :ASALUTATION_ID,
          :AALTSALUTATION,
          :ATITEL_ID,
          :AFIRSTNAME,
          :ANAME,
          :ANAME2,
          :ADAY_OF_BIRTH,
          :AISPRIVATE_PERSON      
        );
    end
    else
    begin
      /* Update einrichten: nur erforderlich wenn nach Duplikaten gesucht und gefunden wurde */
    end  
    
    /* Daten zum Ehepartner anlegen */
    if (AISMARRIED=1) then
    begin
      update
        V_PERSON
      set
        IS_MARRIED=:AISMARRIED,
        MARRIED_TO_ID=:AMARRIED_TO_ID, 
        MARRIED_SINCE=:AMARRIED_SINCE,
        MARRIAGE_PARTNER_FIRSTNAME=:AMARRIAGE_PARTNER_FIRSTNAME,
        MARRIAGE_PARTNER_NAME1=:AMARRIAGE_PARTNER_NAME1      
      where
        ID=:person_id;
    end
    
    /* Informationen zur Person hinterlegen */
    if (AINFODATAPRESENT=1) then
    begin
      update
        V_PERSON
      set
        DESCRIPTION=:AINFO
      where
        ID=:person_id;    
    end  
    
    message = '';
    success = 1;      
  end  
  else
  begin
    message = 'NO_VALID_PERSON_ID';
    success = 0;
    suspend;
    Exit;     
  end
  
  suspend;
end
^   

COMMENT ON PROCEDURE SP_INSERT_PERSON IS
'Personendaten einfügen'^

COMMIT WORK^

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_INSERT_PERSON'^

CREATE OR ALTER PROCEDURE SP_INSERT_ADDRESS(
  ATENANT_ID integer,  /* wenn Adresse: Pflichtfeld */
  AADDRESS_TYPE_ID integer, /* wenn Adresse: Pflichtfeld */
  ADISTRICT varchar(254),
  AZIPCODE integer, /* wenn Adresse: Pflichtfeld */
  ACITY varchar(254), /* wenn Adresse: Pflichtfeld */
  APOST_OFFICE_BOX varchar(254),        
  ASTREET varchar(254), /* wenn Adresse: Pflichtfeld */
  ASTREET_ADDRESS_FROM varchar(127), /* wenn Adresse: Pflichtfeld */
  ASTREET_ADDRESS_TO varchar(127),
  AISPOSTADDRESS smallint,
  AISPRIVATE_ADDRESS smallint,
  ARELATION_TYPE RELATION_TYPE,
  ARELATION_ID integer,
  ADODUPLICATES smallint)
RETURNS(
  success smallint,
  message varchar(254),
  address_id integer)
AS
declare variable do_insert smallint;
begin
  success = 0;
  message = 'FAILD_BY_UNKNOWN_REASON';
  address_id = -1;
  do_insert = -1;
  
  /* Überprüfen ob Adressdaten vorhanden; wenn ja, dann vorhandene Daten updaten ansonsten insert */  
  if (ADODUPLICATES = 1) then
  begin       
    select 
      iif(ADDRESS_ID is null, -1, ADDRESS_ID) as ADDESS_ID 
    from 
      V_REL_ADDRESSBOOKITEM_DETAILS 
    where
      TENANT_ID=:ATENANT_ID
      and
        (
          (
            ADDRESS_TYPE_ID is null
            and
            :AADDRESS_TYPE_ID is null
          )
          or
          ADDRESS_TYPE_ID=:AADDRESS_TYPE_ID
        )                 
      and
        (
          (
            STREET is null
            and
            :ASTREET is null
          )
          or
          STREET=:ASTREET
        )
      and
        (
          (
            STREET_ADDRESS_FROM is null
            and
            :ASTREET_ADDRESS_FROM is null
          )
          or
          STREET_ADDRESS_FROM=:ASTREET_ADDRESS_FROM    
        )
      and
        (
          (
            STREET_ADDRESS_TO is null
            and
            :ASTREET_ADDRESS_TO is null
          )
          or
          STREET_ADDRESS_TO=:ASTREET_ADDRESS_TO    
        )
      and
        (
          (
            CITY is null
            and
            :ACITY is null
          )
          or
          CITY=:ACITY    
        )                 
      and
        (
          (
            DISTRICT is null
            and
            :ADISTRICT is null
          )
          or
          DISTRICT=:ADISTRICT
        )                 
      and
        (
          (
            ZIPCODE is null
            and
            :AZIPCODE is null
          )
          or
          ZIPCODE=:AZIPCODE
        )                 
      and
        (
          (
            POST_OFFICE_BOX is null
            and
            :APOST_OFFICE_BOX is null
          )
          or
          POST_OFFICE_BOX=:APOST_OFFICE_BOX
        )                 
      and
        (
          (
            ISPOSTADDRESS is null
            and
            :AISPOSTADDRESS is null
          )
          or
          ISPOSTADDRESS=:AISPOSTADDRESS
        )                 
      and
        (
          (
            ISPRIVATE_ADDRESS is null
            and
            :AISPRIVATE_ADDRESS is null
          )
          or
          ISPRIVATE_ADDRESS=:AISPRIVATE_ADDRESS 
        )
    into
     :address_id;
      
    if ((address_id is not null) and (address_id <> -1)) then
    begin   
      do_insert = 0;
    end
    else
    begin
      address_id = -1;
    end
  end 
  
  if (address_id = -1) then
  begin
    select SEQ_ID from SP_GET_SEQUENCEID_BY_IDENT('ADDRESS') into :address_id;
    do_insert = 1;
  end
   
  if ((address_id <> -1) and (address_id is not null)) then
  begin
    if (do_insert not in (0,1)) then
    begin
      success = 0;
      message = 'FAILD_BY_OBSCURE_PROCESSING';
      suspend;
      Exit;
    end

    if (do_insert = 1) then
    begin
      insert
      into
        V_ADDRESS
        (         
          ID,
          TENANT_ID,
          ADDRESS_TYPE_ID,
          STREET,
          STREET_ADDRESS_FROM,
          STREET_ADDRESS_TO,
          CITY,
          DISTRICT,
          ZIPCODE,
          POST_OFFICE_BOX,
          ISPOSTADDRESS,
          ISPRIVATE          
        )
      values
        (
          :address_id,
          :ATENANT_ID,
          :AADDRESS_TYPE_ID,
          :ASTREET,
          :ASTREET_ADDRESS_FROM,
          :ASTREET_ADDRESS_TO,
          :ACITY,                        
          :ADISTRICT,            
          :AZIPCODE,            
          :APOST_OFFICE_BOX,        
          :AISPOSTADDRESS,
          :AISPRIVATE_ADDRESS
        );  
    end
    else
    begin
      update
        V_ADDRESS
      set
        TENANT_ID=:ATENANT_ID,
        ADDRESS_TYPE_ID=:AADDRESS_TYPE_ID,
        STREET=:ASTREET,
        STREET_ADDRESS_FROM=:ASTREET_ADDRESS_FROM,
        STREET_ADDRESS_TO=:ASTREET_ADDRESS_TO,
        CITY=:ACITY,
        DISTRICT=:ADISTRICT,
        ZIPCODE=:AZIPCODE,
        POST_OFFICE_BOX=:APOST_OFFICE_BOX,
        ISPOSTADDRESS=:AISPOSTADDRESS,
        ISPRIVATE=:AISPRIVATE_ADDRESS
      where
        ID=:address_id;      
    end
    
    /* Relation anlegen */
    if (ARELATION_TYPE = 'BY_PERSON') then
    begin
      if (not exists(select 1 from V_REL_PERSON_ADDRESS where PERSON_ID=:ARELATION_ID and ADDRESS_ID=:address_id)) then
      begin
        insert
        into
          V_REL_PERSON_ADDRESS
          (
            PERSON_ID,
            ADDRESS_ID
          )
        values
          (
            :ARELATION_ID,
            :address_id
          );  
      end
    end
    
    message = '';
    success = 1;      
  end  
  else
  begin
    message = 'NO_VALID_ADDRESS_ID';
    success = 0;
    suspend;
    Exit;     
  end 
     
  suspend;
end
^                             
                          
COMMENT ON PROCEDURE SP_INSERT_ADDRESS IS
'Adressdaten einfügen'^                          

COMMIT WORK^

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_INSERT_ADDRESS'^

CREATE OR ALTER PROCEDURE SP_INSERT_CONTACT(
  ATENANT_ID integer,  /* wenn Kontaktdaten: Pflichtfeld */
  ACONTACT_TYPE_ID integer, /* wenn Kontaktdaten: Pflichtfeld */      
  AAREA_CODE varchar(5),
  APHONE_FMT varchar(127), /* wenn Kontaktdaten: mindestens ein weiteres Kontdaktdatenfeld als Pflichtfeld */
  AFAX_FMT varchar(127), /* wenn Kontaktdaten: mindestens ein weiteres Kontdaktdatenfeld als Pflichtfeld */
  AWWW varchar(254), /* wenn Kontaktdaten: mindestens ein weiteres Kontdaktdatenfeld als Pflichtfeld */
  AEMAIL varchar(254), /* wenn Kontaktdaten: mindestens ein weiteres Kontdaktdatenfeld als Pflichtfeld */ 
  ASKYPE varchar(32), /* wenn Kontaktdaten: mindestens ein weiteres Kontdaktdatenfeld als Pflichtfeld */
  AMESSANGERNAME varchar(32),
  ARELATION_TYPE RELATION_TYPE,
  ARELATION_ID integer,
  ADODUPLICATES smallint)
RETURNS(
  success smallint,
  message varchar(254),
  contact_id integer)
AS
declare variable do_insert smallint;
begin
  success = 0;
  message = 'FAILD_BY_UNKNOWN_REASON';
  contact_id = -1;
  
  /* Überprüfen ob Kontaktdaten vorhanden; wenn ja, dann vorhandene Daten updaten ansonsten insert */
  if (ADODUPLICATES = 1) then
  begin       
    select 
      iif(CONTACT_ID is null, -1, CONTACT_ID) as CONTACT_ID 
    from 
      V_REL_ADDRESSBOOKITEM_DETAILS 
    where
      TENANT_ID=:ATENANT_ID
      and
        (
          (
            CONTACT_TYPE_ID is null
            and
            :ACONTACT_TYPE_ID is null
          )
          or
          CONTACT_TYPE_ID=:ACONTACT_TYPE_ID
        )      
      and
        (
          (
            AREA_CODE is null
            and
            :AAREA_CODE is null
          )
          or
          AREA_CODE=:AAREA_CODE
        )
      and
        (
          (
            PHONE_FMT is null
            and
            :APHONE_FMT is null
          )
          or
          PHONE_FMT=:APHONE_FMT
        )      
      and
        (
          (
            FAX_FMT is null
            and
            :AFAX_FMT is null
          )
          or
          FAX_FMT=:AFAX_FMT
        )
      and
        (
          (
            WWW is null
            and
            :AWWW is null
          )
          or
          WWW=:AWWW
        )
      and
        (
          (
            EMAIL is null
            and
            :AEMAIL is null
          )
          or
          EMAIL=:AEMAIL
        )
      and
        (
          (
            SKYPE is null
            and
            :ASKYPE is null
          )
          or
          SKYPE=:ASKYPE
        )      
      and
        (
          (
            MESSANGERNAME is null
            and
            :AMESSANGERNAME is null
          )
          or
          MESSANGERNAME=:AMESSANGERNAME
        )      
    into
      :contact_id;

    if ((contact_id is not null) and (contact_id <> -1)) then
    begin   
      do_insert = 0;
    end
    else
    begin
      contact_id = -1;
    end
  end  
  
  if (contact_id = -1) then
  begin
    select SEQ_ID from SP_GET_SEQUENCEID_BY_IDENT('CONTACT') into :contact_id;
    do_insert = 1;
  end 
  
  if ((contact_id <> -1) and (contact_id is not null)) then
  begin
    if (do_insert not in (0,1)) then
    begin
      success = 0;
      message = 'FAILD_BY_OBSCURE_PROCESSING';
      suspend;
      Exit;
    end

    if (do_insert = 1) then
    begin
      insert
      into
        V_CONTACT
        (
          ID,
          TENANT_ID,
          CONTACT_TYPE_ID,
          AREA_CODE,
          PHONE_FMT,
          FAX_FMT,
          WWW,
          EMAIL,
          SKYPE,
          MESSANGERNAME        
        )
      values
        (
          :contact_id,
          :ATENANT_ID,
          :ACONTACT_TYPE_ID,      
          :AAREA_CODE,
          :APHONE_FMT,
          :AFAX_FMT,
          :AWWW,
          :AEMAIL, 
          :ASKYPE,
          :AMESSANGERNAME        
        );  
    end
    else
    begin
      update
        V_CONTACT
      set
        TENANT_ID=:ATENANT_ID,
        CONTACT_TYPE_ID=:ACONTACT_TYPE_ID,
        AREA_CODE=:AAREA_CODE,
        PHONE_FMT=:APHONE_FMT,
        FAX_FMT=:AFAX_FMT,
        WWW=:AWWW,
        EMAIL=:AEMAIL,
        SKYPE=:ASKYPE,
        MESSANGERNAME=:AMESSANGERNAME
      where
        ID=:contact_id;
    end
  
    /* Relation anlegen */
    if (ARELATION_TYPE = 'BY_PERSON') then
    begin
      if (not exists(select 1 from V_REL_PERSON_CONTACT where PERSON_ID=:ARELATION_ID and CONTACT_ID=:contact_id)) then
      begin
        insert
        into
          V_REL_PERSON_CONTACT
          (
            PERSON_ID,
            CONTACT_ID
          )
        values
          (
            :ARELATION_ID,
            :contact_id
          );            
      end
    end
    
    message = '';
    success = 1;      
  end  
  else
  begin
    message = 'NO_VALID_CONTACT_ID';
    success = 0;
    suspend;
    Exit;     
  end
    
  suspend;
end
^                            

COMMENT ON PROCEDURE SP_INSERT_CONTACT IS
'Kontaktdaten einfügen'^

COMMIT WORK^

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_INSERT_CONTACT'^

CREATE OR ALTER PROCEDURE SP_INSERT_BANK(
  ATENANT_ID integer,  /* wenn Bankdaten: Pflichtfeld */
  ADEPOSITOR varchar(254), /* wenn Bankdaten: Pflichtfeld */
  ABLZ_FMT varchar(10), /* wenn Bankdaten: Pflichtfeld */       
  AKTO_FMT varchar(10), /* wenn Bankdaten: Pflichtfeld */
  AIBAN varchar(30),
  ABIC varchar(11),        
  ARELATION_TYPE RELATION_TYPE,
  ARELATION_ID integer,
  ADODUPLICATES smallint)
RETURNS(
  success smallint,
  message varchar(254),
  bank_id integer)
AS
declare variable do_insert smallint;
begin
  success = 0;
  message = 'FAILD_BY_UNKNOWN_REASON';
  bank_id = -1;
  do_insert = -1;
  
  /* 1. Üeberprüfen ob Banktdaten vorhanden; wenn ja, dann vorhandene Daten updaten ansonsten insert */
  if (ADODUPLICATES = 1) then
  begin
    select 
      iif(BANK_ID is null, -1, BANK_ID) as BANK_ID 
    from 
      V_REL_ADDRESSBOOKITEM_DETAILS 
    where
      TENANT_ID=:ATENANT_ID
      and
      (
        (
          CAPTION is null
          and
          :ADEPOSITOR is null          
        )
        or
        CAPTION=:ADEPOSITOR
      )            
      and
      (
        (
          BLZ_FMT is null
          and
          :ABLZ_FMT is null
        )
        or
        BLZ_FMT=:ABLZ_FMT
      )            
      and
      (
        (
          KTO_FMT is null
          and
          :AKTO_FMT is null
        )
        or
        KTO_FMT=:AKTO_FMT
      )      
      and
      (
        (
          IBAN is null
          and
          :AIBAN is null
        )
        or
        IBAN=:AIBAN
      )      
      and
      (
        (
          BIC is null
          and
          :ABIC is null
        )
        or
        BIC=:ABIC
      )      
    into
      :bank_id;  
                 
    if ((bank_id is not null) and (bank_id <> -1)) then
    begin
      do_insert = 0;
    end
    else
    begin
      bank_id = -1;
    end
  end
  
  if (bank_id = -1) then
  begin
    select SEQ_ID from SP_GET_SEQUENCEID_BY_IDENT('BANK') into :bank_id;
    do_insert = 1;
  end  
  
  if ((bank_id <> -1) and (bank_id is not null)) then
  begin
    if (do_insert not in (0,1)) then
    begin
      success = 0;
      message = 'FAILD_BY_OBSCURE_PROCESSING';
      suspend;
      Exit;
    end

    if (do_insert = 1) then
    begin
      insert
      into
        V_BANK
        (
          ID,
          TENANT_ID,
          CAPTION,
          BLZ_FMT,
          KTO_FMT,
          IBAN,
          BIC        
        )
      values
        (
          :bank_id,
          :ATENANT_ID,
          :ADEPOSITOR,
          :ABLZ_FMT,       
          :AKTO_FMT,
          :AIBAN,
          :ABIC        
        );  
    end
    else
    begin
      update
        V_BANK
      set
          TENANT_ID=:ATENANT_ID,
          CAPTION=:ADEPOSITOR,
          BLZ_FMT=:ABLZ_FMT,
          KTO_FMT=:AKTO_FMT,
          IBAN=:AIBAN,
          BIC=:ABIC
      where
        ID=:bank_id;
    end    
    
    /* Relation anlegen */
    if (ARELATION_TYPE = 'BY_PERSON') then
    begin
      if (not exists(select 1 from V_REL_PERSON_BANK where PERSON_ID=:ARELATION_ID and BANK_ID=:bank_id)) then
      begin
        insert
        into
          V_REL_PERSON_BANK
          (
            PERSON_ID,
            BANK_ID
          )
        values
          (
            :ARELATION_ID,
            :bank_id
          );            
      end  
    end
    
    message = '';
    success = 1;      
  end  
  else
  begin
    message = 'NO_VALID_BANK_ID';
    success = 0;
    suspend;
    Exit;     
  end  
  
  suspend;
end
^                            
                       
COMMENT ON PROCEDURE SP_INSERT_BANK IS
'Kontaktdaten einfügen'^                       

COMMIT WORK^

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_INSERT_BANK'^

CREATE OR ALTER PROCEDURE SP_INSERT_DOCUMENT(
  ATENANT_ID integer,  /* Pflichtfeld */
  APHOTO_UNIQUE_NAME varchar(254),
  APHOTO_REAL_NAME varchar(254),/* wenn true wird ein Foto erwatet */
  APHOTO_EXT varchar(64), 
  ARELATION_TYPE RELATION_TYPE,
  ARELATION_ID integer,
  ADODUPLICATES smallint)
RETURNS(
  success smallint,
  message varchar(254),
  document_id integer)
AS
declare variable do_insert smallint;
begin
  success = 0;
  message = 'FAILD_BY_UNKNOWN_REASON';
  document_id = -1;
  do_insert = -1;
  
  /* Üeberprüfen ob Dokumente vorhanden; wenn ja, dann vorhandene Daten updaten ansonsten insert */  
  if (exists(select 1 from V_DOCUMENT where TENANT_ID=:ATENANT_ID and UNIQUE_NAME=:APHOTO_UNIQUE_NAME)) then
  begin
    select ID from V_DOCUMENT where TENANT_ID=:ATENANT_ID and UNIQUE_NAME=:APHOTO_UNIQUE_NAME into :document_id;      
    do_insert = 0;  
  end 
  
  if ((document_id = -1) and (document_id is not null)) then
  begin
    select SEQ_ID from SP_GET_SEQUENCEID_BY_IDENT('DOCUMENT') into :document_id;
    if ((APHOTO_UNIQUE_NAME is null) or (Trim(APHOTO_UNIQUE_NAME) = '')) then
    begin
      select UNIQUENAME from SP_UNIQUENAME(:ATENANT_ID, :APHOTO_EXT) into :APHOTO_UNIQUE_NAME;
    end
    do_insert = 1;
  end
  
  if ((document_id <> -1) and (document_id is not null)) then
  begin
    if (do_insert not in (0,1)) then
    begin
      success = 0;
      message = 'FAILD_BY_OBSCURE_PROCESSING';
      suspend;
      Exit;
    end
    
    if (do_insert = 1) then
    begin
      insert
      into
        V_DOCUMENT
        (
          ID,
          TENANT_ID,
          UNIQUE_NAME,
          REAL_NAME
        )
      values
        (
          :document_id,
          :ATENANT_ID,
          :APHOTO_UNIQUE_NAME,
          :APHOTO_REAL_NAME
        );  
    end
    else
    begin
      update
        V_DOCUMENT
      set
        TENANT_ID=:ATENANT_ID,
        UNIQUE_NAME=:APHOTO_UNIQUE_NAME,
        REAL_NAME=:APHOTO_REAL_NAME     
      where
        ID=:document_id;
    end    
      
    /* Fremdschlüsel anlegen */
    if (ARELATION_TYPE = 'BY_PERSON') then
    begin
      if (exists(select 1 from V_PERSON where ID=:ARELATION_ID)) then
      begin
        update
          V_PERSON
        set
          PICTURE_ID=:document_id
        where
          ID=:ARELATION_ID;            
      end    
    end
  
    /* Wenn erfolgreich, wird immer der eindeutige Name der Fotodatei übergeben */
    message = APHOTO_UNIQUE_NAME;
    success = 1;      
  end  
  else
  begin
    message = 'NO_VALID_DOCUMENT_ID';
    success = 0; 
    suspend;
    Exit;
  end  
  
  suspend;
end
^                         
                           
COMMENT ON PROCEDURE SP_INSERT_DOCUMENT IS
'Dokumentendaten einfügen'^                           

COMMIT WORK^

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_INSERT_DOCUMENT'^

CREATE OR ALTER PROCEDURE SP_ADD_ADDRESSBOOKITEM (
  ATENANT_ID integer,  /* Pflichtfeld */
  ASALUTATION_ID integer, /* Pflichtfeld */
  AALTSALUTATION varchar(126),
  ATITEL_ID integer, /* Pflichtfeld */
  AFIRSTNAME varchar(126),
  ANAME varchar(126), /* Pflichtfeld */
  ANAME2 varchar(126),
  ADAY_OF_BIRTH date,
  AISPRIVATE_PERSON smallint,
  /* Ehepartner */
  AISMARRIED  smallint, /* wenn true werden daten zum Ehepartner erwartet */
  AMARRIED_TO_ID integer, 
  AMARRIED_SINCE date,
  AMARRIAGE_PARTNER_FIRSTNAME varchar(126),
  AMARRIAGE_PARTNER_NAME1 varchar(126), /* wenn verheiratet: Pflichtfeld */ 
  /* Adresse */
  AADDRESSDATAPRESENT smallint, /* wenn true werden Daten zur Addresse erwatet */
  AADDRESS_TYPE_ID integer, /* wenn Adresse: Pflichtfeld */
  ADISTRICT varchar(254),
  AZIPCODE integer, /* wenn Adresse: Pflichtfeld */
  ACITY varchar(254), /* wenn Adresse: Pflichtfeld */
  APOST_OFFICE_BOX varchar(254),        
  ASTREET varchar(254), /* wenn Adresse: Pflichtfeld */
  ASTREET_ADDRESS_FROM varchar(127), /* wenn Adresse: Pflichtfeld */
  ASTREET_ADDRESS_TO varchar(127),
  AISPOSTADDRESS smallint,
  AISPRIVATE_ADDRESS smallint,
  /* Kontaktdaten */
  ACONTACTDATAPRESENT smallint, /* wenn true werden Daten zu Kontakten erwatet */
  ACONTACT_TYPE_ID integer, /* wenn Kontaktdaten: Pflichtfeld */      
  AAREA_CODE varchar(5),
  APHONE_FMT varchar(127), /* wenn Kontaktdaten: mindestens ein weiteres Kontdaktdatenfeld als Pflichtfeld */
  AFAX_FMT varchar(127), /* wenn Kontaktdaten: mindestens ein weiteres Kontdaktdatenfeld als Pflichtfeld */
  AWWW varchar(254), /* wenn Kontaktdaten: mindestens ein weiteres Kontdaktdatenfeld als Pflichtfeld */
  AEMAIL varchar(254), /* wenn Kontaktdaten: mindestens ein weiteres Kontdaktdatenfeld als Pflichtfeld */ 
  ASKYPE varchar(32), /* wenn Kontaktdaten: mindestens ein weiteres Kontdaktdatenfeld als Pflichtfeld */
  AMESSANGERNAME varchar(32), /* wenn Kontaktdaten: mindestens ein weiteres Kontdaktdatenfeld als Pflichtfeld */
  /* Bankinformationen */  
  ABANKDATAPRESENT smallint, /* wenn true werden Daten zur Bankverbindung erwatet */
  ADEPOSITOR varchar(254), /* wenn Bankdaten: Pflichtfeld */
  ABLZ_FMT varchar(10), /* wenn Bankdaten: Pflichtfeld */       
  AKTO_FMT varchar(10), /* wenn Bankdaten: Pflichtfeld */
  AIBAN varchar(30),
  ABIC varchar(11), 
  /* Info */
  AINFODATAPRESENT smallint, /* wenn true werden Informationen erwatet */
  AINFO BLOB SUB_TYPE TEXT SEGMENT SIZE 16384,
  /* Photo */
  APHOTOPRESENT smallint,
  APHOTO_UNIQUE_NAME varchar(254),
  APHOTO_REAL_NAME varchar(254),/* wenn true wird ein Foto erwatet */
  APHOTO_EXT varchar(64))
RETURNS (
  success smallint,
  code smallint,
  info varchar(2000))
AS
declare variable person_id integer;
declare variable address_id integer;
declare variable contact_id integer;
declare variable bank_id integer;
declare variable document_id integer;
declare variable message varchar(254);
declare variable do_duplicates smallint;
declare variable uniquename UNIQUE_NAME;
begin
  success = 0;
  code = 0;
  info = '{"result": null}';  
  do_duplicates = 0;

  /* Es werden alle Pflichtfelder überprüft */
  select 
    success, 
    code, 
    info 
  from 
    SP_CHK_DATA_BY_ADD_ADDRESSITEM(:ATENANT_ID,
                                   :ASALUTATION_ID,
                                   :AALTSALUTATION,
                                   :ATITEL_ID,
                                   :AFIRSTNAME,
                                   :ANAME,
                                   :ANAME2,
                                   :ADAY_OF_BIRTH,
                                   :AISPRIVATE_PERSON,
                                   :AISMARRIED,
                                   :AMARRIED_TO_ID, 
                                   :AMARRIED_SINCE,
                                   :AMARRIAGE_PARTNER_FIRSTNAME,
                                   :AMARRIAGE_PARTNER_NAME1, 
                                   :AADDRESSDATAPRESENT,
                                   :AADDRESS_TYPE_ID,
                                   :ADISTRICT,
                                   :AZIPCODE,
                                   :ACITY,
                                   :APOST_OFFICE_BOX,        
                                   :ASTREET,
                                   :ASTREET_ADDRESS_FROM,
                                   :ASTREET_ADDRESS_TO,
                                   :AISPOSTADDRESS,
                                   :AISPRIVATE_ADDRESS,
                                   :ACONTACTDATAPRESENT,
                                   :ACONTACT_TYPE_ID,      
                                   :AAREA_CODE,
                                   :APHONE_FMT,
                                   :AFAX_FMT,
                                   :AWWW,
                                   :AEMAIL, 
                                   :ASKYPE,
                                   :AMESSANGERNAME,  
                                   :ABANKDATAPRESENT,
                                   :ADEPOSITOR,
                                   :ABLZ_FMT,       
                                   :AKTO_FMT,
                                   :AIBAN,
                                   :ABIC, 
                                   :AINFODATAPRESENT,
                                   :AINFO,
                                   :APHOTOPRESENT,
                                   :APHOTO_UNIQUE_NAME,
                                   :APHOTO_REAL_NAME) 
  into 
    :success, 
    :code, 
    :info;
    
  if (success = 1) then
  begin
    /* Wenn alle Pflichtfelder vorhanden, Resultfelder wieder auf 0 setzen */ 
    
    success = 0;
    code = 0;
    info = '{"result": null}';
          
    select result from SP_READINTEGER('ADDRESSBOOK', 'CHECK', 'ALLOW_DUPLICATES', 0) into :do_duplicates;      
          
    /* Personendaten anlegen */
    select 
      success,
      message,
      person_id 
    from 
      SP_INSERT_PERSON(:ATENANT_ID,
                       :ASALUTATION_ID,
                       :AALTSALUTATION,
                       :ATITEL_ID,
                       :AFIRSTNAME,
                       :ANAME,
                       :ANAME2,
                       :ADAY_OF_BIRTH,
                       :AISPRIVATE_PERSON,
                       :AISMARRIED,
                       :AMARRIED_TO_ID, 
                       :AMARRIED_SINCE,
                       :AMARRIAGE_PARTNER_FIRSTNAME,
                       :AMARRIAGE_PARTNER_NAME1,
                       :AINFODATAPRESENT,
                       :AINFO,
                       :do_duplicates) 
    into 
      :success,
      :message,
      :person_id;
          
    /* Rückgabe auswerten */          
    if (success = 0) then
    begin
      code = 1;
      info = '{"kind": 2, "publish": "INSERT_BY_PERSON_FAILD", "list": [{"message": "INSERT_BY_PERSON_FAILD"}, {"message": "' || :message || '"}]}';
      suspend;
      Exit;
    end
    
    if (AADDRESSDATAPRESENT = 1) then
    begin
      success = 0;
          
      /* Adressdaten anlegen */
      select
        success,
        message,
        address_id
      from
        SP_INSERT_ADDRESS(:ATENANT_ID,
                          :AADDRESS_TYPE_ID,
                          :ADISTRICT,
                          :AZIPCODE,
                          :ACITY,
                          :APOST_OFFICE_BOX,        
                          :ASTREET,
                          :ASTREET_ADDRESS_FROM,
                          :ASTREET_ADDRESS_TO,
                          :AISPOSTADDRESS,
                          :AISPRIVATE_ADDRESS,
                          'BY_PERSON' /* Relationkind */,
                          :person_id /* Relation-ID */,
                          :do_duplicates)
      into
        :success,
        :message,
        :address_id;
        
      /* Rückgabe auswerten */     
      if (success = 0) then
      begin
        code = 1;
        info = '{"kind": 2, "publish": "INSERT_BY_ADDRESS_FAILD", "list": [{"message": "INSERT_BY_ADDRESS_FAILD"}, {"message": "' || :message || '"}]}';
        suspend;
        Exit;
      end        
    end
    
    if (ACONTACTDATAPRESENT = 1) then
    begin
      success = 0;
          
      /* Kontaktdaten */
      select
        success,
        message,
        contact_id
      from
        SP_INSERT_CONTACT(:ATENANT_ID,
                          :ACONTACT_TYPE_ID,      
                          :AAREA_CODE,
                          :APHONE_FMT,
                          :AFAX_FMT,
                          :AWWW,
                          :AEMAIL, 
                          :ASKYPE,
                          :AMESSANGERNAME,
                          'BY_PERSON' /* Relationkind */,
                          :person_id /* Relation-ID */,
                          :do_duplicates)
      into
        :success,
        :message,
        :contact_id;
        
      /* Rückgabe auswerten */     
      if (success = 0) then
      begin
        code = 1;
        info = '{"kind": 2, "publish": "INSERT_BY_CONTACT_FAILD", "list": [{"message": "INSERT_BY_CONTACT_FAILD"}, {"message": "' || :message || '"}]}';
        suspend;
        Exit;
      end        
    end
                              
    if (ABANKDATAPRESENT = 1) then
    begin
      success = 0;
                  
      /* Bankdaten anlegen */
      select
        success,
        message,
        bank_id
      from
        SP_INSERT_BANK(:ATENANT_ID,
                       :ADEPOSITOR,
                       :ABLZ_FMT,       
                       :AKTO_FMT,
                       :AIBAN,
                       :ABIC,        
                       'BY_PERSON' /* Relationkind */,
                       :person_id /* Relation-ID */,
                       :do_duplicates)
      into
        :success,
        :message,
        :bank_id;
        
      /* Rückgabe auswerten */     
      if (success = 0) then
      begin
        code = 1;
        info = '{"kind": 2, "publish": "INSERT_BY_BANK_FAILD", "list": [{"message": "INSERT_BY_BANK_FAILD"}, {"message": "' || :message || '"}]}';
        suspend;
        Exit;
      end        
    end
      
    if (APHOTOPRESENT = 1) then
    begin
      success = 0;
          
      /* Photo anlegen */
      select 
        success,
        message,
        document_id 
      from 
        SP_INSERT_DOCUMENT(:ATENANT_ID,
                           :APHOTO_UNIQUE_NAME,
                           :APHOTO_REAL_NAME,
                           :APHOTO_EXT,
                           'BY_PERSON' /* Ref.-Tabellenname */, 
                           :person_id /* PK der Ref.-Tabelle */,
                           :do_duplicates)
      into
        :success,
        :message,
        :document_id;
        
      /* Rückgabe auswerten */     
      if (success = 0) then
      begin
        code = 1;
        info = '{"kind": 2, "publish": "INSERT_BY_DOCUMENT_FAILD", "list": [{"message": "INSERT_BY_DOCUMENT_FAILD"}, {"message": "' || :message || '"}]}';
        suspend;
        Exit;
      end
      else
      begin
        uniquename = message;
      end                           
    end

    /* success = 1; -> success sollte nur durch die Insert-SPs auf 1 gesetzt werden */
    code = 1;
    if (success = 1) then
    begin
      if (APHOTOPRESENT = 1) then
      begin
        info = '{"kind": 4, "publish": "ADD_ADDRESSBOOKITEM_SUCCEEDED", "message": "ADD_ADDRESSBOOKITEM_SUCCEEDED", "uniquename": "' || uniquename || '"}';
      end
      else
      begin
        info = '{"kind": 3, "publish": "ADD_ADDRESSBOOKITEM_SUCCEEDED", "message": "ADD_ADDRESSBOOKITEM_SUCCEEDED"}';
      end
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

COMMENT ON PROCEDURE SP_ADD_ADDRESSBOOKITEM IS
'Überprüft Eingaben und legt Addressbucheintrag an'^

COMMIT WORK^

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_ADD_ADDRESSBOOKITEM'^

CREATE OR ALTER PROCEDURE SP_ADD_ADDRESSBOOKITEM_BY_SRV (
  ASESSION_ID varchar(254),  
  AUSERNAME varchar(254),
  AIP varchar(254),
  ATENANT_ID integer,  /* Pflichtfeld */
  ASALUTATION_ID integer, /* Pflichtfeld */
  AALTSALUTATION varchar(126),
  ATITEL_ID integer, /* Pflichtfeld */
  AFIRSTNAME varchar(126),
  ANAME varchar(126), /* Pflichtfeld */
  ANAME2 varchar(126),
  ADAY_OF_BIRTH date,
  AISPRIVATE_PERSON smallint,
  AISMARRIED  smallint, /* wenn true werden daten zum Ehepartner erwartet */
  AMARRIED_TO_ID integer, 
  AMARRIED_SINCE date,
  AMARRIAGE_PARTNER_FIRSTNAME varchar(126),
  AMARRIAGE_PARTNER_NAME1 varchar(126), /* wenn verheiratet: Pflichtfeld */ 
  AADDRESSDATAPRESENT smallint, /* wenn true werden Daten zur Addresse erwatet */
  AADDRESS_TYPE_ID integer, /* wenn Adresse: Pflichtfeld */
  ADISTRICT varchar(254),
  AZIPCODE integer, /* wenn Adresse: Pflichtfeld */
  ACITY varchar(254), /* wenn Adresse: Pflichtfeld */
  APOST_OFFICE_BOX varchar(254),        
  ASTREET varchar(254), /* wenn Adresse: Pflichtfeld */
  ASTREET_ADDRESS_FROM varchar(127), /* wenn Adresse: Pflichtfeld */
  ASTREET_ADDRESS_TO varchar(127),
  AISPOSTADDRESS smallint,
  AISPRIVATE_ADDRESS smallint,
  ACONTACTDATAPRESENT smallint, /* wenn true werden Daten zu Kontakten erwatet */
  ACONTACT_TYPE_ID integer, /* wenn Kontaktdaten: Pflichtfeld */      
  AAREA_CODE varchar(5),
  APHONE_FMT varchar(127), /* wenn Kontaktdaten: mindestens ein weiteres Kontdaktdatenfeld als Pflichtfeld */
  AFAX_FMT varchar(127), /* wenn Kontaktdaten: mindestens ein weiteres Kontdaktdatenfeld als Pflichtfeld */
  AWWW varchar(254), /* wenn Kontaktdaten: mindestens ein weiteres Kontdaktdatenfeld als Pflichtfeld */
  AEMAIL varchar(254), /* wenn Kontaktdaten: mindestens ein weiteres Kontdaktdatenfeld als Pflichtfeld */ 
  ASKYPE varchar(32), /* wenn Kontaktdaten: mindestens ein weiteres Kontdaktdatenfeld als Pflichtfeld */
  AMESSANGERNAME varchar(32), /* wenn Kontaktdaten: mindestens ein weiteres Kontdaktdatenfeld als Pflichtfeld */  
  ABANKDATAPRESENT smallint, /* wenn true werden Daten zur Bankverbindung erwatet */
  ADEPOSITOR varchar(254), /* wenn Bankdaten: Pflichtfeld */
  ABLZ_FMT varchar(10), /* wenn Bankdaten: Pflichtfeld */       
  AKTO_FMT varchar(10), /* wenn Bankdaten: Pflichtfeld */
  AIBAN varchar(30),
  ABIC varchar(11), 
  AINFODATAPRESENT smallint, /* wenn true werden Informationen erwatet */
  AINFO BLOB SUB_TYPE TEXT SEGMENT SIZE 16384,
  APHOTOPRESENT smallint,
  APHOTO_UNIQUE_NAME varchar(254),
  APHOTO_REAL_NAME varchar(254), /* wenn true wird ein Foto erwatet */
  APHOTO_EXT varchar(64))
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
    select success from SP_CHECKGRANT(:AUSERNAME, 'MEMBERS') into :success_by_grant;
    
    if (success_by_grant = 1) then
    begin
      /* Wenn der JSON-String im Feld INFO zu lang wird, wird von der SP zwei oder mehrere Datensätze erzeugt.
         Aus diesem Grund wird die SP über eine FOR-Loop abgefragt
      */
      for select success, code, info from SP_ADD_ADDRESSBOOKITEM(:ATENANT_ID,
                                                                 :ASALUTATION_ID,
                                                                 :AALTSALUTATION,
                                                                 :ATITEL_ID,
                                                                 :AFIRSTNAME,
                                                                 :ANAME,
                                                                 :ANAME2,
                                                                 :ADAY_OF_BIRTH,
                                                                 :AISPRIVATE_PERSON,
                                                                 :AISMARRIED,
                                                                 :AMARRIED_TO_ID, 
                                                                 :AMARRIED_SINCE,
                                                                 :AMARRIAGE_PARTNER_FIRSTNAME,
                                                                 :AMARRIAGE_PARTNER_NAME1, 
                                                                 :AADDRESSDATAPRESENT,
                                                                 :AADDRESS_TYPE_ID,
                                                                 :ADISTRICT,
                                                                 :AZIPCODE,
                                                                 :ACITY,
                                                                 :APOST_OFFICE_BOX,        
                                                                 :ASTREET,
                                                                 :ASTREET_ADDRESS_FROM,
                                                                 :ASTREET_ADDRESS_TO,
                                                                 :AISPOSTADDRESS,
                                                                 :AISPRIVATE_ADDRESS,
                                                                 :ACONTACTDATAPRESENT,
                                                                 :ACONTACT_TYPE_ID,      
                                                                 :AAREA_CODE,
                                                                 :APHONE_FMT,
                                                                 :AFAX_FMT,
                                                                 :AWWW,
                                                                 :AEMAIL, 
                                                                 :ASKYPE,
                                                                 :AMESSANGERNAME,  
                                                                 :ABANKDATAPRESENT,
                                                                 :ADEPOSITOR,
                                                                 :ABLZ_FMT,       
                                                                 :AKTO_FMT,
                                                                 :AIBAN,
                                                                 :ABIC, 
                                                                 :AINFODATAPRESENT,
                                                                 :AINFO,
                                                                 :APHOTOPRESENT,
                                                                 :APHOTO_UNIQUE_NAME,
                                                                 :APHOTO_REAL_NAME,
                                                                 :APHOTO_EXT) into :success, :code, :info do
      begin
        suspend;
      end 
    end
    else
    begin
      info = '{"kind": 1, "publish": "NO_GRANT_FOR_ADD_MEMBER", "message": "NO_GRANT_FOR_ADD_MEMBER"}';
      
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

COMMENT ON PROCEDURE SP_ADD_ADDRESSBOOKITEM_BY_SRV IS
'Überprüft Sitzungsverwaltung und ruft SP_ADD_ADDRESSBOOKITEM auf'^

COMMIT WORK^

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_ADD_ADDRESSBOOKITEM_BY_SRV'^

CREATE OR ALTER PROCEDURE SP_UPDATE_DOC_BY_FILE (
  ATENANT_ID integer,  /* Pflichtfeld */
  AFILE_UNIQUE_NAME UNIQUE_NAME,
  AFILE_REAL_NAME varchar(254),
  AMIMETYPE MIME_TYPE,
  ASUBTYPE MIME_SUBTYPE,
  ARELATION_TYPE RELATION_TYPE,
  AACCESS_MODE ACCESS_MODE,
  ADATA_OBJECT BLOB SUB_TYPE 0 SEGMENT SIZE 16384)
RETURNS (
  success smallint,
  code smallint,
  info varchar(2000))
AS
declare variable document_id integer;
declare variable check_mimetype varchar(254);
declare variable result_ident varchar(64);
declare variable result_value varchar(2000);
declare variable ident varchar(128);
declare variable value_for_ident varchar(255);
declare variable do_append smallint;
declare variable key_section varchar(128);
declare variable section varchar(128);
begin
  success = 0;
  code = 1;
  info = '{"kind": 0, "message": "FAILD_BY_UNKNOWN_REASON"}';
  document_id = -1; 
  do_append = 0;
  
  check_mimetype = Trim(AMIMETYPE) || '/' || Trim(ASUBTYPE);
  
  /* nur erlaubte Mimetypen anlegen */
  key_section = 'ADDRESSBOOK';
  section = 'MIMETYPE';  
  for 
    select 
      aident,
      avalue
    from 
      SP_READSECTION(:key_section, :section) 
    into 
      :result_ident, 
      :result_value 
    do
  begin
    if ((Lower(Trim(check_mimetype)) = Lower(Trim(result_ident))) and (result_value = 'TRUE')) then
    begin
      do_append = 1;
      Break;
    end
  end   
  
  if (do_append = 1) then
  begin
    if (exists(select 1 from V_DOCUMENT where TENANT_ID=:ATENANT_ID and REAL_NAME=:AFILE_REAL_NAME and UNIQUE_NAME=:AFILE_UNIQUE_NAME)) then
    begin
      select ID from V_DOCUMENT where TENANT_ID=:ATENANT_ID and REAL_NAME=:AFILE_REAL_NAME and UNIQUE_NAME=:AFILE_UNIQUE_NAME into :document_id;
    end
  
    if (AACCESS_MODE= 'UPDATE') then
    begin
      if (document_id = -1) then
      begin
        success = 0;
        code = 1;
        info = '{"kind": 0, "message": "NO_VALID_RECORD_FOUND"}';
        suspend;
        Exit;
      end
      else
      begin
        if (ARELATION_TYPE = 'BY_PERSON') then
        begin
          update
            V_DOCUMENT
          set
            MIME_TYPE=:AMIMETYPE,
            MIME_SUBTYPE=:ASUBTYPE,
            DATA_OBJECT=:ADATA_OBJECT
          where
            ID=:document_id;
        end
        else
        begin
          success = 0;
          code = 1;
          info = '{"kind": 0, "message": "NO_VALID_RELATIONTYPE"}';
          suspend;
          Exit;      
        end
      end
    end
    else
    begin
      success = 0;
      code = 1;
      info = '{"kind": 0, "message": "NO_VALID_ACCESSMODE"}';
      suspend;
      Exit;  
    end
    
    success = 1;
    code = 1;
    info = '{"kind": 0, "message": "ADD_FILERESOURCE_TO_DOCUMENT_SUCCEEDED"}';
  end
  else
  begin
    success = 0;
    code = 1;
    info = '{"kind": 0, "message": "NO_VALID_MIMETYPE"}';
    suspend;
    Exit;  
  end 

  suspend;
end^

COMMENT ON PROCEDURE SP_UPDATE_DOC_BY_FILE IS
'Führt eine Datei in die Documentenverwaltung ein'^

COMMIT WORK^

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_UPDATE_DOC_BY_FILE'^

CREATE OR ALTER PROCEDURE SP_UPDATE_DOC_BY_FILE_BY_SRV (
  ASESSION_ID varchar(254),  
  AUSERNAME varchar(254),
  AIP varchar(254),
  ATENANT_ID integer,  /* Pflichtfeld */
  AFILE_UNIQUE_NAME UNIQUE_NAME,
  AFILE_REAL_NAME varchar(254),
  AMIMETYPE MIME_TYPE,
  ASUBTYPE MIME_SUBTYPE,
  ARELATION_TYPE RELATION_TYPE,
  AACCESS_MODE ACCESS_MODE,
  ADATA_OBJECT BLOB SUB_TYPE 0 SEGMENT SIZE 16384)
RETURNS (
  success smallint,
  code smallint,
  info varchar(2000))
as  
declare variable success_by_touchsession smallint;
declare variable success_by_grant smallint;
begin
  success = 0;
  code = 0;
  info = '{"result": null}';

  select success from SP_TOUCHSESSION(:ASESSION_ID, :AUSERNAME, :AIP) into :success_by_touchsession;
  
  if (success_by_touchsession = 1) then
  begin
    select success from SP_CHECKGRANT(:AUSERNAME, 'FILERESOURCE') into :success_by_grant;
    
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
          SP_UPDATE_DOC_BY_FILE(:ATENANT_ID,
                                :AFILE_UNIQUE_NAME,
                                :AFILE_REAL_NAME,
                                :AMIMETYPE,
                                :ASUBTYPE,
                                :ARELATION_TYPE,
                                :AACCESS_MODE,
                                :ADATA_OBJECT)
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
      info = '{"kind": 1, "publish": "NO_GRANT_FOR_ADD_FILERESOURCE", "message": "NO_GRANT_FOR_ADD_FILERESOURCE"}';
      
      suspend;
    end
  end
  else
  begin
    info = '{"kind": 1, "publish": "CANCEL_PROCESS_BY_SESSIONMANAGEMENT", "message": "CANCEL_PROCESS_BY_SESSIONMANAGEMENT"}';
    
    suspend;
  end
end^

COMMENT ON PROCEDURE SP_UPDATE_DOC_BY_FILE_BY_SRV IS
'Checked die Sitzungsverwaltung und ruft SP_UPDATE_DOC_BY_FILE_BY_SRV auf'^

COMMIT WORK^

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_UPDATE_DOC_BY_FILE_BY_SRV'^

SET TERM ; ^ 

COMMIT WORK;
/******************************************************************************/
/*                                 Grants                                 
/******************************************************************************/

/* Users */

/* Views */

/* Tables */

/* SPs */
GRANT EXECUTE ON PROCEDURE SP_ADD_ADDRESSBOOKITEM TO SP_ADD_ADDRESSBOOKITEM_BY_SRV;
GRANT EXECUTE ON PROCEDURE SP_CHECKGRANT TO SP_ADD_ADDRESSBOOKITEM_BY_SRV;
GRANT EXECUTE ON PROCEDURE SP_TOUCHSESSION TO SP_ADD_ADDRESSBOOKITEM_BY_SRV; 
GRANT EXECUTE ON PROCEDURE SP_CHK_DATA_BY_ADD_ADDRESSITEM TO SP_ADD_ADDRESSBOOKITEM;
GRANT SELECT ON V_TENANT TO SP_CHK_DATA_BY_ADD_ADDRESSITEM;
GRANT EXECUTE ON PROCEDURE SP_INSERT_PERSON TO SP_ADD_ADDRESSBOOKITEM;
GRANT EXECUTE ON PROCEDURE SP_INSERT_ADDRESS TO SP_ADD_ADDRESSBOOKITEM;
GRANT EXECUTE ON PROCEDURE SP_INSERT_CONTACT TO SP_ADD_ADDRESSBOOKITEM;
GRANT EXECUTE ON PROCEDURE SP_INSERT_BANK TO SP_ADD_ADDRESSBOOKITEM;
GRANT EXECUTE ON PROCEDURE SP_INSERT_DOCUMENT TO SP_ADD_ADDRESSBOOKITEM;
GRANT EXECUTE ON PROCEDURE SP_READINTEGER TO SP_ADD_ADDRESSBOOKITEM;

GRANT EXECUTE ON PROCEDURE SP_GET_SEQUENCEID_BY_IDENT TO SP_INSERT_PERSON;
GRANT INSERT, UPDATE ON V_PERSON TO SP_INSERT_PERSON;

GRANT EXECUTE ON PROCEDURE SP_GET_SEQUENCEID_BY_IDENT TO SP_INSERT_ADDRESS;
GRANT SELECT ON V_REL_ADDRESSBOOKITEM_DETAILS TO SP_INSERT_ADDRESS;
GRANT INSERT, UPDATE ON V_ADDRESS TO SP_INSERT_ADDRESS;
GRANT SELECT, INSERT ON V_REL_PERSON_ADDRESS TO SP_INSERT_ADDRESS;

GRANT EXECUTE ON PROCEDURE SP_GET_SEQUENCEID_BY_IDENT TO SP_INSERT_CONTACT;
GRANT SELECT ON V_REL_ADDRESSBOOKITEM_DETAILS TO SP_INSERT_CONTACT;
GRANT INSERT, UPDATE ON V_CONTACT TO SP_INSERT_CONTACT;
GRANT SELECT, INSERT ON V_REL_PERSON_CONTACT TO SP_INSERT_CONTACT;

GRANT EXECUTE ON PROCEDURE SP_GET_SEQUENCEID_BY_IDENT TO SP_INSERT_BANK;
GRANT SELECT ON V_REL_ADDRESSBOOKITEM_DETAILS TO SP_INSERT_BANK;
GRANT INSERT, UPDATE ON V_BANK TO SP_INSERT_BANK;
GRANT SELECT, INSERT ON V_REL_PERSON_BANK TO SP_INSERT_BANK;

GRANT EXECUTE ON PROCEDURE SP_GET_SEQUENCEID_BY_IDENT TO SP_INSERT_DOCUMENT;
GRANT EXECUTE ON PROCEDURE SP_UNIQUENAME TO SP_INSERT_DOCUMENT;
GRANT SELECT, UPDATE, INSERT ON V_DOCUMENT TO SP_INSERT_DOCUMENT;
GRANT SELECT, UPDATE ON V_PERSON TO SP_INSERT_DOCUMENT;

GRANT EXECUTE ON PROCEDURE SP_GET_SEQUENCEID_BY_IDENT TO SP_UNIQUENAME;
GRANT EXECUTE ON PROCEDURE SP_DBVERSION TO SP_UNIQUENAME;
GRANT EXECUTE ON PROCEDURE SP_READSTRING TO SP_UNIQUENAME;

GRANT EXECUTE ON PROCEDURE SP_UNIQUENAME TO SP_GET_UNIQUENAME;
  
GRANT EXECUTE ON PROCEDURE SP_UNIQUENAME TO SP_GET_UNIQUENAME;
GRANT EXECUTE ON PROCEDURE SP_TOUCHSESSION TO SP_GET_UNIQUENAME_BY_SRV;
GRANT EXECUTE ON PROCEDURE SP_CHECKGRANT TO SP_GET_UNIQUENAME_BY_SRV;
GRANT EXECUTE ON PROCEDURE SP_GET_UNIQUENAME TO SP_GET_UNIQUENAME_BY_SRV;

GRANT EXECUTE ON PROCEDURE SP_UPDATE_DOC_BY_FILE TO SP_UPDATE_DOC_BY_FILE_BY_SRV;
GRANT EXECUTE ON PROCEDURE SP_CHECKGRANT TO SP_UPDATE_DOC_BY_FILE_BY_SRV;
GRANT EXECUTE ON PROCEDURE SP_TOUCHSESSION TO SP_UPDATE_DOC_BY_FILE_BY_SRV; 
GRANT SELECT, UPDATE ON V_DOCUMENT TO SP_UPDATE_DOC_BY_FILE; 

/* Roles */


COMMIT WORK;
/******************************************************************************/
/*                                 Input                                  
/******************************************************************************/

input 'data_0002.sql';

COMMIT WORK;
/******************************************************************************/
/******************************************************************************/
/******************************************************************************/
