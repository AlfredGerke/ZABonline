* In den vorliegenden Ordner werden Sparchressoucen f�r DE und DE-DE hinterlegt
* Die Dateien werden von hier aus nicht von Wavemakter erkannt
* Sie m�ssen in die Wavemakerinstallation kopiert werden
* In diesem Beispiel wird folgender Installationspfad f�r Wavmakter angenommen:
  C:\Programme\WaveMaker\6.4.6GA\  
* Dateien in folgende Ordner kopieren:    
  C:\Programme\WaveMaker\6.4.6GA\studio\lib\wm\language\nls\de-de    
  C:\Programme\WaveMaker\6.4.6GA\studio\lib\wm\language\nls\de     
                                                                                                              
## G�ltig ab 6.5.x:
* Bei den folgenden Notizen handelt es sich derzeit nur um Annahmen von AGE
* Mit der Einf�hrung von 6.5.2 l�sst sich eine Spracherweiterung f�r den WizardLayer nach dem oben genannten Vorgehen nicht herstellen
* Anpassungen in der Datei: lib_build_de-de.js wie sie im Debugger gefunden wurde, haben sich dagegen bew�hrt
* Die Datei:     
  lib_build_de-de.js geh�rt zum Framework vom WM und wird im Verzeichnis: C:\Users\Alfred\Programme\WaveMaker\6.5.2.Release\studio\lib\build\nls abgelegt
* In diesem Beispiel wird folgender Installationspfad f�r Wavmakter angenommen:    
  C:\Users\Alfred\Programme\WaveMaker\6.5.2.Release\  
* Nach Umstellung auf 6.5.3:
  Originalversion von lib_build_de-de.js unter lib_build_de-de.js.original_6.5.3 in den Trunk aufgenommen 
* Gleiches Vorgehen mit 6.6.x
* Gleiches Vorgehen mit 6.7.x          