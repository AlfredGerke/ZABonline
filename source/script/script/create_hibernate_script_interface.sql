/*******************************************************************************
/* Author:  Alfred Gerke (AGE)                                                  
/* Date:    2013-04-16                                                          
/* Purpose: Grundsteinlegung des Datenmodelles f�r ZABonline (Wavemaker)    
/*                                                                              
/*******************************************************************************
/* - Das Script arbeitet mit Befehlen der SQL-Erweiterung f�r FireBird 2.5.x   
/* - Das Script ist f�r die Ausf�hrung im IBExpert erstellt worden              
/* - Ein m�glicher Connect zur Produktionsdatenbank sollte geschlossen werden   
/******************************************************************************/
/* History: 2013-04-16
/*          Erstellt ein Script-Inteface f�r Hibernate und f�hrt das Script-Interface aus
/******************************************************************************/

/******************************************************************************/
/*        Following SET SQL DIALECT is just for the Database Comparer         */
/******************************************************************************/
SET SQL DIALECT 3;

SET NAMES WIN1252;

/* An dieser Stelle muss die Client-DLL (Pfad und Name) �berpr�ft werden      */
SET CLIENTLIB 'C:\Users\Alfred\Programme\Firebird_2_5\bin\fbclient.dll';

/* An dieser Stelle muss die IP, der Datenbankpfad, Name der Datanbank sowie Benutzerinformationen (User/Password) �berf�hrt werden */
CONNECT '127.0.0.1:ZABONLINEEMBEDDED' USER 'SYSDBA' PASSWORD 'masterkey';
/******************************************************************************/
/*                                 Script-Interface                                  
/******************************************************************************/
/* Wenn Script-Interface vorhanden, zuerst l�schen */
SHEll DEL C:\Users\Alfred\Sourcen\GitHub\ZABonline\source\script\model2hibernate\create_hibernate_interface.sql;

OUTPUT 'C:\Users\Alfred\Sourcen\GitHub\ZABonline\source\script\model2hibernate\create_hibernate_interface.sql';
select Trim(trailing from sourcecode) from SP_CREATE_HIBERNATE_SCRIPT('person', 0, 1, 'INSTALLER', 'C:\Users\Alfred\Sourcen\GitHub\ZABonline\source\script\model2hibernate\', 'masterkey');
OUTPUT; 
  
COMMIT WORK;
/******************************************************************************/
/*                                 Hibernate-Interface                                  
/******************************************************************************/

input 'C:\Users\Alfred\Sourcen\GitHub\ZABonline\source\script\model2hibernate\create_hibernate_interface.sql';

COMMIT WORK;
/******************************************************************************/
/******************************************************************************/
/******************************************************************************/
