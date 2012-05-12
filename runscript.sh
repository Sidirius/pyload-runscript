#!/bin/sh

#---------------------------------------------------------------------------
#------- Script "bereinigt" Datei / Ordner -  Namen und entfernt
#------- ungewollte u. unoetige Dateien und Dateinamen-Parts wie
#------- Scene-Tags oder Sprachangaben und bringt die Dateien in
#------- eine saubere Dateikultur
#-------
#------- Initial-Script für pyLoad "package_finished" / "unrar_finished"
#------- http://code.google.com/p/pyload-runscript/source/browse/start.sh
#------- 
#------- aktuelle "ipkg tr" "ipkg sed" "ipkg find" Pakete vorausgesetzt!
#------- "ipkg update" "ipkg install tr sed find"
#---------------------------------------------------------------------------

#---------------------------------------------------------------------------
#------- persoenliche Pfadangaben bearbeiten
#------- http://code.google.com/p/pyload-runscript/source/browse/start.sh
#---------------------------------------------------------------------------

PATH=/opt/bin:/opt/sbin

#---------------------------------------------------------------------------
#------- entferne unnoetige Dateien und Ordner 
#------- Textdateien / Info-Dateien / Reparatur-Dateien / Untertitel ...
#---------------------------------------------------------------------------

cd "$UF_FOLDER"
/opt/bin/find . \( -name '*.sfv' -o -name '*.nfo' -o -name '*.txt' -o -name '*.rev' \) -type f -exec rm '{}' \;
/opt/bin/find . \( -iname '*sample*' -o -iname 'subs' -o -iname '*imdb*' \) -type d -exec rm -rf '{}' \;

#---------------------------------------------------------------------------
#------- entferne Leerzeichen und ersetze Sonderzeichen mit Punkten
#---------------------------------------------------------------------------

renRecursive()
{
find `$UF_FOLDER/`* ! -name "*.sh" -type d -print | while read FILE
do
  if [ -d $FILE ]; then
    cd $FILE
    renRecursive
    renFolder
    renFiles
    cd ..
  fi
done
}

renFolder()
{
find `$UF_FOLDER/`* ! -name "*.sh" -type d -print | while read FILE
do
  if [ -d "$FILE" ]; then
  NEW=`echo "$FILE" | sed -r 's/ +/./g' | sed -r 's/-/./g;s/_/./g;s/^\.+//;s/\.+$//' | tr -s '.'`
    if [ $NEW != $FILE -a ! -f $NEW -a ! -d $NEW ]; then
      mv "$FILE" "$NEW"
    fi
  fi
done
}

renFiles()
{
find `$UF_FOLDER/`* ! -name "*.sh" -type f -print | while read FILE
do
  if [ -f "$FILE" ]; then
  NEW=`echo "$FILE" | sed -r 's/ +/./g' | sed -r 's/-/./g;s/_/./g;s/^\.+//;s/\.+$//' | tr -s '.'`
    if [ $NEW != $FILE -a ! -f $NEW -a ! -d $NEW ]; then
      mv "$FILE" "$NEW"
    fi
  fi
done
}

#---------------------------------------------------------------------------
#------- aendere rekursiv alles in Kleinbuchstaben
#---------------------------------------------------------------------------

lowRecursive()
{
find `$UF_FOLDER/`* -name "*" -type d -print | while read FILE
do
  if [ -d $FILE ]; then
    cd $FILE
    lowRecursive
    lowFiles
    cd ..
  fi
done
}

lowFiles()
{
find `$UF_FOLDER/`* ! -name "*.sh" | while read FILE
do
  if [ -f $FILE -o -d $FILE ]; then
  NEW=`echo $FILE | tr 'A-Z' 'a-z'`
    if [ $NEW != $FILE -a ! -f $NEW -a ! -d $NEW ]; then
      mv "$FILE" "$NEW"
    fi
  fi
done
}

#---------------------------------------------------------------------------
#------- entferne Szene-Tags und / oder unnoetige Dateinamenteile
#------- "$DELNAME" ggf. anlegen und mit zu filternden Inhalten fuellen
#------- http://code.google.com/p/pyload-runscript/source/browse/start.sh
#---------------------------------------------------------------------------

rmTagsRecursive()
{
find `$UF_FOLDER/`* ! -name "*.sh" -type d -print | while read FILE
do
  if [ -d $FILE ]; then
    cd "$FILE"
    rmTagsRecursive
    rmTags
    cd ..
  fi
done
}

