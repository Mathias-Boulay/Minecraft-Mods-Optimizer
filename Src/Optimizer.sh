#!bin/bash

#Needed programs: PNGQuant; FFMPEG; Zip/Unzip
#All functions thinks we are in the same folder as the file.

GREEN = "\033[32m"
WHITE = "\033[0m"

for folder in ["Mods","Temp","Output"]
	if [ -d "$folder" ]
	then
		echo -e '$GREEN "$folder" folder found. $WHITE'
		
	else
		echo -e '$GREEN "$folder" folder not found, creating it. $WHITE'
		mkdir Mods
	fi
done

function Unzip_mod(){
	target = $1
	mv 
	}