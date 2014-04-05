/*******************************************************************************
/* Author:  Alfred Gerke (AGE)                                                  
/* Date:    2013-03-31                                                          
/* Purpose: Grundsteinlegung des Datenmodelles für ZABonline (Wavemaker)    
/*                                                                              
/*******************************************************************************
/* - Das Script arbeitet mit Befehlen der SQL-Erweiterung für FireBird 2.5.x   
/* - Das Script ist für die Ausführung im ISQL erstellt worden              
/* - Ein möglicher Connect zur ZABonline-DB sollte geschlossen werden   
/******************************************************************************/
/* History: 2013-03-31
/*          Betriebsdaten einrichten
/*          2014-04-05
/*          Scripte auf ISQL optimiert
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
  number = '3';
  subitem = '0';
  script = 'create_factory.sql';
  description = 'Betriebsdaten einrichten';
  
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

CREATE DOMAIN FACTORYNUMBER AS
VARCHAR(64);

COMMENT ON DOMAIN FACTORYNUMBER IS
'Betriebsnummer';

COMMIT WORK;
/******************************************************************************/
/*                                 Sequences                                  
/******************************************************************************/

/* Standardsequences werden druch die SP: SP_CREATE_SEQUENCE erstellt */

CREATE SEQUENCE SEQ_FACTORY_DATA_IDX;
ALTER SEQUENCE SEQ_FACTORY_DATA_IDX RESTART WITH 0;
COMMENT ON SEQUENCE SEQ_FACTORY_DATA_IDX IS 'Eindeutiger Index für die Namenserweiterung von generierten Betriebsdatentabellen';
  
COMMIT WORK;
/******************************************************************************/
/*                                  Tables                                   
/******************************************************************************/

CREATE TABLE FACTORY (
  ID                         INTEGER NOT NULL,
  TENANT_ID                  INTEGER NOT NULL,    
  TAG_ID                     INTEGER,
  DATASHEET_ID               INTEGER,
  CONTACT_PERSON_ID          INTEGER,
  FACTORY_NUMBER             FACTORYNUMBER,
  CAPTION                    CAPTION254, 
  DESCRIPTION1               VARCHAR(2000),
  DESCRIPTION2               VARCHAR(2000),
  DESCRIPTION3               VARCHAR(2000),
  CONTACT_PERSON_NAME        VARCHAR(126),
  CONTACT_PERSON_FIRSTNAME   VARCHAR(126),
  CONTACT_PHONE              INTEGER,
  CONTACT_PHONE_FMT          VARCHAR(126),
  CONTACT_EMAIL              VARCHAR(254),
  DESCRIPTION                BLOB SUB_TYPE 1 SEGMENT SIZE 16384,
  SOFTDEL                    BOOLEAN,    
  CRE_USER                   VARCHAR(32) NOT NULL,
  CRE_DATE                   TIMESTAMP NOT NULL,
  CHG_USER                   VARCHAR(32),
  CHG_DATE                   TIMESTAMP
);

COMMENT ON TABLE FACTORY IS
'Betriebsdaten'; 

COMMENT ON COLUMN FACTORY.ID IS
'Primärschlüssel';

COMMENT ON COLUMN FACTORY.TENANT_ID IS
'Fremdschlüssel Mandant';

COMMENT ON COLUMN FACTORY.TAG_ID IS
'Fremdschlüssel für Tags';

COMMENT ON COLUMN FACTORY.DATASHEET_ID IS
'Fremdschlüssel aus DATASHEET';

COMMENT ON COLUMN FACTORY.CONTACT_PERSON_ID  IS
'Fremdschlüssel aus Person';

COMMENT ON COLUMN FACTORY.FACTORY_NUMBER IS
'Betriebsnummer';

COMMENT ON COLUMN FACTORY.CAPTION IS
'Kurzbezeichnung für einen Betrieb';
 
COMMENT ON COLUMN FACTORY.DESCRIPTION1 IS
'Langbezeichnung für einen Betrieb';

COMMENT ON COLUMN FACTORY.DESCRIPTION2 IS
'Langbezeichnung für einen Betrieb';

COMMENT ON COLUMN FACTORY.DESCRIPTION3 IS
'Langbezeichnung für einen Betrieb';

COMMENT ON COLUMN FACTORY.CONTACT_PERSON_NAME IS
'Name der Kontaktperson';

COMMENT ON COLUMN FACTORY.CONTACT_PERSON_FIRSTNAME IS
'Vorname der Kontaktperson';

COMMENT ON COLUMN FACTORY.CONTACT_PHONE IS
'Telefon der Kontaktperson als numerischer Wert';

COMMENT ON COLUMN FACTORY.CONTACT_PHONE_FMT IS
'Telefon der Kontatkperson als formatierter String';

COMMENT ON COLUMN FACTORY.CONTACT_EMAIL IS
'Mailadresse der Kontaktperson';

