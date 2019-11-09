# Shell-Scripte
Nützliche kleine Helfer für den Linux-Fotografen

_*** for english description see [README_en](README_en.md) ***_

__Vorbemerkungen:__ Alle hier vorgestellten Scripte müssen in ein Verzeichnis kopiert werden, das in der Variable `$PATH` gelistet ist. Sodann muß das Script ausführbar gemacht werden für den aktuellen Benutzer.

## Checksum
Zweck: Dateikonsistenz im Bildarchiv sicherstellen

### Hintergrund
Nutzt der Fotograf RAW-Dateien in der Kamera, dann sind diese Dateien bei der weiteren Verarbeitung im RAW-Editor Read-only.     
Jegliche Einstellungen werden entweder in der internen Datenbank des RAW-Editors und/oder in Sidecar-Files (.xmp) abgespeichert. Es ist daher einfach festzustellen, ob die RAW-Dateien eines (umfangreichen) Bildarchivs noch alle intakt sind, und zwar anhand von Prüfsummen für die RAW-Bilddateien. Das vereinfacht auch die notwendigen Backups und reduziert das Speichervolumen.    
Mehr dazu: https://www.bilddateien.de/fotografie/bildbearbeitung/foto-backup.html

### Das Script
Das Script kennt zwei Modi:

1. Erstellen von Prüfsummen-Dateien    
Wenn ein Fotoprojekt abgeschlossen ist und alle relevanten RAW-Dateien im Projektordner gespeichert sind, dann wird ein Terminal in diesem Ordner geöffnet und dort das Script aufgerufen.     
Im Modus (c) erzeugt das Script dann Prüfsummen-Files (derzeit nach 3 verschiedenen Algorithmen) für alle Dateien in diesem Verzeichnis. Der Name der Prüfsummen-Files entspricht dem Verzeichnis-Namen.
1. Verifizieren der Dateikonsistenz    
In regelmäßigen Abständen können die erzeugten Prüfsummen-Files kontrolliert werden. Um das Gesamtarchiv zu prüfen, wird ein Terminal in der obersten Ordner-Ebene des Archivs geöffnet und dort das Script aufgerufen.  
Im Modus (t) werden dann alle Unterordner nach Prüfsummen-Files durchsucht und diese abgearbeitet. Alle dabei auftretenden Fehler (beschädigte RAW-Dateien, fehlende RAW-Dateien, ...) werden dabei in ein Logfile im Startverzeichnis geschrieben.   


## Exiftune
Zweck: Bilddateien mittels des Kommandozeilenprogramms "exiftool" untersuchen

### Hintergrund
[ExifTool](https://www.sno.phy.queensu.ca/~phil/exiftool/) von Phil Harvey ist eine freie Software zum Auslesen, Schreiben und Bearbeiten von Metadaten in Bild-, Audio- und Videodateien. Es arbeitet plattformunabhängig, unterstützt verschiedene Arten von Metadaten wie Exif, IPTC, XMP, JFIF, GeoTIFF, ICC-Profile, Photoshop IRB, FlashPix, AFCP und ID3 sowie die herstellerspezifischen (RAW-)Metadatenformate vieler Digitalkameras von Canon, Casio, Fuji, JVC/Victor, Kodak, Leaf, Minolta/Konica-Minolta, Nikon, Olympus/Epson, Panasonic/Leica, Pentax/Asahi, Ricoh, Sanyo und Sigma/Foveon. 

Exif-Daten werden hierbei direkt von der Kamera erzeugt und gespeichert – IPTC/IIM und das neuere XMP für Bildinformationen hingegen dienen zur Katalogisierung und Veröffentlichung.      
Ebenso sind in RAW-Dateien eingebettete JPG-Bilder eingebettet, die für Vorschauzwecke u. a. in der Kamera benötigt werden.

Exiftool ist eine Kommandozeilen-Anwendung. Die zahlreichen Parameter, die die Funktionen definieren, sind nicht immer selbsterklärend. Das Script 'Exiftune' stellt häufig genutzte Funktionen durch einfache Aufrufe zur Verfügung.

### Das Script
Das Script stellt folgende Funktionen zur Verfügung:

1. Export aller Metadaten in eigene Dateien
	- Originaldaten mit unveränderten Tags im Textformat
	- In deutsche Sprache übersetzte Metadaten im HTML-Format
1. Export der eingebetteten Vorschau-Bilder im jpg-Format aus RAW-Dateien
1. Import von Metadaten in Bilddateien aus Textfiles
1. Übertragung von Metadaten zwischen Bilddateien

Aufgerufen wird das Script in einem Terminal, das in dem Verzeichnis geöffnet wird, in dem die (eine oder mehrere) Bilddateien liegen.

#### Export von Metadaten
Nach Wahl der Option (t) wird automatisch das Verzeichnis nach Bilddateien durchsucht und ein Unterverzeichnis `meta` angelegt, in dem je eine `.txt`-Datei mit den Original-Tag-Namen der Metadaten und eine `.html`-Datei mit den in deutsche Sprache übersetzten Tagbeschreibungen und den Inhalten erstellt wird - für jede vorhandene Bilddatei entstehen also 2 Metadaten-Dateien. Diese tragen den Dateinamen der Bilddatei mit den Ergänzungen `_tag` für die Textdatei mit den unveränderten Tags und `_de` für die übersetzte HTML-Datei.

#### Export von eingebetteten Vorschaubildern
Die Option (e) stellt verschiedene Funktionen zum Auslesen der eingebetteten JPG-Vorschau-Bilder bereit:

- (a) liest alle Bilder aus, die `exiftool` finden kann.
- (g) untersucht alle eingebetteten Bilder und gibt nur jeweils dasjenige mit dem größten Bildformat heraus.    
Für die Benutzung der Option "größtes Bild" muß im Benutzerverzeichnis eine Datei `.ExifTool_config` erstellt werden und [dieser Inhalt](https://owl.phy.queensu.ca/~phil/exiftool/config.html) hineinkopiert werden.
- (t), (p), (j) und (o) lesen _nur_ die jeweils genannten Tags aus. Nicht jedes Kamera-RAW-Format nutzt jedes dieser Tags, es gibt hier Unterschiede sowohl von Hersteller zu Hersteller als auch unter verschiedenen Kameramodellen (teilweise auch Firmwareständen) des selben Herstellers.

#### Metadaten reduzieren und Copyright-Hinweise hinzufügen
Die Option (m) verändert die Originalbilder. Es werden die Metadaten der im aktiven Verzeichnis liegenden Bilddateien weitgehend gelöscht, lediglich einige wenige Kamera- und Aufnahme-Kennwerte (Hersteller, Typ der Kamera, Objektiv, Blende, Belichtungszeit, Belichtungskorrektur, ISO und Brennweite) bleiben erhalten.     
Außerdem werden die für die Kennzeichnung der Bildrechte nötigen Felder ausgefüllt, die hierfür nötigen Inhalte müssen am Anfang des Scriptes in die Felder `Fotograf`, `Herausgeber` und `Rechte` jeweils hinter dem `=` zwischen den `"`-Zeichen eingetragen werden.

