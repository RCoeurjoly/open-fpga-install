#!/bin/bash
#
# This is a complex installer that allows internationalization
# The goal behind it is allowing as many people getting access to this
# knowledge as possible by giving them the chance to read what is being
# done in their computers in their own language
#
# Please contribute translating the *.po files to as many languages as possible
# I accept pull-requests in exchange for credit
#
# (Copyleft) D. Cuartielles, 2016, GPLv3

##
# POC around i18n/Localization in a bash script
# create the localization files for all available languages
cd locale
source ./generate_translations.sh
cd ..

# initialiaze the global variables needed for your default language
export TEXTDOMAINDIR=locale
export TEXTDOMAIN=install.sh
I18NLIB=libs/i18n-lib.sh

# source in I18N library - shown above
# this is the only message that cannot be translated
if [[ -f $I18NLIB ]]
then
        . $I18NLIB
else
        printf "ERROR - $I18NLIB NOT FOUND"
        exit 1
fi

## Start of script
# clear the screen
clear

# are we root yet? You need to be sudo if you're gonna install things
if [ $(whoami) != 'root' ]; then
        i18n_display "Need to be root"
        # printf "$0"
        exit 1;
fi

## ALLOW USER TO SET LANG PREFERENCE
## assume lang and country code follows
##XXX this part isn't working yet, I comment it away
#if [[ "$1" = "-lang" ]]
#then
#        export LC_ALL="$2_$3.UTF-8"
#fi

# Display initial greeting
printf "\n#######################################################################\n\n"
i18n_display "Greeting"

# Install all dependencies
printf "\n#######################################################################\n\n"
i18n_display "Installing dependencies"
printf "\n#######################################################################\n\n"
sudo apt-get install build-essential clang bison flex libreadline-dev \
    gawk tcl-dev libffi-dev git mercurial graphviz   \
    xdot pkg-config python python3 libftdi-dev git

# create a temporary installation folder
mkdir install.tmp

# Install Icestorm
printf "\n#######################################################################\n\n"
i18n_display "Installing icestorm"
printf "\n#######################################################################\n\n"
cd install.tmp
git clone https://github.com/cliffordwolf/icestorm.git icestorm
cd icestorm
make -j$(nproc)
sudo make install
cd ..
cd ..

# Install Arachne-pnr
printf "\n#######################################################################\n\n"
i18n_display "Installing arachnepnr"
printf "\n#######################################################################\n\n"
cd install.tmp
git clone https://github.com/cseed/arachne-pnr.git arachne-pnr
cd arachne-pnr
make -j$(nproc)
sudo make install
cd ..
cd ..

# Install Yosys
printf "\n#######################################################################\n\n"
i18n_display "Installing yosys"
printf "\n#######################################################################\n\n"
cd install.tmp
git clone https://github.com/cliffordwolf/yosys.git yosys
cd yosys
make -j$(nproc)
sudo make install
cd ..
cd ..

# Install Icarus Verilog
printf "\n#######################################################################\n\n"
i18n_display "Installing icarus"
printf "\n#######################################################################\n\n"
sudo add-apt-repository ppa:team-electronics/ppa
sudo apt-get update
sudo apt-get install iverilog

# Install GTKWave
printf "\n#######################################################################\n\n"
i18n_display "Installing gtkwave"
printf "\n#######################################################################\n\n"
sudo apt-get install gtkwave

# Delete temp files
printf "\n#######################################################################\n\n"
i18n_display "Deleting temp files"
printf "\n#######################################################################\n\n"
rm -fR install.tmp

# Download courseware
printf "\n#######################################################################\n\n"
i18n_display "Downloading courseware"
printf "\n#######################################################################\n\n"
git clone https://github.com/Obijuan/open-fpga-verilog-tutorial.git open-fpga-verilog-tutorial

# Display final remarks
printf "\n#######################################################################\n\n"
i18n_display "Credits"
printf "\n#######################################################################\n\n"
i18n_display "Copyright"
printf "\n#######################################################################\n\n"

# Install ends here
exit 0