COMMENT ON COLUMN FACTORY.DESCRIPTION IS
'Unstrukturierte Information zum Betrieb';

COMMENT ON COLUMN FACTORY.SOFTDEL IS
'Löschflag';

COMMENT ON COLUMN FACTORY.CRE_USER IS
'Erstellt von';

COMMENT ON COLUMN FACTORY.CRE_DATE IS
'Erstellt am';

COMMENT ON COLUMN FACTORY.CHG_USER IS
'Geändert von';

COMMENT ON COLUMN FACTORY.CHG_DATE IS
'Geändert am';

/* Userview anlegen */
execute procedure SP_CREATE_USER_VIEW 'FACTORY';
/* Sequence anlegen */
execute procedure SP_CREATE_SEQUNECE 'FACTORY';
/* Trigger anlegen */
execute procedure SP_CREATE_TRIGGER_BI 'FACTORY';
execute procedure SP_CREATE_TRIGGER_BU 'FACTORY';

/* Relation zwischen FACTORY und CATEGORY komplett über SP_CREATE_ZABRELATION erstellen */

/*
 *
 * 
CREATE TABLE REL_FACTORY_CATEGORY (
     FACTORY_ID     INTEGER NOT NULL,
     CATEGORY_ID   INTEGER NOT NULL
);

COMMENT ON TABLE REL_FACTORY_CATEGORY IS
'Relation zwischen Betriebs- und Kategriedaten';

COMMENT ON COLUMN REL_FACTORY_CATEGORY.FACTORY_ID IS
'Fremdschlüssel aus Factory';

COMMENT ON COLUMN REL_FACTORY_CATEGORY.CATEGORY_ID IS
'Fremdschlüssel aus Category';

* Userview anlegen *
execute procedure SP_CREATE_USER_VIEW 'REL_FACTORY_CATEGORY';
* Relationen haben keine Standardsequence und -trigger *
*
*
*/

/* Relation zwischen FACTORY und PERSON komplett über SP_CREATE_ZABRELATION erstellen */

/*
 *
 * 
CREATE TABLE REL_FACTORY_PERSON (
     FACTORY_ID   INTEGER NOT NULL,
     PERSON_ID    INTEGER NOT NULL
);

COMMENT ON TABLE REL_FACTORY_PERSON IS
'Relation zwischen Personen- und Betriebsdaten';

COMMENT ON COLUMN REL_FACTORY_PERSON.FACTORY_ID IS
'Fremschlüssel aus Factory';

COMMENT ON COLUMN REL_FACTORY_PERSON.PERSON_ID IS
'Fremschlüssel aus PERSON';

* Userview anlegen *
execute procedure SP_CREATE_USER_VIEW 'REL_FACTORY_PERSON';
* Relationen haben keine Standardsequence und -trigger *
*
*
*/

/* Relation zwischen FACTORY und CONTACT komplett über SP_CREATE_ZABRELATION erstellen */

/*
 *
 * 
CREATE TABLE REL_FACTORY_CONTACT (
     FACTORY_ID    INTEGER NOT NULL,
     CONTACT_ID    INTEGER NOT NULL
);

COMMENT ON TABLE REL_FACTORY_CONTACT IS
'Relation zwischen Betriebs- und Kontaktdaten';

COMMENT ON COLUMN REL_FACTORY_CONTACT.FACTORY_ID IS
'Fremschlüssel aus Factory';

COMMENT ON COLUMN REL_FACTORY_CONTACT.CONTACT_ID IS
'Fremschlüssel aus Address';

* Userview anlegen *
execute procedure SP_CREATE_USER_VIEW 'REL_FACTORY_CONTACT';
* Relationen haben keine Standardsequence und -trigger *
*
*
*/

/* Relation zwischen FACTORY und ADDRESS komplett über SP_CREATE_ZABRELATION erstellen */

/*
 *
 * 
CREATE TABLE REL_FACTORY_ADDRESS (
     FACTORY_ID    INTEGER NOT NULL,
     ADDRESS_ID    INTEGER NOT NULL
);

COMMENT ON TABLE REL_FACTORY_ADDRESS IS
'Relation zwischen Betriebs- und Adressdaten';

COMMENT ON COLUMN REL_FACTORY_ADDRESS.FACTORY_ID IS
'Fremschlüssel aus Factory';

COMMENT ON COLUMN REL_FACTORY_ADDRESS.ADDRESS_ID IS
'Fremschlüssel aus Address';

* Userview anlegen *
execute procedure SP_CREATE_USER_VIEW 'REL_FACTORY_ADDRESS';
* Relationen haben keine Standardsequence und -trigger *
*
*
*/

/* Relation zwischen FACTORY und BANK komplett über SP_CREATE_ZABRELATION erstellen */

