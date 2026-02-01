# My macbook setup
Mainly used for SRE, DevOps, Linux Sysadmins.

## Run setup.sh
```bash
./setup.sh
```
This single command handles everything: installs Xcode tools, Homebrew, Ansible, and runs the full configuration.

### Optionally, run the Ansible playbook
In case of any changes in the roles, you can either run the setup.sh script again, or run the Ansible playbook:
```bash
ansible-playbook site.yml
```

This will automatically install:
- All command line tools from the Brewfile (git, kubectl, docker, etc.)
- All GUI applications from the Brewfile (iTerm2, Chrome, Docker Desktop, etc.)
- Dotfiles configuration (.zshrc, .aliases, .vimrc, etc.)
- macOS system settings

## Manual Steps

### iterm2
Change font. In iterm2, go to Preferences > Profiles > Text > Change Font. Select 'Hack Nerd Font'
