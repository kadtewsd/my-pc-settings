# Homebrewのインストール
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# パスを通す (Apple Silicon Mac想定)
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# 開発ツール・GUIアプリのインストール
brew install anyenv vim mysql-client docker-connector postman
brew install --cask tableplus karabiner-elements
brew install --cask visual-studio-code
brew install --cask jetbrains-toolbox

# anyenvの設定
anyenv install --init
mkdir -p $(anyenv root)/plugins
git clone https://github.com/znz/anyenv-update.git $(anyenv root)/plugins/anyenv-update

# nodenv, jenv, pyenv のインストール (zshrcの定義に合わせる)
anyenv install nodenv
anyenv install jenv
anyenv install pyenv
anyenv install rbenv

# 設定の反映
exec $SHELL -l

# mysqlclientのインストール等で必要になるシンボリックリンク
brew link openssl@3 --force

# もし Oh My Zsh を使わない純粋な zsh の場合はこちら
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k

