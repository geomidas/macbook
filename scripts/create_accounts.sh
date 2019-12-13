#!/bin/bash

# <--- Info ------------------------------------------------------------------>
#
#    - Parse a CSV file and store account info
#    - Create user accounts
#
# <--- George Keramidas ------------------------------------------------------->

  csvfile=/home/gkeramidas/accounts_to_be_created.csv
  # create 2 arrays that will store all accounts and their passwords
  declare -a acc
  declare -a pass
  counter=0
  # Loop that parses a csv file line by line and stores usernames and passwords in the arrays
  while read -r line ; do
        echo "Processing line: $line"
        acc[$counter]=$( echo $line | cut -d, -f1 )
        pass[$counter]=$( echo $line | cut -d, -f2 )
        echo "Entry added: ${acc[$counter]} ${pass[$counter]}"
        echo "Creating account: ${acc[$counter]} with password: ${pass[$counter]}"
        # use the two arrays to create local system accounts and directories
        # -m for normal home dirs under /home
        # -g to add the account to the sftp group
        useradd -m -G sftp -s /bin/bash -p "$(echo ${pass[$counter]} | openssl passwd -1 -stdin)" ${acc[$counter]}
        exitcode=$( echo $? )
        if ! [[ $exitcode == '0' ]] ; then
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
          sleep 1
        fi
        counter=$((counter+1))
        echo "increased counter to $counter"
        echo
  done < $csvfile
