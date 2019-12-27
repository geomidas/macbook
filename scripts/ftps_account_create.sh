#!/bin/bash

# <--- Info ------------------------------------------------------------------>
#
# Description:  Creates local user account and ftps dir for client data
#               Expects username (and optionally password) as arguments
#
#               This script can be remotely executed by a sudoer
#               Example command: ssh -t ftps.cartrawler.com 'sudo /root/create-ftps-account.bash username'
#
# <--- George Keramidas ------------------------------------------------------->

# check if the user has root priviledges
if [ "$(id -u)" -ne 0 ] ; then
    echo "Must be root to run this script."
    exit $E_NOTROOT
fi
# Check if the 2 args were given
if [ "$#" -lt 1 ]; then
    echo 'Error: Illegal number of parameters.'
    echo 'Usage:'
    echo '/root/create-ftps-account.bash username'
    echo 'or'
    echo '/root/create-ftps-account.bash username password'
    exit
fi
# Username and Password were provided. Proceed creating the account
username="$1"
password="$2"
# check username and password quality
if [[ "$username" =~ [^a-zA-Z0-9] ]] ; then
    echo "Error: $username is not a valid username. Only alphanumerics are allowed in usernames."
    exit
fi
if [[ -z "${password}" ]] ; then
    password=$( </dev/urandom tr -dc 'A-Za-z0-9!#$%&()*+,-./:;<=>?@[\]_~' | head -c 24  ; echo )
fi
echo
echo "Username: ${username}"
echo "Password: ${password}"
echo -ne "Creating account... \r"
# -m for normal home dirs under /home
# -G to add the account to the sftp group
useradd -m -d "/ftp/$username" -s /bin/bash -p "$( echo ${password} | openssl passwd -1 -stdin )" $username
# Check for errors
exitcode=$( echo $? )
if [ $exitcode -eq '0' ] ; then
    # Make the user dir private
    echo -ne "Securing /ftp/${username} \r"
    chown nobody:nogroup "/ftp/${username}" &&\
    chmod a-w "/ftp/${username}"  &&\
    mkdir "/ftp/${username}/files"  &&\
    chown "${username}:${username}" "/ftp/${username}/files"
    if [ $? -eq 0 ] ; then echo -e "Securing /ftp/$username" ; else exit ; fi
    echo "Success: FTP account $username has been created."
    echo
else
    # Account failed to be created. Print out the reason.
    echo "Error: $exitcode"
    case $exitcode in
         1)  echo 'can not update password file' ;;
         2)  echo 'invalid command syntax' ;;
         3)  echo 'invalid argument to option' ;;
         4)  echo 'UID already in use (and no -o)' ;;
         6)  echo 'specified group does not exist' ;;
         9)  echo 'username already in use' ;;
        10)  echo 'can not update group file' ;;
        12)  echo 'can not create home directory' ;;
        14)  echo 'can not update SELinux user mapping' ;;
         *)  echo 'Unknown error.' ;;
    esac
fi
