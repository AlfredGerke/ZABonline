/*******************************************************************************
/* Author:  Alfred Gerke (AGE)                                                  
/* Date:    2013-05-07                                                        
/* Purpose: Grundsteinlegung des Datenmodelles für ZABonline (Wavemaker)    
/*                                                                              
/*******************************************************************************
/* - Das Script arbeitet mit Befehlen der SQL-Erweiterung für FireBird 2.5.x   
/* - Das Script ist für die Ausführung im IBExpert erstellt worden              
/* - Ein möglicher Connect zur Produktionsdatenbank sollte geschlossen werden   
/******************************************************************************/
/* History: 2013-05-06
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
  number = '4';
  subitem = '0';
  script = 'create_admin.sql';
  description = 'Administration erstellen';
  
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

/******************************************************************************/
/*                                  ALTER                                   
/******************************************************************************/

/******************************************************************************/
/*                                  Views                                   
/******************************************************************************/

/* USER-Views werden druch die SP: SP_CREATE_USER_VIEW erstellt */

/******************************************************************************/
/*                                Primary Keys                               
/******************************************************************************/

/******************************************************************************/
/*                                Foreign Keys                                
/******************************************************************************/

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

/* erstellt in create_person.sql, Kommentar und Grants schon vorhanden */
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

CREATE OR ALTER PROCEDURE SP_CHK_DATA_BY_ADD_USER (
  AROLE_ID integer,  /* Pflichtfeld */
  ATENANT_ID integer,  /* Pflichtfeld */
  APERSON_ID integer,
  AUSER varchar(256),  /* Pflichtfeld */
  APASSWORD varchar(512),  /* Pflichtfeld */
  AFIRSTNAME varchar(256),  /* Pflichtfeld */
  ANAME varchar(256),  /* Pflichtfeld */
  AEMAIL varchar(127), /* Pflichtfeld */
  AALLOW_LOGIN BOOLEAN)  /* Pflichtfeld */
RETURNS (
  success smallint,
  code smallint,
  info varchar(2000))
AS
begin 
  success = 0;
  code = 0;
  info = '{"result": null}';
  
  if (AROLE_ID is null) then
  begin
    code = 1;
    info = '{"kind": 1, "publish": "NO_MANDATORY_ROLE_ID_BY_NEWUSER", "message": "NO_MANDATORY_ROLE_ID"}';
    suspend;
    Exit;
  end
  
  if (not exists(select 1 from V_ROLES where ID=:AROLE_ID)) then
  begin
    code = 1;
    info = '{"kind": 1, "publish": "NO_VALID_ROLE_ID_BY_NEWUSER", "message": "NO_VALID_ROLE_ID"}';
    suspend;
    Exit;  
  end  
  
  if (ATENANT_ID is null) then
  begin
    code = 1;
    info = '{"kind": 1, "publish": "NO_MANDATORY_MANDANT_ID_BY_NEWUSER", "message": "NO_MANDATORY_MANDANT_ID"}';
    suspend;
    Exit;
  end
  
  if (not exists(select 1 from V_TENANT where ID=:ATENANT_ID)) then
  begin
    code = 1;
    info = '{"kind": 1, "publish": "NO_VALID_MANDANT_ID_BY_NEWUSER", "message": "NO_VALID_MANDANT_ID"}';
    suspend;
    Exit;  
  end
  
  if (APERSON_ID is not null) then
  begin
    if (not exists(select 1 from V_PERSON where ID=:APERSON_ID)) then
    begin
      code = 1;
      info = '{"kind": 1, "publish": "NO_VALID_PERSON_ID_BY_NEWUSER", "message": "NO_VALID_PERSON_ID"}';
      suspend;
      Exit;  
    end
  end 
  
  if (AUSER is null) then
  begin
    code = 1;
    info = '{"kind": 1, "publish": "NO_MANDATORY_USERNAME_BY_NEWUSER", "message": "NO_MANDATORY_USERNAME"}';
    suspend;
    Exit;    
  end
  else
  begin
    if (exists(select 1 from V_USERS where Upper(USERNAME)=Upper(:AUSER))) then
    begin
      code = 1;
      info = '{"kind": 1, "publish": "DUPLICATE_USERNAME_NOT_ALLOWED_BY_NEWUSER", "message": "DUPLICATE_USERNAME_NOT_ALLOWED"}';
      suspend;
      Exit;    
    end
  end
  
  if (APASSWORD is null) then
  begin
    code = 1;
    info = '{"kind": 1, "publish": "NO_MANDATORY_PASSWORD_BY_NEWUSER", "message": "NO_MANDATORY_PASSWORD"}';
    suspend;
    Exit;
  end
  
  if (AFIRSTNAME is null) then
  begin
    code = 1;
    info = '{"kind": 1, "publish": "NO_MANDATORY_FIRSTNAME_BY_NEWUSER", "message": "NO_MANDATORY_FIRSTNAME"}';
    suspend;
    Exit;  
  end
  
  if (ANAME is null) then
  begin
    code = 1;
    info = '{"kind": 1, "publish": "NO_MANDATORY_NAME_BY_NEWUSER", "message": "NO_MANDATORY_NAME"}';
    suspend;
    Exit;  
  end
  
  if (AEMAIL is null) then
  begin
    code = 1;
    info = '{"kind": 1, "publish": "NO_MANDATORY_EMAIL_BY_NEWUSER", "message": "NO_MANDATORY_EMAIL"}';
    suspend;
    Exit;  
  end
  
  if (AALLOW_LOGIN  not in (0,1)) then
  begin
    code = 1;
    info = '{"kind": 1, "publish": "NO_VALID_ALLOW_LOGIN_BY_NEWUSER", "message": "NO_VALID_ALLOW_LOGIN"}';
    suspend;
    Exit;  
  end  
  
  success = 1;
  
  suspend;
