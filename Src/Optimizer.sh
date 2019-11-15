#!bin/bash

#Needed programs: PNGQuant; FFMPEG; Zip/Unzip
#All functions thinks we are in the same folder as this file.

GREEN = "\033[32m"
BLUE = "\033[34m"
WHITE = "\033[0m"
Filename = ""
HorizontalLine = "============================================================================"

#Init
for folder in ["Mods","Temp","Output"]
do
	if [ -d "$folder" ]
	then
		print '"$folder" folder found.'
		
	else
		print '$"$folder" folder not found, creating it.'
		mkdir $folder
	fi
done

function print(){
	if [ "$#" -eq 2 ]
	then
		echo -e $GREEN"$1" $BLUE"$2" $WHITE
	else
		echo -e $GREEN"$1" $WHITE
	fi
	}

function Unzip_mod(){
	target = "$1"
	Filename = `basename "$target" `
	mv "$target" ../Temp/"$Filename"
	unzip -qq -o -d ./Temp/"$Filename" ./Temp/"$Filename"
	rm -f ./Temp/"$Filename"
	}
	
function Optimize_textures(){
	cd Temp
	ColorPalette = "$1"
	for PNG in "$(find . -name '*.png' )"
	do
		print "Optimizing" "`basename $PNG`"
		pngquant --ext .png -f --speed 1 --quiet "$ColorPalette" "$PNG"
		
	done
	cd ..
	
	}
	
	
function Optimize_audio(){
	cd Temp
	Frequency = "$1"
	Bitrate = "$2"
	for AUDIO in $(find . -name '*.ogg'); 
	do
		print "Optimizing" "`basename $AUDIO`"
		ffmpeg -i "$AUDIO" -v 0 -y -ar "$Frequency" -b:a "$Bitrate" -f ogg "${audio%.*}.ogg"
	done
	cd ..
	
	}
	
function Remove_assets(){
	cd Temp
	print "Removing" "assets"
	rm -f -R assets
	print "Removing leftover files..."
	
	for PNG in "$(find . -name '*.png' )"
	do
		print "Removing" "`basename $PNG`"
		rm -f "$PNG"
		
	done
	
	for AUDIO in $(find . -name '*.ogg'); 
	do
		print "Removing" "`basename $AUDIO`"
	rm -f "$AUDIO"
	done
	cd ..
	
	}
	
function Repackage_mod(){
	print "Rapackaging" "$Filename"
	zip -r -9 --quiet "$Filename" ./Temp/*
	mv ./Temp/"$Filename" ./Output/"$Filename"
	rm -f -R Temp/*
	}
	


function main_menu(){
	clear
	
	print "     _           ___  ___   _____     "
	print "    | |         /   |/   | |_   _|    "
	print "    | |        / /|   /| |   | |      "
	print "    | |       / / |__/ | |   | |      "
	print "    | |___   / /       | |   | |      "
	print "    |_____| /_/        |_|   |_|      "


	Choice-1 = "Optimize textures"
	Choice-2 = "Optimize sounds"
	Choice-3 = "Optimize both textures and sounds"
	Choice-4 = "Server side optimization"
	
	select choice in "$Choice-1" "$Choice-2" "Choice-3" "Choice-4"
	do
		case "$choice" in 
			"$Choice-1")
				#Optimize textures
				;;
			"$Choice-2")
				#Optimize audio
				;;
			"$Choice-3")
				#Optimize both audio and textures
				;;
			"$Choice-4")
				#optimize files for server use.
				;;
				
			*)
				#Nothing has been chosen
				;;
				
		esac
	
	
	done
	
	
	}
	
	
	
	
	