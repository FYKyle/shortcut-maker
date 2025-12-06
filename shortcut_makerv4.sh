#!/bin/bash
######################
### SHORTCUT MAKER ###
######################
# creates shortcuts :P
# that aren't aliases
#--- set up ---
snes9x_appimg_loc="$HOME/games-on-yo-phone/SNES/"
gameshortcut_dir="$HOME/games-on-yo-phone/__gameshortcuts__/"
image_dir="$HOME/games-on-yo-phone/__shortcut-images__/"
proton_dir="$HOME/games-on-yo-phone/__PROTON__/"
wineprefix_dir="$HOME/.local/share/wineprefixes/"
printf -v currentdir "%q" "$PWD"
#--- Preperations --- 
echo -ne 'Game: '; read game
game=$game
gamenospace=${game// /}
game_lower=${gamenospace,,}
echo -ne 'Platform: '; read platform
#--- LINUX ---
if [ $platform == 'linux' ]; then 
	echo -ne "Executable ?> "; read executable
	printf -v executable "%q" "$executable"
	command="cd $currentdir && nohup ./$executable &> /dev/null"
fi
#--- SNES9x --- 
if [ $platform == 'snes' ]; then 
	echo -ne "Rom: "; read rom
	printf -v rom "%q" "$rom"
	command="cd $snes9x_appimg_loc && ./Snes9x-1.63-x86_64.AppImage $rom" 
fi
#--- RPG MAKER --- 
if [ $platform == 'rpgmaker' ]; then 
	command="cd $currentdir && nohup rpgmaker-linux &> /dev/null"
fi
#--- MAME --- 
if [ $platform == 'mame' ]; then 
	echo -ne "Bios: "; read bios
	echo -ne "Game Zip: "; read gamezip
	command="nohup mame -bios $bios ${gamezip}.zip &> /dev/null"
fi
#--- STEAM ---
if [ $platform == 'steam' ]; then 
	echo -ne "Steam ID: "; read steamid
	command="nohup steam -silent steam://rungameid/${steamid} &> /dev/null & disown"
fi
#--- WINE & PROTON --- 
if [ $platform == 'wine' ]; then 
	ls $wineprefix_dir
	echo -ne "Prefix: "; read prefix
	echo -ne "Executable ?> "; read executable
	printf -v executable "%q" "$executable"
	#--- PROTON ---
	echo -ne "Proton? Y/n> "; read proton_choice
	if [ $proton_choice == 'y' ]; then
		ls $proton_dir
		echo -ne "Proton: "; read proton_version
		printf -v proton_version "%q" "$proton_version"
		command="WINEPREFIX=$wineprefix_dir$prefix PROTONPATH=$proton_dir$proton_version umu-run $currentdir/$executable &> /dev/null & disown"
	fi
	#--- WINE ---
	if [ $proton_choice == 'n' ]; then
		command="WINEPREFIX=$wineprefix_dir$prefix wine $currentdir/$executable &> /dev/null & disown"
	fi
fi
#--- IMAGE THUMBNAIL ---
declare -A img_array
echo -ne 'Image Thumbnail Y/n> '; read imageconfirm
directory_count=1
if [ ${imageconfirm,,} == 'y' ]; then
	for img_file in "$image_dir"*; do 
		img_array[$directory_count]=$img_file
		echo "[$directory_count] ${img_file//$image_dir/}"
		((++directory_count))
	done
	echo -ne "#> "; read image_choice
	thumbnail_code="catimg -H 23 ${img_array[$image_choice]}"
elif [ ${imageconfirm,,} == 'n' ]; then
	thumbnail_code=""
fi
#--- WRITING FILE ---
shortcut=$gameshortcut_dir$game_lower
cat > $shortcut << EOF
$thumbnail_code
echo -e "[\e[32mPLAYING\e[0m] ${game^^}"
$command
EOF
#---
chmod +x $shortcut