end^    

COMMENT ON PROCEDURE SP_CHK_DATA_BY_ADD_USER IS
'Überprüft alle logischen Inhalte für einen Benutzerdateneintrag'^

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_CHK_DATA_BY_ADD_USER'^
      
CREATE OR ALTER PROCEDURE SP_INSERT_USER (
  AROLE_ID integer,  /* Pflichtfeld */
  ATENANT_ID integer,  /* Pflichtfeld */
  APERSON_ID integer,
  AUSER varchar(256),  /* Pflichtfeld */
  APASSWORD varchar(512),  /* Pflichtfeld */
  AFIRSTNAME varchar(256),  /* Pflichtfeld */
  ANAME varchar(256),  /* Pflichtfeld */
  AEMAIL varchar(127), /* Pflichtfeld */
  AALLOW_LOGIN BOOLEAN)  /* Pflichtfeld */
RETURNS (
  success smallint,
  message varchar(254),
  user_id integer)
AS
begin
  success = 0;
  message = 'FAILD_BY_UNKNOWN_REASON';
  user_id = -1;
  
  if (exists(select 1 from V_USERS where Upper(USERNAME)=Upper(:AUSER))) then
  begin
    message = 'DUPLICATE_USERNAME_NOT_ALLOWED';
    suspend;
    Exit;    
  end
                                  
  select SEQ_ID from SP_GET_SEQUENCEID_BY_IDENT('USERS') into :user_id;

  if ((user_id <> -1) and (user_id is not null)) then
  begin
    insert
    into
      V_USERS
      (
        ID,
        ROLE_ID,
        TENANT_ID,
        PERSON_ID,
        USERNAME,
        "PASSWORD",
        FIRST_NAME,
        NAME,
        EMAIL,
        ALLOW_LOGIN
      )
    values
      (
        :user_id,
        :AROLE_ID,
        :ATENANT_ID,
        :APERSON_ID,
        :AUSER,
        :APASSWORD,
        :AFIRSTNAME,
        :ANAME,
        :AEMAIL,
        :AALLOW_LOGIN
      );  

    message = '';
    success = 1;      
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

