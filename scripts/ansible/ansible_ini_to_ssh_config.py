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

import re, os, getopt, sys
from os.path import expanduser


def read_arguments():
    full_cmd_arguments = sys.argv
    argument_list = full_cmd_arguments[1:]
    short_options = "hi:"
    long_options = ["help", "inventory="]
    try:
        arguments, values = getopt.getopt(argument_list, short_options, long_options)
    except getopt.error as err:
        # Output error, and return with an error code
        print(str(err))
        print(values)
        sys.exit(2)
    # Evaluate options
    for current_argument, current_value in arguments:
        if current_argument in ("-h", "--help"):
            print("Displaying help  \n")
            print("  -h | --help      \tShow this help menu")
            print("  -i | --inventory \tSpecify the inventory file to be parsed")
            print("")
        elif current_argument in ("-i", "--inventory"):
            print(("Using inventory file (%s)") % (current_value))
            global ansible_hosts_file
            ansible_hosts_file = current_value


def recreate_ssh_conf():
    # Recreate the ssh config file
    if os.path.isfile(outfile):
        os.remove(outfile)
    f = open(outfile, "w")
    os.chmod(outfile, 0o600)

    # Append ssh configs that apply to all hosts
    f = open(outfile, "a")
    f.write("Host *\n"\
            "  ForwardX11 no\n"\
            "  LogLevel ERROR\n"\
            "  StrictHostKeyChecking no\n"\
            "  UserKnownHostsFile=/dev/null\n\n")
    f.close()


def parse_hosts(hosts, outfile):
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
            # Is the host behind a bastion/proxy?
            if "proxy_jump=" in line:
                line = line.replace("proxy_jump=", "ProxyJump ")
                modcount += 1
            # Here, you can add any other ansible variables that are present in your hosts file

            # Split line into list objects
            line = line.strip().split()

            # Continue, if the line was modified at least once
            if modcount > 0:
                # Store a line with 'Host' and the hostname we want to ssh as
                result = "Host" + " " + str(line[0])
                # Loop through 
                for i in range(1, modcount+1):
                    # Create the result, using the below pattern.
                    # The result will be a number of lines, depending on how many line mods happened above
                    result = result + "\n  " + str(line[(2 * i) - 1]) + " " + str(line[2 * i])

                # Adds new lines after each host entry
                result = result + "\n\n"

                # Append the lines (result) into the ssh config file
                f = open(outfile, "a")
                f.write(result)
                f.close()


if __name__ == "__main__":
    read_arguments()

    # user home dir
    home = expanduser("~")
    # Set the ansible hosts file if it was not passed with -i
    # Default ansible hosts file is /etc/ansible/hosts
    #ansible_hosts_file = "/etc/ansible/hosts"
    # My LU hosts file
    try:
        ansible_hosts_file
    except NameError:
        ansible_hosts_file = home + "/ansible/hosts.ini"
        #ansible_hosts_file = home + "/lu/onboarding_project/ansible/inventory/hosts.ini"
        #ansible_hosts_file2 = home + "/lu/onboarding_project/ansible/inventory/prod.ini"
        #ansible_hosts_file3 = home + "/lu/onboarding_project/ansible/inventory/test.ini"
    # user ssh config file
    global outfile
    outfile = home + "/.ssh/config"
    # Load ansible hosts file into variable
    global hosts
    hosts = open(ansible_hosts_file, "r")

    recreate_ssh_conf()
    
    # Parse ansible hosts file 1
    with open(ansible_hosts_file, "rb") as infile:
        parse_hosts(infile, outfile)
    ## Parse ansible hosts file 2
    #with open(ansible_hosts_file2, "rb") as infile:
    #    parse_hosts(infile, outfile)
    ## Parse ansible hosts file 3
    #with open(ansible_hosts_file3, "rb") as infile:
    #    parse_hosts(infile, outfile)

