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

function print_msg(){
	if [ "$#" -eq 2 ]
	then
		echo -e $GREEN"$1" $BLUE"$2" $WHITE
	else
		echo -e $GREEN"$1" $WHITE
	fi
	}

function Prepare_package(){
	target = "$1"
	Filename = `basename "$target" `
	print_msg "Preparing " "$Filename"
	mv "$target" ../Temp/"$Filename"
	unzip -qq -o -d ./Temp/"$Filename" ./Temp/"$Filename"
	rm -f ./Temp/"$Filename"
	}
	
function Optimize_textures(){
	cd Temp
	ColorPalette = "$1"
	for PNG in "$(find . -name '*.png' )"
	do
		print_msg "Optimizing" "`basename $PNG`"
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
		print_msg "Optimizing" "`basename $AUDIO`"
		ffmpeg -i "$AUDIO" -v 0 -y -ar "$Frequency" -b:a "$Bitrate" -f ogg "${audio%.*}.ogg"
	done
	cd ..
	
	}
	
function Remove_assets(){
	cd Temp
	print_msg "Removing" "assets"
	rm -f -R assets
	print_msg "Removing leftover files..."
	
	for PNG in "$(find . -name '*.png' )"
	do
		print_msg "Removing" "`basename $PNG`"
		rm -f "$PNG"
		
	done
	
	for AUDIO in $(find . -name '*.ogg'); 
	do
		print_msg "Removing" "`basename $AUDIO`"
	rm -f "$AUDIO"
	done
	cd ..
	
	}
	
function Repackage_mod(){
	print_msg "Rapackaging" "$Filename"
	zip -r -9 --quiet "$Filename" ./Temp/*
	mv ./Temp/"$Filename" ./Output/"$Filename"
	rm -f -R Temp/*
	}
	


function main_menu(){
	clear
	
	print_msg "     _           ___  ___   _____     "
	print_msg "    | |         /   |/   | |_   _|    "
	print_msg "    | |        / /|   /| |   | |      "
	print_msg "    | |       / / |__/ | |   | |      "
	print_msg "    | |___   / /       | |   | |      "
	print_msg "    |_____| /_/        |_|   |_|      "


	Choice-1 = "Optimize textures (manual quality)"
	Choice-2 = "Optimize sounds (manual quality)"
	Choice-3 = "Automatically optimize both textures and sounds (recommended)"
	Choice-4 = "Server side optimization"
	Choice-5 = "Exit the prorgram"
	
	select choice in "$Choice-1" "$Choice-2" "Choice-3" "Choice-4" "Choice-5"
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
				for File in "$(find . -name '*.jar' -o -name '*.zip')"
				do
					Prepare_package("$File");
					Optimize_textures(256);
					Optimize_audio(36000,80);
					Repackage_mod();
				done
				
				;;
			"$Choice-4")
				#optimize files for server use.
				;;
			"$Choice-5")
				print_msg "Okay, I'll exit then."
				exit 0
				;;
				
			*)
				#Nothing has been chosen
				print_msg "This isn't a valid choice !"
				;;
				
		esac
	
	
	done
	
	
	}
	
	
	
	
	