COMMENT ON PROCEDURE SP_INSERT_USER IS
'Benutzerdaten einfügen'^                           

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_INSERT_USER'^

CREATE OR ALTER PROCEDURE SP_ADD_USER (
  AROLE_ID integer,  /* Pflichtfeld */
  ATENANT_ID integer,  /* Pflichtfeld */
  APERSON_ID integer,
  AUSER varchar(256),  /* Pflichtfeld */
  APASSWORD varchar(512),  /* Pflichtfeld */
  AFIRSTNAME varchar(256),  /* Pflichtfeld */
  ANAME varchar(256),  /* Pflichtfeld */
  AEMAIL varchar(127), /* Pflichtfeld */
  AALLOW_LOGIN BOOLEAN)  /* Pflichtfeld */
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

  /* Es werden alle Pflichtfelder überprüft */
  select 
    success, 
    code, 
    info 
  from 
    SP_CHK_DATA_BY_ADD_USER(:AROLE_ID,
                            :ATENANT_ID,
                            :APERSON_ID,
                            :AUSER,
                            :APASSWORD,
                            :AFIRSTNAME,
                            :ANAME,
                            :AEMAIL,
                            :AALLOW_LOGIN) 
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
      user_id      
    from
      SP_INSERT_USER(:AROLE_ID,
                     :ATENANT_ID,
                     :APERSON_ID,
                     :AUSER,
                     :APASSWORD,
                     :AFIRSTNAME,
                     :ANAME,
                     :AEMAIL,
                     :AALLOW_LOGIN)
    into
      :success,
      :message,
      :user_id;
      
    /* Rückgabe auswerten */     
    if (success = 0) then
    begin
      code = 1;
      info = '{"kind": 2, "publish": "INSERT_BY_USER_FAILD_BY_NEWUSER", "list": [{"message": "INSERT_BY_USER_FAILD"}, {"message": "' || :message || '"}]}';
      suspend;
      Exit;
    end
    
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
  end  

  suspend;
end
^

COMMENT ON PROCEDURE SP_ADD_USER IS
'Überprüft Eingaben und legt Benutzer an'^

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_ADD_USER'^

CREATE OR ALTER PROCEDURE SP_ADD_USER_BY_SRV (
  ASESSION_ID varchar(254),    
  AUSERNAME varchar(254),
  AIP varchar(254),
  AROLE_ID integer,  /* Pflichtfeld */
  ATENANT_ID integer,  /* Pflichtfeld */
  APERSON_ID integer,
  AUSER varchar(256),  /* Pflichtfeld */
  APASSWORD varchar(512),  /* Pflichtfeld */
  AFIRSTNAME varchar(256),  /* Pflichtfeld */
  ANAME varchar(256),  /* Pflichtfeld */
  AEMAIL varchar(127), /* Pflichtfeld */
  AALLOW_LOGIN BOOLEAN)  /* Pflichtfeld */
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
    select success from SP_CHECKGRANT(:AUSERNAME, 'IS_ADMIN') into :success_by_grant;
    
    if (success_by_grant = 1) then
    begin
      /* Wenn der JSON-String im Feld INFO zu lang wird, wird von der SP zwei oder mehrere Datensätze erzeugt.
         Aus diesem Grund wird die SP über eine FOR-Loop abgefragt
      */
      for select success, code, info from SP_ADD_USER(:AROLE_ID,
                                                      :ATENANT_ID,
                                                      :APERSON_ID,
                                                      :AUSER,
                                                      :APASSWORD,
                                                      :AFIRSTNAME,
                                                      :ANAME,
                                                      :AEMAIL,
                                                      :AALLOW_LOGIN) into :success, :code, :info do
      begin
        suspend;
      end 
    end
    else
    begin
      info = '{"kind": 1, "publish": "NO_GRANT_FOR_ADD_USER", "message": "NO_GRANT_FOR_ADD_USER"}';
      
      suspend;
    end
  end
  else
  begin
    info = '{"kind": 1, "publish": "CANCEL_PROCESS_BY_SESSIONMANAGEMENT", "message": "CANCEL_PROCESS_BY_SESSIONMANAGEMENT"}';
    
    suspend;
  end
