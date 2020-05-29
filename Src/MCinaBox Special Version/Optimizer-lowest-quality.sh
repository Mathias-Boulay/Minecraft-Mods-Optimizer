#! /bin/bash

#This script cranks down the mods file size to something really low.
#Why ? 
#I just take into account RAM limitation on many android phones,
#to allow them to have the java modded experience with MCinaBox !



#Needed programs: PNGQuant; FFMPEG; Zip/Unzip
#All functions thinks we are in the same folder as this file.

GREEN="\033[32m"
BLUE="\033[36m"
WHITE="\033[0m"
Filename=""
HorizontalLine="============================================================================"

function print_msg(){
	if [ "$#" -eq 2 ]
	then
		echo -e $GREEN"$1" $BLUE"$2" $WHITE
	else
		echo -e $GREEN"$1" $WHITE
	fi
	}

function Prepare_package(){
	target="$1"
	Filename=`basename "$target" `
	print_msg "Preparing " "$Filename"
	mv ./Mods/"$Filename" ./Temp/Mod.zip
	unzip -qq -o -d ./Temp ./Temp/Mod.zip
	rm -f ./Temp/Mod.zip
	}
	
function Optimize_textures(){
	cd Temp
	ColorPalette="$1"
	print_msg "Starting textures optimization..."
	
	find . -name "*.png" -print0 | while read -d $'\0' PNG
	do
		PNG_NAME=`basename $PNG`
		print_msg "Optimizing" "$PNG_NAME"
		pngquant --ext .png -f --speed 1 --quiet "$ColorPalette" "$PNG"
	done
	
	cd ..
	
	}
	
	
function Optimize_audio(){
	cd Temp
	Frequency="$1"
	Bitrate="$2"
	print_msg "Starting sounds optimization..."
	
	find . -name "*.ogg" -print0 | while read -d $'\0' OGG
	do
		print_msg "Optimizing" "`basename $OGG`"
		ffmpeg -i "$OGG" -v 0 -y -ac 1 -ar "$Frequency" -b:a "$Bitrate" -f ogg "${audio%.*}.ogg"
	done
	cd ..
	
	}

	
function Repackage_mod(){
	cd Temp
	print_msg "Rapackaging" "$Filename"
	zip -r -9 --quiet "$Filename" *
	cd ..
	mv ./Temp/"$Filename" ./Output/"$Filename"
	rm -f -R ./Temp/*
	}
	

#Init
for folder in {"Mods","Temp","Output"}
do
	if [ -d "$folder" ]
	then
		print_msg '"$folder" folder found.'
		
	else
		print_msg '"$folder" folder not found, creating it.'
		mkdir $folder
	fi
done
chmod -R 777 *

clear
print_msg $HorizontalLine
print_msg "     _           ___  ___   _____     "
print_msg "    | |         /   |/   | |_   _|    "
print_msg "    | |        / /|   /| |   | |      "
print_msg "    | |       / / |__/ | |   | |      "
print_msg "    | |___   / /       | |   | |      "
print_msg "    |_____| /_/        |_|   |_|      "
print_msg $HorizontalLine
print_msg "MCinaBox Special Edition !"
print_msg $HorizontalLine



for File in "$(find . -name '*.jar' -o -name '*.zip')"
	do
	Prepare_package "$File"
	Optimize_textures 64
	Optimize_audio 26000 48
	Repackage_mod
done

echo "I'm done !"
wait 3