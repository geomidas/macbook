#!/usr/bin/env bash

# <--- Info ------------------------------------------------------------------>
#
#    Description:  
#    - Lists a dir with home dirs and
#    - Changes their owner's default login
#
#    Use case:
#      Ftp users should not be able to log in via a shell,
#      Here, we disable those logins via the setting /sbin/nologin in /etc/passwd
#
# <--- George Keramidas ------------------------------------------------------->

# counter
num=1

# loop through a list of home dirs under /ftp
for user in $(ls /ftp) ; do
  echo " $num : Working on $user ... "
  # show current entry on passwd
  grep "$user:" /etc/passwd
  # Dry run ; show the change but make no changes to the file.
  sed "s@$user:/bin/bash@$user:/sbin/nologin@g" /etc/passwd | grep -i "$user"
  # Make the change
  sed -i "s@$user:/bin/bash@$user:/sbin/nologin@g" /etc/passwd
  # increase counter
  ((++num))
done