end^

COMMENT ON PROCEDURE SP_ADD_USER_BY_SRV IS
'Überprüft Sitzungsverwaltung und ruft SP_ADD_USER auf'^

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_ADD_USER_BY_SRV'^

CREATE OR ALTER PROCEDURE SP_CHK_DATA_BY_ADD_ROLE (
  ACAPTION varchar(64)) /* Pflichtfeld */  
RETURNS (
  success smallint,
  code smallint,
  info varchar(2000))
AS
begin 
  success = 0;
  code = 0;
  info = '{"result": null}';
  
  if (ACAPTION is null) then
  begin
    code = 1;
    info = '{"kind": 1, "publish": "NO_MANDATORY_ROLE_CAPTION_BY_NEWROLE", "message": "NO_MANDATORY_ROLE_CAPTION"}';
    suspend;
    Exit;
  end
  
  if (exists(select 1 from V_ROLES where Upper(CAPTION)=Upper(:ACAPTION))) then
  begin
    code = 1;
    info = '{"kind": 1, "publish": "DUPLICATE_ROLECAPTION_NOT_ALLOWED_BY_NEWROLE", "message": "DUPLICATE_ROLECAPTION_NOT_ALLOWED"}';
    suspend;
    Exit;  
  end    
  
  success = 1;
  
  suspend;
end^    

COMMENT ON PROCEDURE SP_CHK_DATA_BY_ADD_ROLE IS
'Überprüft alle logischen Inhalte für einen Berechtigungsateneintrag'^

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_CHK_DATA_BY_ADD_ROLE'^

CREATE OR ALTER PROCEDURE SP_INSERT_ROLE (
  ACAPTION varchar(64), /* Pflichtfeld */
  ADESCRIPTION varchar(2000),
  AISADMIN Boolean,
  ASETUP Boolean,
  AMEMBERS Boolean,
  AACTIVITYRECORDING Boolean,
  ASEPA Boolean,
  ABILLING Boolean,
  AIMPORT Boolean,
  AEXPORT Boolean,
  AREFERENCEDATA Boolean,
  AREPORTING Boolean,
  AMISC Boolean,
  AFILERESOURCE Boolean)
RETURNS (
  success smallint,
  message varchar(254),
  role_id integer)
AS
begin
  success = 0;
  message = 'FAILD_BY_UNKNOWN_REASON';
  role_id = -1;
  
  if (exists(select 1 from V_ROLES where Upper(CAPTION)=Upper(:ACAPTION))) then
  begin
    message = 'DUPLICATE_ROLECAPTION_NOT_ALLOWED';
    suspend;
    Exit;    
  end
                                  
  select SEQ_ID from SP_GET_SEQUENCEID_BY_IDENT('ROLES') into :role_id;

  if ((role_id <> -1) and (role_id is not null)) then
  begin
    insert
    into
      V_ROLES
      (
        ID,
        CAPTION,
        DESCRIPTION,
        IS_ADMIN,
        SETUP,
        MEMBERS,
        ACTIVITY_RECORDING,
        SEPA,
        BILLING,
        IMPORT,
        EXPORT,
        REFERENCE_DATA,
        REPORTING,
        MISC,
        FILERESOURCE
      )
    values
      (
        :role_id,
        :ACAPTION,
        :ADESCRIPTION,
        :AISADMIN,
        :ASETUP,
        :AMEMBERS,
        :AACTIVITYRECORDING,
        :ASEPA,
        :ABILLING,
        :AIMPORT,
        :AEXPORT,
        :AREFERENCEDATA,
        :AREPORTING,
        :AMISC,
        :AFILERESOURCE
      );  

    message = '';
    success = 1;      
  end  
  else
  begin
    message = 'NO_VALID_ROLE_ID';
    success = 0;
    suspend;
    Exit;     
  end
  
  suspend;
