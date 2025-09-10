#!/bin/bash
######################
### SHORTCUT MAKER ###
######################
# creates shortcuts :P
# that aren't aliases
#--- set up ---
gameshortcut_dir="$HOME/games-on-yo-phone/__gameshortcuts__/"
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
#--- WINE --- 
if [ $platform == 'wine' ]; then 
ls ~/.local/share/wineprefixes
echo -ne "Prefix: "; read prefix
echo -ne "Executable ?> "; read executable
printf -v executable "%q" "$executable"
command="WINEPREFIX=~/.local/share/wineprefixes/$prefix wine $currentdir/$executable &> /dev/null & disown"
fi
#--- WRITING FILE ---
shortcut=$gameshortcut_dir$game_lower
cat > $shortcut << EOF
echo -e "[\e[32mPLAYING\e[0m] ${game^^}"
$command
EOF
#---
chmod +x $shortcut
