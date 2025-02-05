# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

zstyle ':omz:*' aliases no
# zstyle ':omz:plugins:git' aliases no

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

bindkey -v
bindkey -M viins '^p' insert-last-word

# vim() {
#   if [ -z "$@" ]; then
#     nvim `fzf`
#   else
#     nvim $@
#   fi
# }
alias vim=nvim
vvim() {
  if [ -z "$@" ]; then
    /Applications/Neovide.app/Contents/MacOS/neovide `fzf`
  else
    /Applications/Neovide.app/Contents/MacOS/neovide neovide $@
  fi
}
code() {
  if [ -z "$@" ]; then
    /usr/local/bin/code `fzf`
  else
    /usr/local/bin/code $@
  fi
}

export HIST_IGNORE_SPACE=true
export HIST_SAVE_NO_DUPS=true
export HIST_VERIFY=true
export HISTSIZE=500000
export SAVEHIST=100000

export EDITOR=/opt/homebrew/bin/nvim
# [[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh
# eval "$(fasd --init auto)"
alias j=z

alias gs="git status"
alias gm="git checkout master"
alias ls='lsd'
alias pr='gh pr view'
alias prweb='gh pr view --web'

# php-related aliases
alias phpa='ps aux | grep phpactor | grep -v grep | grep Cellar'

# --files: List files that would be searched but do not search
# --no-ignore: Do not respect .gitignore, etc...
# --hidden: Search hidden files and folders
# --follow: Follow symlinks
# --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
# export FZF_DEFAULT_COMMAND='ag -g ""'
# export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'
# export FZF_DEFAULT_COMMAND='rg --files --follow --glob "!.git/*"'
export FZF_DEFAULT_COMMAND='fd --type f'
# export FZF_DEFAULT_OPTS="--reverse --inline-info --exact"
export FZF_DEFAULT_OPTS="--exact"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export RIPGREP_CONFIG_PATH=~/.ripgreprc

export PATH="/usr/local/opt/php@8.1/bin:$PATH"
export PATH="/usr/local/opt/php@8.1/sbin:$PATH"
export LDFLAGS="-L/usr/local/opt/php@8.1/lib"
export CPPFLAGS="-I/usr/local/opt/php@8.1/include"

timenow() {
  node -e "var now = Date.now(); console.log(new Date(now), now)"
}
timewhen() {
  echo -n "when: "; node -e "console.log(new Date(parseInt(\"$1\")))"
  echo -n " now: "; node -e "var now = Date.now(); console.log(new Date(now), now)"
  echo -n " ago: "; node -e "var ago = Date.now() - parseInt(\"$1\"); console.log((Math.abs(ago) / 1000 / 60).toFixed(2), 'minutes ' + (ago > 0 ? 'ago' : 'ahead'))"
}

export DOCKER_CLI_HINTS=false # kill Docker spam ads

eval "$(zoxide init zsh)"
source <(fzf --zsh)

# Bind ctrl-r but not up arrow
eval "$(atuin init zsh --disable-up-arrow)"

cd ~/projects/programs