/* 
 *
 * 
CREATE TABLE REL_FACTORY_BANK (
     FACTORY_ID    INTEGER NOT NULL,
     BANK_ID       INTEGER NOT NULL
);

COMMENT ON TABLE REL_FACTORY_BANK IS
'Relation zwischen Betriebs- und Bankdaten';

COMMENT ON COLUMN REL_FACTORY_BANK.FACTORY_ID IS
'Fremschlüssel aus Factory';

COMMENT ON COLUMN REL_FACTORY_BANK.BANK_ID IS
'Fremschlüssel aus Bank';

* Userview anlegen *
execute procedure SP_CREATE_USER_VIEW 'REL_FACTORY_BANK';
* Relationen haben keine Standardsequence und -trigger *
*
*
*/

CREATE TABLE DATASHEET (
  ID                         INTEGER NOT NULL,
  TENANT_ID                  INTEGER NOT NULL,    
  TAG_ID                     INTEGER,
  TABLE_STORE_ID             INTEGER,
  CAPTION                    CAPTION64,
  DESCRIPTION                VARCHAR(2000),  
  SOFTDEL                    BOOLEAN,    
  CRE_USER                   VARCHAR(32) NOT NULL,
  CRE_DATE                   TIMESTAMP NOT NULL,
  CHG_USER                   VARCHAR(32),
  CHG_DATE                   TIMESTAMP  
);

COMMENT ON TABLE DATASHEET IS
'Datenblatt für Betriebsdaten, erweiterte Personendaten, etc.; ein Datenblatt wird als Maske angeboten'; 

COMMENT ON COLUMN DATASHEET.ID IS
'Primärschlüssel';

COMMENT ON COLUMN DATASHEET.TENANT_ID IS
'Fremdschlüssel Mandant';

COMMENT ON COLUMN DATASHEET.TAG_ID IS
'Fremdschlüssel für Tags';

COMMENT ON COLUMN DATASHEET.TABLE_STORE_ID IS
'Fremdschlüssel für Tabellen';

COMMENT ON COLUMN DATASHEET.CAPTION IS
'Kurzbezeichnung für das Datenblatt';

COMMENT ON COLUMN DATASHEET.DESCRIPTION IS
'Langbezeichnung für das Datenblatt';
 
COMMENT ON COLUMN DATASHEET.SOFTDEL IS
'Löschflag';

COMMENT ON COLUMN DATASHEET.CRE_USER IS
'Erstellt von';

COMMENT ON COLUMN DATASHEET.CRE_DATE IS
'Erstellt am';

COMMENT ON COLUMN DATASHEET.CHG_USER IS
'Geändert von';

COMMENT ON COLUMN DATASHEET.CHG_DATE IS
'Geändert am';

/* Userview anlegen */
execute procedure SP_CREATE_USER_VIEW 'DATASHEET';
/* Sequence anlegen */
execute procedure SP_CREATE_SEQUNECE 'DATASHEET';
/* Trigger anlegen */
execute procedure SP_CREATE_TRIGGER_BI 'DATASHEET';
execute procedure SP_CREATE_TRIGGER_BU 'DATASHEET';

CREATE TABLE FIELD_STORE(
  ID                  INTEGER      NOT NULL,  
  TENANT_ID           INTEGER      NOT NULL,
  TAG_ID              INTEGER,  
  CATEGORY_ID         INTEGER,
  PARENT_ID           INTEGER,
  LABEL               LABEL,
  CODE                DBOBJECTNAME32 NOT NULL,
  NAME                CAPTION64    NOT NULL,
  DATA_TYPE           DBOBJECTNAME32,
  TYPE_LENGTH         INTEGER,
  TYPE_SCALE          INTEGER,
  MANDATORY           BOOLEAN,
  IS_FOREIGN_KEY      BOOLEAN,
  IS_LOOKUP           BOOLEAN,
  REFERENCE_TABLE     DBOBJECTNAME32,
  LOOKUP_CAPTION_FIELD DBOBJECTNAME32,   
  LOOKUP_REF_ID_FIELD DBOBJECTNAME32,
  UNIQUE_IDX_NAME     DBOBJECTNAME24,
  IS_CALCULATED       BOOLEAN,
  CALC_SP_NAME        DBOBJECTNAME32, 
  IS_VISIBLE          BOOLEAN DEFAULT 1,          
  DESCRIPTION         VARCHAR(2000),
  DONOTDELETE         BOOLEAN,    
  SOFTDEL             BOOLEAN,    
  CRE_USER            VARCHAR(32)  NOT NULL,
  CRE_DATE            TIMESTAMP    NOT NULL,
  CHG_USER            VARCHAR(32),
  CHG_DATE            TIMESTAMP
);

COMMENT ON TABLE FIELD_STORE IS
'Felddefinitionen'; 

COMMENT ON COLUMN FIELD_STORE.ID IS
'Primärschlüssel';

COMMENT On COLUMN FIELD_STORE.TENANT_ID IS
'Fremdschlüssel für Mandanten';

COMMENT ON COLUMN FIELD_STORE.TAG_ID IS
'Fremdschlüssel für Tags';

