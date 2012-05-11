#!/bin/sh
PATH=/opt/bin:/opt/sbin

#---------------------------------------------------------------------------
#---------------- entferne unnoetige Dateien und Ordner
#---------------------------------------------------------------------------

cd "$UF_FOLDER"
/opt/bin/find . \( -name '*.sfv' -o -name '*.nfo' -o -name '*.txt' -o -name '*.rev' \) -type f -exec rm '{}' \;
/opt/bin/find . \( -iname '*sample*' -o -iname 'subs' -o -iname '*imdb*' \) -type d -exec rm -rf '{}' \;

#---------------------------------------------------------------------------
#---------------- entferne Leerzeichen und ersetze Sonderzeichen mit Punkten
#---------------------------------------------------------------------------

renRecursive()
{
/opt/bin/find `$UF_FOLDER/`* ! -name "*.sh" -type d -print | while read FILE
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
/opt/bin/find `$UF_FOLDER/`* ! -name "*.sh" -type d -print | while read FILE
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
/opt/bin/find `$UF_FOLDER/`* ! -name "*.sh" -type f -print | while read FILE
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
#---------------- aendere rekursiv alles in Kleinbuchstaben
#---------------------------------------------------------------------------

lowRecursive()
{
/opt/bin/find `$UF_FOLDER/`* -name "*" -type d -print | while read FILE
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
/opt/bin/find `$UF_FOLDER/`* ! -name "*.sh" | while read FILE
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
#---------------- entferne Szene-Tags und unnoetige Dateinamenteile
#---------------------------------------------------------------------------

rmTagsRecursive()
{
/opt/bin/find `$UF_FOLDER/`* ! -name "*.sh" -type d -print | while read FILE
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
/opt/bin/find `$UF_FOLDER/`* ! -name "*.sh" -print | while read FILE
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
#---------------- aendere alles nach einem Punkt in Grossbuchstaben
#---------------------------------------------------------------------------

upRecursive()
{
/opt/bin/find `$UF_FOLDER/`* ! -name "*.sh" -type d -print | while read FILE
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
/opt/bin/find `$UF_FOLDER/`* ! -name "*.sh" -type d -print | while read FILE
do
   if [ -d $FILE ]; then
        # pay attention not to break this line
        NEW=`echo $FILE | sed -r 's/(\<.)/\u\1/g;s/([se][0123456789])/\u\1/g;s/Dvd/DVD/;s/Dts/DTS/;s/Csi/CSI/;s/Hd/HD/'`
        if [ $NEW != $FILE -a ! -f $NEW -a ! -d $NEW ]; then
        mv "$FILE" "$NEW"
	fi
   fi
done
}

upFiles()
{
/opt/bin/find `$UF_FOLDER/`* ! -name "*.sh" -type f -print | while read FILE
do
   if [ -f $FILE ]; then
        # pay attention not to break this line
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
#---------------- verschiebe Dateien und Ordner ins Zielverzeichnis
#---------------------------------------------------------------------------

sleep 5
/opt/bin/find `$UF_FOLDER/`* -iname "Runscript.sh" -print | while read FILE
do
rm "$FILE"
done

copy2destination()
{
echo "`date` /opt/bin/find `$UF_FOLDER/`* ! -iname "*.sh"" >> $LOGFILE 
/opt/bin/find `$UF_FOLDER/`* ! -iname "*.sh" -print | while read FILE
do
	echo "mv "$FILE" "$DESTINATION/"" >> $LOGFILE
        mv "$FILE" "$DESTINATION/"
done
}

copyseries()
{
for SERIEN in `cat $SERIES`
do
echo "`date` /opt/bin/find `$UF_FOLDER/`* -iname "*"$SERIEN"*" -type f" >> $LOGFILE
/opt/bin/find `$UF_FOLDER/`* -iname "*"$SERIEN"*" -type f -print | while read SERIE
        do
	echo "mv "$SERIE" "$DESTISERIEN/"$SERIEN"/"" >> $LOGFILE
        mv "$SERIE" "$DESTISERIEN/"$SERIEN"/"
        done
done
}
copyseries

if [ $? -eq 0 ] ; then
 sleep 25; rm -rf "$UF_FOLDER"
else
 copy2destination 
fi

if [ $? -eq 0 ] ; then
sleep 25; rm -rf "$UF_FOLDER"
fi

#---------------------------------------------------------------------------
#---------------- Scriptende
#---------------------------------------------------------------------------

exit 0 
