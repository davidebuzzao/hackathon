#! /bin/bash

################ USAGE #################
###  setup_dir $OS
################

config='local/config/'
OS=$1 ## macOS/linux

echo $OS
if [ $OS == linux ]; then
    profile='/home/$USER/.bashrc'
elif [ $OS == macOS ]; then
    profile='/Users/$USER/.bash_profile'
fi
echo $profile
cat $config\direnv_allow.txt >> $profile
cat $config\venv_allow.txt >> $profile
source $profile

cat $config\direnvrc_config.txt > ~/.config/direnv/direnvrc
direnv allow ./

pip install -r $config\requirements.txt
