#!/bin/bash
# ------------------------------------------------------------------------------
#
# Description:  Update a confluence page
#               (It basically recreates the page with updated content)
#
# Author:       Georgios Keramidas
#
# ------------------------------------------------------------------------------

# ------ Functions -------------------------------------------------------------
set_variables() {
  confluence_credentials='ldapusername:ldappassword'
  scr_dir="$HOME/repos/macbook/scripts/confluence_api"
  # in case xhtml conversion is selected (-x option): create tmp file to store the xhtml output
  page_content_file_xhtml='/tmp/confl_page.xhtml'
}
check_options() {
  # Exit if the user did not specify the page name and id
  if [ -z ${pageid+x} ] ; then
    echo 'Error: You did not specify the page id.'
    echo 'Open the page in your browser, the page id is the last integer in the url.'
    echo 'Use: --page_id <number>'
    exit
  fi
  if [ -z ${pagename+x} ] ; then
    echo 'Error: You did not specify the page name.'
    echo 'Use: --page_name <page name>'
    echo 'Tip: You could even change the page name if you type a new one; Keep in mind that the page url will change as well.'
    exit
  fi
  # If the user did not provide an input file using -f
  if [ -z ${page_content_file+x} ] ; then
    # use the content in the script dir
    page_content_file="$scr_dir/page_content.txt"
  fi
  # ver_num is set by the option: -v or --page_ver_num
  if [ -z ${ver_num+x} ] ; then
    get_page_version_num
  fi
}
get_page_version_num() {
  ver_num=$(curl -s -u "$confluence_credentials" -X GET http://confluence.cartrawler.com/pages/viewpreviousversions.action?pageId=$pageid | grep '(v. ' | sed 's/[^0-9]*//g')
  # The new version should be +1 from the current
  ((ver_num++))
  number='^[0-9]+$'
  if ! [[ "$ver_num" =~ $number ]] || [ -z ${ver_num+x} ] ; then
    echo "Error. Page version number: $ver_num"
    exit
  fi
}
xhtml_conversion() {
  if [[ $convert_to_xhtml == 'true' ]] ; then
    # Create the xhtml file
    if [ -f "$page_content_file_xhtml" ] ; then
      mv "$page_content_file_xhtml" "${page_content_file_xhtml}.old"
    fi
    touch $page_content_file_xhtml
    xhtml_create_table '2'
    # Replace new lines with <br></br>
    content=$(sed -e ':a' -e 'N' -e '$!ba' -e 's:\n::g' "$page_content_file_xhtml" )
    # Function that allows proceeding only if there are changes from the previous xhtml file
    check_for_changes
  else
    content=$(cat "$page_content_file")
  fi
}
xhtml_create_table() {
  case "$1" in
    '2')
        ##### Create a Table for: 2 Columns, infinite rows. #####
        # Loop through the content file and add 2 column table tags
        while read line ; do
          echo $line | awk '{print "<tr><th><center>",$1,"</center></th><td><center>",$2,"</center></td></tr>"}' >> $page_content_file_xhtml
        done < "$page_content_file"
        content=$(cat "$page_content_file_xhtml" )
        # Add table header and footer
        echo "<table><tbody>${content}</tbody></table>" > $page_content_file_xhtml
        ;;
  esac
}
printdebuginf () {
  # Print out debugging info
  echo "updating page: $pagename"
  echo "page id: $pageid"
  echo "Confluence page version: $ver_num"
  # Check the version number is a valid number
  re='^[0-9]+$'
  if ! [[ $ver_num =~ $re ]] ; then
      echo "Error: Not a number"
  fi
  # Print out the content with which the new page will be created
  echo -e "Using content:\n$content"
  # The above content can break the api in cases where the syntax does not conform to the confluence api standard
}
set_apicall_header() {
  json=$(cat <<-EOF
  {
    "id": "$pageid",
    "title":"$pagename",
    "type":"page",
    "version":{"number":"$ver_num"},
    "body":{"storage":{"value":"$content","representation":"storage"}}
  }
EOF
  )
}
check_for_changes() {
  # If there are not any changes stop here.
  if diff "$page_content_file_xhtml" "${page_content_file_xhtml}.old" &> /dev/null ; then
    echo 'No changes. Exiting.'
    exit
  fi
}
make_api_call() {
  echo 'Making the api call...'
  confluence_output=$(curl -s -u "$confluence_credentials" -X PUT -H 'Content-Type: application/json' -d "$json" http://confluence.cartrawler.com/rest/api/content/$pageid)
  echo
  echo '--------- API call reply ----------- '
  echo "$confluence_output"
}
catch_errors () {
  # Error: Wrong page version number
  echo "$confluence_output" | grep -q 'Version must be incremented on update'
  if  [[ "$?" == '0' ]] ; then
      echo 'Provide the correct confluence page number... '
  elif
      echo "$confluence_output" | grep -q 'Illegal unquoted character\|Unrecognized character' ; then
        echo 'Error: Illegal characters in the page content.'
  else
      # If the error did not appear, just increase the counter so its correct for the next run
      ((ver_num++))
  fi
}

# ------ Parse command line arguments ------------------------------------------
  POSITIONAL=()
  while [[ $# -gt 0 ]] ; do
    key="$1"
    case $key in
      -n|--page_name)
                          pagename="$2"
                          shift # past argument
                          shift # past value
                          ;;
      -i|--page_id)
                          pageid="$2"
                          shift # past argument
                          shift # past value
                          ;;
      -v|--page_ver_num)
                          ver_num="$2"
                          shift # past argument
                          shift # past value
                          ;;
      -f|--content_file)
                          page_content_file="$2"
                          shift # past argument
                          shift # past value
                          ;;
      -x|--convert_to_xhtml)
                          if [[ "$2" == 'TRUE' || "$2" == 'true' || "$2" == 'yes' ]] ; then
                            convert_to_xhtml='true'
                          else
                            convert_to_xhtml='false'
                          fi
                          shift # past argument
                          shift # past value
                          ;;
      *)
                          echo "Error: Unkown option: $key"
                          exit
                          ;;
    esac
  done
  # Restore positional parameters
  set -- "${POSITIONAL[@]}"

# ------ Main ------------------------------------------------------------------
set_variables
check_options
xhtml_conversion
printdebuginf
set_apicall_header
make_api_call
catch_errors

