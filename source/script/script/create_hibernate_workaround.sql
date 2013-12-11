/*******************************************************************************
/* Author:  Alfred Gerke (AGE)                                                  
/* Date:    2013-10-19                                                          
/* Purpose: Workaround für das Hibernate-Interface von WaveMaker
/*
/*          In WaveMaker Stand 6.5.3 ist es nicht möglich einzelne Entitäten
/*          aus einer Datenbank zu erstellen. Es wird immer nur die gesamte Datenbank
/*          generiert. Einzelne Tabellen lassen sich nicht auswählen.          
/*          Mit diesem Workaround lassen sich für ausgwählte Tabellen Entitäten 
/*          erstellen, welche zu den vorhandenen Entitäten kopiert werden können.
/* 
/*          Zu einer Tabelle wird eine *.java-Datei erstellt, eine *.hbm.xml-
/*          Beschreibungsdatei und eine Checkliste erstellt. 
/*          Die *.java-Datei und die *.hbm.xml-Datei wird zu den übrigen Dateien
/*          der Hibernate-Schnittstelle kopiert.
/*
/*          Die Checkliste beschreibt, welche Wavemaker Dateien mit welchen 
/*          Inhalten gändert werden müssen.
/*                                                                               
/*******************************************************************************
/* - Das Script arbeitet mit Befehlen der SQL-Erweiterung für FireBird 2.5.x   
/* - Das Script ist für die Ausführung im IBExpert erstellt worden              
/* - Ein möglicher Connect zur ZABonline-DB sollte geschlossen werden   
/******************************************************************************/
/* History: 2013-10-19
/*          Workaround für das Hibernate-Interface von WaveMaker
/******************************************************************************/

/******************************************************************************/
/*        Following SET SQL DIALECT is just for the Database Comparer         
/******************************************************************************/
SET SQL DIALECT 3;

SET NAMES WIN1252;

/* An dieser Stelle muss die Client-DLL (Pfad und Name) überprüft werden      */
SET CLIENTLIB 'C:\Users\Alfred\Programme\Firebird_2_5\bin\fbclient.dll';

/* An dieser Stelle muss die IP, der Datenbankpfad, Name der Datanbank sowie Benutzerinformationen (User/Password) überführt werden */
CONNECT '127.0.0.1:ZABONLINEEMBEDDED' USER 'SYSDBA' PASSWORD 'masterkey';
/******************************************************************************/
/*                                  Hibernate-Workaround                                   
/******************************************************************************/

SET TERM ^ ;

CREATE OR ALTER PROCEDURE SP_GET_INDENTS (
  AINDENT smallint = 1,
  AINDENTLEN smallint = 2)
returns (
  result varchar(254))
as
declare variable indent varchar(254);
declare variable is_ready smallint;
declare variable idx smallint;
begin
  result = '';
  indent = '';
  is_ready = 0;
  idx = 1;
  
  while (is_ready = 0) do
  begin
    indent = indent || ' ';
    
    if (idx = AINDENTLEN) then
    begin
      is_ready = 1;
    end
    else
    begin
      idx = idx + 1;
    end
  end 
  
  is_ready = 0;
  idx = 1;
  
  while (is_ready = 0) do
  begin
    result = result || indent;
  
    if (idx = AINDENT) then
    begin
      is_ready = 1;
    end
    else
    begin
      idx = idx + 1;
    end
  end
  
  suspend;
end^

COMMENT ON PROCEDURE SP_GET_INDENTS IS
'Idents für die Codegenerierung'^
  
CREATE OR ALTER PROCEDURE SP_CAPITALIZE (
  ASTRING varchar(2000),
  AINDEX integer,
  ADOLOWER smallint DEFAULT NULL)
returns (
  result varchar(2000)  
)
as
declare variable dummy varchar(2000);
declare variable replace_dummy varchar(2000);
declare variable idx integer;
begin
  dummy = ASTRING;
  
  if (ADOLOWER = 1) then  
  begin
    dummy = Lower(dummy);
  end  
  
  if (AINDEX = 0) then
  begin
    idx = 1;
  end
  else
  begin
    idx = AINDEX;
  end
    
  replace_dummy = Upper(substring(:dummy from idx for 1));
  dummy = overlay(:dummy placing :replace_dummy from idx for 1);
  
  result = dummy;
  
  suspend;
end^

COMMENT ON PROCEDURE SP_CAPITALIZE IS
'Zeichen im String Groß schreiben'^

CREATE OR ALTER PROCEDURE SP_SET_ENTITYNAME (
  AREPLACESTRING varchar(32),
  ASTRING varchar(32),
  ADOUPPER smallint,
  ADUMMY varchar(32) DEFAULT NULL)
returns (
  property varchar(32))
as
declare variable format_string varchar(32);
declare variable sub_string varchar(32);
declare variable replace_string varchar(32);
declare variable is_ready smallint;
declare variable idx integer;
declare variable dummy varchar(32);
begin
  format_string = Lower(Trim(ASTRING));
  sub_string = AREPLACESTRING;
  idx = 0;
  is_ready = 0;
  
  if (ADUMMY is not null) then
  begin
    dummy = ADUMMY;
  end
  else
  begin
    dummy = ' ';
  end
  
  if (dummy = AREPLACESTRING) then
  begin
    property = format_string;
    suspend;
    Exit;
  end 
  
  while (is_ready = 0) do
  begin
    idx = position(:sub_string in :format_string);
    if (idx > 0) then
    begin
      is_ready = 0;
      /* replace_string = ' ' || Upper(substring(:format_string from idx+1 for 1)); */
      if (ADOUPPER = 1) then
      begin
        replace_string = Upper(substring(:format_string from idx+1 for 1));
      end
      else
      begin
        replace_string = substring(:format_string from idx+1 for 1);
      end
      
      format_string = overlay(:format_string placing :replace_string from idx for 2);
    end
    else
    begin
      is_ready = 1;
    end
  end

  /*format_string = replace(:format_string, ' ', '');*/

  property = format_string;
  
  suspend;
end^

COMMENT ON PROCEDURE SP_SET_ENTITYNAME IS
'Feldnamen anpassen'^ 

CREATE OR ALTER PROCEDURE SP_METADATA_TO_JAVA(
  ATABLENAME varchar(32),
  AIS_VIEW smallint,
  AINSTALL_USER varchar(32),
  AFLAG varchar(32),
  APACKAGE varchar(254) DEFAULT 'com.zabonlinedb.data',
  ADBNAME varchar(254) DEFAULT 'ZABonline [WaveMaker]',
  ADBVERSION varchar(64) DEFAULT '000.000.00000')
returns (
  sourcecode varchar(2000))
