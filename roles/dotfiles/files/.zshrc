# History
export HISTFILE=~/.zsh_history
export HISTFILESIZE=1000000000
export HISTSIZE=1000000000
setopt INC_APPEND_HISTORY
export HISTTIMEFORMAT="[%F %T] "
setopt EXTENDED_HISTORY
setopt HIST_FIND_NO_DUPS

source ~/.env
source ~/.aliases

source /Users/georgios/.oh-my-zsh/custom/plugins/fzf-tab-completion/zsh/fzf-zsh-completion.sh
source /Users/georgios/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh
source /Users/georgios/homebrew/share/zsh-navigation-tools/zsh-navigation-tools.plugin.zsh
source /Users/georgios/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /Users/georgios/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

bindkey '\e[A' history-beginning-search-backward
bindkey '\e[B' history-beginning-search-forward

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /Users/georgios/homebrew/bin/vault vault
