/*******************************************************************************
/* Author:  Alfred Gerke (AGE)                                                  
/* Date:    2013-12-10                                                          
/* Purpose: Nicht implementierbare Interfaces erstellen
/*                                                                              
/*******************************************************************************
/* - Das Script arbeitet mit Befehlen der SQL-Erweiterung für FireBird 2.5.x   
/* - Das Script ist für die Ausführung im IBExpert erstellt worden              
/* - Ein möglicher Connect zur ZABonline-DB sollte geschlossen werden 
/* - Die Installationstools müssen installiert worden sein  
/******************************************************************************/
/* History: 2013-12-10
/*          Interfaces ohne Implementation erstellen 
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
  script = 'create_interface.sql';
  description = 'Interfaces ohne Implementation erstellen';
  
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
    
  suspend;
end^

/* Kommentar und Grants werden in create_implemantation.sql vergeben */

SET TERM ; ^

COMMIT WORK;
/******************************************************************************/
/******************************************************************************/
/******************************************************************************/