# --- Powerlevel10k Instant Prompt ---
# 起動高速化のため、ファイルの先頭に記述してください
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${USER}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${USER}.zsh"
fi

# --- anyenv / nodenv / jenv ---
# 既存の設定を整理して集約 
if command -v anyenv 1>/dev/null 2>&1; then
  eval "$(anyenv init -)"
fi

# --- Theme Setup ---
source ~/powerlevel10k/powerlevel10k.zsh-theme

# --- Environment Variables ---
export LIBRARY_PATH=$LIBRARY_PATH:/opt/homebrew/Cellar/openssl@3/3.0.7/lib
export LDFLAGS="-L/opt/homebrew/opt/openssl@3/lib"
export CPPFLAGS="-I/opt/homebrew/opt/openssl@3/include"
export JAVA_HOME=/Library/Java/JavaVirtualMachines/amazon-corretto-17.jdk/Contents/Home

# Path設定の整理 
export PATH=$PATH:$HOME/.jenv/bin:/opt/homebrew/opt/openssl@3/bin:/opt/homebrew/opt/libpq/bin:$HOME/android/flutter/bin:$HOME/android/cmdline-tools/bin

# pnpm [cite: 6]
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# --- Aliases & Keybinds ---
alias gitl='git log --graph'
alias gitla='git log --graph --all'
alias gits='git log --stat'
# ローカルブランチで squash & merge した分を削除する
alias gb-clean="git fetch -p && git branch -vv | grep ': gone]' | awk '{print \$1}' | xargs -r git branch -D"
alias gb-purge="git branch | grep -v '^\*' | grep -v 'main' | xargs -I % git branch -D %"

bindkey -e
bindkey "^P" up-line-or-history
bindkey "^N" down-line-or-history

# --- p10k Config ---
# 設定ファイル（後述のセットアップで作成されます）があれば読み込む
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
