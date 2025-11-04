# ===================================================================
# POWERLEVEL10K (prompt theme)
# ===================================================================

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# ===================================================================
# ALIASES
# ===================================================================
alias reload-zsh="source ~/.zshrc"
alias edit-zsh="nvim ~/.zshrc"
alias n="nvim"
alias c="clear"
alias f="fastfetch"
alias comboio="sl"
alias ls="eza --icons=always"
alias cd="z"
alias python="python3"

# ===================================================================
# HISTORY SETTINGS
# ===================================================================
HISTSIZE=10000
SAVEHIST=$HISTSIZE
HISTFILE=~/.zsh_history
HISTDUP=erase
setopt appendhistory sharehistory hist_ignore_space hist_ignore_all_dups \
       hist_save_no_dups hist_ignore_dups hist_find_no_dups

# ===================================================================
# PATH CONFIG
# ===================================================================
export PATH="$PATH:/Users/joseanmartinez/.spicetify"
export PATH="$HOME/.rbenv/shims:$PATH"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# ===================================================================
# AUTOSUGGESTIONS + SYNTAX HIGHLIGHTING
# ===================================================================
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ===================================================================
# ZINIT (Plugin manager) - required for ZVM
# ===================================================================
if [[ ! -f ~/.zinit/bin/zinit.zsh ]]; then
  mkdir -p ~/.zinit && git clone https://github.com/zdharma-continuum/zinit.git ~/.zinit/bin
fi
source ~/.zinit/bin/zinit.zsh

# ===================================================================
# ZSH VI MODE (ZVM)
# ===================================================================
zinit light jeffreytse/zsh-vi-mode

export ZVM_VI_EDITOR="nvim"
export EDITOR="nvim"
export VISUAL="nvim"

zvm_bindkey viins '^O' clear-screen
zvm_bindkey vicmd '^O' clear-screen

bindkey -v

# ===================================================================
# COMPLETION
# ===================================================================
autoload -Uz compinit && compinit

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu yes
zstyle ':fzf-tab:*' fzf-min-height 30
zstyle ':fzf-tab:complete:*:*' fzf-preview '~/.config/others/lessfilter.sh $realpath'

# ===================================================================
# FZF + FD + EZA + BAT + ZOXIDE
# ===================================================================
eval "$(zoxide init --cmd cd zsh)"
eval "$(fzf --zsh)"

export FZF_DEFAULT_OPTS="--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"
export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

_fzf_zoxide_cd_final() {
  local dir
  dir=$(zoxide query -l | fzf --height 40% --layout=reverse --border --prompt="Dir: ")
  [[ -n "$dir" ]] && cd "$dir" && zle reset-prompt && clear
}
zle -N _fzf_zoxide_cd_final
bindkey '^F' _fzf_zoxide_cd_final

# ===================================================================
# NVM (Node Version Manager)
# ===================================================================
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# ===================================================================
# YAZI FILE MANAGER
# ===================================================================
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# ===================================================================
# TMUX AUTO-ATTACH
# ===================================================================
if [[ -z "$TMUX" ]]; then
  if tmux list-sessions &> /dev/null; then
    tmux attach
  else
    tmux new-session
  fi
fi