as
declare variable original_field_name varchar(31);
declare variable field_name varchar(31);
declare variable field_source varchar(31);
declare variable field_length smallint;
declare variable field_scale smallint;
declare variable field_type smallint;
declare variable date_found smallint;
declare variable class_name varchar(2000);
declare variable package_name varchar(254);
declare variable db_name varchar(254);
declare variable db_version varchar(64);
declare variable method_name varchar(254);
declare variable indent_x1 varchar(254);
declare variable indent_x2 varchar(254);
begin
  /*
   *
   *   
  OUTPUT 'C:\Users\Alfred\Sourcen\GitHub\ZABonline\source\script\model2hibernate\datasheet.java';
  select Trim(sourcecode) from SP_METADATA_TO_JAVA('DATASHEET', 0, 'INSTALLER', 'BEGIN', 'com.zabonlinedb.data', 'ZABonline [WaveMaker]', '000.000.00000');
  select Trim(sourcecode) from SP_METADATA_TO_JAVA('DATASHEET', 0, 'INSTALLER', 'PROPERTY', null,null, null);
  select Trim(sourcecode) from SP_METADATA_TO_JAVA('DATASHEET', 0, 'INSTALLER', 'METHOD', null,null, null);
  select Trim(sourcecode) from SP_METADATA_TO_JAVA('DATASHEET', 0, 'INSTALLER', 'END', null,null, null);
  OUTPUT;
   *
   *
   */

  sourcecode = '';
  date_found = 0;
  class_name = ATABLENAME;   
  package_name = APACKAGE;
  db_name = ADBNAME;
  db_version = ADBVERSION;
  
  select result from SP_GET_INDENTS(1) into :indent_x1;
  select result from SP_GET_INDENTS(2) into :indent_x2;
    
  if (exists(select 1 from RDB$RELATIONS where UPPER(RDB$RELATION_NAME)=UPPER(:ATABLENAME) and UPPER(RDB$OWNER_NAME)=UPPER(:AINSTALL_USER))) then
  begin
    if (AFLAG = 'END') then
    begin      
      sourcecode = '}';
      suspend;
      Exit;
    end
    
    if (AFLAG = 'BEGIN') then
    begin    
      sourcecode = 'package ' || package_name || ';';      
      suspend;
      sourcecode = '';
      suspend;      
    end
    
    for 
      select 
        RDB$FIELD_NAME,
        RDB$FIELD_SOURCE 
      from 
        RDB$RELATION_FIELDS 
      where 
        UPPER(RDB$RELATION_NAME)=UPPER(:ATABLENAME) 
      into 
        :original_field_name,
        :field_source 
    do
    begin
      for 
        select
          RDB$FIELD_LENGTH,
          RDB$FIELD_SCALE,
          RDB$FIELD_TYPE   
        from
          RDB$FIELDS
        where
          (UPPER(RDB$FIELD_NAME) = UPPER(:field_source))        
        into
          :field_length,
          :field_scale,
          :field_type
      do
      begin
        /*
         *
         *         
        Datatype: BLOB - Fieldtype: 261
        Datatype: CHAR - Fieldtype: 14
        Datatype: CSTRING - Fieldtype: 40
        Datatype: D_FLOAT - Fieldtype: 11
        Datatype: DOUBLE - Fieldtype: 27
        Datatype: FLOAT - Fieldtype: 10
        Datatype: INT64 - Fieldtype: 16
        Datatype: INTEGER - Fieldtype: 8
        Datatype: QUAD - Fieldtype: 9
        Datatype: SMALLINT - Fieldtype: 7
        Datatype: DATE - Fieldtype: 12
        Datatype: TIME - Fieldtype: 13
        Datatype: TIMESTAMP - Fieldtype: 35
        Datatype: VARCHAR - Fieldtype: 37
        *
        *        
        */
              
        original_field_name = trim(original_field_name);
        select property from SP_SET_ENTITYNAME('_', :original_field_name, 1, null) into :field_name;
        select result from SP_CAPITALIZE(:field_name, 1, 0) into :method_name;          
        
        if (AFLAG = 'BEGIN') then
        begin
          if (field_type in (12, 13, 35)) then
          begin
            if (date_found = 0) then
            begin
              date_found = 1;
              sourcecode = 'import java.util.Date;';
              suspend;
            end
          end       
        end        
              
        if (AFLAG = 'PROPERTY') then
        begin
          if (field_type in (14, 37, 40, 261)) then
          begin
            sourcecode = indent_x1 || 'private String ' || field_name || ';';
            suspend;
          end         
          
          if (field_type in (11, 27)) then
          begin
            sourcecode = indent_x1 || 'private Double ' || field_name || ';';
            suspend;
          end          
          
          if (field_type = 10) then
          begin
            sourcecode = indent_x1 || 'private Float ' || field_name || ';';
            suspend;
          end          

          if (field_type = 16) then
          begin
            sourcecode = indent_x1 || 'private Long ' || field_name || ';';
            suspend;
          end

          if (field_type = 8) then
          begin
            sourcecode = indent_x1 || 'private Integer ' || field_name || ';';
            suspend;
          end          

          if (field_type = 9) then
          begin
            sourcecode = '//Unbekannter Feldtype: QUAD - Fieldtype: 9 -> ' || field_name || ';';
            suspend;
          end          
          
          if (field_type = 7) then
          begin
            sourcecode = indent_x1 || 'private Short ' || field_name || ';';
            suspend;
          end          
          
          if (field_type in (12, 13, 35)) then
          begin
            sourcecode = indent_x1 || 'private Date ' || field_name || ';';
            suspend;
          end                                                   
        end

        if (AFLAG = 'METHOD') then
        begin
          if (field_type in (14, 37, 40, 261)) then
          begin
            sourcecode = indent_x1 || 'public String get' || method_name || '(String '|| field_name ||') {';
            suspend;
            sourcecode = indent_x2 || 'return ' || field_name || ';';
            suspend;
            sourcecode = indent_x1 || '}';
            suspend;         
            sourcecode = '';
            suspend;
            sourcecode = indent_x1 || 'public void set' || method_name || '(String '|| field_name ||') {';
            suspend;
            sourcecode = indent_x2 || 'this.' || field_name || ' = ' || field_name || ';';
            suspend;
            sourcecode = indent_x1 || '}';
            suspend;         
            sourcecode = '';
            suspend;               
          end
                   
          if (field_type in (11, 27)) then
          begin
            sourcecode = indent_x1 || 'public Double get' || method_name || '(Double '|| field_name ||') {';
            suspend;
            sourcecode = indent_x2 || 'return ' || field_name || ';';
            suspend;
            sourcecode = indent_x1 || '}';
            suspend;         
            sourcecode = '';
            suspend;
            sourcecode = indent_x1 || 'public void set' || method_name || '(Double '|| field_name ||') {';
            suspend;
            sourcecode = indent_x2 || 'this.' || field_name || ' = ' || field_name || ';';
            suspend;
            sourcecode = indent_x1 || '}';
            suspend;         
            sourcecode = '';
            suspend;            
          end          
          
          if (field_type = 10) then
          begin
            sourcecode = indent_x1 || 'public Float get' || method_name || '(Float '|| field_name ||') {';
            suspend;
            sourcecode = indent_x2 || 'return ' || field_name || ';';
            suspend;
            sourcecode = indent_x1 || '}';
            suspend;         
            sourcecode = '';
            suspend;
            sourcecode = indent_x1 || 'public void set' || method_name || '(Float '|| field_name ||') {';
            suspend;
            sourcecode = indent_x2 || 'this.' || field_name || ' = ' || field_name || ';';
            suspend;
            sourcecode = indent_x1 || '}';
            suspend;         
            sourcecode = '';
            suspend;            
          end          

          if (field_type = 16) then
          begin
            sourcecode = indent_x1 || 'public Long get' || method_name || '(Long '|| field_name ||') {';
            suspend;
            sourcecode = indent_x2 || 'return ' || field_name || ';';
            suspend;
            sourcecode = indent_x1 || '}';
            suspend;         
            sourcecode = '';
            suspend;
            sourcecode = indent_x1 || 'public void set' || method_name || '(Long '|| field_name ||') {';
            suspend;
            sourcecode = indent_x2 || 'this.' || field_name || ' = ' || field_name || ';';
            suspend;
            sourcecode = indent_x1 || '}';
            suspend;         
            sourcecode = '';
            suspend;            
          end

          if (field_type = 8) then
          begin
            sourcecode = indent_x1 || 'public Integer get' || method_name || '(Integer '|| field_name ||') {';
            suspend;
            sourcecode = indent_x2 || 'return ' || field_name || ';';
            suspend;
            sourcecode = indent_x1 || '}';
            suspend;         
            sourcecode = '';
            suspend;
            sourcecode = indent_x1 || 'public void set' || method_name || '(Integer '|| field_name ||') {';
            suspend;
            sourcecode = indent_x2 || 'this.' || field_name || ' = ' || field_name || ';';
            suspend;
            sourcecode = indent_x1 || '}';
            suspend;         
            sourcecode = '';
            suspend;            
          end          

          if (field_type = 9) then
          begin
            sourcecode = '//Unbekannter Feldtype: QUAD - Fieldtype: 9 -> ' || field_name || ';';
            suspend;
          end          
          
          if (field_type = 7) then
          begin
            sourcecode = indent_x1 || 'public Short get' || method_name || '(Short '|| field_name ||') {';
            suspend;
            sourcecode = indent_x2 || 'return ' || field_name || ';';
            suspend;
            sourcecode = indent_x1 || '}';
            suspend;         
            sourcecode = '';
            suspend;
            sourcecode = indent_x1 || 'public void set' || method_name || '(Short '|| field_name ||') {';
            suspend;
            sourcecode = indent_x2 || 'this.' || field_name || ' = ' || field_name || ';';
            suspend;
            sourcecode = indent_x1 || '}';
            suspend;         
            sourcecode = '';
            suspend;            
          end          
          
          if (field_type in (12, 13, 35)) then
          begin
            sourcecode = indent_x1 || 'public Date get' || method_name || '(Date '|| field_name ||') {';
            suspend;
            sourcecode = indent_x2 || 'return ' || field_name || ';';
            suspend;
            sourcecode = indent_x1 || '}';
            suspend;         
            sourcecode = '';
            suspend;
            sourcecode = indent_x1 || 'public void set' || method_name || '(Date '|| field_name ||') {';
            suspend;
            sourcecode = indent_x2 || 'this.' || field_name || ' = ' || field_name || ';';
            suspend;
            sourcecode = indent_x1 || '}';
            suspend;         
            sourcecode = '';
            suspend;            
          end                            
        end        
      end     
    end
    
    if (AFLAG = 'PROPERTY') then
    begin
      sourcecode = '';
      suspend;
      Exit;
    end  
    
    if (AFLAG = 'BEGIN') then
    begin
      select property from SP_SET_ENTITYNAME('_', :ATABLENAME, 1, null) into :class_name;
      select result from SP_CAPITALIZE(:class_name, 1, 0) into :class_name;
      
      sourcecode = '/**';
      suspend;
      sourcecode = ' * ';
      suspend;          
      sourcecode = ' *  Erstellt: via SP_METADATA_TO_JAVA - Datenbank: ' || db_name || ' - Version: ' || db_version;
      suspend;
      sourcecode = ' *  Erstellt am: ' || current_timestamp;
      suspend;       
      sourcecode = ' *  Entität: ' || class_name;
      suspend;
      sourcecode = ' * ';
      suspend;
      sourcecode = ' */';    
      suspend;
      sourcecode = 'public class ' || class_name || ' {';
      suspend;
      sourcecode = '';
      suspend;
      Exit;
    end    
  end            
