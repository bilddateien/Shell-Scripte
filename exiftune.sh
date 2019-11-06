#!/bin/bash

#Dateikonsistenz im Bildarchiv sicherstellen
#erstellt von: Bernhard Albicker, www.bilddateien.de 

#Copyright-Vermerke für Bilder hier eintragen:
Fotograf="Name des Fotografen"
Herausgeber="Bildherausgeber"
Rechte="Lizensierungshinweise"

echo -e "\n*** Operationen an/mit Metadaten von Bilddateien ***\n"		#-e wegen der Zeilenumbrüche
echo "Eingebettete JPG-Dateien aus RAW-Dateien extrahieren      (e)"
echo "Metadaten aus Bilddateien auslesen und als Text speichern (t)"
echo "Metadaten begrenzen und copyright hinzufügen              (m)"
read -p "Auswahl: " mode
echo -e "\n"

startverz="$(pwd)"   #Startverzeichnis, von dem aus das Script im Terminal gestartet wurde, "/der/Pfad/nach"
#echo $startverz
verzname="$(basename $startverz)"  #Name des letzten Verzeichnisses im Pfad des Startverz., "nach"
#echo $verzname

# https://owl.phy.queensu.ca/~phil/exiftool/exiftool_pod.html#Tag-operations

if [ $mode == "e" ]; then
	echo -e "\nWelcher Typ des eingebetteten JPG soll ausgelesen werden?\n"		#-e wegen der Zeilenumbrüche
	echo "alle            (a)"
	echo "größte Vorschau (g)"
	echo "Thumbnail       (t)"
	echo "Preview         (p)"
	echo "JPG from RAW    (j)"
	echo "Other           (o)"
	read -p "Auswahl: " typ
	echo -e "\n"
	
	cd $startverz		
	if [ ! -d $jpg ]; then
  		mkdir jpg
	fi
	if [ $typ == "a" ]; then
		#jpg extrahieren im aktuellen Verzeichnis:
		exiftool -a -b -W jpg/%f_%t%-c.%s -preview:all $startverz
		# war %d%f_%t%-c.%s => [%d]akt. Verz., [%f]Dateiname, [%t]Tagname, [%-c]lfd. Nr., [%s] vorgeschlagene Erweiterung
		echo -e "erledigt ...
"
	elif [ $typ == "g" ]; then
		if [ ! -d "$big" ]; then
  			mkdir big
		fi
		#größtes jpg extrahieren im aktuellen Verzeichnis:
		#https://owl.phy.queensu.ca/~phil/exiftool/config.html
		for file in *
		do
			if [ -f "$file" ]; then
				echo $file
				exiftool -b -BigImage  $file > big/${file%.*}_bigImage.jpg
			fi
		done
		echo -e "erledigt ...
"
	elif [ $typ == "t" ]; then
		exiftool -b -ThumbnailImage -w jpg/%f_ThumbnailImage%-c.jpg $startverz
		echo -e "erledigt ...
"
	elif [ $typ == "p" ]; then
		exiftool -b -PreviewImage -w jpg/%f_PreviewImage%-c.jpg $startverz
		echo -e "erledigt ...
"
	elif [ $typ == "j" ]; then
		exiftool -b -JpgFromRaw -w jpg/%f_JpgFromRaw%-c.jpg $startverz
		echo -e "erledigt ...
"
	elif [ $typ == "o" ]; then
		exiftool -b -OtherImage -w jpg/%f_OtherImage%-c.jpg $startverz
		echo -e "erledigt ...
"
	else
		#Benutzer hat sich vertippt - es wird nichts ausgeführt
		echo -e "\nFalsche Auswahl, bitte Script erneut starten\n"
	fi

elif [ $mode == "t" ]; then
	cd $startverz		
	mkdir meta
	exiftool -lang de -a -G -h -w meta/%f_de%-c.html $startverz
	exiftool -s -a -G -w meta/%f_tag%-c.txt $startverz
	#Dateien werden in Verz. "meta" gelegt, mit [%file]Filename, angehängt der fest kodierte Inhalt (tag oder de) mit angehängter laufender Bindestrich/Nummer [%-c], falls die Datei schon existiert.
	echo -e "erledigt ...
"

elif [ $mode == "m" ]; then
	echo -e "ACHTUNG: Die Dateien im aktuellen Verzeichnis"
	echo -e "\t$startverz"
	echo -e "werden verändert! Ist das das richtige Verzeichnis?\n"
	read -p "(j)a - (n)ein  " mjn
	if [ $mjn == "j" ]; then
		read -p "Dateiendung:  " ext
		cd $startverz
		for file in *.$ext
			do
				echo $file
				exiftool -overwrite_original -all=  -tagsFromFile @ -Lens -Make -Model -AFMode -ApertureValue -ExposureCompensation -ExposureTime -FNumber -FocalLength -ISO -Creator -Publisher -Rights  $file
				exiftool -overwrite_original -Artist="$Fotograf" -Copyright="$Rechte" -Creator="$Fotograf" -Publisher="$Herausgeber" -Rights="$Rechte"  $file
			done
	elif [ $mjn == "n" ]; then
		echo "bitte ins richtige Verzeichnis wechseln und Script neu starten"
	fi
	echo -e "erledigt ...
"

else
	#Benutzer hat sich vertippt - es wird nichts ausgeführt
	echo -e "\nFalsche Auswahl, bitte Script erneut starten\n"

fi

