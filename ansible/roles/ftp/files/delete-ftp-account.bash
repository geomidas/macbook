#!/bin/bash

# <--- Info ------------------------------------------------------------------>
#
#     Deletes local user account and ftp dir of client data
#     Expects username as argument
#
#     This script can be remotely executed by a sudoer
#     Example command: ssh -t prod-sftp-server.cartrawler.com 'sudo /root/delete-ftp-account.bash username'
#
# <--- George Keramidas ------------------------------------------------------->

echo
# check if the user has root priviledges
if [ "$(id -u)" -ne 0 ] ; then
    echo "Error:   You must be root to run this script."
    exit $E_NOTROOT
fi
# Check if the 2 args were given
if [ "$#" -ne 1 ]; then
    echo 'Error:   Illegal number of parameters.'
    echo 'Example: delete-sftp-account.bash username'
    exit
fi
# Username was provided. Proceed deleting the account
username="$1"
echo "Username: $username"
userdel $username
if [ $? -eq 0 ] ; then 
    echo -e "Deleted account" 
else 
    exit 
fi
echo -ne "Backing up /ftp/$username ... \r"
rsync -a /ftp/$username /ftp/deleted_ftp_data/
# if the sync succeeds, proceed deleting the data dir
if [ $? -eq 0 ] ; then
    echo "Backup: /ftp/deleted_ftp_data/$username"
    rm -rf "/ftp/$username"
    echo "Deleted: /ftp/$username"
else
    exit
fi
echo "Success"
echo