COMMENT ON COLUMN FIELD_STORE.CATEGORY_ID IS
'Fremdschlüsse für Kategorien';

COMMENT ON COLUMN FIELD_STORE.PARENT_ID IS
'Fremdschlüsse für FIELD_STORE';

COMMENT ON COLUMN FIELD_STORE.LABEL IS
'Gruppierung über ein Label';

COMMENT ON COLUMN FIELD_STORE.CODE IS
'Name des Feldes in Tabellen';

COMMENT ON COLUMN FIELD_STORE.NAME IS
'Bezeichnung des Feldes in Masken';

COMMENT ON COLUMN FIELD_STORE.DATA_TYPE IS
'Datentyp des Feldes';

COMMENT ON COLUMN FIELD_STORE.TYPE_LENGTH IS
'Erlaubte Länge, nur für bestimmte Datentypen notwendig';

COMMENT ON COLUMN FIELD_STORE.TYPE_SCALE IS
'Nachkommaanteil, ist immer in TYPE_LENGTH enthalten (einschließlich Kommazeichen)';

COMMENT ON COLUMN FIELD_STORE.MANDATORY IS
'Wenn TRUE ist die Eingabe in dieses Feld Pflicht (NOT NULL)';

COMMENT ON COLUMN FIELD_STORE.IS_FOREIGN_KEY IS
'Wenn True muss REFERENCE_TABLE gefüllt sein; REFERNCE_TABLE ist Master; IS_LOOKUP muss False sein';

COMMENT ON COLUMN FIELD_STORE.IS_LOOKUP IS
'Wenn True muss REFERENCE_TABLE gefüllt sein; REFERNCE_TABLE beinhaltet die Daten; IS_FOREIGN_KEY muss False sein';

COMMENT ON COLUMN FIELD_STORE.REFERENCE_TABLE IS
'Wenn IS_FOREIGN_KEY=1 dann Tabelle mit Fremdschlüssel; Wenn IS_LOOKUP=1 dann Tabelle mit Lookupdaten';

COMMENT ON COLUMN FIELD_STORE.LOOKUP_CAPTION_FIELD IS
'Wenn IS_LOOKUP=1 dann Feld aus REFERENCE_TABLE angeben zum Anzeigen von Daten in einer Liste';

COMMENT ON COLUMN FIELD_STORE.LOOKUP_REF_ID_FIELD IS
'Wenn IS_LOOKUP=1 dann Primärkey aus REFERENCE_TABLE angeben';

COMMENT ON COLUMN FIELD_STORE.UNIQUE_IDX_NAME IS
'Name für eindeutigen Index'; 

COMMENT ON COLUMN FIELD_STORE.IS_CALCULATED IS
'Wenn True, dann Wert aus CALC_SP_NAME';

COMMENT ON COLUMN FIELD_STORE.CALC_SP_NAME IS
'Wenn IS_CALCULATED=1 dann SP zur Berechnung eintragen';

COMMENT ON COLUMN FIELD_STORE.IS_VISIBLE IS
'Feld ist sichtbar'; 

COMMENT ON COLUMN FIELD_STORE.DESCRIPTION IS
'Beschreibung';

COMMENT ON COLUMN FIELD_STORE.DONOTDELETE IS
'Löschflag ignorieren';

COMMENT ON COLUMN FIELD_STORE.SOFTDEL IS
'Löschflag';

COMMENT ON COLUMN FIELD_STORE.CRE_USER IS
'Erstellt von';

COMMENT ON COLUMN FIELD_STORE.CRE_DATE IS
'Erstellt am';

COMMENT ON COLUMN FIELD_STORE.CHG_USER IS
'Geändert von';

COMMENT ON COLUMN FIELD_STORE.CHG_DATE IS
'Geändert am';

/* Userview anlegen */
execute procedure SP_CREATE_USER_VIEW 'FIELD_STORE';
/* Sequence anlegen */
execute procedure SP_CREATE_SEQUNECE 'FIELD_STORE';
/* Trigger anlegen */
execute procedure SP_CREATE_TRIGGER_BI 'FIELD_STORE';
execute procedure SP_CREATE_TRIGGER_BU 'FIELD_STORE';
execute procedure SP_CREATE_TRIGGER_BD 'FIELD_STORE', 'DONOTDELETE';

CREATE TABLE TABLE_STORE(
  ID                  INTEGER      NOT NULL,  
  TENANT_ID           INTEGER      NOT NULL,
  TAG_ID              INTEGER,  
  CATEGORY_ID         INTEGER,
  LABEL               LABEL,     
  TABLE_NAME          DBOBJECTNAME24,     
  DESCRIPTION         VARCHAR(2000),
  DONOTDELETE         BOOLEAN,    
  SOFTDEL             BOOLEAN,    
  CRE_USER            VARCHAR(32)  NOT NULL,
  CRE_DATE            TIMESTAMP    NOT NULL,
  CHG_USER            VARCHAR(32),
  CHG_DATE            TIMESTAMP
);

