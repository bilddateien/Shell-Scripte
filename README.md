# Shell-Scripte
Nützliche kleine Helfer für den Linux-Fotografen

_*** for english description see README_en ***_

## Checksum
Zweck: Dateikonsistenz im Bildarchiv sicherstellen

### Hintergrund
Nutzt der Fotograf RAW-Dateien in der Kamera, dann sind diese Dateien bei der weiteren Verarbeitung im RAW-Editor Read-only.     
Jegliche Einstellungen werden entweder in der internen Datenbank des RAW-Editors und/oder in Sidecar-Files (.xmp) abgespeichert. Es ist daher einfach festzustellen, ob die RAW-Dateien eines (umfangreichen) Bildarchivs noch alle intakt sind, und zwar anhand von Prüfsummen für die RAW-Bilddateien. Das vereinfacht auch die notwendigen Backups und reduziert das Speichervolumen.    
Mehr dazu: https://www.bilddateien.de/fotografie/bildbearbeitung/foto-backup.html

### Das Script
Installation:      
Das Script wird in ein Verzeichnis kopiert, das in der Variable `$PATH` gespeichert ist und ausführbar gemacht.

Betrieb:     
Das Script kennt zwei Modi:

1. Erstellen von Prüfsummen-Dateien
Wenn ein Fotoprojekt abgeschlossen ist und alle relevanten RAW-Dateien im Projektordner gespeichert sind, dann wird ein Terminal in diesem Ordner geöffnet und dort das Script aufgerufen.     
Im Modus (c) erzeugt das Script dann Prüfsummen-Files (derzeit nach 3 verschiedenen Algorithmen) für alle Dateien in diesem Verzeichnis. Der Name der Prüfsummen-Files entspricht dem Verzeichnis-Namen.
1. Verifizieren der Dateikonsistenz
In regelmäßigen Abständen können die erzeugten Prüfsummen-Files kontrolliert werden. Um das Gesamtarchiv zu prüfen, wird ein Terminal in der obersten Ordner-Ebene des Archivs geöffnet und dort das Script aufgerufen.  
Im Modus (t) werden dann alle Unterordner nach Prüfsummen-Files durchsucht und diese abgearbeitet. Alle dabei auftretenden Fehler (beschädigte RAW-Dateien, fehlende RAW-Dateien, ...) werden dabei in ein Logfile im Startverzeichnis geschrieben.   
