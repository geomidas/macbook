#!/usr/bin/env bash

# <--- Info ------------------------------------------------------------------>
#
#      Requires Ansible
#      Diffs multiple files and ignores the similar ones
#      Created this in order to help combine multiple versions of a config file into a single template
#
# <--- George Keramidas ------------------------------------------------------->

# <--- Parse Options ---------------------------------------------------------->
# If there are less than 4 arguments print the help message
if [ $# -lt 4 ] ; then
  echo -e "usage: $0 -i internaldev-web -f /etc/ntp.conf \n\noptions:  -i  Ansible inventory group or host
          -f  Filepath of the file that is to be pulled and processed from the hosts in the inventory ( see option -i )
          -d  (Optional) Destination directory for all the files to be pulled \n"
  exit 1 ;
fi
while getopts ":f:i:d:h" optname
  do
    case "$optname" in
      "i") inventory="$OPTARG" ; ;;
      "f") filepath="$OPTARG" ; ;;
      "d") destdir="$OPTARG" ; ;;
      "?") echo "Unknown option $OPTARG" ; exit 0 ; ;;
      ":") echo "No argument value for option $OPTARG" ; exit 0 ; ;;
        *) echo "Unknown error while processing options" ; exit 0 ; ;;
    esac
  done
shift $(($OPTIND - 1))

# <--- Variables -------------------------------------------------------------->
# Get file name from the filepath
file="$( echo $filepath | rev | cut -d '/' -f '1' | rev )"

# <--- Functions -------------------------------------------------------------->
catch_errors() {
  # Error when file was not specified
  if [ -z "$filepath" ] || [ -z "$inventory" ] ; then
    print_help
    exit
  fi
  if [ -z $destdir ] ; then
    # Set default destination dir. User can change this using -d
    destdir="/tmp/$file"
  fi
  # If the dir already exists delete it
  if [ -d "$destdir" ] ; then
    echo "Recreating directory: $destdir"
    read -p "Press enter to continue... "
    rm -rf "$destdir"
  fi
}
determine_os() {
  unameOut="$(uname -s)"
  case "${unameOut}" in
    Linux*)  machine=Linux ;;
    Darwin*) machine=Mac ;;
    CYGWIN*) machine=Cygwin ;;
    MINGW*)  machine=MinGw ;;
    *)       machine="UNKNOWN:${unameOut}" ; exit
  esac
}
pull_files() {
  ansible $inventory -b -m fetch -a "src=$filepath dest=$destdir"
}
rm_whitespace() {
  # Remove empty lines and comments from all the files that were pulled
  if rubbish=$( grep -rl '^\s*\(#\|$\)' $destdir) ; then
     rubbish=$(echo "$rubbish" | awk '{print $1,$2}')
     echo "$rubbish" | xargs sed -i -e 's/#.*$//'
     echo "$rubbish" | xargs sed -i -e '/^$/d'
  fi
  # Sort the content of the files
  for f in $(find $destdir -type f -name $file) ; do
    sort -u -o "${f}" "${f}"
  done
}
rm_local_ip() {
  # Remove lines with the IP 127.0.*.*
  for f in $(find $destdir -type f -name $file) ; do
    grep -v 127\.0\. "${f}" > "${f}.tmp"
    mv "${f}.tmp" "${f}"
  done
}
results() {
  case "$machine" in
    Linux)  hashalg='md5sum' ;;
    Mac)    hashalg='md5'
  esac
  # Results
  res=$( find "$destdir" -type f -name "$file" | xargs -n1 "$hashalg" | awk '{print $4,$2}' )
  # Create a table of the count and file name
  join -1 2 <( echo "$res" | sort -k1,1 -t'(' | cut -d '(' -f1  | uniq -c | tail -n '+1' ) \
            <( echo "$res" | sort -k1,1 -u -t'(' | sed 's/(\|)//g' ) \
             | awk '{print $2,$3}' | sort -nr | column -t
}

# <--- Main ------------------------------------------------------------------->
# Determine OS. Using different hashing algorithm depending on the OS where this script runs
determine_os
catch_errors
pull_files
rm_whitespace
rm_local_ip
results
