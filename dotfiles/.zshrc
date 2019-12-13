#source ~/.fonts/*.sh
#----- ZSH configs ----------------------------------------------------------#
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/gkeramidas/.oh-my-zsh"

ZSH_THEME="powerlevel9k/powerlevel9k"
DEFAULT_FOREGROUND='blue'
DEFAULT_FOREGROUND2='cyan'
POWERLEVEL9K_STATUS_VERBOSE=true
POWERLEVEL9K_STATUS_CROSS=true
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
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
POWERLEVEL9K_MODE='nerdfont-complete'
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
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context root_indicator os_icon dir rbenv vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time background_jobs time)

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

HIST_STAMPS="yyyy-mm-dd"

plugins=( history zsh-syntax-highlighting zsh-completions zsh-autosuggestions git aws knife jira docker jsontools httpie web-search tmux tmuxinator osx )
source $ZSH/oh-my-zsh.sh

# ZSH syntax highlighting
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

#----- User configuration ----------------------------------------------------------#
# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='mvim'
fi

#----- Aliases --------------------------------------------------------------#
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
# Runs the kubernetes dashboard for a cluster
alias kube="${HOME}/repos/sysadmin/scripts/kubedashboard/kubedashboard.sh"

#----- Other custom stuff ---------------------------------------------------------#
$HOME/repos/gkeramidas/scripts/housekeeping.sh
if [ /usr/local/bin/kubectl ]; then source <(kubectl completion zsh); fi