end^

COMMENT ON PROCEDURE SP_METADATA_TO_JAVA IS
'Erstellt Entitäten (Java-Sourcecode) für eine Hibernateschnittstelle'^

CREATE OR ALTER PROCEDURE SP_METADATA_TO_XML(
  ATABLENAME varchar(32),
  AIS_VIEW smallint,
  ATABLE_AS_VIEW smallint,
  AINSTALL_USER varchar(32),
  AFLAG varchar(32),
  APACKAGE varchar(254) DEFAULT 'com.zabonlinedb.data',
  ADBNAME varchar(254) DEFAULT 'ZABonline [WaveMaker]',
  ADBVERSION varchar(64) DEFAULT '000.000.00000',
  AHIBERNATEURI varchar(254) DEFAULT '-//Hibernate/Hibernate Mapping DTD 3.0//EN',
  AHIBERNATEMAPDTD varchar(254) DEFAULT 'http://hibernate.sourceforge.net/hibernate-mapping-3.0.dtd',
  AIDNAME varchar(264) DEFAULT 'id',
  AGENERATORCLASS varchar(64) DEFAULT 'assigned') 
returns (
  sourcecode varchar(2000))
as
declare variable original_field_name varchar(31);
declare variable field_name varchar(31);
declare variable field_source varchar(31);
declare variable field_length smallint;
declare variable field_scale smallint;
declare variable field_type smallint;                                       
declare variable class_name varchar(2000);
declare variable package_name varchar(254);
declare variable db_name varchar(254);
declare variable db_version varchar(64);
declare variable method_name varchar(254);
declare variable indent_x1 varchar(254);
declare variable indent_x2 varchar(254);
declare variable indent_x3 varchar(254);
declare variable indent_x4 varchar(254);
declare variable hibernate_uri varchar(254);
declare variable hibernate_map_dtd varchar(254);
declare variable db_source varchar(32);
declare variable pk_index_name varchar(32);
declare variable count_pk_fields integer;
declare variable data_type varchar(64);
declare variable null_flag smallint;
declare variable property_items varchar(64);
declare variable pk_contraint_name varchar(32);
declare variable is_pk smallint;
begin
  /*
   *
   *   
  OUTPUT 'C:\Users\Alfred\Sourcen\GitHub\ZABonline\source\script\model2hibernate\datasheet.hbm.xml';
  select Trim(sourcecode) from SP_METADATA_TO_XML('DATASHEET', 0, 1, 'INSTALLER', 'BEGIN', 'com.zabonlinedb.data', 'ZABonline [WaveMaker]', '000.000.00000', '-//Hibernate/Hibernate Mapping DTD 3.0//EN', 'http://hibernate.sourceforge.net/hibernate-mapping-3.0.dtd');
  select Trim(sourcecode) from SP_METADATA_TO_XML('DATASHEET', 0, 1, 'INSTALLER', 'PK_PROPERTY');
  select Trim(sourcecode) from SP_METADATA_TO_XML('DATASHEET', 0, 1, 'INSTALLER', 'PROPERTY');
  select Trim(sourcecode) from SP_METADATA_TO_XML('DATASHEET', 0, 1, 'INSTALLER', 'END');
  OUTPUT;
   *
   *
   */
  sourcecode = '';
  class_name = ATABLENAME;     
  package_name = APACKAGE;
  db_name = ADBNAME;
  db_version = ADBVERSION;
  hibernate_uri = AHIBERNATEURI;
  hibernate_map_dtd = AHIBERNATEMAPDTD;
  
  select result from SP_GET_INDENTS(1) into :indent_x1;
  select result from SP_GET_INDENTS(2) into :indent_x2;
  select result from SP_GET_INDENTS(3) into :indent_x3;
  select result from SP_GET_INDENTS(4) into :indent_x4;
  
  if (ATABLE_AS_VIEW = 1) then
  begin
    db_source = 'V_' || UPPER(ATABLENAME);
  end
  else
  begin
    db_source = UPPER(ATABLENAME);
  end
   
  if (exists(select 1 from RDB$RELATIONS where UPPER(RDB$RELATION_NAME)=UPPER(:ATABLENAME) and UPPER(RDB$OWNER_NAME)=UPPER(:AINSTALL_USER))) then
  begin
    if (AFLAG = 'END') then
    begin     
      sourcecode= indent_x1 || '</class>';
      suspend;
      sourcecode = '</hibernate-mapping>';
      suspend;
      Exit;
    end  
  
    if (AFLAG = 'BEGIN') then
    begin
      select property from SP_SET_ENTITYNAME('_', :ATABLENAME, 1, null) into :class_name;   
      select result from SP_CAPITALIZE(:class_name, 1, 0) into :class_name;

      sourcecode = '<!-- Erstellt: via SP_METADATA_TO_XML - Datenbank: ' || db_name || ' - Version: ' || db_version || ' -->';
      suspend;
      sourcecode = '<!-- Erstellt am: ' || current_timestamp || ' -->';
      suspend;       
      sourcecode = '<!-- Entität: ' || class_name || ' -->';
      suspend;
      sourcecode = '<!DOCTYPE hibernate-mapping PUBLIC "' || hibernate_uri || '" "' || hibernate_map_dtd ||'">';
      suspend;
      sourcecode = '<hibernate-mapping>';
      suspend;
      sourcecode= indent_x1 || '<class name="'|| package_name || '.' || class_name ||'" table="' || db_source ||'" dynamic-insert="false" dynamic-update="false">';
      suspend;
      Exit;
    end  
        
    select
      RDB$CONSTRAINT_NAME,
      RDB$INDEX_NAME
    from
      RDB$RELATION_CONSTRAINTS
    where
      RDB$RELATION_NAME = Upper(:ATABLENAME)
      and
      RDB$CONSTRAINT_TYPE = 'PRIMARY KEY'
    into
      :pk_contraint_name,
      :pk_index_name;    
  
    select count(RDB$FIELD_NAME) from RDB$INDEX_SEGMENTS where UPPER(RDB$INDEX_NAME)=UPPER(:pk_index_name) into :count_pk_fields;
    
    if (AFLAG = 'PK_PROPERTY') then
    begin
      if ((count_pk_fields = 0) or (count_pk_fields is null)) then
      begin
        sourcecode = '<!-- Warning: NO PRIMARY KEY PRESENT -->';
        suspend;
        Exit;        
      end
      else
      begin
        if (count_pk_fields > 1) then
        begin
          sourcecode = indent_x2 || '<composite-id name="' || AIDNAME || '" class="' || package_name || '.' || class_name ||'">';
          suspend;
        end
      end
    end
          
    for 
      select 
        RDB$FIELD_NAME,
        RDB$FIELD_SOURCE,
        RDB$NULL_FLAG 
      from 
        RDB$RELATION_FIELDS 
      where 
        UPPER(RDB$RELATION_NAME)=UPPER(:ATABLENAME) 
      into 
        :original_field_name,
        :field_source,
        :null_flag 
    do
    begin
      for 
        select
          RDB$FIELD_LENGTH,
          RDB$FIELD_SCALE,
          RDB$FIELD_TYPE   
        from
          RDB$FIELDS
        where
          (UPPER(RDB$FIELD_NAME) = UPPER(:field_source))        
        into
          :field_length,
          :field_scale,
          :field_type
      do
      begin 
        /*
         *
         *         
        Datatype: BLOB - Fieldtype: 261
        Datatype: CHAR - Fieldtype: 14
        Datatype: CSTRING - Fieldtype: 40
        Datatype: D_FLOAT - Fieldtype: 11
        Datatype: DOUBLE - Fieldtype: 27
        Datatype: FLOAT - Fieldtype: 10
        Datatype: INT64 - Fieldtype: 16
        Datatype: INTEGER - Fieldtype: 8
        Datatype: QUAD - Fieldtype: 9
        Datatype: SMALLINT - Fieldtype: 7
        Datatype: DATE - Fieldtype: 12
        Datatype: TIME - Fieldtype: 13
        Datatype: TIMESTAMP - Fieldtype: 35
        Datatype: VARCHAR - Fieldtype: 37
        *
        *        
        */
        property_items = '';
        original_field_name = trim(original_field_name);
        select property from SP_SET_ENTITYNAME('_', :original_field_name, 1, null) into :field_name;
        select result from SP_CAPITALIZE(:field_name, 1, 0) into :method_name;                                 
                  
        if (field_type in (14, 37, 40, 261)) then
        begin
          data_type = 'string';          
          property_items = ' length="' || field_length || '"';
        end
                 
        if (field_type in (11, 27)) then
        begin
          data_type = 'double';            
          property_items = ' length="' || field_length || '"';
        end          
        
        if (field_type = 10) then
        begin
          data_type = 'float';            
          property_items = ' length="' || field_length || '"';
        end          

        if (field_type = 16) then
        begin
          data_type = 'long';            
        end

        if (field_type = 8) then
        begin
          data_type = 'integer';            
        end          

        if (field_type = 9) then
        begin
          break;            
        end          
        
        if (field_type = 7) then
        begin
          data_type = 'short';            
        end          
        
        if (field_type in (12, 13, 35)) then
        begin
          data_type = 'date';            
          property_items = ' length="' || field_length || '"';
        end
        
        if (null_flag = 1) then
        begin
          property_items = property_items || ' not-null="true"';
        end
                                 
        if (AFLAG = 'PK_PROPERTY') then
        begin
          if (exists(select 1 from RDB$INDEX_SEGMENTS where UPPER(RDB$INDEX_NAME)=UPPER(:pk_index_name) and UPPER(RDB$FIELD_NAME)=UPPER(:original_field_name))) then
          begin          
            if (count_pk_fields > 1) then
            begin
              sourcecode = indent_x3 || '<key-property name="' || field_name || '" type="' || data_type || '">';
              suspend;
              sourcecode = indent_x4 || '<column name="' || original_field_name || '"/>';
              suspend;
              sourcecode = indent_x3 || '</key-property>';
              suspend;
            end
            else
            begin
              if (count_pk_fields = 1) then
              begin
                sourcecode = indent_x3 || '<' || AIDNAME || ' name="' || field_name || '" type="' || data_type || '">';
                suspend;
                sourcecode = indent_x4 || '<column name="' || original_field_name || '"/>';
                suspend;
                sourcecode = indent_x4 || '<generator class="' || AGENERATORCLASS || '"/>';
                suspend;
                sourcecode = indent_x3 || '</' || AIDNAME || '>';
                suspend;
              end 
              else
              begin
                Exit;
              end           
            end
          end        
        end
        
        if (AFLAG = 'PROPERTY') then
        begin
          if (not exists(select 1 from RDB$INDEX_SEGMENTS where UPPER(RDB$INDEX_NAME)=UPPER(:pk_index_name) and UPPER(RDB$FIELD_NAME)=UPPER(:original_field_name))) then
          begin          
            sourcecode = indent_x3 || '<property name="' || field_name || '" type="' || data_type || '">';
            suspend;
            if (property_items = '') then
            begin
              sourcecode = indent_x4 || '<column name="' || original_field_name || '"/>';
            end
            else
            begin
              sourcecode = indent_x4 || '<column name="' || original_field_name || '"'|| property_items ||'/>';
            end  
            suspend;
            sourcecode = indent_x3 || '</property>';
            suspend;       
          end
        end
      end
    end
    
    if (AFLAG = 'PK_PROPERTY') then
    begin
      if (count_pk_fields > 1) then
      begin
        sourcecode = indent_x2 || '</composite-id>';
        suspend;
      end
    end      
  end
