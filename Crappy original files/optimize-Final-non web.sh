#!/bin/bash
cd Mods
rename "s/ //g" *
cd ..

echo -e "\033[33m#####################################\033[0m"
echo -e "\033[33m#    _           ___  ___   _____   #\033[0m"
echo -e "\033[33m#   | |         /   |/   | |_   _|  #\033[0m"
echo -e "\033[33m#   | |        / /|   /| |   | |    #\033[0m"
echo -e "\033[33m#   | |       / / |__/ | |   | |    #\033[0m"
echo -e "\033[33m#   | |___   / /       | |   | |    #\033[0m"
echo -e "\033[33m#   |_____| /_/        |_|   |_|    #\033[0m"
echo -e "\033[33m#                                   #\033[0m"
echo -e "\033[33m#####################################\033[0m"
#Point départ du code:
echo -e ""
echo -e "\033[33m###########################################\033[0m"
echo -e "\033[33m#                                         #\033[0m"
echo -e "\033[33m# What type of optimization do you want ? #\033[0m"
echo -e "\033[33m# 0- Textures optimization                #\033[0m"
echo -e "\033[33m# 1- Audio optimization                   #\033[0m"
echo -e "\033[33m# 2- Auto-translation                     #\033[0m"
echo -e "\033[33m# 3- Textures AND audio optimization      #\033[0m"
echo -e "\033[33m# 4- Server side optimization             #\033[0m"
echo -e "\033[33m#                                         #\033[0m"
echo -e "\033[33m###########################################\033[0m"
#On récupère le type d'optimisation voulue
read opttype

