# Shell scripts
Useful little helpers for the Linux photographer

_*** Deutsche Beschreibung findet sich in README ***_

## Checksum
Purpose: To ensure file consistency in the image archive.

### Background
If the photographer uses RAW files in the camera, these files are read-only during further processing in the RAW editor.     
Any settings are stored either in the RAW Editor's internal database and/or in sidecar files (.xmp). It is therefore easy to determine whether the RAW files of an (extensive) image archive are still all intact, based on checksums for the RAW image files. This also simplifies the necessary backups and reduces the storage volume.    
More information: https://www.bilddateien.de/fotografie/bildbearbeitung/foto-backup.html

### The script
Installation:      
The script is copied to a directory stored in the `$PATH` variable and made executable.

Operation:     
The script has two modes:

1. creating checksum files
When a photo project is finished and all relevant RAW files are saved in the project folder, a terminal is opened in this folder and the script is called there.     
In mode (c) the script generates checksum files (currently using 3 different algorithms) for all files in this directory. The name of the checksum files corresponds to the directory name.
1. verifying the file consistency
The generated checksum files can be checked at regular intervals. To check the entire archive, a terminal is opened in the top folder level of the archive and the script is called there.    
In the mode (t) all subfolders are then searched for checksum files and these are processed. All errors that occur (damaged RAW files, missing RAW files, ...) are written to a log file in the start directory.   
