# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# set -xv # for debug slowness

source $HOME/.dot/prezshrc

if is_docker; then
	HISTFILE="${HOME}/.zsh_history_docker"
else
	HISTFILE="${HOME}/.zsh_history"
fi

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.

if is_amazon_mac; then
	#ZSH_THEME="af-magic"
	ZSH_THEME="powerlevel10k/powerlevel10k"
elif is_wsl || is_amazon_cloud_desktop; then
	ZSH_THEME="afowler"
else
	ZSH_THEME="superjarin"
fi

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Fix directory permissions checking
ZSH_DISABLE_COMPFIX="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="false"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="dd.mm.yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.

plugins=(git alias-tips zsh-autopair zsh-autosuggestions zsh-navigation-tools history-substring-search fast-syntax-highlighting)

is_wsl || is_fullsystem && plugins=(${plugins[@]} sudo cp rsync z colored-man-pages)

is_fullsystem && plugins=(${plugins[@]} screen vscode adb nmap)

is_archlinux && plugins=(${plugins[@]} archlinux)

is_ubuntu && plugins=(${plugins[@]} ubuntu)

is_mac && plugins=(${plugins[@]} brew auto-notify golang)

has_java && is_fullsystem && plugins=(${plugins[@]} gradle mvn)

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

source ~/.dot/myrc

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=12"

unsetopt correctall

if is_mac; then
	export PATH="/opt/homebrew/opt/binutils/bin:$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin:/Users/gosahai/.toolbox/bin:/Users/gosahai/.depot_tools:/opt/homebrew/opt/node@18/bin"
	test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

	eval "$(/opt/homebrew/bin/brew shellenv)"

	export PAGER=less
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# if you wish to use IMDS set AWS_EC2_METADATA_DISABLED=false

if is_amazon_cloud_desktop; then
	export AWS_EC2_METADATA_DISABLED=true
	export TZ='Asia/Kolkata'
fi