if [ $opttype -eq 0 ]
then
	#PNG
	echo -e "\033[33m_________________________________________________________________________________\033[0m" 
	echo -e ""
	echo -e "\033[33m#################################################################################\033[0m"
	echo -e "\033[33m#                                                                               #\033[0m"
	echo -e "\033[33m# Which level of textures optimization ?                                        #\033[0m"
	echo -e "\033[33m# 0- Minimal: No visible texture loss, less optimization.                       #\033[0m"
	echo -e "\033[33m# 1- Medium: Some texture loss may rarely appear, good optimization.            #\033[0m"
	echo -e "\033[33m# 2- Heavy: Certains textures may look degraded, but really good optimization.  #\033[0m"
	echo -e "\033[33m# 3- Maximal: A lot of textures can get broken, should be use only with texture #\033[0m"
	echo -e "\033[33m# quality verification enabled. Best optimization.                              #\033[0m"
	echo -e "\033[33m# Any other value will be used as a custom value... use it safely.              #\033[0m"
	echo -e "\033[33m# You can enable texture quality verification just after.                       #\033[0m"
	echo -e "\033[33m#                                                                               #\033[0m"
	echo -e "\033[33m#################################################################################\033[0m"
	read PngLevel
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
	#echo -e $PngLevel
	echo -e "\033[33m_________________________________________________________\033[0m"
	echo -e ""
	echo -e "\033[33m#########################################################\033[0m"
	echo -e "\033[33m#                                                       #\033[0m"
	echo -e "\033[33m# Do you want to enable texture quality verification ?  #\033[0m"
	echo -e "\033[33m# It helps to avoid broken textures during optimization #\033[0m"
	echo -e "\033[33m# 0- No.                                                #\033[0m"
	echo -e "\033[33m# 1- Yes.                                               #\033[0m"
	echo -e "\033[33m#                                                       #\033[0m"
	echo -e "\033[33m#########################################################\033[0m"
	read PngQuality
	echo -e ""
	echo -e "\033[33mProcessing optimization of all mods...\033[0m"
	cd Mods
	for line in $(find . -name '*.jar'); do
		echo -e "\033[33mFound \033[34m`basename $line`\033[0m"
		echo -e "\033[33mMoving \033[34m`basename $line` \033[33minto temp directory\033[0m"
		mv $line ./../Uncompressed/$line
		cd ..
		cd Uncompressed
		#On décompresse et supprime le jar.
		echo -e "\033[33mUnzipping \033[34m`basename $line`\033[0m"
		unzip -qq "*.jar"
		rm -f $line
		chmod -R 777 *
		rename "s/ //g" *
		rename "s/ //g" */*
		rename "s/ //g" */*/*
		rename "s/ //g" */*/*/*
		rename "s/ //g" */*/*/*/*
		rename "s/ //g" */*/*/*/*/*
		rename "s/ //g" */*/*/*/*/*/*
		rename "s/ //g" */*/*/*/*/*/*/*
		rename "s/ //g" */*/*/*/*/*/*/*/*
		rename "s/ //g" */*/*/*/*/*/*/*/*/*
		rename "s/ //g" */*/*/*/*/*/*/*/*/*/*
		rename "s/ //g" */*/*/*/*/*/*/*/*/*/*/*
		#On lance pngquant avec des optimisations en fonction des arguments
		echo -e "\033[33mOptimizing all textures files...\033[0m"
		if [ $PngQuality -eq 0 ]
		then
			#Pas de protection,vivons sans contraception.
			for png in  $(find . -name '*.png'); do
				echo -e "\033[33mOptimizing \033[34m`basename $png`\033[0m"
				pngquant --ext .png -f --speed 1 --quiet $PngLevel $png
			done
		else
			#Mieux vaut prevenir que guérir.
			for png in  $(find . -name '*.png'); do
				echo -e "\033[33mOptimizing \033[34m`basename '$png'`\033[0m"
				pngquant --ext .png -f --speed 1 --quiet -Q 75-100 $PngLevel '$png'
			done
		fi
		#Maintenant faut reziper le mod et l'envoyer dans un dossier voisin:
		echo -e "\033[33mRezipping \033[34m`basename $line`\033[0m"
		zip -r -9 --quiet $line * 
		echo -e "\033[33mMoving \033[34m`basename $line` \033[33minto its final directory\033[0m"
		mv $line ../Final/`basename $line`
		echo -e "\033[33mRemoving junk files\033[0m"
		rm -R *
		#Reset ma position
		cd ../Mods
	done #Yes we have a textures optimized mod !
	
elif [ $opttype -eq 1 ]
then
	#OGG with ffmpeg !
	echo -e "\033[33m______________________________________________________________________________\033[0m"
	echo -e ""
	echo -e "\033[33m##############################################################################\033[0m"
	echo -e "\033[33m#                                                                            #\033[0m"
	echo -e "\033[33m# Which level of audio optimization ?                                        #\033[0m"
	echo -e "\033[33m# 0- Lite: No audio compression problem, lowest optimization                 #\033[0m"
	echo -e "\033[33m# 1- Medium: Some audio compresion problem might appear, medium optimization #\033[0m"
	echo -e "\033[33m# 2- Heavy: Audio may be degraded too much, best optimisation                #\033[0m"
	echo -e "\033[33m#                                                                            #\033[0m"
	echo -e "\033[33m##############################################################################\033[0m"
	read OggLevel
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
			echo -e "\033[31mWrong value !\033[0m"
			echo -e "\033[31mFalling back on Lite optimization !\033[0m"
			OggLevel=128k
		fi
	cd Mods
	echo -e "_____________________________________"
	echo -e "\033[33mProcessing optimization of all mods...\033[0m"
	for line in $(find . -name '*.jar'); do
		echo -e $line
		mv $line ./../Uncompressed/$line
		cd ..
		cd Uncompressed
		#On décompresse et supprime le jar.
		unzip -qq "*.jar"
		rm -f $line
		chmod -R 777 *
		rename "s/ //g" *
		rename "s/ //g" */*
		rename "s/ //g" */*/*
		rename "s/ //g" */*/*/*
		rename "s/ //g" */*/*/*/*
		rename "s/ //g" */*/*/*/*/*
		rename "s/ //g" */*/*/*/*/*/*
		rename "s/ //g" */*/*/*/*/*/*/*
		rename "s/ //g" */*/*/*/*/*/*/*/*
		rename "s/ //g" */*/*/*/*/*/*/*/*/*
		rename "s/ //g" */*/*/*/*/*/*/*/*/*/*
		rename "s/ //g" */*/*/*/*/*/*/*/*/*/*/*
		#On lance ffmpeg avec des optimisations en fonction des arguments...
		for audio in $(find . -name '*.ogg'); do
			echo -e "\033[33mOptimizing \033[34m`basename $audio`\033[0m"
			ffmpeg -i $audio -v 0 -y -ar 36000 -b:a $OggLevel -f ogg "${audio%.*}.ogg"
		done
		#Maintenant faut reziper le mod et l'envoyer dans un dossier voisin:
		echo -e "\033[33mRezipping \033[34m`basename $line`\033[0m"
		zip -r -9 --quiet $line * 
		echo -e "\033[33mMoving \033[34m`basename $line` \033[33minto its final directory\033[0m"
		mv $line ../Final/`basename $line`
		echo -e "\033[33mRemoving junk files"
		rm -R *
		#Reset ma position
		cd ../Mods
		
	done #Yes we have a audio optimized mod !
		
elif [ $opttype -eq 2 ]
then
	#Translate with google !
	echo -e "\033[33m____________________________________________________________\033[0m"
	echo -e ""
	echo -e "\033[33m############################################################\033[0m"
	echo -e "\033[33m#                                                          #\033[0m"
	echo -e "\033[33m# All translations are made from english.                  #\033[0m"
	echo -e "\033[33m# In which language do you want the mod to be translated ? #\033[0m"
	echo -e "\033[33m# 0- French                                                #\033[0m" #fr
	echo -e "\033[33m# 1- Russian                                               #\033[0m" #ru
	echo -e "\033[33m# 2- Japanese                                              #\033[0m" #ja
	echo -e "\033[33m# 3- Simplified Chinese                                    #\033[0m" #zh-CN
	echo -e "\033[33m# 4- Spanish                                               #\033[0m" #es
	echo -e "\033[33m# 5- German                                                #\033[0m" #de
	echo -e "\033[33m# Any other value will be ignored                          #\033[0m"
	echo -e "\033[33m#                                                          #\033[0m"
	echo -e "\033[33m############################################################\033[0m"
	read LanguageLevel
	#Mettre les bon code pour le langage:
	if [ $LanguageLevel -eq 0 ]
	then
		#Français
		LanguageLevel=fr
		LanguageFileCode=fr_FR.lang
	elif [ $LanguageLevel -eq 1 ]
	then
		#Russe
		LanguageLevel=ru
		LanguageFileCode=ru_RU.lang
	elif [ $LanguageLevel -eq 2 ]
	then
		#Japonais
		LanguageLevel=ja
		LanguageFileCode=ja_JP.lang
	elif [ $LanguageLevel -eq 3 ]
	then
		#Chinois (simplifié)
		LanguageLevel=zh-CN
		LanguageFileCode=zh_CN.lang
	elif [ $LanguageLevel -eq 4 ]
	then
		#Espagnol
		LanguageLevel=es
		LanguageFileCode=es_ES.lang
	elif [ $LanguageLevel -eq 5 ]
	then
		#Allemand
		LanguageLevel=de
		LanguageFileCode=de_DE.lang
	elif [ $LanguageLevel -eq 6 ]
	then
		#Italien
		LanguageLevel=it
		LanguageFileCode=it_IT.lang
	else
		echo -e "\033[31mWrong value ! Falling back on French !\033[0m"
		LanguageLevel=fr
		LanguageFileCode=fr_FR.lang
	fi
	echo -e "\033[33m______________________________________________________________________\033[0m"
	echo -e ""
	echo -e "\033[33m######################################################################\033[0m"
	echo -e "\033[33m#                                                                    #\033[0m"
	echo -e "\033[33m# In case a language file already exists, translate the mod anyway ? #\033[0m"
	echo -e "\033[33m# 0- No.                                                             #\033[0m"
	echo -e "\033[33m# 1- Yes.                                                            #\033[0m"
	echo -e "\033[33m# Any other value will fall back on NO.                              #\033[0m"
	echo -e "\033[33m#                                                                    #\033[0m"
	echo -e "\033[33m######################################################################\033[0m"
	read CheckFile
	#Go prendre les jar
	echo -e "\033[33m______________________________________\033[0m"
	echo -e "\033[33mProcessing optimization of all mods...\033[0m"
	cd Mods
	for line in $(find . -name '*.jar'); do
		echo -e "\033[33mFound \033[34m`basename $line`\033[0m"
		echo -e "\033[33mMoving \033[34m`basename $line` \033[33minto temp directory\033[0m"
		mv $line ./../Uncompressed/$line
		cd ..
		cd Uncompressed
		#On décompresse et supprime le jar.
		echo -e "\033[33mUnzipping \033[34m`basename $line`\033[0m"
		unzip -qq "*.jar"
		rm -f $line
		chmod -R 777 *
		rename "s/ //g" *
		rename "s/ //g" */*
		rename "s/ //g" */*/*
		rename "s/ //g" */*/*/*
		rename "s/ //g" */*/*/*/*
		rename "s/ //g" */*/*/*/*/*
		rename "s/ //g" */*/*/*/*/*/*
		rename "s/ //g" */*/*/*/*/*/*/*
		rename "s/ //g" */*/*/*/*/*/*/*/*
		rename "s/ //g" */*/*/*/*/*/*/*/*/*
		rename "s/ //g" */*/*/*/*/*/*/*/*/*/*
		rename "s/ //g" */*/*/*/*/*/*/*/*/*/*/*
		#Définition de quelques variables
		USFile=`find . -name 'en_US.lang'`
		echo -e $USFile
		LanguageDirectory=`dirname $USFile`
		TranslatedFile=$LanguageDirectory'/'"$LanguageFileCode"
		echo -e $TranslatedFile
		if [ $CheckFile -eq 1 ]
		then
			if [ -e "$TranslatedFile" ]
			then
				#Heu... Do nothing !
				echo -e "\033[31mA lang file already exists. Ignoring \033[34m`basename $line`\033[0m"
			else
				#Translate the mod since no lang file has been found.
				#Et maintenant faut que l'on trouve nos fichiers.
				while read ligne
				do
					ValToTranslate=`cut -d '=' -f2 <<< $ligne`
					Key=`cut -d '=' -f1 <<< $ligne`
					#Construction de fichiers temporaires
					echo -e $ValToTranslate >> ToTranslate.txt
					echo -e "Found $ValToTranslate"
					echo -e $Key >> KeyFile.txt
					#Ajoute les = sur les lignes non-vides
					if [ -n "$Key" ]
					then
						echo -e -n "=" >> KeyFile.txt
					fi
				done < $(find . -name 'en_US.lang');
				echo -e "\033[33mSending the file to translate, the process may take several minutes...\033[0m"
				../trans -b -e bing -no-autocorrect -o ./Translated.txt -s en -t $LanguageLevel -i ./ToTranslate.txt
				#On reconstruit un fichier de langue traduit cette fois ci.
				paste -d '' './KeyFile.txt' './Translated.txt' > 'FinalLanguageFile.lang'
				#Le fichier reconstruit, on corrige quelques fautes systémattiques lors des traitements précédents puis on le déplace.
				echo -e "\033[33m# Correcting step"
				echo -e "\033[33m# Phase 1: Colored names step\033[0m"
				sed -i -e 's/§ /§/g' './FinalLanguageFile.lang'
				sed -i -e 's/ §/§/g' './FinalLanguageFile.lang'
				echo -e "\033[33m# Phase 2: Aliases\033[0m"
				sed -i -e 's/%/ %/g' './FinalLanguageFile.lang'
				sed -i -e 's/% /%/g' './FinalLanguageFile.lang'
				
				mv ./FinalLanguageFile.lang $TranslatedFile
				#On supprime les fichier temporaires et on rezipe !
				rm -f KeyFile.txt
				rm -f ToTranslated.txt
				rm -f Translated.txt
			fi
		else
			#Traduit le mod sans prendre compte des fichiers existants
			rm -f $TranslatedFile
			#Et maintenant faut que l'on trouve nos fichiers.
			while read ligne
			do
				ValToTranslate=`cut -d '=' -f2 <<< $ligne`
				Key=`cut -d '=' -f1 <<< $ligne`
				#Construction de fichiers temporaires
				echo -e $ValToTranslate >> ToTranslate.txt
				echo -e "\033[33mFound \033[34m$ValToTranslate\033[0m"
				echo -e $Key >> KeyFile.txt
				#Ajoute les = sur les lignes non-vides
				if [ -n "$Key" ]
				then
					echo -e -n "=" >> KeyFile.txt
				fi
			done < $(find . -name 'en_US.lang');
			echo -e "\033[33mSending the file to translate, the process may take several minutes...\033[0m"
			../trans -b -e bing -no-autocorrect -o ./Translated.txt -s en -t $LanguageLevel -i ./ToTranslate.txt
			#On reconstruit un fichier de langue traduit cette fois ci.
			paste -d '' './KeyFile.txt' './Translated.txt' > 'FinalLanguageFile.lang'
			#Le fichier reconstruit, on corrige quelques fautes systémattiques lors des traitements précédents puis on le déplace.
			echo -e "\033[33m# Correcting step\033[0m"
			echo -e "\033[33m# Phase 1: Colored names step\033[00m"
			sed -i -e 's/§ /§/g' './FinalLanguageFile.lang'
			sed -i -e 's/ §/§/g' './FinalLanguageFile.lang'
			echo -e "\033[33m# Phase 2: Aliases\033[0m"
			sed -i -e 's/%/ %/g' './FinalLanguageFile.lang'
			sed -i -e 's/% /%/g' './FinalLanguageFile.lang'
			
			mv ./FinalLanguageFile.lang $TranslatedFile
			#On supprime les fichier temporaires et on rezipe !
			rm -f KeyFile.txt
			rm -f ToTranslated.txt
			rm -f Translated.txt
		fi
			
		#Maintenant faut reziper le mod et l'envoyer dans un dossier voisin:
		echo -e "\033[33mRezipping \033[34m`basename $line`\033[0m"
		zip -r -9 --quiet $line * 
		echo -e "\033[33mMoving \033[34m`basename $line` \033[33minto its final directory\033[0m"
		mv $line ../Final/`basename $line`
		echo -e "\033[33mRemoving junk files\033[0m"
		rm -R *
		#Reset ma position
		cd ../Mods
	done # Oui, nous avons obtenu un mod traduit !

elif [ $opttype -eq 3 ]
then
	#Double optimisation !
	#PNG:
	echo -e "\033[33m_________________________________________________________________________________\033[0m" #Something's wrong here... 
	echo -e ""
	echo -e "\033[33m#################################################################################\033[0m"
	echo -e "\033[33m#                                                                               #\033[0m"
	echo -e "\033[33m# Which level of textures optimization ?                                        #\033[0m"
	echo -e "\033[33m# 0- Minimal: No visible texture loss, less optimization.                       #\033[0m"
	echo -e "\033[33m# 1- Medium: Some texture loss may rarely appear, good optimization.            #\033[0m"
	echo -e "\033[33m# 2- Heavy: Certains textures may look degraded, but really good optimization.  #\033[0m"
	echo -e "\033[33m# 3- Maximal: A lot of textures can get broken, should be use only with texture #\033[0m"
	echo -e "\033[33m# quality verification enabled. Best optimization.                              #\033[0m"
	echo -e "\033[33m# Any other value will be used as a custom value... use it safely.              #\033[0m"
	echo -e "\033[33m# You can enable texture quality verification just after.                       #\033[0m"
	echo -e "\033[33m#                                                                               #\033[0m"
	echo -e "\033[33m#################################################################################\033[0m"
	read PngLevel
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
	#echo -e $PngLevel
	echo -e "\033[33m_________________________________________________________\033[0m"
	echo -e ""
	echo -e "\033[33m#########################################################\033[0m"
	echo -e "\033[33m#                                                       #\033[0m"
	echo -e "\033[33m# Do you want to enable texture quality verification ?  #\033[0m"
	echo -e "\033[33m# It helps to avoid broken textures during optimization #\033[0m"
	echo -e "\033[33m# 0- No.                                                #\033[0m"
	echo -e "\033[33m# 1- Yes.                                               #\033[0m"
	echo -e "\033[33m#                                                       #\033[0m"
	echo -e "\033[33m#########################################################\033[0m"
	read PngQuality
	
	#OGG with ffmpeg !
	echo -e "\033[33m______________________________________________________________________________\033[0m"
	echo -e ""
	echo -e "\033[33m##############################################################################\033[0m"
	echo -e "\033[33m#                                                                            #\033[0m"
	echo -e "\033[33m# Which level of audio optimization ?                                        #\033[0m"
	echo -e "\033[33m# 0- Lite: No audio compression problem, lowest optimization                 #\033[0m"
	echo -e "\033[33m# 1- Medium: Some audio compresion problem might appear, medium optimization #\033[0m"
	echo -e "\033[33m# 2- Heavy: Audio may be degraded too much, best optimisation                #\033[0m"
	echo -e "\033[33m#                                                                            #\033[0m"
	echo -e "\033[33m##############################################################################\033[0m"
	read OggLevel
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
			echo -e "\033[31mWrong value !\033[0m"
			echo -e "\033[31mFalling back on Lite optimization !\033[0m"
			OggLevel=128k
		fi
	cd Mods
	echo -e "_____________________________________"
	echo -e "\033[33mProcessing optimization of all mods...\033[0m"
	
	#General part:
	for line in $(find . -name '*.jar'); do
		echo -e "\033[33mFound \033[34m`basename $line`\033[0m"
		echo -e "\033[33mMoving \033[34m`basename $line` \033[33minto temp directory\033[0m"
		mv $line ./../Uncompressed/$line
		cd ..
		cd Uncompressed
		#On décompresse et supprime le jar.
		echo -e "\033[33mUnzipping \033[34m`basename $line`\033[0m"
		unzip -qq "*.jar"
		rm -f $line
		chmod -R 777 *
		rename "s/ //g" *
		rename "s/ //g" */*
		rename "s/ //g" */*/*
		rename "s/ //g" */*/*/*
		rename "s/ //g" */*/*/*/*
		rename "s/ //g" */*/*/*/*/*
		rename "s/ //g" */*/*/*/*/*/*
		rename "s/ //g" */*/*/*/*/*/*/*
		rename "s/ //g" */*/*/*/*/*/*/*/*
		rename "s/ //g" */*/*/*/*/*/*/*/*/*
		rename "s/ //g" */*/*/*/*/*/*/*/*/*/*
		rename "s/ //g" */*/*/*/*/*/*/*/*/*/*/*
		echo -e "\033[33mOptimizing textures...\033[0m"
		#Png opti part:
		if [ $PngQuality -eq 0 ]
		then
			#Pas de protection,vivons sans contraception.
			for png in  $(find . -name '*.png'); do
				echo -e "\033[33mOptimizing \033[34m`basename $png`\033[0m"
				pngquant --ext .png -f --speed 1 --quiet $PngLevel $png
			done
		else
			#Mieux vaut prevenir que guérir.
			for png in  $(find . -name '*.png'); do
				echo -e "\033[33mOptimizing \033[34m`basename $png`\033[0m"
				pngquant --ext .png -f --speed 1 --quiet -Q 75-100 $PngLevel $png
			done
		fi
		
		#FFMPEG part:
		echo -e "\033[33mOptimizing sounds...\033[33m"
		for audio in $(find . -name '*.ogg'); do
			echo -e "\033[33mOptimizing \033[34m`basename $audio`\033[0m"
			ffmpeg -i $audio -v 0 -y -ar 36000 -b:a $OggLevel -f ogg "${audio%.*}.ogg"
		done
		#Maintenant faut reziper le mod et l'envoyer dans un dossier voisin:
		echo -e "\033[33mRezipping \033[34m`basename $line`\033[33m"
		zip -r -9 --quiet $line * 
		echo -e "\033[33mMoving \033[34m`basename $line` \033[33minto its final directory\033[0m"
		mv $line ../Final/`basename $line`
		echo -e "\033[33mRemoving junk files\033[0m"
		rm -R *
		#Reset ma position
		cd ../Mods
	done # Yes we have now a fully optimized mod !

elif [ $opttype -eq 4 ]
then
	#Server side optimisation
	echo -e "\033[33m_________________________________________________________________________________________________________________\033[0m"
	echo -e ""
	echo -e "\033[33m#################################################################################################################\033[0m"
	echo -e "\033[33m#                                                                                                               #\033[0m"
	echo -e "\033[33m# Server side optimization allows to launch a server faster by removing useless files like textures and sounds. #\033[0m"
	echo -e "\033[33m# This way the modpack take less space and less time to decompress                                              #\033[0m"
	echo -e "\033[33m# Please note it's useless to put client-side mod here.                                                         #\033[0m"
	echo -e "\033[33m#                                                                                                               #\033[0m"
	echo -e "\033[33m#################################################################################################################\033[0m"
	
	sleep 10
	cd Mods
	#Take one file and move it
	for line in $(find . -name '*.jar'); do
		echo -e "\033[33mFound \033[34m`basename $line`\033[0m"
		echo -e "\033[33mMoving \033[34m`basename $line` \033[33minto temp directory\033[0m"
		mv $line ./../Uncompressed/$line
		cd ..
		cd Uncompressed
		#On décompresse et supprime le jar.
		echo -e "\033[33mUnzipping \033[34m`basename $line`\033[0m"
		unzip -qq "*.jar"
		rm -f $line
		chmod -R 777 *
		rename "s/ //g" *
		rename "s/ //g" */*
		rename "s/ //g" */*/*
		rename "s/ //g" */*/*/*
		rename "s/ //g" */*/*/*/*
		rename "s/ //g" */*/*/*/*/*
		rename "s/ //g" */*/*/*/*/*/*
		rename "s/ //g" */*/*/*/*/*/*/*
		rename "s/ //g" */*/*/*/*/*/*/*/*
		rename "s/ //g" */*/*/*/*/*/*/*/*/*
		rename "s/ //g" */*/*/*/*/*/*/*/*/*/*
		rename "s/ //g" */*/*/*/*/*/*/*/*/*/*/*
		#Remove every png
		echo -e "\033[33mRemoving textures folder\033[0m"
		rm -f -R assets/*/textures
		echo -e "\033[33mRemoving textures out of textures folder\033[0m" 
		for png in $(find . -name '*.png'); do
			echo -e "\033[33mRemoving \033[34m`basename $png`\033[0m";
			rm -f $png
		done
		#Remove every ogg
		echo -e "\033[33mRemoving sounds folder\033[0m"
		rm -f -R assets/*/sounds
		echo -e "\033[33mRemoving sounds out of sounds folder\033[0m"
		for ogg in $(find . -name '*.ogg'); do
			echo -e "\033[33mRemoving \033[34m`basename $ogg`\033[0m";
			rm -f $ogg
		done
		#Maintenant faut reziper le mod et l'envoyer dans un dossier voisin:
		echo -e "\033[33mRezipping \033[34m`basename $line`\033[0m"
		zip -r -9 --quiet $line * 
		echo -e "\033[33mMoving \033[34m`basename $line` \033[33minto its final directory\033[0m"
		mv $line ../Final/`basename $line`
		echo -e "\033[33mRemoving junk files\033[0m"
		rm -R *
		#Reset ma position
		cd ../Mods
	done # Yes we have now a fully optimized mod !
elif [ $opttype -eq 5 ]
then
	#Ressourcespack optimization
	echo -e "\033[33m__________________________________________________________________________________________\033[0m"
	echo -e "\033[33mRessourcespacks are only lightly optimized to avoïd any distortion of the original content\033[0m"
	sleep 6
	#Go on prend les fichiers !
	cd Packs
	for line in $(find . -name '*.zip'); do
		echo -e "\033[33mFound \033[34m`basename $line`\033[0m"
		echo -e "\033[33mMoving \033[34m`basename $line` \033[33minto temp directory\033[0m"
		mv $line ./../Uncompressed/$line
		cd ..
		cd Uncompressed
		#On décompresse et supprime le pack.
		echo -e "\033[33mUnzipping \033[34m`basename $line`\033[0m"
		unzip -qq "*.zip"
		rm -f $line
		chmod -R 777 *
		rename "s/ //g" *
		rename "s/ //g" */*
		rename "s/ //g" */*/*
		rename "s/ //g" */*/*/*
		rename "s/ //g" */*/*/*/*
		rename "s/ //g" */*/*/*/*/*
		rename "s/ //g" */*/*/*/*/*/*
		rename "s/ //g" */*/*/*/*/*/*/*
		rename "s/ //g" */*/*/*/*/*/*/*/*
		rename "s/ //g" */*/*/*/*/*/*/*/*/*
		rename "s/ //g" */*/*/*/*/*/*/*/*/*/*
		rename "s/ //g" */*/*/*/*/*/*/*/*/*/*/*
		#Optimize every png:
		for png in  $(find . -name '*.png'); do
			echo -e "\033[33mOptimizing \033[34m`basename $png`\033[0m"
			pngquant --ext .png -f --speed 1 --quiet $PngLevel $png
		done
		#Maintenant faut reziper le pack et l'envoyer dans un dossier voisin:
		echo -e "\033[33mRezipping \033[34m`basename $line`\033[0m"
		zip -r -9 --quiet $line * 
		echo -e "\033[33mMoving \033[34m`basename $line`\033[33minto its final directory\033[0m"
		mv $line ../Final/`basename $line`
		echo -e "\033[33mRemoving junk files\033[0m"
		rm -R *
		#Reset ma position
		cd ../Packs
	done #Optimized ressourcespacks !
		
		
fi
echo -e "\033[33mEverything is done, so I go away\033[0m"
read temp
