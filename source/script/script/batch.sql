/******************************************************************************/
/* Author:  Alfred Gerke (AGE)                                                  
/* Date:    2012-03-17                                                          
/* Purpose: Dieses Script ruft alle vorhandenen Updatescripte auf                                                              
/******************************************************************************/
/* - Das Script arbeitet mit Befehlen der SQL-Erweiterung für FireBird 2.5.x  
/* - Das Script ist ausschließlich für die Ausführung im IBExpert erstellt worden            
/* - Ein möglicher Connect zur ZABonline-DB muss geschlossen werden
/* - Das Datenbankfile muss vorhanden sein
/******************************************************************************/
/* History: 2012-03-17
/*          Erstellung 
/******************************************************************************/

/******************************************************************************/
/*                                  Create Users
/******************************************************************************/

/*
 *
 * 
  Userscript nur einmal einspielen.
  User werden in der Sicherheitsdatenbank angelegt.
  WICHTIG: Am Ende des Scriptes wird über einen Shell-Befehl eine bestehende
           Datenbank gelöscht. Dieser Vorgang kann im weiteren Verlauf zu Fehlern
           führen. In dem Fall die Datenbank von Hand löschen und erneut die
           Datenbank aufbauen beginnent mit create_tools.sql.
           Da im ersten Durchlauf die User über create_user.sql angelegt wurden,
           braucht dieses Script nicht mehr gestartet zu werden

input 'create_user.sql';
*
*
*/
/******************************************************************************/
/*                                  Create Database
/******************************************************************************/

input 'create_tools.sql';
input 'create_hibernate_workaround.sql';
/*
 * 
 * bis auf weiteres zurückgestellt
input 'create_json.sql';
*
*
*/ 


input 'create_interface.sql';

input 'create_db.sql';
input 'create_person.sql';
input 'create_testproc_env.sql';
input 'create_factory.sql';
input 'create_admin.sql';
input 'create_find.sql';

input 'create_implementation.sql';

/******************************************************************************/
/*                                  Modify Schema
/*
/* In diesem Abschnitt sollen nur Scripte aufgeführt werden die Ändernungen am
/* Datenmodell per SP durchführen. z.B.: SP_CREATE_ALL_SIMPLE_INDEXE
/******************************************************************************/

input 'create_simple_indexe.sql';
/*
 * 
 * bis auf weiteres zurückgestellt
input 'recreate_user_views.sql';
*
*
*/

input 'create_grant_catalog_properties.sql';

/******************************************************************************/
/*                                  Clean up
/*
/* In diesem Abschnitt sollen nur Scripte aufgeführt werden die alle temporären
/* Datenbankobjekte, welche nur für die Installation verwendet werden, entfernen
/******************************************************************************/

input 'clean_up.sql';

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/