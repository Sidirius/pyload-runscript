#!/bin/sh

#-----------------------------------------------------------------------
#----- Scriptstart - Initialscript für pyLoad Hook "package_finished"
#----- Script unter "./pyload/scripts/package_finished" oder
#----- "./pyload/scripts/unrar_finished" speichern und ausfuehrbar machen
#----- "chmod +x [Scriptname]" 
#-----
#----- Script zur Datei / Ordner Umbenennung findet ihr unter http://pastebin.com/mWW5usaB
#----- Script (siehe Link) unter personalisierter Pfadangabe der Variablen "SCRP" speichern
#----- und ausfuehrbar machen "chmod +x [Scriptname]"
#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
# nachfolgende Pfadangaben bitte anpassen
#-----------------------------------------------------------------------

PATH=/opt/bin:/opt/sbin
PREFIX="/share/Public" # dein "Home-Verzeichnis" 
SCRP=/share/Public # Pfad zur runscript.sh http://pastebin.com/mWW5usaB
UNRARALL=${PREFIX}/unrarall # Pfad zu unrarall https://github.com/arfoll/unrarall
DESTINATION=/share/Qmultimedia/ # dein Download-Zielverzeichnis - ANPASSEN!
DESTISERIEN=/share/Qmultimedia/Serien # Serien-Verzeichnis - ANPASSEN!
LOGFILE=${PREFIX}/pyload_finished.txt # Logfile-Pfad
UNRARON=1 # Downloads/Archive entpacken: ja = 1 - nein = 0
DELNAME=${PREFIX}/DELNAME # Datei welche die Ersetzungsvariablen enthaelt
SERIES=${PREFIX}/SERIEN # Datei welche die Serienvariablen enthaelt
UF_FOLDER=$2 # $2 = "package_finished" $1 = "unrar_finished"

#-----------------------------------------------------------------------
# sende personalisierte Angaben an runscript.sh http://pastebin.com/mWW5usaB
#-----------------------------------------------------------------------

export UF_FOLDER
export DESTINATION
export DESTISERIEN
export DELNAME
export SERIES
export LOGFILE

#-----------------------------------------------------------------------
# Logfile-Ausgabe, setze "#" um Log zu deaktivieren
#-----------------------------------------------------------------------

echo "`date`START arguments unrar_finished" >>$LOGFILE
echo "$0 0 Scriptname" >>$LOGFILE
echo "$1 1. Argument" >>$LOGFILE
echo "$2 2. Argument" >>$LOGFILE
echo "$# Argumente gesamt" >>$LOGFILE
echo STOP arguments unrar_finished >>$LOGFILE

#-----------------------------------------------------------------------
# Wenn UNRARON=1 entpacke Archive
#-----------------------------------------------------------------------

if [ $UNRARON = 1 ]; then
 cd "$UF_FOLDER"
  `$UNRARALL -d "$UF_FOLDER" --full-path -c`	
fi

#-----------------------------------------------------------------------
# Kopiere und starte das Haupt-Script
#-----------------------------------------------------------------------

sleep 5
cp $SCRP/runscript.sh "$UF_FOLDER/"
cd "$UF_FOLDER"
./runscript.sh &
sleep 240
exit 0

#-----------------------------------------------------------------------
# Scriptende
#-----------------------------------------------------------------------
