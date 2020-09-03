# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# PATH
export PATH="$HOME/.rvm/rubies/ruby-2.5.5/bin:$PATH"
export PATH="$PATH:/Users/georgios/homebrew/bin"
# Mysql Workbench
export PATH=$PATH:/Applications/MySQLWorkbench.app/Contents/MacOS
#Add MySQL (Homebrew-installed) to path
export PATH="$PATH:/Users/georgios/homebrew/opt/mysql@5.6/bin"
# Ansible - Python bins
export PATH="$PATH:/Users/georgios/Library/Python/3.7/bin"
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
#export PATH="$PATH:/Users/georgios/.gem/bin"
#export PATH="$PATH:/Users/georgios/.rvm/bin"

# FPATH
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
  autoload -Uz compinit
  compinit
fi

# ZSH
plugins=(fzf aws git aws-mfa history mysql-colorize history-substring-search zsh-navigation-tools zsh-syntax-highlighting zsh-completions ansible terraform bundler dotenv osx rsync ruby rake colored-man-pages colorize nmap zsh-interactive-cd)
export ZSH="/Users/georgios/.oh-my-zsh"
export HISTFILE=~/.zsh_history
export HISTFILESIZE=1000000000
export HISTSIZE=1000000000
setopt INC_APPEND_HISTORY
export HISTTIMEFORMAT="[%F %T] "
setopt EXTENDED_HISTORY
setopt HIST_FIND_NO_DUPS
ZSH_THEME="powerlevel10k/powerlevel10k"
source ~/powerlevel10k/powerlevel10k.zsh-theme
COMPLETION_WAITING_DOTS="true"
DISABLE_UPDATE_PROMPT=true

source /Users/georgios/.oh-my-zsh/custom/plugins/fzf-tab-completion/zsh/fzf-zsh-completion.sh
source /Users/georgios/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh
source /Users/georgios/homebrew/share/zsh-navigation-tools/zsh-navigation-tools.plugin.zsh
source /Users/georgios/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /Users/georgios/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

bindkey '\e[A' history-beginning-search-backward
bindkey '\e[B' history-beginning-search-forward

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#----- Aliases --------------------------------------------------------------#
alias firefox='/Applications/Firefox.app/Contents/MacOS/firefox'
alias k='kubectl'
alias mysqlg='mysql --pager=/Users/georgios/.bash/mysql-colorize/mycat'
alias ll='ls -AlhG'
alias pip='pip3'
alias code='open -a "Visual Studio Code" .'
# Shows 10 biggest files
alias lf='du -hsx * | sort -rh | head -10'
# List and sort dirs by size:
alias sortdis='du -m --max-depth 1 | sort -rn'
function repeat() {
    local i max
    max=$1; shift;
    for ((i=1; i <= max ; i++)); do  # --> C-like syntax
        eval "$@";
    done
}
function ask() {
    echo -n "$@" '[y/n] ' ; read ans
    case "$ans" in
        y*|Y*) return 0 ;;
        *) return 1 ;;
    esac
}
# Grep color
#export GREP_OPTIONS='--color=always'
#export GREP_COLOR='1;31;34'

#[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /Users/georgios/homebrew/bin/vault vault

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

source ~/.learnupon_env
alias grep="~/homebrew/bin/ggrep"