COMMENT ON TABLE TABLE_STORE IS
'Tabellendefinitionen';

COMMENT ON COLUMN TABLE_STORE.ID IS
'Primärschlüssel';

COMMENT On COLUMN TABLE_STORE.TENANT_ID IS
'Fremdschlüssel für Mandanten';

COMMENT ON COLUMN TABLE_STORE.TAG_ID IS
'Fremdschlüssel für Tags';

COMMENT ON COLUMN TABLE_STORE.CATEGORY_ID IS
'Fremdschlüsse für Kategorien';

COMMENT ON COLUMN TABLE_STORE.LABEL IS
'Gruppierung über ein Label';

COMMENT On COLUMN TABLE_STORE.TABLE_NAME IS
'Name der Tabelle, max. 24 Zeichen';
          
COMMENT ON COLUMN TABLE_STORE.DESCRIPTION IS
'Beschreibung der Tabelle';

COMMENT ON COLUMN TABLE_STORE.DONOTDELETE IS
'Löschflag ignorieren';

COMMENT ON COLUMN TABLE_STORE.SOFTDEL IS
'Löschflag';

COMMENT ON COLUMN TABLE_STORE.CRE_USER IS
'Erstellt von';

COMMENT ON COLUMN TABLE_STORE.CRE_DATE IS
'Erstellt am';

COMMENT ON COLUMN TABLE_STORE.CHG_USER IS
'Geändert von';

COMMENT ON COLUMN TABLE_STORE.CHG_DATE IS
'Geändert am';

/* Userview anlegen */
execute procedure SP_CREATE_USER_VIEW 'TABLE_STORE';
/* Sequence anlegen */
execute procedure SP_CREATE_SEQUNECE 'TABLE_STORE';
/* Trigger anlegen */
execute procedure SP_CREATE_TRIGGER_BI 'TABLE_STORE';
execute procedure SP_CREATE_TRIGGER_BU 'TABLE_STORE';
execute procedure SP_CREATE_TRIGGER_BD 'TABLE_STORE', 'DONOTDELETE';

/* Relation zwischen TABLE_STORE und FIELD_STORE komplett über SP_CREATE_ZABRELATION erstellen */

/*
 *
 * 
CREATE TABLE REL_TABLE_STORE_FIELD_STORE (
  TABLE_ID   INTEGER NOT NULL,
  FIELD_ID    INTEGER NOT NULL 
);

COMMENT ON TABLE REL_TABLE_STORE_FIELD_STORE IS
'Relation zwischen Tabellen und Feldern';

COMMENT ON COLUMN REL_TABLE_STORE_FIELD_STORE.TABLE_ID IS
'Fremdschlüssel aus TABLE_STORE';

COMMENT ON COLUMN REL_TABLE_STORE_FIELD_STORE.FIELD_ID IS
'Fremdschlüssel aus FIELD_STORE';

* Userview anlegen *
execute procedure SP_CREATE_USER_VIEW 'REL_TABLE_STORE_FIELD_STORE';
* Relationen haben keine Standardsequence und -trigger *
*
*
*/

COMMIT WORK;
/******************************************************************************/
/*                                  ALTER                                   
/******************************************************************************/

/* Tables */

ALTER TABLE TENANT
  ADD FIX_PART_FATORY_DATA_NAME DBOBJECTNAME15,
  ADD DATASHEET_FACTORY_DATA_ID INTEGER,
  ADD FIX_PART_PERSON_DATA_NAME DBOBJECTNAME15,
  ADD DATASHEET_PERSON_ID INTEGER,
  ADD FIX_PART_CONTACT_DATA_NAME DBOBJECTNAME15,
  ADD DATASHEET_CONTACT_ID INTEGER,
  ADD FIX_PART_ADDRESS_DATA_NAME DBOBJECTNAME15,
  ADD DATASHEET_ADDRESS_ID INTEGER;

COMMENT ON COLUMN TENANT.FIX_PART_FATORY_DATA_NAME IS
'Fester Namensantiel einer generierten Datentabelle für Betriebsdaten'; 

COMMENT ON COLUMN TENANT.DATASHEET_FACTORY_DATA_ID IS
'Datasheet ID für Datenblatt für Betriebsdaten';

COMMENT ON COLUMN TENANT.FIX_PART_PERSON_DATA_NAME IS
'Fester Namensantiel einer generierten Datentabelle für Personendaten'; 

COMMENT ON COLUMN TENANT.DATASHEET_PERSON_ID IS
'Datasheet ID für Datenblatt für erweiterte Personendaten';

COMMENT ON COLUMN TENANT.FIX_PART_CONTACT_DATA_NAME IS
'Fester Namensantiel einer generierten Datentabelle für Kontaktdaten'; 

COMMENT ON COLUMN TENANT.DATASHEET_CONTACT_ID IS
'Datasheet ID für Datenblatt für erweiterte Kontaktdaten';

