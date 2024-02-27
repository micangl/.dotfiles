#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Source the .localrc file
# Idea taken from https://github.com/jmervine/zshrc
[[ -f ~/.localrc ]] && source ~/.localrc

#set -o vi

# Autocompletion (with tab) for git. Should be enabled by default.
#source /usr/share/bash-completion/completions/git

alias sx='startx'
alias ls='ls -l --human-readable --group-directories-first --color=always'
alias grep='grep --color=always'
alias pacman='pacman --color auto'
alias df='df -h -T'
alias less='less -r --mouse'
alias dnvim='nvim -i NONE'
alias config='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

function git-lines() {
    # git ls-files prints a list of all the files in the current working
    # directory (it should be situated in git repository). wc -l prints each
    # file's line counts; piping into it doesn't work, so xargs takes all the
    # file names (separated by a new line) outputted by git and passes them to
    # wc -l in a single line (as if they were manually typed and passed as
    # arguments). The -R switch for neovim makes the contents read-only, and +$
    # goes to the last line (where the total count of code-lines will be).
    git ls-files | xargs wc -l | nvim -R +$
}
export -f git-lines
function git-file-added() {
    # Print the date the file passed as argument was added to the repository.
    git log --follow --format=%ad --date default $1 | tail -1
}
export -f git-file-added
function pac-sizes() {
    # List all installed packages with their size. Append total size.
    # https://wiki.archlinux.org/title/pacman/Tips_and_tricks
    # https://gist.github.com/fsteffenhagen/e09b827430956d7f1de35140111e14c4
    LC_ALL=C pacman -Qi |
    awk '/^Name/{name=$3} /^Installed Size/{print $4$5, name}' |
    sort -h |
    column -t |
    tee /dev/tty |
    numfmt --suffix=B --from=auto |
    awk 'BEGIN {sum=0} {sum=sum+$1} END {printf "%.0f\n", sum}' |
    numfmt --suffix=B --to=iec-i
}
export -f pac-sizes

export HISTCONTROL='ignorespace'
export PATH="/home/$USER/bin:$LOCAL_PATH:$PATH"
export EDITOR="nvim"
export MANPAGER='nvim +Man!'
#export QT_SCALE_FACTOR=1.2
# Makes qt5 applications use qt5ct's (theme manager for qt5 only) theme.
export QT_QPA_PLATFORMTHEME=qt5ct
export QT_FONT_DPI=96
# https://bbs.archlinux.org/viewtopic.php?id=189975
# Remove useless gtk-3 processses used for accessibility.
export NO_AT_BRIDGE=1
export LIBVA_DRI3_DISABLE=1
# Added a color for .md
export LS_COLORS='di=1;94:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=35:*.rpm=90:*.png=35:*.gif=36:*.jpg=35:*.c=92:*.jar=33:*.py=93:*.h=90:*.txt=94:*.doc=104:*.docx=104:*.odt=104:*.csv=102:*.xlsx=102:*.xlsm=102:*.rb=31:*.cpp=92:*.sh=92:*.html=96:*.zip=4;33:*.tar.gz=4;33:*.mp4=105:*.mp3=106:*.md=32'
# Default PS1
#PS1='[\u@\h \W]\$ '
PS1='\[\e[33m\][\[\e[36m\]\u@\h \W\[\e[33m\]]\$ \[\e[0m\]'