end^

COMMENT ON PROCEDURE SP_INSERT_ROLE IS
'Benutzerrolle einfügen'^

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_INSERT_ROLE'^

CREATE OR ALTER PROCEDURE SP_ADD_ROLE (
  ACAPTION varchar(64), /* Pflichtfeld */
  ADESCRIPTION varchar(2000),
  AISADMIN Boolean,
  ASETUP Boolean,
  AMEMBERS Boolean,
  AACTIVITYRECORDING Boolean,
  ASEPA Boolean,
  ABILLING Boolean,
  AIMPORT Boolean,
  AEXPORT Boolean,
  AREFERENCEDATA Boolean,
  AREPORTING Boolean,
  AMISC Boolean,
  AFILERESOURCE Boolean)
RETURNS (
  success smallint,
  code smallint,
  info varchar(2000))
AS
declare variable message varchar(254);
declare variable role_id Integer;
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
    SP_CHK_DATA_BY_ADD_ROLE(:ACAPTION) 
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
      role_id      
    from
      SP_INSERT_ROLE(:ACAPTION,
        :ADESCRIPTION,
        :AISADMIN,
        :ASETUP,
        :AMEMBERS,
        :AACTIVITYRECORDING,
        :ASEPA,
        :ABILLING,
        :AIMPORT,
        :AEXPORT,
        :AREFERENCEDATA,
        :AREPORTING,
        :AMISC,
        :AFILERESOURCE)
    into
      :success,
      :message,
      :role_id;
      
    /* Rückgabe auswerten */     
    if (success = 0) then
    begin
      code = 1;
      info = '{"kind": 2, "publish": "INSERT_BY_ROLE_FAILD_BY_NEWROLE", "list": [{"message": "INSERT_BY_ROLE_FAILD"}, {"message": "' || :message || '"}]}';
      suspend;
      Exit;
    end
    
    /* success = 1; -> success sollte nur durch die Insert-SPs auf 1 gesetzt werden */
    code = 1;
    if (success = 1) then
    begin
      info = '{"kind": 3, "publish": "ADD_ROLE_SUCCEEDED", "message": "ADD_ROLE_SUCCEEDED"}';
    end  
    else
    begin
      success = 0;
      info = '{"kind": 1, "publish": "FAILD_BY_OBSCURE_PROCESSING", "message": "FAILD_BY_OBSCURE_PROCESSING"}';
    end                                   
  end  

  suspend;
end^

COMMENT ON PROCEDURE SP_ADD_ROLE IS
'Überprüft Eingaben und legt Benutzerrolle an'^

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_ADD_ROLE'^

CREATE OR ALTER PROCEDURE SP_ADD_ROLE_BY_SRV (
  ASESSION_ID varchar(254),    
  AUSERNAME varchar(254),
  AIP varchar(254),
  ACAPTION varchar(64), /* Pflichtfeld */
  ADESCRIPTION varchar(2000),  
  AISADMIN smallint,
  ASETUP smallint,
  AMEMBERS smallint,
  AACTIVITYRECORDING smallint,
  ASEPA smallint,
  ABILLING smallint,
  AIMPORT smallint,
  AEXPORT smallint,
  AREFERENCEDATA smallint,
  AREPORTING smallint,
  AMISC smallint,
  AFILERESOURCE smallint)  
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
    select success from SP_CHECKGRANT(:AUSERNAME, 'IS_ADMIN') into :success_by_grant;
    
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
        SP_ADD_ROLE(:ACAPTION,
          :ADESCRIPTION,  
          :AISADMIN,
          :ASETUP,
          :AMEMBERS,
          :AACTIVITYRECORDING,
          :ASEPA,
          :ABILLING,
          :AIMPORT,
          :AEXPORT,
          :AREFERENCEDATA,
          :AREPORTING,
          :AMISC,
          :AFILERESOURCE) 
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
      info = '{"kind": 1, "publish": "NO_GRANT_FOR_ADD_ROLE", "message": "NO_GRANT_FOR_ADD_ROLE"}';
      
      suspend;
    end
  end
  else
  begin
    info = '{"kind": 1, "publish": "CANCEL_PROCESS_BY_SESSIONMANAGEMENT", "message": "CANCEL_PROCESS_BY_SESSIONMANAGEMENT"}';
    
    suspend;
  end