COMMENT ON COLUMN TENANT.FIX_PART_ADDRESS_DATA_NAME IS
'Fester Namensantiel einer generierten Datentabelle für Adresssdaten'; 

COMMENT ON COLUMN TENANT.DATASHEET_ADDRESS_ID IS
'Datasheet ID für Datenblatt für erweiterte Adressdaten';

/* Userview aktualisieren */
execute procedure SP_CREATE_USER_VIEW 'TENANT';

COMMIT WORK;
/******************************************************************************/
/*                                Primary Keys                               
/******************************************************************************/

ALTER TABLE FACTORY ADD CONSTRAINT PK_FACTORY PRIMARY KEY (ID);
ALTER TABLE DATASHEET ADD CONSTRAINT PK_DATASHEET PRIMARY KEY (ID);
ALTER TABLE FIELD_STORE ADD CONSTRAINT PK_FIELD_STORE PRIMARY KEY (ID);
ALTER TABLE TABLE_STORE ADD CONSTRAINT PK_TABLE_STORE PRIMARY KEY (ID);

COMMIT WORK;
/******************************************************************************/
/*                                Foreign Keys                                
/******************************************************************************/

ALTER TABLE TENANT ADD CONSTRAINT FK_FACTORY_DATASHEET_FD FOREIGN KEY (DATASHEET_FACTORY_DATA_ID) REFERENCES DATASHEET(ID) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE TENANT ADD CONSTRAINT FK_FACTORY_DATASHEET_P FOREIGN KEY (DATASHEET_PERSON_ID) REFERENCES DATASHEET(ID) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE TENANT ADD CONSTRAINT FK_FACTORY_DATASHEET_C FOREIGN KEY (DATASHEET_CONTACT_ID) REFERENCES DATASHEET(ID) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE TENANT ADD CONSTRAINT FK_FACTORY_DATASHEET_A FOREIGN KEY (DATASHEET_ADDRESS_ID) REFERENCES DATASHEET(ID) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE FACTORY ADD CONSTRAINT FK_FACTORY_TENANT FOREIGN KEY (TENANT_ID) REFERENCES TENANT(ID) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE FACTORY ADD CONSTRAINT FK_FACTORY_TAG FOREIGN KEY (TAG_ID) REFERENCES TAG(ID) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE FACTORY ADD CONSTRAINT FK_FACTORY_DATASHEET FOREIGN KEY (DATASHEET_ID) REFERENCES DATASHEET(ID) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE FACTORY ADD CONSTRAINT FK_FACTORY_CONTACT_PERSON FOREIGN KEY (CONTACT_PERSON_ID) REFERENCES PERSON(ID) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE DATASHEET ADD CONSTRAINT FK_DATASHEET_TENANT FOREIGN KEY (TENANT_ID) REFERENCES TENANT(ID) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE DATASHEET ADD CONSTRAINT FK_DATASHEET_TAG FOREIGN KEY (TAG_ID) REFERENCES TAG(ID) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE DATASHEET ADD CONSTRAINT FK_DATASHEET_TABLE_STORE FOREIGN KEY (TABLE_STORE_ID) REFERENCES TABLE_STORE(ID) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE FIELD_STORE ADD CONSTRAINT FK_FIELD_STORE_TENANT FOREIGN KEY (TENANT_ID) REFERENCES TENANT(ID) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE FIELD_STORE ADD CONSTRAINT FK_FIELD_STORE_TAG FOREIGN KEY (TAG_ID) REFERENCES TAG(ID) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE FIELD_STORE ADD CONSTRAINT FK_FIELD_STORE_CATEGORY FOREIGN KEY (CATEGORY_ID) REFERENCES CATEGORY(ID) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE FIELD_STORE ADD CONSTRAINT FK_FIELD_STORE_FIELD_STORE FOREIGN KEY (PARENT_ID) REFERENCES FIELD_STORE(ID) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE FIELD_STORE ADD CONSTRAINT FK_FIELD_STORE_DATA_TYPE FOREIGN KEY (DATA_TYPE) REFERENCES DATATYPE(CODE) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE TABLE_STORE ADD CONSTRAINT FK_TABLE_STORE_TENANT FOREIGN KEY (TENANT_ID) REFERENCES TENANT(ID) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE TABLE_STORE ADD CONSTRAINT FK_TABLE_STORE_TAG FOREIGN KEY (TAG_ID) REFERENCES TAG(ID) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE TABLE_STORE ADD CONSTRAINT FK_TABLE_STORE_CATEGORY FOREIGN KEY (CATEGORY_ID) REFERENCES CATEGORY(ID) ON DELETE SET NULL ON UPDATE CASCADE;