end^

COMMENT ON PROCEDURE SP_METADATA_TO_XML IS
'Erstellt Entitäten (XML-Mapfile) für eine Hibernateschnittstelle'^ 

CREATE OR ALTER PROCEDURE SP_METADATA_FOR_CHECKLIST(
  ATABLENAME varchar(32),
  AIS_VIEW smallint,
  ATABLE_AS_VIEW smallint,
  AINSTALL_USER varchar(32),
  AFLAG varchar(32),
  APACKAGE varchar(254) DEFAULT 'com.zabonlinedb.data',
  ADBNAME varchar(254) DEFAULT 'ZABonline [WaveMaker]',
  ADBVERSION varchar(64) DEFAULT '000.000.00000',
  APROJECTDIR varchar(254) DEFAULT '\GitHub\ZABonline\source\wavemaker\projects\ZABonline',
  AWMVERSION varchar(10) DEFAULT '6.5.3',
  ADBSERVICE varchar(64) DEFAULT 'ZABonlineDB')
returns(
  sourcecode varchar(2000))
as
declare variable original_field_name varchar(31);
declare variable field_name varchar(31);
declare variable field_source varchar(31);
declare variable field_length smallint;
declare variable field_scale smallint;
declare variable field_type smallint;
declare variable class_name varchar(2000);
declare variable package_name varchar(254);
declare variable db_name varchar(254);
declare variable db_version varchar(64);
declare variable method_name varchar(254);
declare variable indent_x1 varchar(254);
declare variable indent_x2 varchar(254);
declare variable indent_x3 varchar(254);
declare variable indent_x4 varchar(254);
declare variable db_source varchar(32);
declare variable pk_index_name varchar(32);
declare variable count_pk_fields integer;
declare variable data_type varchar(64);
declare variable null_flag smallint;
declare variable property_items varchar(64);
declare variable pk_contraint_name varchar(32);
declare variable valid_wm_version smallint;
begin
  /*
   *
   *   
  OUTPUT 'C:\Users\Alfred\Sourcen\GitHub\ZABonline\source\script\model2hibernate\datasheet.checklist.txt';
  select Trim(sourcecode) from SP_METADATA_FOR_CHECKLIST('DATASHEET', 0, 1, 'INSTALLER', 'BEGIN', 'com.zabonlinedb.data', 'ZABonline [WaveMaker]', '000.000.00000', '\GitHub\ZABonline\source\wavemaker\projects\ZABonline', '6.5.3');
  select Trim(sourcecode) from SP_METADATA_FOR_CHECKLIST('DATASHEET', 0, 1, 'INSTALLER', 'SERVICEDEF');
  select Trim(sourcecode) from SP_METADATA_FOR_CHECKLIST('DATASHEET', 0, 1, 'INSTALLER', 'DBSERVICE.SPRING');
  select Trim(sourcecode) from SSP_METADATA_FOR_CHECKLIST('DATASHEET', 0, 1, 'INSTALLER', 'PROJECT-MANAGERS');
  select Trim(sourcecode) from SP_METADATA_FOR_CHECKLIST('DATASHEET', 0, 1, 'INSTALLER', 'TYPES');
  select Trim(sourcecode) from SP_METADATA_FOR_CHECKLIST('DATASHEET', 0, 1, 'INSTALLER', 'ENTITY');
  OUTPUT;
   *
   *
   */
                       
  sourcecode = '';
  class_name = ATABLENAME;     
  package_name = APACKAGE;
  db_name = ADBNAME;
  db_version = ADBVERSION;
  
  select result from SP_GET_INDENTS(1) into :indent_x1;
  select result from SP_GET_INDENTS(2) into :indent_x2;
  select result from SP_GET_INDENTS(3) into :indent_x3;
  select result from SP_GET_INDENTS(4) into :indent_x4;
  
  if ((AWMVERSION = '6.5.2') or (AWMVERSION = '6.5.3') or (AWMVERSION = '6.6.0')) then
  begin
    valid_wm_version = 1;
  end
  else
  begin
    valid_wm_version = 0;
  end
  
  if (ATABLE_AS_VIEW = 1) then
  begin
    db_source = 'V_' || UPPER(ATABLENAME);
  end
  else
  begin
    db_source = UPPER(ATABLENAME);
  end
   
  if (exists(select 1 from RDB$RELATIONS where UPPER(RDB$RELATION_NAME)=UPPER(:ATABLENAME) and UPPER(RDB$OWNER_NAME)=UPPER(:AINSTALL_USER))) then
  begin
    /* alles was zum Anfang gemacht werden soll */
    select property from SP_SET_ENTITYNAME('_', :ATABLENAME, 1, null) into :class_name;   
    select result from SP_CAPITALIZE(:class_name, 1, 0) into :class_name;    
    
    if (AFLAG = 'BEGIN') then
    begin
      sourcecode = 'Checkliste zum Einbinden der Entität in Wavemaker (' || AWMVERSION || ')';
      suspend;
      sourcecode = '===========================================================';
      suspend;      
      sourcecode = 'Erstellt: via SP_METADATA_FOR_CHECKLIST - Datenbank: ' || db_name || ' - Version: ' || db_version;
      suspend;
      sourcecode = 'Ersttellt am: ' || current_timestamp;
      suspend;       
      sourcecode = 'Entität: ' || class_name;
      suspend;
      sourcecode = 'Datenbankservice: ' || ADBSERVICE;
      suspend;
      sourcecode = '';
      suspend;
      sourcecode = '';
      suspend;      
      Exit;
    end     
    
    if (AFLAG = 'ENTITY') then
    begin
      sourcecode = 'Datei: ' || class_name || '.java';
      suspend;
      sourcecode = 'Datei: ' || class_name || '.hbm.xml';
      suspend;    
      if (valid_wm_version = 1) then
      begin               
        sourcecode = 'Ordner: ' || APROJECTDIR || '\services\' || ADBSERVICE || '\src\' || replace(package_name, '.', '\');
        suspend;
        sourcecode = '';
        suspend;
        sourcecode = indent_x1 || 'Die beiden Dateien werden in den oben genannten Ordern kopiert.';
        suspend;
        sourcecode = '';        
        suspend;
        sourcecode = '';
        suspend;                   
      end 
      else
      begin
        sourcecode = 'Wichtig: Unbekannte Wavemaker Version (' || AWMVERSION || ')';
        suspend;              
      end          
      Exit;        
    end
    
    if (AFLAG = 'TYPES') then
    begin
      sourcecode = 'Datei: types.js';
      suspend;
      if (valid_wm_version = 1) then
      begin      
        sourcecode = 'Ordner: ' || APROJECTDIR || '\webapproot\';
        suspend;
        sourcecode = '';
        suspend;
        sourcecode = indent_x1 || 'Nach dem Einbinden der Dateien, Wavemaker starten und die Datenbankschnittstelle (' || ADBSERVICE || ') sichern (eventuell kleine Änderung vornehmen).';
        suspend;
        sourcecode = indent_x1 || 'Das Sichern der Datenbankschnittstelle (' || ADBSERVICE || ') wird die notwendigen Daten in die Datei: types.js einfügen.';
        suspend;
        sourcecode = '';        
        suspend;
        sourcecode = '';
        suspend;        
      end 
      else
      begin
        sourcecode = 'Wichtig: Unbekannte Wavemaker Version (' || AWMVERSION || ')';
        suspend;              
      end          
      Exit;    
    end
    
    if (AFLAG = 'SERVICEDEF') then
    begin
      sourcecode = 'Datei: servicedef.xml';
      suspend;
      if (valid_wm_version = 1) then
      begin
        sourcecode = 'Ordner: ' || APROJECTDIR || '\services\' || ADBSERVICE || '\designtime\';
        suspend;
        sourcecode = '';
        suspend;        
        sourcecode = indent_x1 || '<dataobjects>';
        suspend;        
        sourcecode = indent_x2 || '<dataobject javaType="' || package_name || '.' || class_name || '" supportsQuickData="true">';
        suspend;                
      end
      else
      begin
        sourcecode = 'Wichtig: Unbekannte Wavemaker Version (' || AWMVERSION || ')';
        suspend;
        Exit;              
      end      
    end
  
    if (AFLAG = 'DBSERVICE.SPRING') then
    begin
      sourcecode = 'Datei: ' || ADBSERVICE || '.spring.xml';
      suspend;
      if (valid_wm_version = 1) then
      begin      
        sourcecode = 'Ordner: ' || APROJECTDIR || '\services\' || ADBSERVICE || '\src\';
        suspend;
        sourcecode = '';
        suspend;
        sourcecode = indent_x1 || '<property name="mappingResources">';
        suspend;
        sourcecode = indent_x2 || '<list>';
        suspend;
        sourcecode = indent_x3 || '<value>' || replace(package_name, '.', '/') || '/' || class_name || '.hbm.xml</value>';
        suspend;
        sourcecode = '';        
        suspend;
        sourcecode = '';
        suspend;        
      end 
      else
      begin
        sourcecode = 'Wichtig: Unbekannte Wavemaker Version (' || AWMVERSION || ')';
        suspend;              
      end          
      Exit;
    end
    
    if (AFLAG = 'PROJECT-MANAGERS') then
    begin
      sourcecode = 'Datei: project-managers.xml';
      suspend;
      if (valid_wm_version = 1) then
      begin      
        sourcecode = 'Ordner: ' || APROJECTDIR || '\webapproot\WEB-INF\';
        suspend;        
        sourcecode = '';
        suspend;        
        sourcecode = indent_x1 || '<entry key="' || ADBSERVICE || '">';
        suspend;        
        sourcecode = indent_x2 || '<list>';
        suspend;        
        sourcecode = indent_x3 || '<value>' || package_name || '.' || class_name || '</value>';
        suspend;
        sourcecode = '';        
        suspend;
        sourcecode = '';
        suspend;        
      end
      else
      begin
        sourcecode = 'Wichtig: Unbekannte Wavemaker Version (' || AWMVERSION || ')';
        suspend;              
      end            
      Exit;
    end
    
    select
      RDB$CONSTRAINT_NAME,
      RDB$INDEX_NAME
    from
      RDB$RELATION_CONSTRAINTS
    where
      RDB$RELATION_NAME = Upper(:ATABLENAME)
      and
      RDB$CONSTRAINT_TYPE = 'PRIMARY KEY'
    into
      :pk_contraint_name,
      :pk_index_name;    
  
    select count(RDB$FIELD_NAME) from RDB$INDEX_SEGMENTS where UPPER(RDB$INDEX_NAME)=UPPER(:pk_index_name) into :count_pk_fields;
    
    for 
      select 
        RDB$FIELD_NAME,
        RDB$FIELD_SOURCE,
        RDB$NULL_FLAG 
      from 
        RDB$RELATION_FIELDS 
      where 
        UPPER(RDB$RELATION_NAME)=UPPER(:ATABLENAME) 
      into 
        :original_field_name,
        :field_source,
        :null_flag 
    do
    begin
      for 
        select
          RDB$FIELD_LENGTH,
          RDB$FIELD_SCALE,
          RDB$FIELD_TYPE   
        from
          RDB$FIELDS
        where
          (UPPER(RDB$FIELD_NAME) = UPPER(:field_source))        
        into
          :field_length,
          :field_scale,
          :field_type
      do
      begin
        /* alles was pro Feld gemacht werden soll */
        /*
         *
         *         
        Datatype: BLOB - Fieldtype: 261
        Datatype: CHAR - Fieldtype: 14
        Datatype: CSTRING - Fieldtype: 40
        Datatype: D_FLOAT - Fieldtype: 11
        Datatype: DOUBLE - Fieldtype: 27
        Datatype: FLOAT - Fieldtype: 10
        Datatype: INT64 - Fieldtype: 16
        Datatype: INTEGER - Fieldtype: 8
        Datatype: QUAD - Fieldtype: 9
        Datatype: SMALLINT - Fieldtype: 7
        Datatype: DATE - Fieldtype: 12
        Datatype: TIME - Fieldtype: 13
        Datatype: TIMESTAMP - Fieldtype: 35
        Datatype: VARCHAR - Fieldtype: 37
        *
        *        
        */
        property_items = '';
        original_field_name = trim(original_field_name);
        select property from SP_SET_ENTITYNAME('_', :original_field_name, 1, null) into :field_name;
        select result from SP_CAPITALIZE(:field_name, 1, 0) into :method_name;                                 
                  
        if (field_type in (14, 37, 40, 261)) then
        begin
          data_type = 'string';          
          property_items = ' typeRef="java.lang.String" isList="false"';
        end
                 
        if (field_type in (11, 27)) then
        begin
          data_type = 'double';            
          property_items = ' typeRef="java.lang.Double" isList="false"';
        end          
        
        if (field_type = 10) then
        begin
          data_type = 'float';            
          property_items = ' typeRef="java.lang.Float" isList="false"';
        end          

        if (field_type = 16) then
        begin
          data_type = 'long';            
          property_items = ' typeRef="java.lang.Long" isList="false"';
        end

        if (field_type = 8) then
        begin
          data_type = 'integer';            
          property_items = ' typeRef="java.lang.Integer" isList="false"';
        end          

        if (field_type = 9) then
        begin
          break;            
        end          
        
        if (field_type = 7) then
        begin
          data_type = 'short';            
          property_items = ' typeRef="java.lang.Short" isList="false"';
        end          
        
        if (field_type in (12, 13, 35)) then
        begin
          data_type = 'date';            
          property_items = ' typeRef="java.util.Date" isList="false"';
        end
        
        if (null_flag = 1) then
        begin
          property_items = property_items || ' allowNull="false"';
        end
        else        
        begin
          property_items = property_items || ' allowNull="true"';
        end

        if (AFLAG = 'SERVICEDEF') then
        begin
          if (exists(select 1 from RDB$INDEX_SEGMENTS where UPPER(RDB$INDEX_NAME)=UPPER(:pk_index_name) and UPPER(RDB$FIELD_NAME)=UPPER(:original_field_name))) then
          begin
            sourcecode = indent_x3 || '<element name="' || field_name || '"' || property_items || '>';
            suspend;
            sourcecode = indent_x4 || '<require>delete</require>';
            suspend;
            sourcecode = indent_x4 || '<require>read</require>';
            suspend;
            sourcecode = indent_x4 || '<require>update</require>';
            suspend;
            sourcecode = indent_x4 || '<require>insert</require>';
            suspend;
            sourcecode = indent_x4 || '<noChange>delete</noChange>';
            suspend;
            sourcecode = indent_x4 || '<noChange>read</noChange>';
            suspend;
            sourcecode = indent_x4 || '<noChange>update</noChange>';
            suspend;
            sourcecode = indent_x3 || '</element>';
            suspend;          
          end
          else
          begin
            sourcecode = indent_x3 || '<element name="' || field_name || '"' || property_items || '/>';
            suspend;
          end
        end
      end
    end 
    /* alles was zum Schluss gemacht werden soll */
    if (AFLAG = 'SERVICEDEF') then
    begin
      if (valid_wm_version = 1) then
      begin
        sourcecode = indent_x2 || '</dataobject>';
        suspend;
        sourcecode = '';        
        suspend;
        sourcecode = '';
        suspend;
        Exit;                
      end      
    end    
  end           
