#!/bin/sh

#-----------------------------------------------------------------------
#----- Scriptstart
#-----------------------------------------------------------------------

CHKDIR="$(basename `pwd` )"
if [ $CHKDIR = "unrar_finished" ]; then
UF_FOLDER=$1
else
UF_FOLDER=$2
fi

#-----------------------------------------------------------------------
#----- nachfolgende Pfadangaben bitte anpassen
#-----------------------------------------------------------------------

PATH=/opt/bin:/opt/sbin
PREFIX="/share/Public"            # dein "Home-Verzeichnis" - ANPASSEN!
RUNSCRP=${PREFIX}/runscript.sh    # Pfad zum runscript 
UNRARALL=${PREFIX}/unrarscript    # Pfad zum unrarscript 
DESTINATION=/share/Qmultimedia/   # dein Downloadverzeichnis - ANPASSEN!
DESTIS=/share/Qmultimedia/Serien  # Serien-Verzeichnis - ANPASSEN!
LOGFILE=${PREFIX}/logfile         # Logfile-Pfad
UNRARON=1                         # Archive entpacken: ja = 1 - nein = 0
ALLLOW=0                          # Dateinamen in Kleinbuchstaben = 1
DELNAME=${PREFIX}/DELNAME         # Datei mit Ersetzungsvariablen 
SERIES=${PREFIX}/SERIEN           # Datei mit Serienvariablen
PASSWORDS=${PREFIX}/passwoerter   # Datei mit Archiv-Passwoertern 

#-----------------------------------------------------------------------
#----- exportiere personalisierte Angaben 
#-----------------------------------------------------------------------

export UF_FOLDER
export DESTINATION
export DESTIS
export DELNAME
export SERIES
export LOGFILE
export PASSWORDS
export ALLLOW

#-----------------------------------------------------------------------
#----- Logfile-Ausgabe, setze "#" um Log zu deaktivieren
#-----------------------------------------------------------------------

echo "-----------------------------------" >>$LOGFILE
echo "   " >>$LOGFILE
echo "   " >>$LOGFILE
echo "`date`" >>$LOGFILE
echo "$0 0 Scriptname" >>$LOGFILE
echo "$1 1. Argument" >>$LOGFILE
echo "$2 2. Argument" >>$LOGFILE
echo "$# Argumente gesamt" >>$LOGFILE
echo "-----------------------------------" >>$LOGFILE

#-----------------------------------------------------------------------
#----- Check ob Argumente uebergeben und \$RUNSCRP vorhanden
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

if [ ! -f $UNRARALL ]; then
cd "$PREFIX"
wget http://pyload-runscript.googlecode.com/files/unrarscript
chmod +x unrarscript
fi

if [ ! -f $SERIES ]; then
cd "$PREFIX"
wget http://pyload-runscript.googlecode.com/files/SERIES
fi

if [ ! -f $DELNAME ]; then
cd "$PREFIX"
wget http://pyload-runscript.googlecode.com/files/DELNAME
fi

if [ ! -f $PASSWORDS ]; then
cd "$PREFIX"
touch passwoerter
fi

#-----------------------------------------------------------------------
#----- Wenn UNRARON=1 entpacke Archive
#-----------------------------------------------------------------------

if [ $UNRARON = 1 ]; then
 cd "$UF_FOLDER"
  `$UNRARALL -d "$UF_FOLDER" --full-path -c`    
fi

if [ $? = "1" ]; then
exit 1
fi

#-----------------------------------------------------------------------
#----- Kopiere und starte das Haupt-Script
#-----------------------------------------------------------------------

if [ $STRNSCRP = 0 ]; then
  echo "`date` --- keine Argumente uebergeben, beende Script ---" >> $LOGFILE
  echo "--------------------------------------------------------" >> $LOGFILE
  cd $PREFIX
  rmdir dummydir
  exit 0
else
  sleep 15
  cp $RUNSCRP "$UF_FOLDER/"
  cd "$UF_FOLDER"
  ./runscript.sh &
fi

exit 0

#-----------------------------------------------------------------------
#----- Scriptende
#-----------------------------------------------------------------------