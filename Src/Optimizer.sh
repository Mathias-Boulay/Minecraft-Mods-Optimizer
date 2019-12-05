

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
		ffmpeg -i "$OGG" -v 0 -y -ar "$Frequency" -b:a "$Bitrate" -f ogg "${audio%.*}.ogg"
	done
	cd ..
	
	}
	
function Remove_assets(){
	cd Temp
	print_msg "Removing" "assets"
	rm -f -R assets
	print_msg "Removing leftover files..."
	
	find . -name "*.ogg" -print0 | while read -d $'\0' PNG
	do
		print_msg "Removing" "`basename $PNG`"
		rm -f "$PNG"
		
	done
	
	find . -name "*.ogg" -print0 | while read -d $'\0' OGG
	do
		print_msg "Removing" "`basename $OGG`"
	rm -f "$OGG"
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


print_msg "1 - Optimize textures (manual quality)"
print_msg "2 - Optimize sounds (manual quality)"
print_msg "3 - Automatically optimize both textures and sounds (recommended)"
print_msg "4 - Server side optimization"
print_msg "X - Exit the program"

read MAIN_CHOICE
if [ $MAIN_CHOICE -eq 1 ] #Manual textures optimization
then
	clear
	print_msg "1 - High - Most of the size advantage with minimal quality loss (recommended)"
	print_msg "2 - Medium - Extra size loss but the quality degradation tends to be way more visible "
	print_msg "3 - Low - Only choose this if you're desperate, since the color palette will be overdegraded, it's less enjoyable to look at in game"
	print_msg "X - Exit the program"
	
	read PNG_QUALITY
	
	if [ $PNG_QUALITY -eq 1 ]
	then
		clear
		for File in "$(find . -name '*.jar' -o -name '*.zip')"
		do
			Prepare_package "$File"
			Optimize_textures 256
			Repackage_mod
		done
		
	elif [ $PNG_QUALITY -eq 2 ]
	then
		clear
		for File in "$(find . -name '*.jar' -o -name '*.zip')"
		do
			Prepare_package "$File"
			Optimize_textures 128
			Repackage_mod
		done
	
	elif [ $PNG_QUALITY -eq 3 ]
	then
		clear
		for File in "$(find . -name '*.jar' -o -name '*.zip')"
		do
			Prepare_package "$File"
			Optimize_textures 64
			Repackage_mod
		done
	
	else
		print_msg "Okay, I'll exit then"
		exit 0
	fi

elif [ $MAIN_CHOICE -eq 2 ] #Manual sounds optimization
then
	clear
	print_msg "1 - High - Light file size reduction with minimal quality loss (recommended)"
	print_msg "2 - Medium - Extra size loss, however the best ears may be able to see a difference "
	print_msg "3 - Low - Best size loss, may be uncomfortable to hear on long term."
	print_msg "4 - Cancel the sounds optimization and go back to the main menu"
	
	read OGG_QUALITY
	
	if [ $OGG_QUALITY -eq 1 ]
	then
		clear
		for File in "$(find . -name '*.jar' -o -name '*.zip')"
		do
			Prepare_package "$File"
			Optimize_sounds 36000 120
			Repackage_mod 
		done
		
	elif [ $OGG_QUALITY -eq 2 ]
	then
		clear
		for File in "$(find . -name '*.jar' -o -name '*.zip')"
		do
			Prepare_package "$File"
			Optimize_textures 36000 100
			Repackage_mod
		done
	
	elif [ $OGG_QUALITY -eq 3 ]
	then
		clear
		for File in "$(find . -name '*.jar' -o -name '*.zip')"
		do
			Prepare_package "$File"
			Optimize_textures 36000 80
			Repackage_mod
		done
	
	else
		print_msg "Okay, I'll exit then"
		exit 0
	fi

elif [ $MAIN_CHOICE -eq 3 ] #Auto mod optimization
then
	clear
	for File in "$(find . -name '*.jar' -o -name '*.zip')"
	do
		Prepare_package "$File"
		Optimize_textures 256
		Optimize_audio 36000 80
		Repackage_mod
	done
	
elif [ $MAIN_CHOICE -eq 4 ] #Server style optimization
then
	clear
	for File in "$(find . -name '*.jar' -o -name '*.zip')"
	do
		Prepare_package "$File"
		Remove_assets
		Repackage_mod
	done

else
	print_msg "Okay I'll exit then"
	exit 0

fi
echo "I'm done !"