end^

COMMENT ON PROCEDURE SP_METADATA_FOR_CHECKLIST IS
'Checkliste um Entitäten (Java-Source / XML-Mapfile) unter Wavemaker einzubinden'^ 

CREATE OR ALTER PROCEDURE SP_CREATE_HIBERNATE_SCRIPT(
  ATABLENAME varchar(32),
  AIS_VIEW smallint,
  ATABLE_AS_VIEW smallint,
  AINSTALL_USER varchar(32),
  ATARGETDIR varchar(254),
  ADBCONNECTPASS varchar(512),
  ACLIENTLIB varchar(254) DEFAULT 'C:\Users\Alfred\Programme\Firebird_2_5\bin\fbclient.dll',
  ACONNECTTO varchar(254) DEFAULT '127.0.0.1:ZABONLINEEMBEDDED',
  ADBCONNECTUSER varchar(32) DEFAULT 'SYSDBA',
  APACKAGE varchar(254) DEFAULT 'com.zabonlinedb.data',
  ADBNAME varchar(254) DEFAULT 'ZABonline [WaveMaker]',
  ADBVERSION varchar(64) DEFAULT '000.000.00000',
  AHIBERNATEURI varchar(254) DEFAULT '-//Hibernate/Hibernate Mapping DTD 3.0//EN',
  AHIBERNATEMAPDTD varchar(254) DEFAULT 'http://hibernate.sourceforge.net/hibernate-mapping-3.0.dtd',
  AIDNAME varchar(264) DEFAULT 'id',
  AGENERATORCLASS varchar(64) DEFAULT 'assigned',
  APROJECTDIR varchar(254) DEFAULT '\GitHub\ZABonline\source\wavemaker\projects\ZABonline',
  AWMVERSION varchar(10) DEFAULT '6.5.3',
  ADBSERVICE varchar(64) DEFAULT 'ZABonlineDB') 
