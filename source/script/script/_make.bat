cls

if "%1"=="" goto Anwendung

isql -b -e -i batch.sql -o %1

goto ENDE1

:Anwendung
echo.
echo    Das Batchprogramm zur Erstellung einer Datenbank wird wie folgt aufgerufen:  
echo.
echo    makedb {Ziel der Logdatei}
echo.

:ENDE1

CLS
echo.
echo    Die Datenbank wurde erstellt 
echo.