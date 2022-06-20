# My macbook setup
Mainly used for SRE, DevOps, Linux Sysadmins.
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
  omz update
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
  # Switch zsh to p10k theme
  sed -i '' 's@^ZSH_THEME="robbyrussell"@ZSH_THEME="powerlevel10k/powerlevel10k"@' ~/.zshrc
  cp ./dotfiles/.p10k ~/.p10k
  git clone https://github.com/zsh-users/zsh-completions.git $ZSH_CUSTOM/plugins/zsh-completions
  git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
  git clone https://github.com/zsh-users/zsh-history-substring-search.git $ZSH_CUSTOM/plugins/zsh-history-substring-search
  sed -i '' 's:^plugins=(.*:plugins=(git ansible terraform docker history colored-man-pages emoji zsh-completions zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search):g' ~/.zshrc
  brew tap homebrew/cask-fonts
  brew install --cask font-hack-nerd-font
  ```
  Change font. In iterm2, go to Preferences > Profiles > Text > Change Font. Select 'Hack Nerd Font'
  
* Various other tools
  ``` 
  brew install              shellcheck \
               findutils \
               coreutils \
               fzf \
               tldr \
               wget \
               tree \
               watch \
               httpie \
               telnet \
               rsync \
               tmux \
               nmap \
               htop \
               vim \
               gpg \
               git \
               git-crypt \
               docker \
               gcc

  brew cask install visual-studio-code \
                    google-chrome \
                    xquartz \
                    gimp
  ```
  
* [Python](https://www.python.org/)
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
  brew install openjdk
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

* Postgres DB client 
  * [dbeaver](https://dbeaver.io/)
    ```
    brew cask install dbeaver-community
    ```

* Kubernetes client
  ```
  brew install kubectl
  brew install kubectx
  brew install kube-ps1  # Control Kubernetes context and namespace
  brew install stern     # monitor multiple kubernetes logs
  ```

* [Ansible](https://docs.ansible.com/)
  ```
  brew install ansible ansible-lint
  brew install graphviz 
  pip install ansible-playbook-grapher
  ```

* [Terraform](https://www.terraform.io/)
  ```
  brew install terraform terragrunt
  ```

* [AWS cli](https://docs.aws.amazon.com/cli/index.html)
  ```
  brew install awscli
  ```
  
* [Azure cli](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-macos?view=azure-cli-latest)  
  ```
  brew install azure-cli
  ```