returns (
  sourcecode varchar(2000))
as
declare variable class_name varchar(2000);
begin
  /*
   *
   *
  OUTPUT 'C:\Users\Alfred\Sourcen\GitHub\ZABonline\source\script\model2hibernate\create_hibernate_interface.sql';
  select Trim(trailing from sourcecode) from SP_CREATE_HIBERNATE_SCRIPT('DATASHEET', 0, 1, 'INSTALLER', 'C:\Users\Alfred\Sourcen\GitHub\ZABonline\source\script\model2hibernate\', 'masterkey');
  OUTPUT;   
   *
   *
   */            

  if (exists(select 1 from RDB$PROCEDURES where UPPER(RDB$PROCEDURE_NAME)=UPPER('SP_DBVERSION'))) then
  begin
    execute statement 'select dbversion from SP_DBVERSION' into :ADBVERSION;
  end

  sourcecode = '/*******************************************************************************';
  suspend;
  sourcecode = '/* Author: ' || current_user;
  suspend;                                                    
  sourcecode = '/* Date: ' || current_timestamp;
  suspend;
  sourcecode = '/* Purpose: Grundsteinlegung des Datenmodelles für ZABonline (Wavemaker)';
  suspend;      
  sourcecode = '/*';
  suspend;                                                                                
  sourcecode = '/*******************************************************************************';
  suspend;
  sourcecode = '/* - Das Script arbeitet mit Befehlen der SQL-Erweiterung für FireBird 2.5.x';
  suspend;     
  sourcecode = '/* - Das Script ist für die Ausführung im IBExpert erstellt worden';
  suspend;                
  sourcecode = '/* - Ein möglicher Connect zur ZABonline-DB sollte geschlossen werden';
  suspend;     
  sourcecode = '/******************************************************************************/';
  suspend;  
  sourcecode = '/* History: ' || current_timestamp;
  suspend;  
  sourcecode = '/*          Diverse Werkzeug für die Entwicklung und Installation';
  suspend;  
  sourcecode = '/******************************************************************************/';
  suspend;  
  sourcecode = '';
  suspend;  
  sourcecode = '/******************************************************************************/';
  suspend;  
  sourcecode = '/*        Following SET SQL DIALECT is just for the Database Comparer         */';
  suspend;  
  sourcecode = '/******************************************************************************/';
  suspend;  
  sourcecode = 'SET SQL DIALECT 3;';
  suspend;  
  sourcecode = '';
  suspend;  
  sourcecode = 'SET NAMES WIN1252;';
  suspend;  
  sourcecode = '';
  suspend;  
  sourcecode = '/* An dieser Stelle muss die Client-DLL (Pfad und Name) überprüft werden      */';
  suspend;  
  sourcecode = 'SET CLIENTLIB ''' || ACLIENTLIB || ''';';
  suspend;  
  sourcecode = '';
  suspend;  
  sourcecode = '/* An dieser Stelle muss die IP, der Datenbankpfad, Name der Datanbank sowie Benutzerinformationen (User/Password) überführt werden */';
  suspend;  
  sourcecode = 'CONNECT ''' || ACONNECTTO || ''' USER ''' || ADBCONNECTUSER || ''' PASSWORD ''' || ADBCONNECTPASS || ''';';
  suspend;  
  sourcecode = '/******************************************************************************/';
  suspend;  
  sourcecode = '/*                                 Hibernate-Interface';
  suspend;                                    
  sourcecode = '/******************************************************************************/';
  suspend;  
  sourcecode = '';
  suspend;  
  
  select property from SP_SET_ENTITYNAME('_', :ATABLENAME, 1, null) into :class_name;
  select result from SP_CAPITALIZE(:class_name, 1, 0) into :class_name;  
  
  sourcecode = 'OUTPUT ''' || ATARGETDIR || '\' || class_name || '.java'';';
  suspend;  
  sourcecode = 'select Trim(trailing from sourcecode) from SP_METADATA_TO_JAVA(''' || :ATABLENAME || ''', '|| :AIS_VIEW || ', ''' || :AINSTALL_USER || ''', ''BEGIN'', ''' || :APACKAGE || ''', ''' || :ADBNAME || ''', ''' || :ADBVERSION || ''');';
  suspend;  
  sourcecode = 'select Trim(trailing from sourcecode) from SP_METADATA_TO_JAVA(''' || :ATABLENAME || ''', '|| :AIS_VIEW || ', ''' || :AINSTALL_USER || ''', ''PROPERTY'', ''' || :APACKAGE || ''', ''' || :ADBNAME || ''', ''' || :ADBVERSION || ''');';
  suspend;  
  sourcecode = 'select Trim(trailing from sourcecode) from SP_METADATA_TO_JAVA(''' || :ATABLENAME || ''', '|| :AIS_VIEW || ', ''' || :AINSTALL_USER || ''', ''METHOD'', ''' || :APACKAGE || ''', ''' || :ADBNAME || ''', ''' || :ADBVERSION || ''');';
  suspend;  
  sourcecode = 'select Trim(trailing from sourcecode) from SP_METADATA_TO_JAVA(''' || :ATABLENAME || ''', '|| :AIS_VIEW || ', ''' || :AINSTALL_USER || ''', ''END'', ''' || :APACKAGE || ''', ''' || :ADBNAME || ''', ''' || :ADBVERSION || ''');';
  suspend;  
  sourcecode = 'OUTPUT;';
  suspend;  
  sourcecode = '';
  suspend;    
  sourcecode = 'OUTPUT ''' || ATARGETDIR || '\' || class_name || '.hbm.xml'';';
  suspend;  
  sourcecode = 'select Trim(trailing from sourcecode) from SP_METADATA_TO_XML(''' || :ATABLENAME || ''', '|| :AIS_VIEW || ', ' || :ATABLE_AS_VIEW || ', ''' || :AINSTALL_USER || ''', ''BEGIN'', ''' || :APACKAGE || ''', ''' || :ADBNAME || ''', ''' || :ADBVERSION || ''', '''|| :AHIBERNATEURI || ''', ''' || :AHIBERNATEMAPDTD || ''', ''' || :AIDNAME || ''', ''' || :AGENERATORCLASS || ''');';
  suspend;  
  sourcecode = 'select Trim(trailing from sourcecode) from SP_METADATA_TO_XML(''' || :ATABLENAME || ''', '|| :AIS_VIEW || ', ' || :ATABLE_AS_VIEW || ', ''' || :AINSTALL_USER || ''', ''PK_PROPERTY'', ''' || :APACKAGE || ''', ''' || :ADBNAME || ''', ''' || :ADBVERSION || ''', '''|| :AHIBERNATEURI || ''', ''' || :AHIBERNATEMAPDTD || ''', ''' || :AIDNAME || ''', ''' || :AGENERATORCLASS || ''');';
  suspend;  
  sourcecode = 'select Trim(trailing from sourcecode) from SP_METADATA_TO_XML(''' || :ATABLENAME || ''', '|| :AIS_VIEW || ', ' || :ATABLE_AS_VIEW || ', ''' || :AINSTALL_USER || ''', ''PROPERTY'', ''' || :APACKAGE || ''', ''' || :ADBNAME || ''', ''' || :ADBVERSION || ''', '''|| :AHIBERNATEURI || ''', ''' || :AHIBERNATEMAPDTD || ''', ''' || :AIDNAME || ''', ''' || :AGENERATORCLASS || ''');';
  suspend;  
  sourcecode = 'select Trim(trailing from sourcecode) from SP_METADATA_TO_XML(''' || :ATABLENAME || ''', '|| :AIS_VIEW || ', ' || :ATABLE_AS_VIEW || ', ''' || :AINSTALL_USER || ''', ''END'', ''' || :APACKAGE || ''', ''' || :ADBNAME || ''', ''' || :ADBVERSION || ''', '''|| :AHIBERNATEURI || ''', ''' || :AHIBERNATEMAPDTD || ''', ''' || :AIDNAME || ''', ''' || :AGENERATORCLASS || ''');';
  suspend;  
  sourcecode = 'OUTPUT;';
  suspend;  
  sourcecode = '';
  suspend;  
  sourcecode = 'OUTPUT ''' || ATARGETDIR || '\' || class_name || '.checklist.txt'';';
  suspend;
  sourcecode = 'select Trim(trailing from sourcecode) from SP_METADATA_FOR_CHECKLIST(''' || :ATABLENAME || ''', '|| :AIS_VIEW || ', ' || :ATABLE_AS_VIEW || ', ''' || :AINSTALL_USER || ''', ''BEGIN'', ''' || :APACKAGE || ''', ''' || :ADBNAME || ''', ''' || :ADBVERSION || ''', '''|| :APROJECTDIR || ''', ''' || :AWMVERSION || ''', ''' || :ADBSERVICE || ''');';
  suspend;  
  sourcecode = 'select Trim(trailing from sourcecode) from SP_METADATA_FOR_CHECKLIST(''' || :ATABLENAME || ''', '|| :AIS_VIEW || ', ' || :ATABLE_AS_VIEW || ', ''' || :AINSTALL_USER || ''', ''SERVICEDEF'', ''' || :APACKAGE || ''', ''' || :ADBNAME || ''', ''' || :ADBVERSION || ''', '''|| :APROJECTDIR || ''', ''' || :AWMVERSION || ''', ''' || :ADBSERVICE || ''');';
  suspend;  
  sourcecode = 'select Trim(trailing from sourcecode) from SP_METADATA_FOR_CHECKLIST(''' || :ATABLENAME || ''', '|| :AIS_VIEW || ', ' || :ATABLE_AS_VIEW || ', ''' || :AINSTALL_USER || ''', ''DBSERVICE.SPRING'', ''' || :APACKAGE || ''', ''' || :ADBNAME || ''', ''' || :ADBVERSION || ''', '''|| :APROJECTDIR || ''', ''' || :AWMVERSION || ''', ''' || :ADBSERVICE || ''');';
  suspend;  
  sourcecode = 'select Trim(trailing from sourcecode) from SP_METADATA_FOR_CHECKLIST(''' || :ATABLENAME || ''', '|| :AIS_VIEW || ', ' || :ATABLE_AS_VIEW || ', ''' || :AINSTALL_USER || ''', ''PROJECT-MANAGERS'', ''' || :APACKAGE || ''', ''' || :ADBNAME || ''', ''' || :ADBVERSION || ''', '''|| :APROJECTDIR || ''', ''' || :AWMVERSION || ''', ''' || :ADBSERVICE || ''');';
  suspend;
  sourcecode = 'select Trim(trailing from sourcecode) from SP_METADATA_FOR_CHECKLIST(''' || :ATABLENAME || ''', '|| :AIS_VIEW || ', ' || :ATABLE_AS_VIEW || ', ''' || :AINSTALL_USER || ''', ''TYPES'', ''' || :APACKAGE || ''', ''' || :ADBNAME || ''', ''' || :ADBVERSION || ''', '''|| :APROJECTDIR || ''', ''' || :AWMVERSION || ''', ''' || :ADBSERVICE || ''');';
  suspend;
  sourcecode = 'select Trim(trailing from sourcecode) from SP_METADATA_FOR_CHECKLIST(''' || :ATABLENAME || ''', '|| :AIS_VIEW || ', ' || :ATABLE_AS_VIEW || ', ''' || :AINSTALL_USER || ''', ''ENTITY'', ''' || :APACKAGE || ''', ''' || :ADBNAME || ''', ''' || :ADBVERSION || ''', '''|| :APROJECTDIR || ''', ''' || :AWMVERSION || ''', ''' || :ADBSERVICE || ''');';
  suspend;      
  sourcecode = 'OUTPUT;';
  suspend;  
  sourcecode = '';
  suspend;  
  sourcecode = 'COMMIT WORK;';
  suspend;  
  sourcecode = '/******************************************************************************/';
  suspend;  
  sourcecode = '/******************************************************************************/';
  suspend;  
  sourcecode = '/******************************************************************************/';
  suspend;  
end^

COMMENT ON PROCEDURE SP_CREATE_HIBERNATE_SCRIPT IS
'Erstellt ein Hibernate-Script-Interface für eine Tabelle'^

SET TERM ; ^

COMMIT WORK;
/******************************************************************************/
/*                                 Grants                                 
/******************************************************************************/

/* Users */
GRANT EXECUTE ON PROCEDURE SP_CAPITALIZE TO INSTALLER;
GRANT EXECUTE ON PROCEDURE SP_SET_ENTITYNAME TO INSTALLER;
GRANT EXECUTE ON PROCEDURE SP_METADATA_TO_JAVA TO INSTALLER;
GRANT EXECUTE ON PROCEDURE SP_METADATA_TO_XML TO INSTALLER;
GRANT EXECUTE ON PROCEDURE SP_METADATA_FOR_CHECKLIST TO INSTALLER;
GRANT EXECUTE ON PROCEDURE SP_CREATE_HIBERNATE_SCRIPT TO INSTALLER;

COMMIT WORK;
/******************************************************************************/
/******************************************************************************/
/******************************************************************************/
