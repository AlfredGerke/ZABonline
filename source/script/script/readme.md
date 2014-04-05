Datenbank
=========

Aufbau des Datenmodelles über SQL-Scripte und ISQL / FlameRobin

**Inhaltsübersicht:**

- Firebird
- ISQL / FlameRobin
- Scripte
- Hibernate
- Zugriffrechte     
- Benutzer

Firebird
--------
Als Datenbank wird Firebird 2.5 verwendet. Diese Version ist notwendig, da in den 
Scripten Sprachelemente verwendet werden, die zum Teil erst mit der Version 2.5 
eingeführt wurden. (z.B.: `CREATE USER`)


ISQL / FlameRobin
-----------------
Die Scripte werde für ISQL und FlameRobin optimiert.      
Folgende Befehle werden immer zu Anfang in jedem Script aufgeführt:

* `SET SQL DIALECT 3`
* `SET NAMES WIN1252`
* `CREATE DATABASE '<IP des Servers>:<Alias>' USER '<Benutzer>' PASSWORD '<Password>' PAGE_SIZE <Size> DEFAULT CHARACTER SET WIN1252 COLLATION WIN1252;`
* `CONNECT '<IP des Servers>:<Alias>' USER '<Benutzer>' PASSWORD '<Password>';` 

Die Befehle `CREATE DATABASE` und `CONNECT` werden natürlich niemals gemeinsam in einem Script stehen, sondern nur entweder/oder. Tatsächlich wird `CREATE DATABASE` nur ein einzieges Mal verwendet, danach wird nur noch `CONNECT` eingesetzt.

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
* `recreate_user_views.sql`: User-Views reorganisieren (wird derzeit nicht ausgeführt: unnötig?)
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
* Getter- und Setter für Standard-Kataloge
* Hibernate-Entities (Sorucen für die WaveMaker-Schnittstelle)

  
Hibernate
---------
Um einzelne JAVA-Entitäten erzeugen zu können, wurde der Hibernate-Workaround eingeführt. 
Zwar kann man über einen Editor in WaveMaker jede beliebige JAVA-Entität erstellen, das kann aber
je nach Umfang des Schemas recht aufwendig werden. Der Workaround soll hier Abhilfe schaffen.

Mit diesem Verfahren kann ein Datenmodell Stück für Stück in das WaveMaker-Projekt eingeführt werden, ohne das ein kompetter Import eines Datenmodelles und die damit verbundene Neubildung von z.B. XML-Mapper notwendig werden.

Das Einführen einer neuen Entität ist nach spätestens 2 Minuten vollzogen.

Der Hibernate-Workaround ist eine Sammlung von SPs (StoredProcedures) die alle notwendigen Metadaten zu einem
Schema sammeln und einer Standardausgabe zur Verfügung stellen. 

Der Workaround wird über das Script `makehib.bat` erstellt. `makehib.bat` arbeitet mit dem ISQL.

Das Zielverzeichnis der JAVA-Entität sowie das zugrundeliegende Schema wird von Hand in das Script `???` eingetragen. 
Es ist unbedingt darauf zu achten, das man nicht direkt in das DATA-Verzeichnis von ZABonlineDB die Entität erstellt. 

Mit `makehib.bat` wird ein auf das Schema passendes Script-Interface erstellt, welches automatisch gestartet wird und die JAVA-Entität, sowie den zugehörigen XML-Mapper und eine Checkliste erstellt.

Die JAVA- und XML-Datei müssen von Hand in den DATA-Ordner von ZABonlineDB verschoben werden. Dies lässt sich am besten über einen Batch erledigen.

In der Checkliste wird aufgeführt, welche Schritte von Hand erledigt werden müssen.

Bei diesem Verfahren handelt es sich nicht um eine Hibernate-Schnittstelle für Firebird, sondern nur um einen Workaround der das Formulieren von JAVA-Entäten erleichtern soll. Aus diesem Grund ist es auch notwendig die Checkliste von Hand abzuarbeiten und Abschlussarbeiten in WaveMaker vorzunehmen.

Wenn diese Schritte vollzogen wurden, wird WaveMaker gestartet und die Entität sollte zur Verfügung stehen. Im Anschluss werden nur noch die Verknüpfungen erstellt und das Schema einmal über WaveMaker gesichert. Erst mit dem Sichern über WaveMaker ist die Entität vollständig registriert.


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
