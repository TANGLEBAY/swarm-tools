#!/bin/bash
clear
# Text Colors
TEXT_RED_B='\e[1;31m'
text_yellow='\e[33m'
text_green='\e[32m'
text_red='\e[31m'
text_reset='\e[0m'
function pause(){
   read -p "$*"
}
echo ""
echo -e $TEXT_RED_B "SWARN - Update fixer"
if [ $(id -u) -ne 0 ]; then
    echo -e $TEXT_RED_B "Please run the SWARM - Update fix with sudo or as root"
    echo -e $TEXT_RED_B && pause ' Press [Enter] key to continue...'
    echo -e $text_reset
    exit 0
fi
echo -e $text_yellow && read -t 60 -p " Are you sure to run the SWARM - Update fix script? (y/N): " selector
echo ""
if [ "$selector" = "y" ] || [ "$selector" = "Y" ]; then
    echo -e $text_yellow " -> Loading old configuration..."
    swarm=/var/lib/swarm
    source $swarm/configs/swarm.cfg
    source $swarm/configs/nginx.cfg
    source $swarm/configs/hornet.cfg
    source $swarm/modules/variables
    if [ -f "$swarm/log/watchdog.log" ]; then
        watchdog=true
    fi
    if [ -f "$swarm/log/pruning.log" ]; then
        dbpruner=true
    fi
    echo ""
    sleep 3
    echo -e $text_yellow " -> Removing SWARM folder..."
    sudo rm -rf /var/lib/swarm
    echo ""
    sleep 3
    echo -e $text_yellow " -> Go to destination folder..."
    cd /var/lib
    echo ""
    sleep 3
    echo -e $text_yellow " -> Download latest SWARM version..."
    sudo git clone https://github.com/TangleBay/swarm.git > /dev/null 2>&1
    echo ""
    sleep 3
    echo -e $text_yellow " -> Set file permissions for SWARM..."
    sudo chmod +x $swarm/swarm $swarm/plugins/watchdog $swarm/plugins/dbpruner
    echo ""
    sleep 3
    echo -e $text_yellow " -> Starting old configuration importer..."
    source $swarm/modules/updater
    if [ "$watchdog" = "true" ]; then
        sudo mkdir -p $swarm/log
        sudo echo "0" > $swarm/log/watchdog.log
    fi
    if [ "$dbpruner" = "true" ]; then
        sudo mkdir -p $swarm/log
        {
            echo "1"
            echo ""
        } > $swarm/log/pruning.log
    fi
    echo ""
    sleep 3
    echo -e $TEXT_RED_B "Fixing SWARM done. You can now remove the script from your device!"
    echo -e $TEXT_RED_B && pause ' Press [Enter] key to continue...'
    echo -e $text_reset
    unset selector
else
    echo -e $TEXT_RED_B "SWARM - Update fixer canceled!"
    echo -e $TEXT_RED_B && pause ' Press [Enter] key to continue...' && echo -e $text_reset
fi
clear
exit 0
