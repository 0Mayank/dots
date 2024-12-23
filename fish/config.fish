zoxide init fish | source
atuin init fish --disable-up-arrow | source
starship init fish | source
direnv hook fish | source

fish_vi_key_bindings

#if set -q TMUX 
#else
#  tmux a 
#end

#bind \cf "tmux-sessionizer"

# if set -q ZELLIJ
# else
#   zellij attach base 
# end

set fish_vi_force_cursor line

# Emulates vim's cursor shape behavior
# Set the normal and visual mode cursors to a block
set fish_cursor_default block 
# Set the insert mode cursor to a line
set fish_cursor_insert line blink 
# Set the replace mode cursor to an underscore
set fish_cursor_replace_one underscore
# The following variable can be used to configure cursor shape in
# visual mode, but due to fish_cursor_default, is redundant here
set fish_cursor_visual block

set -x EDITOR "nvim"
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"
set -x GOPATH "$HOME/.go/"

# Remove fish greeting
set fish_greeting ""

function baptise
  command xattr -dr com.apple.quarantine $argv
end


# Functions needed for !! and !$
function __history_previous_command
  switch (commandline -t)
  case "!"
    commandline -t $history[1]; commandline -f repaint
  case "*"
    commandline -i !
  end
end

function __history_previous_command_arguments
  switch (commandline -t)
  case "!"
    commandline -t ""
    commandline -f history-token-search-backward
  case "*"
    commandline -i '$'
  end
end
# The bindings for !! and !$
if [ $fish_key_bindings = fish_vi_key_bindings ];
  bind -Minsert ! __history_previous_command
  bind -Minsert '$' __history_previous_command_arguments
else
  bind ! __history_previous_command
  bind '$' __history_previous_command_arguments
end

# Start su with fish instead of bash
function su
   command su --shell=/usr/bin/fish $argv
end

# Changing ls to eza
alias ls="eza -la --color=always --group-directories-first --icons"
alias lt="eza -aT --color=always --group-directories-first --icons"
alias ll="eza -l --color=always --group-directories-first --icons"
alias la="eza -a --color=always --group-directories-first --icons"

# Confirm before overwriting
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"

# cd shortcuts
alias cd="z"
alias ..="z .."
alias ...="z ../.."
alias .4="z ../../.."
alias .5="z ../../../.."

# alias snaproot="snapper -c root"
# alias snaphome="snapper -c home"

# Extra flags
alias tree="eza --tree"
alias n="nvim"
alias neofetch="neofetch --source $HOME/.config/neofetch/logo.txt"
alias tl="tldr -s"
alias c="clear"

fish_ssh_agent

# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba init' !!
set -gx MAMBA_EXE "/home/paul/.local/bin/micromamba"
set -gx MAMBA_ROOT_PREFIX "/home/paul/micromamba"
$MAMBA_EXE shell hook --shell fish --root-prefix $MAMBA_ROOT_PREFIX | source
# <<< mamba initialize <<<

function rawdog
  set -gx VCPKG_ROOT "$PWD/.vcpkg"

  set -gx OPENCV_LINK_PATHS "$PWD/lib/linux/libjpeg-turbo/lib,$PWD/lib/linux/opencv/lib,$PWD/lib/linux/opencv/lib/opencv4/3rdparty"

  set -gx OPENCV_INCLUDE_PATHS "$PWD/lib/linux/opencv/include/opencv4"

  set -gx OPENCV_LINK_LIBS "opencv_imgcodecs,opencv_imgproc,opencv_core,liblibjpeg-turbo,liblibtiff,zlib"
end
