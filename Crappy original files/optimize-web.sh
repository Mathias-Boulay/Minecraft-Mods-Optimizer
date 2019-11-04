#!/bin/bash
#Cette version est un optimiseur automatique prévu dans le cadre d'un site web.
#Le service de traduction sera donc absent et des éléments spécifiques seront ajoutés 
#comme la création d'un arbre de fichier en fonction de l'optimisation choisie et les paramètres
#Please note this script is far from done since it may have it's own personnal directory per received file.

#La manière de définir les variables est aussi transformé en paramètres.

#Correction du nom du mod (penser à ajouter une même correction pour le fichier de paramètres ?)
cd Mods
rename "s/ //g" *
cd ..

#On récupère le type d'optimisation voulue:
opttype=$1
#Coeur de l'optimiseur mais sans la traduction.
if [ $opttype -eq 0 ]
then
	#PNG par PNGQUANT ! (Maybe a better optimizer in the future ?)
	PngLevel=$2
	#Need to define the variable PngLevel
	if [ $PngLevel -eq 0 ]
	then
		PngLevel=256;
	elif [ $PngLevel -eq 1 ]
	then
		PngLevel=128;
	elif [ $PngLevel -eq 2 ]
	then
		PngLevel=64;
	elif [ $PngLevel -eq 3 ]
	then
		PngLevel=32;
	fi
	#On récupère l'option de sécurité.
	PngQuality=$3
	cd Mods
	for line in $(find . -name '*.jar'); do
		mv $line ./../Uncompressed/$line
		cd ..
		cd Uncompressed
		#On décompresse et supprime le jar.
		unzip -qq "*.jar"
		rm -f $line
		#On lance pngquant avec des optimisations en fonction des arguments
		if [ $PngQuality -eq 0 ]
		then
			#Pas de protection,vivons sans contraception.
			find . -name '*.png' -exec pngquant --ext .png -f --speed 1 --quiet $PngLevel {} \;
		else
			#Mieux vaut prevenir que guérir.
			find . -name '*.png' -exec pngquant --ext .png -f --speed 1 --quiet -Q 75-100 $PngLevel {} \;
		fi
		#Maintenant faut reziper le mod et l'envoyer dans un dossier voisin:
		zip -r -9 --quiet $line * 
		mv $line ../Final/`basename $line`
		rm -R *
		#Reset ma position
		cd ../Mods
	done #Yes we have a textures optimized mod !
	
elif [ $opttype -eq 1 ]
then
	#OGG with ffmpeg !
	OggLevel=$2
	#On set les arguments
	if [ $OggLevel -eq 0 ]
	then
		OggLevel=128k
	elif [ $OggLevel -eq 1 ]
	then
		OggLevel=96k
	elif [ $OggLevel -eq 2 ]
	then
		OggLevel=80k
	else
		#Falling back on lite optimization
		OggLevel=128k
	fi
	cd Mods
	for line in $(find . -name '*.jar'); do
		echo $line
		mv $line ./../Uncompressed/$line
		cd ..
		cd Uncompressed
		#On décompresse et supprime le jar.
		unzip -qq "*.jar"
		rm -f $line
		#On lance ffmpeg avec des optimisations en fonction des arguments...
		for audio in $(find . -name '*.ogg'); do
			ffmpeg -i $audio -v 0 -y -ar 36000 -b:a $OggLevel -f ogg "${audio%.*}.ogg"
		done
		#Maintenant faut reziper le mod et l'envoyer dans un dossier voisin:
		zip -r -9 --quiet $line * 
		mv $line ../Final/`basename $line`
		rm -R *
		#Reset ma position
		cd ../Mods
		
	done #Yes we have a audio optimized mod !

elif [ $opttype -eq 2 ]
then
	#Double optimisation !
	#PNG:
	PngLevel=$2
	#Need to define the variable PngLevel
	if [ $PngLevel -eq 0 ]
	then
		PngLevel=256;
	elif [ $PngLevel -eq 1 ]
	then
		PngLevel=128;
	elif [ $PngLevel -eq 2 ]
	then
		PngLevel=64;
	elif [ $PngLevel -eq 3 ]
	then
		PngLevel=32;
	fi
	#On vérifie la valeur d'optimisation
	PngQuality=$3
	#OGG with ffmpeg !
	OggLevel=$4
	#On set les arguments
	if [ $OggLevel -eq 0 ]
	then
		OggLevel=128k
	elif [ $OggLevel -eq 1 ]
	then
		OggLevel=96k
	elif [ $OggLevel -eq 2 ]
	then
		OggLevel=80k
	else
		#Fallback sur l'optimisation légère
		OggLevel=128k
	fi
	cd Mods
	#General part:
	for line in $(find . -name '*.jar'); do
		mv $line ./../Uncompressed/$line
		cd ..
		cd Uncompressed
		#On décompresse et supprime le jar.
		unzip -qq "*.jar"
		rm -f $line
		#Png opti part:
		if [ $PngQuality -eq 0 ]
		then
			#Pas de protection,vivons sans contraception.
			find . -name '*.png' -exec pngquant --ext .png -f --speed 1 --quiet $PngLevel {} \;
		else
			#Mieux vaut prevenir que guérir.
			find . -name '*.png' -exec pngquant --ext .png -f --speed 1 --quiet -Q 75-100 $PngLevel {} \;
		fi
		#FFMPEG part:
		for audio in $(find . -name '*.ogg'); do
			ffmpeg -i $audio -v 0 -y -ar 36000 -b:a $OggLevel -f ogg "${audio%.*}.ogg"
		done
		#Maintenant faut reziper le mod et l'envoyer dans un dossier voisin:
		zip -r -9 --quiet $line * 
		mv $line ../Final/`basename $line`
		rm -R *
		#Reset ma position
		cd ../Mods
	done # Yes we have now a fully optimized mod !

elif [ $opttype -eq 3 ]
then
	#Server side optimisation
	cd Mods
	#Take one file and move it
	for line in $(find . -name '*.jar'); do
		mv $line ./../Uncompressed/$line
		cd ..
		cd Uncompressed
		#On décompresse et supprime le jar.
		unzip -qq "*.jar"
		rm -f $line
		#Remove every png
		rm -f -R assets/*/textures 
		for png in $(find . -name '*.png'); do
			rm -f $png
		done
		#Remove every ogg
		rm -f -R assets/*/sounds
		for ogg in $(find . -name '*.ogg'); do
			rm -f $ogg
		done
		#Maintenant faut reziper le mod et l'envoyer dans un dossier voisin:
		zip -r -9 --quiet $line * 
		mv $line ../Final/`basename $line`
		rm -R *
		#Reset ma position
		cd ../Mods
	done # Yes we have now a fully optimized mod !
fi




