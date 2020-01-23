#!/usr/bin/env bash
set -e

# <--- Info ------------------------------------------------------------------>
#
#   Upgrades Debian 8 to 9
#   ssh into the host and execute this script using sudo or the root account
#
# <--- George Keramidas ------------------------------------------------------->

# Upgrade to the latest Debian 8
apt update
apt -y upgrade --download-only

# Wait for user input to continue with the upgrade
read -r -p "Start apt upgrade? [Y/n]" response
response=${response,,} # tolower
if ! [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]]; then
   exit
fi

apt -y upgrade
apt -y full-upgrade

# Remove any java 7 package
apt remove --purge openjdk-7-jdk openjdk-7-jre openjdk-7-jre-headless

# cleanup
apt -y --purge autoremove
apt autoclean

# Wait for user input to continue with the major OS upgrade
read -r -p "Start upgrade from Debian 8 to 9? [Y/n]" response
response=${response,,} # tolower
if ! [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]]; then
   exit
fi
sed -i 's/jessie/stretch/g' /etc/apt/sources.list
sed -i 's/stretch/buster/g' /etc/apt/sources.list
apt update
apt -y upgrade
apt -y full-upgrade

# cleanup
apt autoclean
apt -y --purge autoremove

# Wait for user input to reboot
read -r -p "Reboot? [Y/n]" response
response=${response,,} # tolower
if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]]; then
   reboot
fi
