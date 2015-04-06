#!/bin/bash

# setup colors
red=`tput setaf 1`
green=`tput setaf 2`
cyan=`tput setaf 6`
bold=`tput bold`
reset=`tput sgr0`

heading()
{
	echo
	echo "${cyan}==>${reset}${bold} $1${reset}"
}

success()
{
	echo
	echo "${green}==>${bold} $1${reset}"
}

error()
{
	echo
	echo "${red}==>${bold} Error: $1${reset}"
}

heading "Updating ethereum"

# figure out what we have to update
if [[ -f /usr/bin/geth ]];
then
	ethtype="geth"
	success "Found geth"
else
	if [[ -f /usr/bin/geth ]];
	then
		ethtype="eth"
		success "Found eth"
	else
		error "Couldn't find ethereum"
		exit 0
	fi
fi

heading "Stopping processes"
pm2 kill

heading "Removing ethereum"
sudo apt-get remove $eth -y

heading "Updating repos"
sudo apt-get clean
sudo add-apt-repository -y ppa:ethereum/ethereum
sudo add-apt-repository -y ppa:ethereum/ethereum-dev
sudo apt-get update -y
sudo apt-get upgrade -y

heading "Installing ethereum"
sudo apt-get install -y $eth

heading "Updating eth-netstats client"
cd ~/bin/www
git pull
sudo npm update
cd ..

success "Ethereum was updated successfully"

heading "Restarting processes"
pm2 start processes.json