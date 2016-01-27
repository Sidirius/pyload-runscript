<font size='4'>Dieser "Script-Pack" ist als "Custom Userscript" für pyLoad gedacht. Die Scripte entpacken heruntergeladene RAR-Archive, löschen diese nach erfolgreichem entpacken und bereinigen die Dateinamen. Zudem werden überflüssige Dateien wie Textfiles, NFO-, SFV-Dateien, Samples, Subs und URL-Verweise gelöscht.</font><br><br>
Sind Archive passwortgeschützt, so sucht das Unrar-Script in der Passwortdatei "<b>passwoerter</b>" nach einem hinterlegten PW.<br>
<br><br>
Die aus dem Dateinamen zu entfernenden Teile/Bezeichnungen sind frei editierbar, dazu muss lediglich die Datei "DELNAME" bearbeitet, bzw. um die zu löschenden Bezeichnungen erweitert werden (eine Ersetzungsvariable pro Zeile). "DELNAME" enthält schon viele Ersetzungsvariablen, wie Scene- oder Release-Tags. Die Dateinamen können optional komplett in Kleinbuchstaben oder der erste Buchstabe jedes vorkommenden Wortes in Großbuchstaben ausgegeben werden (siehe Beispiel weiter unten).<br>
<br><br>
Nach dem Umbenennen werden die Dateien (beispielsweise) ins Medienverzeichnis verschoben. Serien werden in den entsprechenden Serienordner des frei definierbare Serienverzeichnis verschoben, dazu muss nur die Datei "SERIEN" bearbeitet werden. Das Script prüft die heruntergeladenen Dateien auf in dem File ("SERIEN") eingetragene (Serien-) Namen und verschiebt bei einem Treffer den Download in dieses Verzeichnis; es reicht eine Eintragung, ist das Verzeichnis nicht angelegt, erledigt dies das Script automatisch.<br>
<br><br><br>
<b>Beispiele:</b>
<br><br>
Wird beispielsweise nachfolgende Serie als RAR-Archiv heruntergeladen, so entpackt das Script die Datei und benennt sie aus meiner persönlichen Sicht sinnvoll um<br>
<br><br>
Original-Dateiname <b><code>odd-job-jack.s01e02.German.AC3D.DL.1080p.BluRay.x264-LameHD</code></b>
<br><br>
Neuer Dateiname <b><code>Odd.Job.Jack.S01E02.1080p</code></b>
<br><br><br>
Benutzt die pyLoad-Events "<b>package_finished</b>" oder "<b>unrar_finished</b>", letzterer, falls die pyLoad-Unrar-Engine benutzt wird.<br>
<br><br>
<font color='red'><b>WICHTIG: Die Option "</b><u>Create folder for each package</u>" "Ordner für jeden Download erstellen" in den pyLoad-Einstellungen muss aktiviert sein!<b></font></b><br><br>
<i><u>Installationsanleitung:</u></i><br><br>
<font color='blue'><b>1.</b> Installiere die benötigten Pakete <b>sed, findutils und tr</b> und optional <b>nano</b> (letzteres um die Dateien "DELNAME", "SERIEN" und "passwoerter" zu bearbeiten, funktioniert aber auch mit vi).</font>
<br><br>
<code>ipkg update</code><br>
<code>ipkg install sed findutils nano tr gawk</code><br>
<code>ipkg upgrade</code> <br>
<br><br>
<font color='blue'><b>2.</b> Installiere Scriptpaket</font>
<br><br>
wechsle ins pyLoad-Verzeichnis "<b>package_finished</b>" (falls das eingebundene Unrarscript verwendet werden soll) oder "<b>unrar_finished</b>" (falls die pyLoad-Unrar-Engine benutzt wird) und lade das Userscript von dieser Seite herunter.<br>
<br><br>
<code>cd ../scripts/package_finished/</code><br>
<code>wget http://pyload-runscript.googlecode.com/files/startscript.sh; chmod +x startscript.sh</code>
<br><br><br>
<font color='blue'><b>3.</b> Anpassen der persönlichen Variablen</font>
<br><br>
<code>nano startscript.sh</code>
<br><br>
<font color='red'>Nachfolgende (Pfad-) Angaben sind unbedingt anzupassen!</font>
<pre><code>PREFIX="/share/Public"            # dein "Home-Verzeichnis" - ANPASSEN!<br>
DESTINATION=/share/Qmultimedia/   # dein Multimediaverzeichnis - ANPASSEN!<br>
DESTIS=/share/Qmultimedia/Serien  # Serien-Verzeichnis - ANPASSEN!<br>
UNRARON=1                         # Archive entpacken: ja = 1 - nein = 0<br>
ALLLOW=0                          # Dateinamen in Kleinbuchstaben = 1<br>
</code></pre>
<b>Home-Verzeichnis</b> = hier werden (automatisch) die Dateien <b>DELNAME SERIEN passwoerter runscript.sh unrarscript</b> gespeichert<br>
<b>Multimediaverzeichnis</b> = das Verzeichnis, wohin die heruntergeladenen, entpackten und umbenannten Dateien verschoben werden<br>
<b>Archive entpacken</b> = UNRARON=1 <br>
<b>Archive nicht entpacken</b> = UNRARON=0<br>
<b>Download-Datei in Kleinbuchstaben</b> = ALLLOW=1<br>
<b>Serien-Verzeichnis</b> = ggf. anlegen! Darin wird ein Verzeichniss erstellt und der fertige Download hineinverschoben, falls eine DL-Datei durch eine Variable im File <b>SERIEN</b> gefunden wird<br><br>
<b>Beispiel:</b> steht in der Datei <b>SERIEN</b> die Bezeichnung deiner Lieblingsserie <b>Benderama</b>, das Verzeichnis ist aber noch nicht angelegt und es wird ein Download dieser Serie gestartet (<code>Benderama.S06E16.Geister.Nachricht.German.DL.Dubbed.WS.1080p.BluRay.x264-GDR</code>), so wird die Datei umbenannt (<code>Benderama.S06E16.Geister.Nachricht.1080p</code>), das Verzeichnis <b><code>Benderama</code></b> im Serien-Verzeichnis angelegt und die fertige Datei dorthinein verschoben.<br>
<br><br><br>
<font color='blue'><b>4.</b> Script starten</font>
<br><br>
<code>./startscript.sh</code>
<br><br>
Das Script läd alle benötigten Scripte und Dateien, falls nicht vorhanden, selbstständig herunter, prüft, welcher Hook gewählt wurde und passt die entsprechende Variable an.<br>
<br><br><br>
<font color='blue'><b>5.</b> ggf. die Dateien mit den Ersetzungsvariablen / Serienvariablen / Passwörtern ändern / erweitern </font> <br><br>
<code>nano DELNAME</code><br>
<code>nano SERIEN</code><br>
<code>nano passwoerter</code><br>
<br><br>
<font color='blue'><b>6.</b> pyLoad neu starten, damit das Userscript geladen wird - fertig! Fröhliches Laden ;- )</font>