/*
 * wird von SP_CREATE_ZABRELATION erstellen
 *
ALTER TABLE REL_FACTORY_CONTACT ADD CONSTRAINT FK_REL_FC_FACTORY FOREIGN KEY (FACTORY_ID) REFERENCES FACTORY(ID) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE REL_FACTORY_CONTACT ADD CONSTRAINT FK_REL_FC_CONTACT FOREIGN KEY (CONTACT_ID) REFERENCES CONTACT(ID) ON DELETE CASCADE ON UPDATE CASCADE;
* 
ALTER TABLE REL_FACTORY_ADDRESS ADD CONSTRAINT FK_REL_FA_FACTORY FOREIGN KEY (FACTORY_ID) REFERENCES FACTORY(ID) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE REL_FACTORY_ADDRESS ADD CONSTRAINT FK_REL_FA_ADDRESS FOREIGN KEY (ADDRESS_ID) REFERENCES ADDRESS(ID) ON DELETE CASCADE ON UPDATE CASCADE;
* 
ALTER TABLE REL_FACTORY_BANK ADD CONSTRAINT FK_REL_FB_FACTORY FOREIGN KEY (FACTORY_ID) REFERENCES FACTORY(ID) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE REL_FACTORY_BANK ADD CONSTRAINT FK_REL_FB_BANK FOREIGN KEY (BANK_ID) REFERENCES BANK(ID) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE REL_FACTORY_CATEGORY ADD CONSTRAINT FK_REL_FCAT_FACTORY FOREIGN KEY (FACTORY_ID) REFERENCES FACTORY(ID) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE REL_FACTORY_CATEGORY ADD CONSTRAINT FK_REL_FCAT_CATEGORY FOREIGN KEY (CATEGORY_ID) REFERENCES CATEGORY(ID) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE REL_FACTORY_PERSON ADD CONSTRAINT FK_REL_FP_FACTORY FOREIGN KEY (FACTORY_ID) REFERENCES FACTORY(ID) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE REL_FACTORY_PERSON ADD CONSTRAINT FK_REL_FP_PERSON FOREIGN KEY (PERSON_ID) REFERENCES PERSON(ID) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE REL_TABLE_STORE_FIELD_STORE ADD CONSTRAINT FK_REL_DP_DATASHEET FOREIGN KEY (TABLE_ID) REFERENCES DATASHEET(ID) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE REL_TABLE_STORE_FIELD_STORE ADD CONSTRAINT FK_REL_DP_PROPERTY FOREIGN KEY (FIELD_ID) REFERENCES FIELD_STORE(ID) ON DELETE CASCADE ON UPDATE CASCADE;
*
*
*/

COMMIT WORK;
/******************************************************************************/
/*                                  Indices                                   
/******************************************************************************/

/*  
 * wird von SP_CREATE_ZABRELATION erstellen
 * 
CREATE UNIQUE INDEX ALT_FACTORY_PERSON ON REL_FACTORY_PERSON (FACTORY_ID, PERSON_ID);
CREATE UNIQUE INDEX ALT_FACTORY_CONTACT ON REL_FACTORY_CONTACT (FACTORY_ID, CONTACT_ID);
CREATE UNIQUE INDEX ALT_FACTORY_ADDRESS ON REL_FACTORY_ADDRESS (FACTORY_ID, ADDRESS_ID);
CREATE UNIQUE INDEX ALT_FACTORY_BANK ON REL_FACTORY_BANK (FACTORY_ID, BANK_ID);
CREATE UNIQUE INDEX ALT_FACTORY_CATEGORY ON REL_FACTORY_CATEGORY (FACTORY_ID, CATEGORY_ID);
CREATE UNIQUE INDEX ALT_TABLE_STORE_FIELD_STORE ON REL_TABLE_STORE_FIELD_STORE (TABLE_ID, FIELD_ID);
*
*
*/

/*
 * eventuell werden diese Indexe nicht benötigt, da die Felder nicht zur anwendung kommen
 * 
CREATE UNIQUE INDEX IDX_TENANT_FIX_PART_FD_NAME ON TENANT (FIX_PART_FATORY_DATA_NAME);
CREATE UNIQUE INDEX IDX_TENANT_FIX_PART_PD_NAME ON TENANT (FIX_PART_PERSON_DATA_NAME);
CREATE UNIQUE INDEX IDX_TENANT_FIX_PART_CD_NAME ON TENANT (FIX_PART_CONTACT_DATA_NAME);
CREATE UNIQUE INDEX IDX_TENANT_FIX_PART_AD_NAME ON TENANT (FIX_PART_ADDRESS_DATA_NAME);
*
*
*/

COMMIT WORK;
/******************************************************************************/
/*                             Relations                              
/******************************************************************************/

/* nach dem alle Datenbankobjekte (Tabelle, PKs, FKs IDX) angelegt wurden dürfen erst die Relationen generiert werden */

