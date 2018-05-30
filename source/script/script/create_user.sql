/*******************************************************************************
/* Author:  Alfred Gerke (AGE)                                                  
/* Date:    2013-03-12                                                          
/* Purpose: Grundsteinlegung des Datenmodelles für ZABonline (Wavemaker)    
/*                                                                              
/*******************************************************************************
/* - Das Script arbeitet mit Befehlen der SQL-Erweiterung für FireBird 2.5.x   
/* - Das Script ist für die Ausführung im ISQL erstellt worden              
/* - Ein möglicher Connect zur ZABonline-DB sollte geschlossen werden   
/******************************************************************************/
/* History: 2013-03-12
/*          Benutzer anlegen
/*          2014-04-05
/*          Scripte auf ISQL optimiert
/******************************************************************************/
/* Vorhandene Datenbank löschen: Pfad anpassen! */
SHEll DEL C:\Users\Alfred\Sourcen\db\firebird\zabonline\legacy\ZAB_ONLINE.FDB;

SET SQL DIALECT 3;

SET NAMES WIN1252;

SET AUTODDL;

/* An dieser Stelle muss die IP, der Datenbankpfad, Name der Datanbank sowie Benutzerinformationen (User/Password) überführt werden */
CREATE DATABASE '127.0.0.1/32258:ZABONLINEEMBEDDED' USER 'SYSDBA' PASSWORD 'masterkey' PAGE_SIZE 4096 DEFAULT CHARACTER SET WIN1252 COLLATION WIN1252;
/******************************************************************************/
/*                                   User                                   
/******************************************************************************/

  CREATE USER WEBCONNECT
  PASSWORD 'webconnect' 
  FIRSTNAME 'Online' 
  MIDDLENAME 'Mitglieder' 
  LASTNAME 'Verwaltung';
    
COMMIT WORK;
/******************************************************************************/
/******************************************************************************/
/******************************************************************************/