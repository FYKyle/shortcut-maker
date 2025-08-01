#!/bin/bash
######################
### SHORTCUT MAKER ###
######################
# creates shortcuts :P
# that aren't aliases
#--- Preperations --- 
echo -ne 'Game: '; read game
game=$game
gamenospace=${game// /}
game_lower=${gamenospace,,}
echo -ne 'Platform: '; read platform
#--- LINUX ---
if [ $platform == 'linux' ]; then 
echo -ne "Path: "; read path
echo -ne "Executable: "; read executable
command="cd $path && nohup ./$executable &> /dev/null"
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
#--- WRITING FILE ---
cat > $game_lower << EOF
echo -e "[\e[32mPLAYING\e[0m] ${game^^}"
$command
EOF
#---
chmod +x $game_lower