rmTags()
{
for i in `cat $DELNAME`
do
  find `$UF_FOLDER/`* ! -name "*.sh" -print | while read FILE
    do
      if [ -d $FILE ]; then
      NEW=`echo $FILE | sed -r 's/'"$i"'\.//g' | sed -r 's/\.'"$i"'//g'`
        if [ $NEW != $FILE -a ! -f $NEW -a ! -d $NEW ]; then
          mv "$FILE" "$NEW"
        fi
      fi
      if [ -f $FILE ]; then
      NEW=`echo $FILE | sed -r 's/'"$i"'\.//g' | sed -r 's/'"$i"'//g'`
        if [ $NEW != $FILE -a ! -f $NEW -a ! -d $NEW ]; then
          mv "$FILE" "$NEW"
        fi
      fi
    done
done
}

#---------------------------------------------------------------------------
#------- aendere ersten Buchstaben nach einem Punkt in einen Grossbuchstaben
#---------------------------------------------------------------------------

upRecursive()
{
find `$UF_FOLDER/`* ! -name "*.sh" -type d -print | while read FILE
do
  if [ -d $FILE ]; then
    cd "$FILE"
    upRecursive
    upFolder
    upFiles
    cd ..
  fi
done
}

upFolder()
{
find `$UF_FOLDER/`* ! -name "*.sh" -type d -print | while read FILE
do
  if [ -d $FILE ]; then
  # nachfolgende Codezeile darf nicht "gelinebreakt" werden!
  NEW=`echo $FILE | sed -r 's/(\<.)/\u\1/g;s/([se][0123456789])/\u\1/g;s/Dvd/DVD/;s/Dts/DTS/;s/Csi/CSI/;s/Hd/HD/'`
    if [ $NEW != $FILE -a ! -f $NEW -a ! -d $NEW ]; then
      mv "$FILE" "$NEW"
    fi
  fi
done
}

upFiles()
{
find `$UF_FOLDER/`* ! -name "*.sh" -type f -print | while read FILE
do
  if [ -f $FILE ]; then
  # nachfolgende Codezeile darf nicht "gelinebreakt" werden!
  NEW=`echo $FILE | sed -r 's/(\<.)/\u\1/g;s/([se][0123456789])/\U\1/g;s/Dvd/DVD/;s/Dts/DTS/;s/Hd/HD/;s/Csi/CSI/' | sed -r 's/(\....)$/\L\1/'`
    if [ $NEW != $FILE -a ! -f $NEW -a ! -d $NEW ]; then
      mv "$FILE" "$NEW"
    fi
  fi
done
}

renRecursive
 sleep 1
renFolder
 sleep 1
renFiles

 sleep 1
lowRecursive
 sleep 1
lowFiles

 sleep 1
rmTagsRecursive
 sleep 1
rmTags

 sleep 1
renRecursive
 sleep 1
renFolder
 sleep 1
renFiles

 sleep 1
upRecursive
 sleep 1
upFolder
 sleep 1
upFiles

#---------------------------------------------------------------------------
#------- verschiebe Dateien und Ordner ins Zielverzeichnis
#------- loesche "runscript.sh" aus dem Downloadverzeichnis
#---------------------------------------------------------------------------

sleep 5
find `$UF_FOLDER/`* -iname "Runscript.sh" -print | while read FILE
do
  rm "$FILE"
done

copyseries()
{
for SERIEN in `cat $SERIES`
do
 if [ ! -d "$DESTIS/$SERIEN" ]; then
   echo "`date` --- $DESTIS/$SERIEN" >> $LOGFILE
   cd "$DESTIS/"
   echo `mkdir $SERIEN`
   cd "$UF_FOLDER"
 fi
echo "`date` --- find `$UF_FOLDER/`* -iname "*"$SERIEN"*" -type f" >> $LOGFILE
find `$UF_FOLDER/`* -iname "*"$SERIEN"*" -type f -print | while read OMEGA
  do
    echo "`date` --- mv "$OMEGA" "$DESTIS/"$SERIEN"/"" >> $LOGFILE
    mv "$OMEGA" "$DESTIS/"$SERIEN"/"
    cd "$UF_FOLDER"; rmdir *
  done
done
}

copy2destination()
{
echo "`date` --- find `$UF_FOLDER/`* ! -iname "*.sh"" >> $LOGFILE
find `$UF_FOLDER/`* ! -iname "*.sh" -print | while read FILE
do
  echo "`date` --- mv "$FILE" "$DESTINATION"" >> $LOGFILE
  mv "$FILE" "$DESTINATION"
done
}

copyseries
 sleep 2
copy2destination

#---------------------------------------------------------------------------
#------- loesche das - leere - Downloadverzeichnis
#---------------------------------------------------------------------------

sleep 25; rm -rf "$UF_FOLDER"

#---------------------------------------------------------------------------
#------- Scriptende
#---------------------------------------------------------------------------

exit 0