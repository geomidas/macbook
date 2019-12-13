#!/usr/bin/env bash

# <--- Info ------------------------------------------------------------------>
#
#    Helps replicate whole dir structure permissions to another system
#
#    - Gets all files under a specific directory
#    - Gathers the permissions, ownership and full path of all files, under the target dir
#    - Creates a csv file with above info
#
#     1) Set the two variables below: "dir" and "source_server"
#     2) Execute this from your local machine that has access to all other machines
#     3) Loop through the final_logs, using chmod to apply the permissions.
#
# <--- George Keramidas ------------------------------------------------------->

# <--- Variables -------------------------------------------------------------->
# The dir that is the root of the files we want to clone the permissions/ownership
dir='/var'
# My personal mac that has access to the servers
mymac='macbook2'
# Server to clone permissions from
source_server='app1'
# servers to clone permissions to
dest_servers='app2 app3 app4 app5 app6'

touch_files() {
  final_logs='/tmp/clone_permissions_scan'
  filelist='/tmp/file_perm_list.txt'
  fileperms='/tmp/file_perm.csv'
  errorlog='/tmp/file_perm_errors.log'
  # (Re)create the log files
  for logfile in ${filelist} ${fileperms} ${errorlog} ; do
    if [ -e ${logfile} ] ; then
      rm ${logfile}
    fi
    touch ${logfile}
  done
  if [[ "${HOSTNAME}" == "${mymac}" ]] ; then
    if [ -d ${final_logs} ] ; then
      rm -rf ${final_logs}
    fi
    mkdir ${final_logs}
  fi
}

deploy_script() {
  echo '-------- Copying this script accross all nodes ---------'
  echo
  for node in ${source_server} ${dest_servers} ; do
    # Sync the script
    echo -ne "${node} \t"
    rsync -a "${HOME}/repos/macbook/scripts/clone_permissions.sh" ${node}:/tmp/clone_permissions.sh
    echo ok
  done
  wait
  echo
}

gather_filelist() {
  # Exclude dirs with spaces
  excludedirs=' -path /var/lib/gems/2.1.0/gems/mini_portile2-2.3.0/test/assets -prune -o -print '
  # Make list of files to be checked
  sudo find ${dir} ${excludedirs} > "${filelist}"
  sed -i 's/ /\n/g' "${filelist}"
  # Count the files
  filenum=$( cat ${filelist} | wc -l)
  echo -e "${HOSTNAME}\t${filenum}"
}

create_csv() {
  # Create a csv file with:  file paths, permissions, ownership
  while read -r line ; do
    if sudo ls "$line" &> /dev/null ; then
       sudo stat -c "%U %G %a %n" "$line" >> ${fileperms}
     else
       echo "Non-existing file: $line" >> ${errorlog}
    fi
  done < ${filelist}
  echo "$HOSTNAME done"
}

run_script_remotely() {
  echo "--------- Creating reports ---------"
  echo
  echo "Counting the number of files under $dir ..."
  for node in ${source_server} ${dest_servers} ; do
    # Run the script in a subshell in the background
    ( ssh root@${node} '/tmp/clone_permissions.sh' & )
  done
  wait
  echo
}

gather_logs() {
  # Sync the log files back on my mac
  for node in ${source_server} ${dest_servers} ; do
    rsync -a "${node}:/tmp/file_perm*" "${final_logs}/${node}_logs/"
  done
  echo
}

filter_logs() {
  echo "--------- Sorting the csv files ---------"
  echo
  # Sort the csv files
  for node in ${source_server} ${dest_servers} ; do
    sort ${final_logs}/${node}_logs/file_perm.csv > ${final_logs}/${node}_logs/file_perm_sorted.csv
    rm ${final_logs}/${node}_logs/file_perm.csv
    mv ${final_logs}/${node}_logs/file_perm_sorted.csv ${final_logs}/${node}_logs/file_perm.csv
  done
  echo "done"
  echo
  echo "--------- Ignoring filenames not on $source_server ---------"
  echo
  # Remove all paths that don't exist on the source
  for node in ${dest_servers} ; do
    while read -r line ; do
      if ! grep -q "${line}" "${final_logs}/${source_server}_logs/file_perm.csv" ; then
        grep -v "${line}" "${final_logs}/${node}_logs/file_perm.csv" > "${final_logs}/${node}_logs/file_perm_clean.csv"
        mv "${final_logs}/${node}_logs/file_perm_clean.csv" "${final_logs}/${node}_logs/file_perm.csv"
      fi
      display_spin_wheel
      echo -ne '\b'
    done < "${final_logs}/${node}_logs/file_perm_list.txt"
  done
  echo
}

diff_logs() {
  echo "Printing the diff between ${source_server} and the other nodes... "
  for node in ${source_server} ${dest_servers} ; do
    diff --new-line-format="" --unchanged-line-format="" ${final_logs}/${source_server}_logs/file_perm.csv ${final_logs}/${node}_logs/file_perm.csv > ${final_logs}/${node}_diff.txt
  done
  echo
  echo "Check results under ${final_logs}"
}

cleanup() {
  for node in ${source_server} ${dest_servers} ; do
    ssh root@${node} "rm ${filelist} ${fileperms} ${errorlog} &> /dev/null"
  done
}

prep_spin_wheel() {
  # Prepare spinny wheel
  i=1
  sp="/-\|"
  echo -n ' '
}

display_spin_wheel() {
  # Display spinny wheel
  printf "\b${sp:i++%${#sp}:1}"
}

# <--- Main ------------------------------------------------------------------>
# Host based execution
case "$HOSTNAME" in
  "${mymac}")
    prep_spin_wheel
    touch_files
    deploy_script
    run_script_remotely
    gather_logs
    filter_logs
    diff_logs
    cleanup
    ;;
  *)
    touch_files
    gather_filelist
    create_csv
    ;;
esac
