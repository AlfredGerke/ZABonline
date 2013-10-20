Datenbank
=========

Aufbau des Datenmodelles über SQL-Scripte und dem IBExpert

**Inhaltsübersicht:**

- Firebird
- IBExpert
- Scripte
- Hibernate
- Zugriffrechte     
- Benutzer

Firebird
--------
Als Datenbank wird Firebird 2.5 verwendet. Diese Version ist notwendig, da in den 
Scripten Sprachelemente verwendet werden, die zum Teil erst mit der Version 2.5 
eingeführt wurden. (z.B.: `CREATE USER`)


IBExpert
--------
Die Scripte sind für das Script-Interface für IBExpert optimiert.      
Folgende Befehle werden immer zu Anfang in jedem Script aufgeführt:

* `SET SQL DIALECT 3`
* `SET NAMES WIN1252`
* `SET CLIENTLIB '<Pfadeangabe>\fbclient.dll';` 
* `CONNECT '<IP des Servers>:<Alias>' USER '<Benutzer>' PASSWORD '<password>';` 

Bestimmte Angaben wie IP des Servers oder DB-Alias müssen natürlich beim klonen 
auf die lokale Umgebung angepasst werden.


Scripte
-------
Die Scripte werden immer in diverse Abschnitte aufgeteilt:

* Kommentarheader (Pflicht)
* Initialisierung der Verbindungsparameter (Pflicht)
* Update-/Versions-Historie (Pflicht)
* Abschnitte für DB-Objekte (wenn benötigt)
    * Exceptions
    * Domains
    * Sequences
    * Tables
    * Views
    * StoredProcedures
    * Datainput
    * Grants
    * etc.                         
    
Jeder Abschnitt wird in der Regel mit einem `COMMIT WORK` abgeschlossen.    

Für alle Scripte die Datenbankobjekte für die Mitgliederverwaltung erstellen,
wird der Benutzer `INSTALLER` für die Verbindungsparameter verwendet.      
Neben den Scripten welche die Mitgliederverwaltung aufbauen, gibt es Scripte welche 
Werkzeuge für die Codegenerierung zur Verfügung stellen. Diese Scripte werden immer 
mit dem Benutzer `SYSDBA` initialisert. 

### Spezielle Scripte
Folgende Scripte richten Werkzeuge für die Codegenerierng ein, unterstützen die 
Installation, oder stellen grundsätzliche Funktionalitäten zur Verfügung:

* `create_user.sql`: Erstellt alle notwendigen Benutzer
* `create_tools.sql`: Werkzeuge für die Codegenerierung
* `create_hibernate_workaround.sql`: Hibernate Script Interface
* `create_json.sql`: JSON-Workaround (in Planung)
* `create_simple_indexe.sql`: Einspalten-Indexe generieren
* `recreate_user_views.sql`: User-Views reorganisieren (wird derzeit nicht ausgeführt; unnötig?)
* `clean_up.sql`: Temporäre DB-Objekte wieder entfernen

Die Codegenerierung erzeugt derzeit 2/3 der verwendeten DB-Objekte.      
Folgende DB-Objekte werden immer automatisch erstellt:

* Update Views (User-Views)
* Standard Sequences für PrimaryKeys
* Standard Kataloge
* Admin Kataloge (notwendig für die Installation und Wartung)
* m-n Verbindungen (Relation-Tables)
* Standard Grants (Zugriffsrechte für DB-Objekte)
* Standard Trigger (Before-Update, Before-Insert, Before-Delete)
* Einspalten-Indexe (z.B. für die Spalte `SOFTDEL`)
* Hibernate-Entities (Sorucen für die WaveMaker-Schnittstelle)

  
Hibernate
---------
???

Zugriffrechte
-------------     
???


Benutzer
--------
Für die Installation und den Betrieb der Mitgliederverwaltung werden zustätzlich
zum `SYSDBA` zwei weitere Benutzer benötigt:

* `INSTALLER`
* `WEBCONNECT`

Die Werkzeuge für die Codegenerierung, den grundsätzlichen Funktionalitäten und 
des *Hibernate Script Interface* werden mit dem `SYSDBA` installiert.        
Das gesamte Datenmodell für die Mitgliederverwaltung wird mit dem Benutzer `INSTALLER` 
eingerichtet.    
Der Benutzer `WEBCONNECT` wird vom Servlet-Container verwendet um eine Connect zur
Datenbank herzustellen. `WEBCONNECT` ist in seinen Rechten stark eingeschränkt. So
kann diese Benutzer keinen direkten Zugriff auf die Tabellen herstellen. Daten können
nur über Update Views (User-Views) verwaltet werden.     