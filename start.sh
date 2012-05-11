#!/bin/sh

#-----------------------------------------------------------------------
#----- Scriptstart - Initialscript für pyLoad Hook "package_finished"
#----- Script unter "./pyload/scripts/package_finished" oder
#----- "./pyload/scripts/unrar_finished" speichern und ausfuehrbar machen
#----- "chmod +x [Scriptname]" 
#-----------------------------------------------------------------------
#----- Script zur Datei / Ordner Umbenennung 
#----- http://code.google.com/p/pyload-runscript/source/browse/runscript.sh
#----- Script (siehe Link) unter personalisierter Pfadangabe der Variablen 
#----- "PREFIX" speichern und ausfuehrbar machen "chmod +x [Scriptname]"
#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
# nachfolgende Pfadangaben bitte anpassen
#-----------------------------------------------------------------------

PATH=/opt/bin:/opt/sbin
PREFIX="/share/Public" # dein "Home-Verzeichnis" 
RUNSCRP=${PREFIX}/runscript.sh
UNRARALL=${PREFIX}/unrarall # Pfad zu unrarall https://github.com/arfoll/unrarall
DESTINATION=/share/Qmultimedia/ # dein Download-Zielverzeichnis - ANPASSEN!
DESTISERIEN=/share/Qmultimedia/Serien # Serien-Verzeichnis - ANPASSEN!
LOGFILE=${PREFIX}/pyload_copy_log # Logfile-Pfad
UNRARON=1 # Downloads/Archive entpacken: ja = 1 - nein = 0
DELNAME=${PREFIX}/DELNAME # Datei welche die Ersetzungsvariablen enthaelt
SERIES=${PREFIX}/SERIEN # Datei welche die Serienvariablen enthaelt
UF_FOLDER=$2 # $2 = "package_finished" $1 = "unrar_finished"

#-----------------------------------------------------------------------
# sende personalisierte Angaben an runscript.sh 
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

echo "`date`START Argumente" >>$LOGFILE
echo "$0 0 Scriptname" >>$LOGFILE
echo "$1 1. Argument" >>$LOGFILE
echo "$2 2. Argument" >>$LOGFILE
echo "$# Argumente gesamt" >>$LOGFILE
echo STOP Argumente >>$LOGFILE

#-----------------------------------------------------------------------
# Check ob Argumente uebergeben und \$RUNSCRP vorhanden
#-----------------------------------------------------------------------

if [ "$#" = 0 ]; then
  STRNSCRP=0
  UNRARON=0
  UF_FOLDER=$PREFIX/dummydir
  cd $PREFIX
   if [ ! -d "$PREFIX/dummydir" ]; then
  mkdir dummydir
   fi
else
  STRNSCRP=1
fi

if [ ! -f $RUNSCRP ]; then
cd "$PREFIX"
wget http://pyload-runscript.googlecode.com/files/runscript.sh
chmod +x runscript.sh
fi


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

if [ $STRNSCRP = 0 ]; then
  echo "`date` --- keine Argumente uebergeben, beende Script ---" >> $LOGFILE
  echo "--------------------------------------------------------" >> $LOGFILE
  exit 0
else
  sleep 5
  cp $RUNSCRP "$UF_FOLDER/"
  cd "$UF_FOLDER"
  ./runscript.sh &
  sleep 240
fi

exit 0

#-----------------------------------------------------------------------
# Scriptende
#-----------------------------------------------------------------------