end^

COMMENT ON PROCEDURE SP_ADD_ROLE_BY_SRV IS
'Überprüft Sitzungsverwaltung und ruft SP_ADD_ROLE auf'^

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_ADD_ROLE_BY_SRV'^

CREATE OR ALTER PROCEDURE SP_CHK_DATA_BY_ADD_TENANT(
  ACAPTION varchar(64), /* Pflichtfeld */
  ACOUNTRYCODEID integer,
  ASESSIONIDLETIME integer, /* Pflichtfeld */
  ASESSIONLIFETIME integer, /* Pflichtfeld */
  AMAXATTEMPT integer) /* Pflichtfeld */
RETURNS (
  success smallint,
  code smallint,
  info varchar(2000))
AS
begin
  success = 0;
  code = 0;
  info = '{"result": null}';
  
  if (ACAPTION is null) then
  begin
    code = 1;
    info = '{"kind": 1, "publish": "NO_MANDATORY_TENANT_BY_NEWTENANT", "message": "NO_MANDATORY_TENANT"}';
    suspend;
    Exit;    
  end
  else
  begin
    if (exists(select 1 from V_TENANT where Upper(CAPTION)=Upper(:ACAPTION))) then
    begin
      code = 1;
      info = '{"kind": 1, "publish": "DUPLICATE_TENANT_NOT_ALLOWED_BY_NEWTENANT", "message": "DUPLICATE_TENANT_NOT_ALLOWED"}';
      suspend;
      Exit;    
    end
  end
  
  if (ACOUNTRYCODEID is null) then
  begin
    /* vorerst keine Aktion */
  end
  else
  begin
    if (not exists(select 1 from V_COUNTRY where ID=:ACOUNTRYCODEID)) then
    begin
      code = 1;
      info = '{"kind": 1, "publish": "NO_VALID_COUNTRY_ID_BY_NEWTENANT", "message": "NO_VALID_COUNTRY_ID"}';
      suspend;
      Exit;      
    end
  end

  if (ASESSIONIDLETIME is null) then
  begin
    code = 1;
    info = '{"kind": 1, "publish": "NO_MANDATORY_SESSIONIDLETIME_BY_NEWTENANT", "message": "NO_MANDATORY_SESSIONIDLETIME"}';
    suspend;
    Exit;   
  end
  else
  begin
    if (ASESSIONIDLETIME <= 0) then
    begin
      code = 1;
      info = '{"kind": 1, "publish": "SESSIONIDLETIME_OUT_OF_RANGE_BY_NEWTENANT", "message": "SESSIONIDLETIME_OUT_OF_RANGE"}';
      suspend;
      Exit;    
    end
  end
  
  if (ASESSIONLIFETIME is null) then
  begin
    code = 1;
    info = '{"kind": 1, "publish": "NO_MANDATORY_SESSIONLIFETIME_BY_NEWTENANT", "message": "NO_MANDATORY_SESSIONLIFETIME"}';
    suspend;
    Exit;  
  end
  else
  begin
    if (ASESSIONLIFETIME <= 0) then
    begin
      code = 1;
      info = '{"kind": 1, "publish": "SESSIONLIFETIME_OUT_OF_RANGE_BY_NEWTENANT", "message": "SESSIONLIFETIME_OUT_OF_RANGE"}';
      suspend;
      Exit;    
    end
  end
  
  if (AMAXATTEMPT is null) then
  begin
    code = 1;
    info = '{"kind": 1, "publish": "NO_MANDATORY_MAXATTEMPT_BY_NEWTENANT", "message": "NO_MANDATORY_MAXATTEMPT"}';
    suspend;
    Exit;  
  end
  else
  begin
    if (AMAXATTEMPT <= 0) then
    begin
      code = 1;
      info = '{"kind": 1, "publish": "MAXATTEMPT_OUT_OF_RANGE_BY_NEWTENANT", "message": "MAXATTEMPT_OUT_OF_RANGE"}';
      suspend;
      Exit;    
    end
  end 
   
  /* Kein Exit bis hierhin */
  success = 1;
    
  suspend;
