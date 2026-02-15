# ===== Aliases =====
alias ll="ls -la"
alias python="python3"
alias aws_id="aws sts get-caller-identity --query 'Account' --output text"
alias wp-env-noproxy="env -u HTTP_PROXY -u HTTPS_PROXY -u http_proxy -u https_proxy wp-env"

# ===== Environment =====
export EDITOR="vim"
# Proxy/Noproxy
export NO_PROXY="localhost,127.0.0.1,::1,wordpress.org,*.wordpress.org,wordpress.net,*.wordpress.net,gravatar.com,*.gravatar.com"
export no_proxy="$NO_PROXY"
## Docker default platform (Apple Silicon などでの互換向上)
#export DOCKER_DEFAULT_PLATFORM="linux/amd64"
# PATH（先頭にユーザー領域）
if [ -d "$HOME/.local/bin" ]; then
  export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
if [ -d /opt/homebrew/opt/php@8.3 ]; then
  export PATH="/opt/homebrew/opt/php@8.3/bin:$PATH"
  export PATH="/opt/homebrew/opt/php@8.3/sbin:$PATH"
fi
export PATH=$HOME/.nodebrew/current/bin:$PATH
#source ~/.safe-chain/scripts/init-posix.sh # Safe-chain Zsh initialization script
if [ -f "$HOME/.local-environment-variables" ]; then
  source "$HOME/.local-environment-variables"
fi

# ===== MySQL Client =====
if [ -d /opt/homebrew/opt/mysql-client ]; then
  export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
  export LDFLAGS="-L/opt/homebrew/opt/mysql-client/lib"
  export CPPFLAGS="-I/opt/homebrew/opt/mysql-client/include"
  export PKG_CONFIG_PATH="/opt/homebrew/opt/mysql-client/lib/pkgconfig"
fi

# ===== Homebrew がある場合のみ macOS 向け設定 =====
if type brew &>/dev/null; then
  # zsh-completions を compinit より前に fpath へ（先頭に追加）
  fpath=("$(brew --prefix)/share/zsh-completions" $fpath)
fi

# ==== git-prompt =====
# https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
if [ -f $HOME/.zsh/git-prompt.sh ]; then
  source $HOME/.zsh/git-prompt.sh

  GIT_PS1_SHOWDIRTYSTATE=true
  GIT_PS1_SHOWUNTRACKEDFILES=true
  GIT_PS1_SHOWSTASHSTATE=true
  GIT_PS1_SHOWUPSTREAM=auto

  setopt PROMPT_SUBST ; PS1='%F{green}%n@%m%f: %F{cyan}%~%f %F{red}$(__git_ps1 "(%s)")%f \$ '
fi

# ===== Completion (compinit) =====
autoload -Uz compinit
# 生成場所を明示＆キャッシュ活用
compinit -d ~/.zcompdump
# よく使う補完チューニング
zmodload zsh/complist
# 大文字小文字無視、部分一致を少し甘めに
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' 'r:|[._-]=* r:|=*'
# 候補をグルーピング&メニュー選択
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select
# 新規コマンドを自動で拾う
zstyle ':completion:*' rehash true

# ===== Plugins =====
# autosuggestions（compinit の後に読み込む）
if type brew &>/dev/null && [ -f "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  # 使い勝手UP：確定キーや戦略の調整（お好みで）
  # bindkey '^ ' autosuggest-accept   # Ctrl+Space で確定（例）
  # ZSH_AUTOSUGGEST_STRATEGY=(history completion)
fi

# syntax-highlighting（最後に読むのが鉄則・任意）
if type brew &>/dev/null && [ -f "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
  source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# ===== direnv =====
eval "$(direnv hook zsh)"

# ===== cursor-agent =====
#if [ -f "$HOME/.local/bin/cursor-agent" ]; then
#  eval "$($HOME/.local/bin/cursor-agent shell-integration zsh)"
#fi

# ===== codex =====
if command -v codex >/dev/null 2>&1; then
  eval "$(codex completion zsh)"
fi 

# ===== Useful options =====
#setopt auto_cd             # `cd` を省略してパスだけで移動
setopt extended_glob       # 高機能グロブ
setopt no_beep             # ビープ音オフ
setopt complete_aliases    # エイリアスにも補完を効かせる

# ===== ヒストリ設定 =====
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000
setopt hist_ignore_dups share_history

# Added by Antigravity
if [ -d ~/.antigravity/antigravity/bin ]; then
  export PATH="~/.antigravity/antigravity/bin:$PATH"
fi

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"
