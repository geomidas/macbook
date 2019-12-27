#!/usr/bin/env bash
set -e 

# <--- Info ------------------------------------------------------------------>
#
#    Executed by the ansible user on ansible.cartrawler.com
#
#    - Updates local devops repo. 
#    - Syncs ansible files under /etc/ansible. 
#    - Creates ssh config out of ansible inventory.
#
# <--- George Keramidas ------------------------------------------------------->

# ------ log file --------------------------------------------------------------
logfile='/var/log/ansible/sync_ansible_files_from_repo.log'
# Create the log file if it doesn't already exist
if ! [ -f "${logfile}" ] ; then
    touch "${logfile}"
fi

# ------ Functions -------------------------------------------------------------
do_git_update() {
    git_update="$(git -C /home/ansible/repos/devops/ remote update 2>&1)"
}
do_git_status() {
    git_status="$(git -C /home/ansible/repos/devops/ status -uno 2>&1)"
}
print_git_status() {
    # print git status
    echo -e "\n$(date +'%Y%m%d-%T'), Changes detected:" >> "${logfile}"
    echo -e "${git_status}\n" >> "${logfile}"
}
print_repo_up_to_date() {
        echo "/home/ansible/repos/devops is up to date." >> "${logfile}"
}
do_git_pull() {
    echo "$(date +'%Y%m%d-%T'), Git pull:" >> "${logfile}"
    git_pull="$(git -C /home/ansible/repos/devops/ pull --all 2>&1)"
    git_pull_result=$?
}
print_git_pull() {
    echo -e "${git_pull}\n" >> "${logfile}"
}
print_sync_complete() {
    echo -e "$(date +'%Y%m%d-%T'), Ansible config file sync is complete.\n" >> "${logfile}"
}
print_sync_failed() {
    echo 'Error: Sync failed.' >> "${logfile}" 
}
create_ssh_config() {
    /home/ansible/repos/devops/scripts/ansible_ini_to_ssh_config.py >> "${logfile}" 2>&1
}
do_fix_git() {
    echo -e "\n$(date +'%Y%m%d-%T'), Error: git pull failed." >> "${logfile}"
    echo "${git_stdout}" >> "${logfile}" 2>&1
    echo -e "\n$(date +'%Y%m%d-%T'), Reseting to HEAD." >> "${logfile}"
    git -C /home/ansible/repos/devops/ reset --hard >> "${logfile}" 2>&1
}

# ------ Execution -------------------------------------------------------------
do_git_update
do_git_status
# Check if repo is up to date
if echo "${git_status}" | grep -q 'up-to-date' ; then
    print_repo_up_to_date
else
    print_git_status
    do_git_pull
    # Check if git pull succeeded
    if [ $git_pull_result -eq 0 ] ; then
        print_git_pull
        # Check if any ansible config changed. All files live under /devops/ansible/roles/ansible_server/files
        if echo "${git_pull}" | grep -q 'ansible/roles/ansible_server/files' ; then
            # sync ansible config
            if sudo rsync -avh /home/ansible/repos/devops/ansible/roles/ansible_server/files/* /etc/ansible/ >> /dev/null 2>&1 ; then
                print_sync_complete
                create_ssh_config
            else
                print_sync_failed
            fi
        fi
    else
        do_fix_git
        # It should be back to normal on the next run
    fi
fi
