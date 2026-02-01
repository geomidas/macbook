# My macbook setup
Mainly used for SRE, DevOps, Linux Sysadmins.
Homebrew, Bash, Python, Ansible, Docker, Kubernetes...

## Initial Setup

### Install
* [Xcode](https://developer.apple.com/xcode/)
  
  Do cmd+space > terminal
  ```
  xcode-select —-install
  ```
* [Homebrew](https://brew.sh/) 
  ```
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  ```
* [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
  ```
  brew install ansible
  ```

### Automated Setup with Ansible
**Option 1: One-command setup (Recommended)**
```bash
./setup.sh
```
This single command handles everything: installs Xcode tools, Homebrew, Ansible, and runs the full configuration.

**Option 2: Manual Ansible setup**
After installing the prerequisites manually, run:
```bash
ansible-playbook site.yml
```

This will automatically install:
- All command line tools from the Brewfile (git, kubectl, docker, etc.)
- All GUI applications from the Brewfile (iTerm2, Chrome, Docker Desktop, etc.)
- Dotfiles configuration (.zshrc, .aliases, .vimrc, etc.)
- macOS system settings

### Manual Setup

Change font. In iterm2, go to Preferences > Profiles > Text > Change Font. Select 'Hack Nerd Font'
