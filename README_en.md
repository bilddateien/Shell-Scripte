# Shell scripts
Useful little helpers for the Linux photographer

_*** Deutsche Beschreibung findet sich in [README](README.md) ***_

__Preliminary remarks:__ All scripts presented here must be copied to a directory listed in the `$PATH` variable. Then the script must be made executable for the current user.

## Checksum
Purpose: To ensure file consistency in the image archive.

### Background
If the photographer uses RAW files in the camera, these files are read-only during further processing in the RAW editor.     
Any settings are stored either in the RAW Editor's internal database and/or in sidecar files (.xmp). It is therefore easy to determine whether the RAW files of an (extensive) image archive are still all intact, based on checksums for the RAW image files. This also simplifies the necessary backups and reduces the storage volume.    
More information: https://www.bilddateien.de/fotografie/bildbearbeitung/foto-backup.html

### The script
The script has two modes:

1. creating checksum files    
When a photo project is finished and all relevant RAW files are saved in the project folder, a terminal is opened in this folder and the script is called there.     
In mode (c) the script generates checksum files (currently using 3 different algorithms) for all files in this directory. The name of the checksum files corresponds to the directory name.
1. verifying the file consistency    
The generated checksum files can be checked at regular intervals. To check the entire archive, a terminal is opened in the top folder level of the archive and the script is called there.    
In the mode (t) all subfolders are then searched for checksum files and these are processed. All errors that occur (damaged RAW files, missing RAW files, ...) are written to a log file in the start directory.   


## Exiftune
Purpose: To examine image files using the "exiftool" command line tool.

### Background    
[ExifTool](https://www.sno.phy.queensu.ca/~phil/exiftool/) by Phil Harvey is a free software for reading, writing and editing metadata in image, audio and video files. It works platform independent, supports different types of metadata like Exif, IPTC, XMP, JFIF, GeoTIFF, ICC profiles, Photoshop IRB, FlashPix, AFCP and ID3 as well as the manufacturer-specific (RAW) metadata formats of many digital cameras from Canon, Casio, Fuji, JVC/Victor, Kodak, Leaf, Minolta/Konica-Minolta, Nikon, Olympus/Epson, Panasonic/Leica, Pentax/Asahi, Ricoh, Sanyo and Sigma/Foveon. 

Exif data is generated and stored directly from the camera, while IPTC/IIM and the newer XMP for image information are used for cataloging and publishing.      
Also embedded in RAW files are JPG images, which are needed for preview purposes, e.g. in the camera.

Exiftool is a command line application. The numerous parameters that define the functions are not always self-explanatory. The script 'Exiftune' provides frequently used functions by simple calls.

### The script    
The script provides the following functions:

1. export of all metadata into own files
    - Original data with unchanged tags in text format
    - Metadata translated into German in HTML format
1. export of embedded preview images in jpg format from RAW files
1. Reduce metadata and add copyright notices
1. import metadata into image files from text files
1. transfer metadata between image files

The script is called in a terminal that is opened in the directory in which the (one or more) image files are located.

#### Export metadata
After selecting the option (t), the directory is automatically searched for image files and a subdirectory `meta` is created, in which a `.txt` file with the original tag names of the metadata and a `.html` file with the tag descriptions translated into German and the contents are created - for each existing image file 2 metadata files are created. These have the file name of the image file with the additions `_tag` for the text file with the unchanged tags and `_de` for the translated HTML file.

#### Export of embedded thumbnails
Option (e) provides various functions for reading the embedded JPG preview images:

- (a) reads all images that `exiftool` can find.
- (g) examines all embedded images and only outputs the one with the largest image format.    
To use the option "largest image" you have to create a file `.ExifTool_config` in the user directory and copy [this content](https://owl.phy.queensu.ca/~phil/exiftool/config.html) into it.
- (t), (p), (j) and (o) _only_ read the tags mentioned. Not every camera RAW format uses each of these tags, there are differences both from manufacturer to manufacturer and between different camera models (partly also firmware versions) of the same manufacturer.
- (e) copies all metadata from the RAW files to the previously extracted (and located in the `/jpg` subfolder) files.

#### Reduce metadata and add copyright notices
The option (m) changes the original images. The metadata of the image files in the active directory are largely deleted, only a few camera and recording parameters (manufacturer, camera type, lens, aperture, exposure time, exposure correction, ISO and focal length) are retained.     
In addition, the fields necessary for the identification of the image rights are filled out, the necessary contents must be entered at the beginning of the script in the fields `Photographer`, `Publisher` and `Rights` after the `=` between the `"` characters. 