execute procedure SP_CREATE_ZABRELATION 'FACTORY', 'PERSON', 1;
execute procedure SP_CREATE_ZABRELATION 'FACTORY', 'CONTACT', 1;
execute procedure SP_CREATE_ZABRELATION 'FACTORY', 'ADDRESS', 1;
execute procedure SP_CREATE_ZABRELATION 'FACTORY', 'BANK', 1;
execute procedure SP_CREATE_ZABRELATION 'FACTORY', 'CATEGORY', 1;
execute procedure SP_CREATE_ZABRELATION 'TABLE_STORE', 'FIELD_STORE', 1;

COMMIT WORK;
/******************************************************************************/
/*                                  Triggers                                  
/******************************************************************************/

/* Standardrigger werden druch die SPs: SP_CREATE_TRIGGER_BI und SP_CREATE_TRIGGER_BU erstellt */

/******************************************************************************/
/*                                  Views                                   
/******************************************************************************/

/* USER-Views werden druch die SP: SP_CREATE_USER_VIEW erstellt */

/******************************************************************************/
/*                             Stored Procedures                              
/******************************************************************************/

SET TERM ^ ;

CREATE OR ALTER PROCEDURE SP_GET_FIX_TABLENAME_BY_IDENT(
  AIDENT varchar(32),
  ATENANT_ID integer)
RETURNS (
  found Boolean,
  tablename DBOBJECTNAME32)
as
DECLARE key_section varchar(128);
DECLARE section varchar(128);
DECLARE ident varchar(128);
DECLARE value_for_default varchar(255);
begin
  tablename = null;
  Found = 0;
  
  key_section = 'GENERATE';  
  ident = 'FIX_TABLENAME';
  
  /* Namensanteil für Datentabelle des Datenblattes für einen Betrieb ermitteln */
  if (AIDENT = 'FACTORY_DATA') then
  begin    
    if (ATENANT_ID is not null) then
    begin
      select FIX_PART_FATORY_DATA_NAME from V_TENANT where ID=:ATENANT_ID into :tablename;
    end
    
    section = AIDENT;
    value_for_default = 'FACTORY_DATA';
    if ((tablename is null) or (Trim(tablename) = '')) then
    begin
      select RESULT from SP_READSTRING(:key_section, :section, :ident, :value_for_default) into :tablename;      
    end    
  end
  
  if (AIDENT = 'PERSON') then
  begin    
    if (ATENANT_ID is not null) then
    begin
      select FIX_PART_PERSON_DATA_NAME from V_TENANT where ID=:ATENANT_ID into :tablename;
    end
    
    section = AIDENT;
    value_for_default = 'PERSON_DATA';
    if ((tablename is null) or (Trim(tablename) = '')) then
    begin
      select RESULT from SP_READSTRING(:key_section, :section, :ident, :value_for_default) into :tablename;      
    end
  end    

  if (AIDENT = 'ADDRESS') then
  begin    
    if (ATENANT_ID is not null) then
    begin
      select FIX_PART_ADDRESS_DATA_NAME from V_TENANT where ID=:ATENANT_ID into :tablename;
    end
    
    section = AIDENT;
    value_for_default = 'ADDRESS_DATA';
    if ((tablename is null) or (Trim(tablename) = '')) then
    begin
      select RESULT from SP_READSTRING(:key_section, :section, :ident, :value_for_default) into :tablename;      
    end
  end

  if (AIDENT = 'CONTACT') then
  begin    
    if (ATENANT_ID is not null) then
    begin
      select FIX_PART_CONTACT_DATA_NAME from V_TENANT where ID=:ATENANT_ID into :tablename;
    end
    
    section = AIDENT;
    value_for_default = 'CONTACT_DATA';
    if ((tablename is null) or (Trim(tablename) = '')) then
    begin
      select RESULT from SP_READSTRING(:key_section, :section, :ident, :value_for_default) into :tablename;      
    end
  end
    
  /* Abschließend testen ob ein Tabellename gefunden wurde */
  if ((tablename is not null) and (Trim(tablename) <> '')) then
  begin
    found = 1;
  end
  
  suspend;
end^

COMMENT ON PROCEDURE SP_GET_FIX_TABLENAME_BY_IDENT IS
'Ermittelt den festen Namensanteil einer zu generierenden Tabelle'^

COMMIT WORK^

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_GET_FIX_TABLENAME_BY_IDENT'^

SET TERM ; ^

COMMIT WORK;
/******************************************************************************/
/*                                 Grants 
/******************************************************************************/

/* Users */

/* Views */

/* Tables */

/* SPs */
GRANT SELECT ON V_TENANT TO PROCEDURE SP_GET_FIX_TABLENAME_BY_IDENT;
GRANT EXECUTE ON PROCEDURE SP_READSTRING TO PROCEDURE SP_GET_FIX_TABLENAME_BY_IDENT;

/* Roles */

COMMIT WORK;
/******************************************************************************/
/*                                 Input                                  
/******************************************************************************/

input 'data_0004.sql';

COMMIT WORK;
/******************************************************************************/
/******************************************************************************/
/******************************************************************************/