end^
  
COMMENT ON PROCEDURE SP_CHK_DATA_BY_ADD_TENANT IS
'Überprüft alle logischen Inhalte für einen Mandanteneintrag'^

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_CHK_DATA_BY_ADD_TENANT'^  
  
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
  
  if (ASessio)
  
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
        SESSION_LIFETIME                
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
        :ASESSIONLIFETIME
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

COMMENT ON PROCEDURE SP_INSERT_TENANT IS
'Mandanten einfügen'^

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_INSERT_TENANT'^
  
CREATE OR ALTER PROCEDURE SP_ADD_TENANT (
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
  code smallint,
  info varchar(2000))
AS
declare variable message varchar(254);
declare variable tenant_id Integer;
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
    SP_CHK_DATA_BY_ADD_TENANT(:ACAPTION,
      :ACOUNTRYCODEID,
      :ASESSIONIDLETIME,
      :ASESSIONLIFETIME,
      :AMAXATTEMPT) 
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
      tenant_id
    from
      SP_INSERT_TENANT(:ACAPTION,
        :ADESCRIPTION,  
        :AFACTORYDATAID,
        :APERSONDATAID,
        :ACONTACTDATAID,
        :AADDRESSDATAID,
        :ACOUNTRYCODEID,
        :ASESSIONIDLETIME,
        :ASESSIONLIFETIME,
        :AMAXATTEMPT)
    into
      :success,
      :message,
      :tenant_id;
      
    /* Rückgabe auswerten */     
    if (success = 0) then
    begin
      code = 1;
      info = '{"kind": 2, "publish": "INSERT_BY_TENANT_FAILD_BY_NEWTENANT", "list": [{"message": "IINSERT_BY_TENANT_FAILD_BY_NEWTENANT"}, {"message": "' || :message || '"}]}';
      suspend;
      Exit;
    end
    
    /* success = 1; -> success sollte nur durch die Insert-SPs auf 1 gesetzt werden */
    code = 1;
    if (success = 1) then
    begin
      info = '{"kind": 3, "publish": "ADD_TENANT_SUCCEEDED", "message": "ADD_TENANT_SUCCEEDED"}';
    end  
    else
    begin
      success = 0;
      info = '{"kind": 1, "publish": "FAILD_BY_OBSCURE_PROCESSING", "message": "FAILD_BY_OBSCURE_PROCESSING"}';
    end                                   
  end  

  suspend;
end^

COMMENT ON PROCEDURE SP_ADD_TENANT IS
'Überprüft Eingabedaten und legt Mandanten an'^

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_ADD_TENANT'^

