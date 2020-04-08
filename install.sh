#!/usr/bin/env bash

set -o nounset # error when referencing undefined variable
set -o errexit # exit when command fails

# Check command is installed
if [ ! -x "$(command -v curl)" ]; then
    echo 'please install curl'
    exit
fi
if [ ! -x "$(command -v tar)" ]; then
    echo 'please install tar'
    exit
fi
if [ ! -x "$(command -v git)" ]; then
    echo 'please install git'
    exit
fi

# ************ install rust programming language **************
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
export PATH="$HOME/.cargo/bin:$PATH"
# ************** install stable rust component ****************
rustup component add rustfmt
rustup component add clippy
rustup component add rls
rustup component add rust-src
rustup component add rust-analysis
rustup component add llvm-tools-preview
# *********** install vscode extension rust language **********
if [ -x "$(command -v code)" ]; then
    echo 'install vscode extension rust language'
    # extension for code completion, Intellisense, refactoring, reformatting, errors, snippets
    code --install-extension rust-lang.rust
    # extension for set of snippets for the Rust programming language
    code --install-extension polypus74.trusty-rusty-snippets
    # extension for Helps Rust developers managing dependencies with Cargo.toml
    code --install-extension serayuzgur.crates
    # extension for syntax highlighting
    code --install-extension dunstontc.vscode-rust-syntax
fi
# *********** install neovim plugins rust language **********
echo 'install vim/neovim plugins rust language'
# Install latest nodejs
if [ ! -x "$(command -v node)" ]; then
    echo 'install nodejs'
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
    nvm install node
fi
# Install yarn
if [ ! -x "$(command -v yarn)" ]; then
    echo 'install yarn'
    npm install -g yarn
fi
# Use package feature to install coc.nvim
echo 'download and uncompress coc.nvim'
curl --fail -L https://github.com/neoclide/coc.nvim/archive/release.tar.gz | tar xzfv -
# For neovim directory
DIR_NEOVIM=~/.local/share/nvim/site/pack/coc/start
# For vim directory
DIR_VIM=~/.vim/pack/coc/start
DIRS=($DIR_NEOVIM $DIR_VIM)
for DIR in "${DIRS[@]}"; do
    mkdir -p $DIR
    cp -rf coc.nvim-release $DIR
done
rm -rf coc.nvim-release
# for DIR in "${DIRS[@]}"; do
#     cd $DIR/coc.nvim-release && ./install.sh nightly
# done
# Install extensions
echo 'install coc.nvim extensions'
mkdir -p ~/.config/coc/extensions
cd ~/.config/coc/extensions
if [ ! -f package.json ]; then
    echo '{"dependencies":{}}' >package.json
fi
# Rust language server extension
yarn add coc-rls --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod
# Json language server extension
yarn add coc-json --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod
# snippets solution for coc.nvim
yarn add coc-snippets --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod
# provide default highlight for coc.nvim
yarn add coc-highlight --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod
# YAML support for vim/neovim
yarn add coc-yaml --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod

# install rust.vim
echo 'install rust.vim'
git clone https://github.com/rust-lang/rust.vim
DIR_NEOVIM=~/.local/share/nvim/site/pack/rust.vim/start/
# For vim user
DIR_VIM=~/.vim/pack/rust.vim/start/
DIRS=($DIR_NEOVIM $DIR_VIM)
for DIR in "${DIRS[@]}"; do
    mkdir -p $DIR
    cp -rf rust.vim $DIR
done
rm -rf rust.vim

# install webapi-vim need web api interface for RustPlay command vim/neovim
echo 'install webapi-vim'
git clone https://github.com/mattn/webapi-vim
DIR_NEOVIM=~/.local/share/nvim/site/pack/webapi-vim/start/
# For vim user
DIR_VIM=~/.vim/pack/webapi-vim/start/
DIRS=($DIR_NEOVIM $DIR_VIM)
for DIR in "${DIRS[@]}"; do
    mkdir -p $DIR
    cp -rf webapi-vim $DIR
done
rm -rf webapi-vim

# disable script option
set +o errexit
set +o nounset

# ****************** install cargo subcommands ******************
echo 'install cargo subcommands'
cargo install cargo-fix
cargo install cargo-bloat
cargo install cargo-asm
cargo install cargo-outdated
cargo install cargo-edit
cargo install cargo-audit
cargo install cargo-expand
cargo install cargo-tree # or cargo-modules
cargo install cargo-update
cargo install cargo-watch
cargo install cargo-vendor
cargo install cargo-make
cargo install rusty-tags
# **************** install rust nightly version *****************
rustup toolchain install nightly
# set default rust toolchain to nightly version
rustup default nightly
# ************** install nightly rust component *****************
rustup component add rustfmt
rustup component add clippy
rustup component add rls
rustup component add rust-src
rustup component add rust-analysis
rustup component add llvm-tools-preview
# ************* install racer for rust code completion **********
cargo install racer
# ************************* set RUST_SRC_PATH ******************************
fish_config="$HOME/.config/fish/config.fish"
bash_config="$HOME/.bashrc"
zsh_config="$HOME/.zshrc"
if [ -f $bash_config ] && ! grep -Fxq "export RUST_SRC_PATH=\$(rustc --print sysroot)/lib/rustlib/src/rust/src" $bash_config; then
    echo "export RUST_SRC_PATH=\$(rustc --print sysroot)/lib/rustlib/src/rust/src" >>$bash_config
fi
if [ -f $zsh_config ] && ! grep -Fxq "export RUST_SRC_PATH=\$(rustc --print sysroot)/lib/rustlib/src/rust/src" $zsh_config; then
    echo "export RUST_SRC_PATH=\$(rustc --print sysroot)/lib/rustlib/src/rust/src" >>$zsh_config
fi
if [ -f $fish_config ] && ! grep -Fxq "set -x RUST_SRC_PATH (rustc --print sysroot)/lib/rustlib/src/rust/src" $fish_config; then
    echo "set -x RUST_SRC_PATH (rustc --print sysroot)/lib/rustlib/src/rust/src" >>$fish_config
fi
export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
# *********************** set alias uprust for update **********************
if [ -f $bash_config ] && ! grep -Fxq 'alias uprust="rustup update && cargo install-update -a"' $bash_config; then
    echo 'alias uprust="rustup update && cargo install-update -a"' >>$bash_config
fi
if [ -f $zsh_config ] && ! grep -Fxq 'alias uprust="rustup update && cargo install-update -a"' $zsh_config; then
    echo 'alias uprust="rustup update && cargo install-update -a"' >>$zsh_config
fi
if [ -f $fish_config ] && ! grep -Fxq 'alias uprust="rustup update && cargo install-update -a"' $fish_config; then
    echo 'alias uprust="rustup update && cargo install-update -a"' >>$fish_config
fi
# ******************* useful rust command line tools *********************
if [ "$1" == "all" ]; then
    echo 'install useful rust command line tools'
    cargo install bat # or fcat
    cargo install lsd # or exa
    cargo install fd-find
    cargo install bingrep
    cargo install ripgrep
    cargo install watchexec
    cargo install hyperfine
    cargo install miniserve
    cargo install topgrade
    cargo install mdbook
    cargo install skim
    cargo install broot
    cargo install fselect
    cargo install tokei
    cargo install ffsend
    cargo install sd
    cargo install peep
fi
# ************************** finish install ******************************
echo '
-----------------------------------------------
|       for update rust and other tools       |
| run command $ uprust after restart terminal |
|           install finish enjoy ;)           |
-----------------------------------------------
              \
               \
                 _~^~^~_
             \) /  o o  \ (/
               "_   -   _"
              // "-----" \\'
