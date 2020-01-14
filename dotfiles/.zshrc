#source ~/.fonts/*.sh
#----- ZSH configs ----------------------------------------------------------#
export ZSH="/Users/gkeramidas/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
DEFAULT_FOREGROUND='blue'
DEFAULT_FOREGROUND2='cyan'
POWERLEVEL9K_STATUS_VERBOSE=true
POWERLEVEL9K_STATUS_CROSS=true
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
#POWERLEVEL9K_DIR_OMIT_FIRST_CHARACTER=false
POWERLEVEL9K_DIR_HOME_BACKGROUND="$DEFAULT_FOREGROUND2"
POWERLEVEL9K_DIR_DEFAULT_BACKGROUND="$DEFAULT_FOREGROUND2"
POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND="$DEFAULT_FOREGROUND2"
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_RPROMPT_ON_NEWLINE=false
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="╭─"
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="╰\uF460 "
POWERLEVEL9K_CONTEXT_DEFAULT_FOREGROUND="$DEFAULT_FOREGROUND"
POWERLEVEL9K_CONTEXT_DEFAULT_BACKGROUND="$DEFAULT_BACKGROUND"
POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND="$DEFAULT_FOREGROUND2"
POWERLEVEL9K_CONTEXT_ROOT_BACKGROUND="$DEFAULT_BACKGROUND"
#POWERLEVEL9K_MODE='awesome-fontconfig'
POWERLEVEL9K_MODE='nerdfont-complete'
#POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR="\uE0B4"
#POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR="%F{$(( $DEFAULT_BACKGROUND - 2 ))}|%f"
#POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR="%F{$(( $DEFAULT_BACKGROUND - 2 ))}|%f"
#POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR="\uE0B6"
POWERLEVEL9K_TIME_BACKGROUND="$DEFAULT_FOREGROUND"
POWERLEVEL9K_TIME_FOREGROUND='black'
POWERLEVEL9K_OS_ICON_BACKGROUND="$DEFAULT_FOREGROUND"
POWERLEVEL9K_OS_ICON_FOREGROUND='black'
POWERLEVEL9K_ROOT_ICON='\uF490'
POWERLEVEL9K_ROOT_INDICATOR_BACKGROUND="$DEFAULT_FOREGROUND2"
POWERLEVEL9K_ROOT_INDICATOR_FOREGROUND='black'
POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND="black"
POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND="$DEFAULT_FOREGROUND2"
POWERLEVEL9K_EXECUTION_TIME_ICON="\u23F1"
#POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(icons_test)
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context root_indicator os_icon dir rbenv vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time background_jobs time)

CASE_SENSITIVE="true"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="yyyy-mm-dd"
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Load custom plugins
for item in $(ls -1 ${HOME}/.profile.d/*.plugin.zsh); do
  [ -e "${item}" ] && source "${item}"
done

# aws
plugins=( helm history zsh-navigation-tools zsh-syntax-highlighting zsh-completions zsh-autosuggestions git golang jira docker jsontools httpie web-search tmux tmuxinator osx ansible colored-man-pages colorize nmap )
source $ZSH/oh-my-zsh.sh
# ZSH syntax highlighting
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

#----- User configuration ----------------------------------------------------------#
# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='mvim'
fi
export VAULT_ADDR=https://vault.tradeix.co.uk
source /usr/local/share/kube-ps1.sh
autoload -U +X bashcompinit && bashcompinit
source /usr/local/etc/bash_completion.d/az

#----- Aliases --------------------------------------------------------------#
alias vscode='open -a "Visual Studio Code" .'
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
alias kube="${HOME}/repos/sysadmin/scripts/kubedashboard/kubedashboard.sh"
#----- Other custom stuff ---------------------------------------------------------#
# export TERM="xterm-256color"
# ssh-add $pem
# Housekeeping
#$HOME/repos/gkeramidas/scripts/housekeeping.sh
if [ /usr/local/bin/kubectl ]; then source <(kubectl completion zsh); fi
