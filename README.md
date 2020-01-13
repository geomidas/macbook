# My macbook setup
Mainly used for Linux Sysadmin and DevOps. 
Homebrew, Bash, Python, Ansible, Docker, Kubernetes...

## Initial Setup

### Disable the "Empty trash" warning
Finder > Preferences > Advanced tab > Uncheck "Show warning before emptying the Trash"

### Disable motd
Disable the welcome message when opening a cli
  ```
  touch ~/.hushlogin
  ```

### Install
* [Xcode](https://developer.apple.com/xcode/)
  
  Do cmd+space > terminal
  ```
  xcode-select —-install
  ```
* [Homebrew](https://brew.sh/) 
  ```
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  git -C "$(brew --repo homebrew/core)" fetch --unshallow
  ```
* [iterm2](https://iterm2.com/downloads.html)
  ```
  brew cask install iterm2
  ```
* [Ohmyzsh](https://ohmyz.sh/)
  ```
  brew install zsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  upgrade_oh_my_zsh
  git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
  git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  brew tap homebrew/cask-fonts
  brew cask install font-hack-nerd-font
  ```
  Change font. In iterm2, go to Preferences > Profiles > Text > Change Font. Select 'Hack Nerd Font'
  
* Various other tools
  ``` 
  brew install zsh-syntax-highlighting \
               zsh-autosuggestions \
               shellcheck \
               findutils \
               fzf \
               tldr \
               watch \
               httpie \
               telnet \
               rsync \
               tmux \
               nmap \
               htop \
               vim \
               git \
               git-crypt \
               docker \
               kubectl \
               gcc

  brew cask install visual-studio-code \
                    google-chrome \
                    xquartz \
                    gimp
  ```
  
* Python
  ```
  brew install python
  curl -s https://bootstrap.pypa.io/get-pip.py -o get-pip.py
  sudo python get-pip.py
  ```
  
* [Go](https://golang.org/)
  ```
  export GOPATH="${HOME}/.go"
  export GOROOT="$(brew --prefix golang)/libexec"
  export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"
  test -d "${GOPATH}" || mkdir "${GOPATH}"
  test -d "${GOPATH}/src/github.com" || mkdir -p "${GOPATH}/src/github.com"
  brew install go
  
  go get golang.org/x/tools/cmd/godoc
  go get golang.org/x/lint/golint
  ```
  
* [AdoptOpenJDK](https://adoptopenjdk.net/)
  ```
  brew tap adoptopenjdk/openjdk
  brew cask install adoptopenjdk
  ```
* Choose an IDE:
  * [intellij](https://www.jetbrains.com/idea/)
    ```
    brew cask install intellij-idea-ce
    ```
  * [NetBeans](https://netbeans.org/kb/articles/mac.html)
    ```
    brew install caskroom/cask/brew-cask
    brew cask install netbeans
    ```

* [Ansible](https://docs.ansible.com/)
  ```
  brew install ansible ansible-lint
  brew install graphviz 
  pip install ansible-playbook-grapher
  ```

* [AWS cli](https://docs.aws.amazon.com/cli/index.html)
  ```
  brew install awscli
  ```
  
* [Azure cli](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-macos?view=azure-cli-latest)  
  ```
  brew install azure-cli
  ```

* [Keepass](https://www.keepassx.org/) (for encrypting passwords and other info)
  ```
  brew cask install keepassx
  ```

* [Atom](https://atom.io/) text editor (Visual Studio Code alternative)
  ```
  brew cask install atom
  ```
  
