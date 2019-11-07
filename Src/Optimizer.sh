#!bin/bash

#Needed programs: PNGQuant; FFMPEG; Zip/Unzip
#All functions thinks we are in the same folder as the file.

GREEN = "\033[32m"
BLUE = "\033[34m"
WHITE = "\033[0m"
Filename = ""

for folder in ["Mods","Temp","Output"]
do
	if [ -d "$folder" ]
	then
		echo -e '$GREEN "$folder" folder found. $WHITE'
		
	else
		echo -e '$GREEN "$folder" folder not found, creating it. $WHITE'
		mkdir Mods
	fi
done

function Unzip_mod(){
	target = "$1"
	Filename = `basename "$target" `
	mv "$target" ../Temp/"$Filename"
	unzip -o -d ./Temp/"$Filename" ./Temp/"$Filename"
	
	}
	
function Optimize_textures(){
	#This function assumes there is something to optimize !
	cd Temp
	ColorPalette = "$1"
	for PNG in "$(find . -name '*.png' )"
	do
		echo -e "'$GREEN'Optimizing '$BLUE' `basename $PNG` '$WHITE'"
		pngquant --ext .png -f --speed 1 --quiet "$ColorPalette" "$PNG"
		
	done
	cd ..
	
	}
	
	
function Optimize_audio(){
	#This function assumes there is something to optimize !
	cd Temp
	Frequency = "$1"
	Bitrate = "$2"
	for AUDIO in $(find . -name '*.ogg'); 
	do
		echo -e "'$GREEN'Optimizing '$BLUE' `basename $AUDIO` '$WHITE'"
		ffmpeg -i "$AUDIO" -v 0 -y -ar "$Frequency" -b:a "$Bitrate" -f ogg "${audio%.*}.ogg"
	done
	cd ..
	
	}
	
function Repackage_mod(){
	
	
	
	}
	
	
	
	
	