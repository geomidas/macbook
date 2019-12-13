#!/usr/bin/env python

# <--- Info ------------------------------------------------------------------>
#
#    Converts an INI style ansible inventory file to an ssh config file. Helpful when
#    - the infrastructure doesn't always have dns entries
#    - using non-standard ssh ports
#
#    Instructions:
#    - Keep your ansible inventory file up to date
#    - crontab this script
#    - You're now able to ssh into any host
#
# <--- George Keramidas ------------------------------------------------------->

import re, os
from os.path import expanduser

# VARS
# user home dir
home = expanduser("~")
# Default ansible hosts file is /etc/ansible/hosts
#ansible_hosts_file = "/etc/ansible/hosts"
ansible_hosts_file = home + "/repos/macbook/ansible/roles/ansible_server/files/hosts"
# user ssh config file
outfile = home + "/.ssh/config"
# Load ansible hosts file into variable
hosts = open(ansible_hosts_file, "r")

# Recreate the ssh config file
if os.path.isfile(outfile):
    os.remove(outfile)
f = open(outfile, "w")
os.chmod(outfile, 0o600)

# Append ssh configs that apply to all hosts
f = open(outfile, "a")
f.write("Host *\n" \
        "  ForwardX11 no\n" \
        "  StrictHostKeyChecking no\n\n")
f.close()

# Parse ansible hosts file, line by line
for line in hosts:
    # Counter for line modifications
    modcount = 0
    line = line.strip()
    # ignore commented-out lines
    if not line.startswith("#"):
        # Looking for custom fields...
        # Custom hostname or IP?
        if "ansible_host=" in line:
            line = line.replace("ansible_host=", "HostName ")
            modcount += 1
        # Custom ssh port?
        if "ansible_port=" in line:
            line = line.replace("ansible_port=", "Port ")
            modcount += 1
        # Custom ssh user?
        if "ansible_user=" in line:
            line = line.replace("ansible_user=", "User ")
            modcount += 1
        # Custom ssh key?
        if "ansible_ssh_private_key=" in line:
            line = line.replace("ansible_ssh_private_key=", "IdentityFile ")
            modcount += 1
        # Here, you can add any other ansible variables that are present in your hosts file

        # Split line into list objects
        line = line.strip().split()

        # Continue, if the line was modified at least once
        if modcount > 0:
            # Store a line with 'Host' and the hostname we want to ssh as
            result = "Host" + "\t\t" + str(line[0])
            # Loop through 
            for i in range(1, modcount+1):
                # Create the result, using the below pattern.
                # The result will be a number of lines, depending on how line mods happened above
                result = result + "\n  " + str(line[(2*i)-1]) + "     \t" + str(line[2*i])

            # Adds new lines after each host entry
            result = result + "\n\n"

            # Append the result into the ssh config file
            f = open(outfile, "a")
            f.write(result)
            f.close()
