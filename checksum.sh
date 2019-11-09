#!/bin/bash

#Dateikonsistenz im Bildarchiv sicherstellen
#erstellt von: Bernhard Albicker, www.bilddateien.de 

echo -e "\n*** Prüfung der Dateikonsistenz im Bildarchiv ***\n"		#-e wegen der Zeilenumbrüche
echo "Erzeugen von Prüfsummen im aktuellen Verzeichnis? (c)"
echo "Überprüfen des kompletten Archivs auf Konsistenz? (t)"
read -p "Auswahl: " mode
echo -e "\n"

startverz="$(pwd)"   #Startverzeichnis, von dem aus das Script im Terminal gestartet wurde, "/der/Pfad/nach"
echo $startverz
verzname="$(basename $startverz)"  #Name des letzten Verzeichnisses im Pfad des Startverz., "nach"
echo $verzname

if [ $mode == "c" ]; then
    shopt -s nocaseglob 	#filenames case-insensitive: Erweiterungen unabh. von Groß/Kleinschreibung testen
    #Checksummen CRC32, SHA1 und MD5 für RAW-Files in einem gegebenen Verzeichnis erzeugen
    #Die Prüfsummendatei trägt den Namen des Verzeichnisses
    echo -e "\nPrüfsummenfiles für das Verzeichnis\n $verzname \nwerden erzeugt\n"
    for file in *.{nef,orf,rw2,pef,dng,tif,jpg,png} 
    do
        # do something on "$file"
        echo $file
        md5sum $file >> $verzname.md5 
        sha1sum --tag $file >> $verzname.sha1 
    done
    cfv -C -f$verzname.sfv *.{nef,orf,rw2,pef,dng,tif,jpg,png}  

    shopt -u nocaseglob
    echo "erledigt ..."

elif [ $mode == "t" ]; then
    #Checksummen CRC32, SHA1 und MD5 für RAW-Files aus einem 
    #Startverzeichnis heraus in allen Unterverzeichnissen überprüfen
    echo -e "\nAlle Prüfsummenfiles unterhalb des Verzeichnis\n $startverz \nwerden überprüft.\nDas kann einige Zeit dauern - abhängig von der Archivgröße.\n"
    datum=$(date '+%Y-%m-%d_%H:%M:%S')
    maschine=$(hostname)
    echo $maschine

    logfile="$startverz/checklog_${maschine}_$datum.txt"
    echo -e "\nDas Logfile liegt unter\n $logfile \nund enthält die Fehler-Ausgaben der Prüfungen\n\nBeginn der Prüfungen:\n"

    for ext in {md5,sfv,sha1}
        do 
            find $startverz -type f -name '*.'$ext -print | while read datei
                do 
                    echo $datei        #enthält Prüfsummendatei mit Verzeichnispfad
                    dir="$(dirname ${datei})"   #Verzeichnispfad der Prüfsummendatei ohne Dateiname
                    echo $dir >> $logfile
                    filename="$(basename ${datei})"    #Dateiname ohne Verzeichnispfad
                    echo $filename    #gibt aktuell verwendete Prüfsummendatei aus
                    cd $dir        #wechselt in das Verzeichnis der Prüfsummendatei
                    if [ $ext == "md5" ]; then
                        echo "*** Prüfung md5 ***" >> $logfile
                        md5sum -c --quiet ${filename} &>> $logfile
                    elif [ $ext == "sfv" ]; then
                        echo "*** Prüfung sfv ***" >> $logfile
                        cfv -T -f ${filename} &>> $logfile    #stdout UND stderr in Log-Datei umleiten
                    elif [ $ext == "sha1" ]; then
                        echo "*** Prüfung sha1 ***" >> $logfile 
                        sha1sum --quiet -c ${filename} &>> $logfile
                    fi
                    cd $startverz
                done
        done
    echo "erledigt ..."

else
    #Benutzer hat sich vertippt - es wird nichts ausgeführt
    echo -e "\nFalsche Auswahl, bitte Script erneut starten\n"

fi

