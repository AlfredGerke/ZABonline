/*******************************************************************************
/* Author:  Alfred Gerke (AGE)                                                  
/* Date:    2013-12-10                                                          
/* Purpose: Erstellt alle DB-Objecte (SPs) welche nur als Interface vorhanden sind
/*                                                                              
/*******************************************************************************
/* - Das Script arbeitet mit Befehlen der SQL-Erweiterung für FireBird 2.5.x   
/* - Das Script ist für die Ausführung im IBExpert erstellt worden              
/* - Ein möglicher Connect zur ZABonline-DB sollte geschlossen werden 
/* - Die Installationstools müssen installiert worden sein  
/******************************************************************************/
/* History: 2013-12-10
/*          Fehlende Implementationen zu bestehenden Interfaces erstellen 
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
/*                                 Insert into UPDATEHISTORY                                  
/******************************************************************************/
SET TERM ^ ; /* definiert den Begin eines Ausführungsblockes */
EXECUTE BLOCK AS
DECLARE number varchar(2000);
DECLARE subitem varchar(2000);
DECLARE script varchar(255);
DECLARE description varchar(2000);
BEGIN
  number = '0';
  subitem = '0';
  script = 'create_implementation.sql';
  description = 'Fehlende Implementationen zu bestehenden Interfaces erstellen';
  
  if (exists(select 1 from RDB$RELATIONS where RDB$RELATION_NAME='UPDATEHISTORY')) then
  begin   
    execute statement 'INSERT INTO UPDATEHISTORY(NUMBER, SUBITEM, SCRIPT, DESCRIPTION) VALUES ( ''' || :number ||''', ''' || :subitem ||''', ''' || :script || ''', ''' || :description || ''');';
  end  

END^        
SET TERM ; ^ /* definiert das Ende eines Ausführungsblockes */

COMMIT WORK;
/******************************************************************************/
/*                             Stored Procedures                              
/******************************************************************************/

SET TERM ^ ;

CREATE OR ALTER PROCEDURE SP_GET_SEQUENCEID_BY_IDENT (
  AIDENT varchar(32))
RETURNS (
    SEQ_ID integer)
as
begin                     
  SEQ_ID = null;

  /* Allegmeine Generatoren */
 
  if (AIDENT = 'FACTORY_DATA') then
  begin
    SEQ_ID = next value for SEQ_FACTORY_DATA_IDX;
  end
 
  if (AIDENT = 'UNIQUENAMEIDX') then
  begin
    SEQ_ID = next value for SEQ_UNIQUENAME_IDX;
  end
  
  /* Primay-Key Generatoren */
  if (AIDENT = 'COUNTRY') then
  begin
    SEQ_ID = next value for SEQ_COUNTRY_ID;  
  end
  
  if (AIDENT = 'TENANT') then
  begin
    SEQ_ID = next value for SEQ_TENANT_ID;  
  end
  
  if (AIDENT = 'ROLES') then
  begin
    SEQ_ID = next value for SEQ_ROLES_ID;
  end

  if (AIDENT = 'USERS') then
  begin
    SEQ_ID = next value for SEQ_USERS_ID;
  end
  
  if (AIDENT = 'FIELD_STORE') then
  begin
    SEQ_ID = next value for SEQ_FIELD_STORE_ID;
  end

  if (AIDENT = 'DATASHEET') then
  begin
    SEQ_ID = next value for SEQ_DATASHEET_ID;
  end

  if (AIDENT = 'FACTORY') then
  begin
    SEQ_ID = next value for SEQ_FACTORY_ID;
  end
    
  if (AIDENT = 'PERSON') then
  begin
    SEQ_ID = next value for SEQ_PERSON_ID;
  end
  
  if (AIDENT = 'ADDRESS') then
  begin
    SEQ_ID = next value for SEQ_ADDRESS_ID;
  end
  
  if (AIDENT = 'CONTACT') then
  begin
    SEQ_ID = next value for SEQ_CONTACT_ID;
  end  

  if (AIDENT = 'BANK') then
  begin
    SEQ_ID = next value for SEQ_BANK_ID;
  end
    
  if (AIDENT = 'DOCUMENT') then
  begin
    SEQ_ID = next value for SEQ_DOCUMENT_ID;
  end
    
  suspend;
end^

COMMENT ON PROCEDURE SP_GET_SEQUENCEID_BY_IDENT IS
'Sequences-Values ermitteln'^

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_GET_SEQUENCEID_BY_IDENT'^

SET TERM ; ^

COMMIT WORK;
/******************************************************************************/
/******************************************************************************/
/******************************************************************************/