#!bin/bash

#Needed programs: PNGQuant; FFMPEG; Zip/Unzip
#All functions thinks we are in the same folder as this file.

GREEN = "\033[32m"
BLUE = "\033[34m"
WHITE = "\033[0m"
Filename = ""
HorizontalLine = "============================================================================"

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
	print_msg "Starting textures optimization..."
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
	print_msg "Starting sounds optimization..."
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
	print_msg $HorizontalLine
	print_msg "     _           ___  ___   _____     "
	print_msg "    | |         /   |/   | |_   _|    "
	print_msg "    | |        / /|   /| |   | |      "
	print_msg "    | |       / / |__/ | |   | |      "
	print_msg "    | |___   / /       | |   | |      "
	print_msg "    |_____| /_/        |_|   |_|      "
	print_msg $HorizontalLine


	ChoiceMAIN-1 = "Optimize textures (manual quality)"
	ChoiceMAIN-2 = "Optimize sounds (manual quality)"
	ChoiceMAIN-3 = "Automatically optimize both textures and sounds (recommended)"
	ChoiceMAIN-4 = "Server side optimization"
	ChoiceMAIN-5 = "Exit the prorgram"
	
	select choiceMAIN in "$ChoiceMAIN-1" "$ChoiceMAIN-2" "ChoiceMAIN-3" "ChoiceMAIN-4" "ChoiceMAIN-5"
	do
		case "$choiceMAIN" in 
			"$ChoiceMAIN-1")
				#Optimize textures
				textures_menu()
				return 0
				;;
			"$ChoiceMAIN-2")
				#Optimize audio
				sounds_menu()
				return 0
				;;
			"$ChoiceMAIN-3")
				#Optimize both audio and textures
				for File in "$(find . -name '*.jar' -o -name '*.zip')"
				do
					Prepare_package("$File")
					Optimize_textures(256)
					Optimize_audio(36000,80)
					Repackage_mod()
				done
				;;
			"$ChoiceMAIN-4")
				#optimize files for server use.
				for File in "$(find . -name '*.jar' -o -name '*.zip')"
				do
					Prepare_package("$File")
					Remove_assets()
					Repackage_mod()
				done
				;;
			"$ChoiceMAIN-5")
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
	
function textures_menu(){
	clear
	print_msg $HorizontalLine
	
	ChoicePNG-1 = "High - Most of the size advantage with minimal quality loss (recommended)"
	ChoicePNG-2 = "Medium - Extra size loss but the quality degradation tends to be way more visible "
	ChoicePNG-3 = "Low - Only choose this if you're desperate, since the color palette will be overdegraded, it's less enjoyable to look at in game"
	ChoicePNG-4 = "Cancel the textures optimization and go back to the main menu"
	
	select choicePNG in "$ChoicePNG-1" "$ChoicePNG-2" "ChoicePNG-3" "ChoicePNG-4"
	do
		case "$choicePNG" in
		
			"$ChoicePNG-1")
				#Optimize for High Quality
				for File in "$(find . -name '*.jar' -o -name '*.zip')"
				do
					Prepare_package("$File")
					Optimize_textures(256)
					Repackage_mod()
				done
				return 0
				;;
			"$ChoicePNG-2")
				#Optimize for Medium Quality
				for File in "$(find . -name '*.jar' -o -name '*.zip')"
				do
					Prepare_package("$File")
					Optimize_textures(128)
					Repackage_mod()
				done
				return 0;
				;;
			"$ChoicePNG-3")
				#Optimize for Low Quality
				for File in "$(find . -name '*.jar' -o -name '*.zip')"
				do
					Prepare_package("$File")
					Optimize_textures(64)
					Repackage_mod()
				done
				return 0;
				;;
			"$ChoicePNG-4")
				#return
				return 0;
				;;
				
			*)
				#Nothing has been chosen
				print_msg "This isn't a valid choice !"
				;;
		esac
	done
	}
	
function sounds_menu(){
	clear
	print_msg $HorizontalLine
	
	ChoiceOGG-1 = "High - Light file size reduction with minimal quality loss (recommended)"
	ChoiceOGG-2 = "Medium - Extra size loss, however the best ears may be able to see a difference "
	ChoiceOGG-3 = "Low - Best size loss, may be uncomfortable to hear on long term."
	ChoiceOGG-4 = "Cancel the sounds optimization and go back to the main menu"
	
	select choiceOGG in "$ChoiceOGG-1" "$ChoiceOGG-2" "ChoiceOGG-3" "ChoiceOGG-4"
	do
		case "$choiceOGG" in
		
			"$ChoiceOGG-1")
				#Optimize for High Quality
				for File in "$(find . -name '*.jar' -o -name '*.zip')"
				do
					Prepare_package("$File")
					Optimize_audio(36000,120)
					Repackage_mod()
				done
				return 0
				;;
			"$ChoiceOGG-2")
				#Optimize for Medium Quality
				for File in "$(find . -name '*.jar' -o -name '*.zip')"
				do
					Prepare_package("$File")
					Optimize_audio(36000,100)
					Repackage_mod()
				done
				return 0;
				;;
			"$ChoiceOGG-3")
				#Optimize for Low Quality
				for File in "$(find . -name '*.jar' -o -name '*.zip')"
				do
					Prepare_package("$File")
					Optimize_audio(36000,80)
					Repackage_mod()
				done
				return 0;
				;;
			"$ChoiceOGG-4")
				#return
				return 0;
				;;
				
			*)
				#Nothing has been chosen
				print_msg "This isn't a valid choice !"
				;;
		esac
	done
	}
	
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
	
main_menu()
	
	
	
	
	