CREATE OR ALTER PROCEDURE SP_ADD_TENANT_BY_SRV (
  ASESSION_ID varchar(254),    
  AUSERNAME varchar(254),
  AIP varchar(254),
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
    select success from SP_CHECKGRANT(:AUSERNAME, 'IS_ADMIN') into :success_by_grant;
    
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
        SP_ADD_TENANT(:ACAPTION,
          :ADESCRIPTION,  
          :AFACTORYDATAID,
          :APERSONDATAID,
          :ACONTACTDATAID,
          :AADDRESSDATAID,
          :ACOUNTRYCODEID,
          :ASESSIONIDLETIME,
          :ASESSIONLIFETIME,
          :AMAXATTEMPT) 
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
      info = '{"kind": 1, "publish": "NO_GRANT_FOR_ADD_TENANT", "message": "NO_GRANT_FOR_ADD_TENANT"}';
      
      suspend;
    end
  end
  else
  begin
    info = '{"kind": 1, "publish": "CANCEL_PROCESS_BY_SESSIONMANAGEMENT", "message": "CANCEL_PROCESS_BY_SESSIONMANAGEMENT"}';
    
    suspend;
  end
end^

COMMENT ON PROCEDURE SP_ADD_TENANT_BY_SRV IS
'Überprüft Sitzungsverwaltung und ruft SP_ADD_TENANT auf'^

execute procedure SP_GRANT_ROLE_TO_OBJECT 'R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', 'SP_ADD_TENANT_BY_SRV'^

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
GRANT EXECUTE ON PROCEDURE SP_TOUCHSESSION TO SP_ADD_ROLE_BY_SRV;
GRANT EXECUTE ON PROCEDURE SP_CHECKGRANT TO SP_ADD_ROLE_BY_SRV;
GRANT EXECUTE ON PROCEDURE SP_ADD_ROLE TO SP_ADD_ROLE_BY_SRV;

GRANT EXECUTE ON PROCEDURE SP_TOUCHSESSION TO SP_ADD_USER_BY_SRV;
GRANT EXECUTE ON PROCEDURE SP_CHECKGRANT TO SP_ADD_USER_BY_SRV;
GRANT EXECUTE ON PROCEDURE SP_ADD_USER TO SP_ADD_USER_BY_SRV;

GRANT EXECUTE ON PROCEDURE SP_CHK_DATA_BY_ADD_ROLE TO SP_ADD_ROLE;

GRANT EXECUTE ON PROCEDURE SP_CHK_DATA_BY_ADD_USER TO SP_ADD_USER;
GRANT EXECUTE ON PROCEDURE SP_INSERT_USER TO SP_ADD_USER;

GRANT SELECT ON V_ROLES TO SP_CHK_DATA_BY_ADD_ROLE;
GRANT SELECT, INSERT ON V_ROLES TO SP_INSERT_ROLE; 
GRANT EXECUTE ON PROCEDURE SP_GET_SEQUENCEID_BY_IDENT TO SP_INSERT_ROLE;

GRANT SELECT ON V_ROLES TO SP_CHK_DATA_BY_ADD_USER; 
GRANT SELECT ON V_TENANT TO SP_CHK_DATA_BY_ADD_USER;
GRANT SELECT ON V_PERSON TO SP_CHK_DATA_BY_ADD_USER;
GRANT SELECT ON V_USERS TO SP_CHK_DATA_BY_ADD_USER;

GRANT SELECT, INSERT ON V_USERS TO SP_INSERT_USER; 
GRANT EXECUTE ON PROCEDURE SP_GET_SEQUENCEID_BY_IDENT TO SP_INSERT_USER;

GRANT EXECUTE ON PROCEDURE SP_TOUCHSESSION TO SP_ADD_TENANT_BY_SRV;
GRANT EXECUTE ON PROCEDURE SP_CHECKGRANT TO SP_ADD_TENANT_BY_SRV;
GRANT EXECUTE ON PROCEDURE SP_ADD_ROLE TO SP_ADD_TENANT_BY_SRV;

GRANT EXECUTE ON PROCEDURE SP_CHK_DATA_BY_ADD_TENANT TO SP_ADD_TENANT; 
GRANT EXECUTE ON PROCEDURE SP_INSERT_TENANT TO SP_ADD_TENANT; 
GRANT SELECT ON V_COUNTRY TO SP_CHK_DATA_BY_ADD_TENANT;
GRANT SELECT ON V_TENANT TO SP_CHK_DATA_BY_ADD_TENANT;
GRANT SELECT, INSERT ON V_TENANT TO SP_INSERT_TENANT;
GRANT EXECUTE ON PROCEDURE SP_GET_SEQUENCEID_BY_IDENT TO SP_INSERT_TENANT;     
    
/* Roles */

COMMIT WORK;
/******************************************************************************/
/*                                 Input                                  
/******************************************************************************/

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/ 
