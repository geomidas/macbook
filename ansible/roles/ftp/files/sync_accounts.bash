#!/bin/bash

# <--- Info ------------------------------------------------------------------>
#
# Description:  Fetches new accounts from Koios
#               Checks if they exist locally
#               Creates any missing ones
#
# <--- George Keramidas ------------------------------------------------------->

# <----- Vars ----------------------------------------------------------------->
dbip='213.168.229.43'
dbuser='ORS_sftp'
dbpass='i0ELw58dkW6sfy4wBekt'
sqlcommandfile='/root/get_accounts.sql'

# <----- Functions ------------------------------------------------------------>


# <----- Main ----------------------------------------------------------------->
fetch_accounts=$( isql "${dbip}" "${dbuser}" "${dbpass}" -b < "${sqlcommandfile}" )
filter_accounts=$( isql 213.168.229.43 ORS_sftp i0ELw58dkW6sfy4wBekt -b < get_accounts.sql | grep -v "user_id.*password" | grep '^| ' | awk '{print $2,$4}' )