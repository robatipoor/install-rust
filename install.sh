#!/usr/bin/env bash

set -o nounset    # error when referencing undefined variable
set -o errexit    # exit when command fails

# ************ install rust programming language **************
curl https://sh.rustup.rs -sSf | sh
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
    code --install-extension rust-lang.rust
    code --install-extension polypus74.trusty-rusty-snippets
    code --install-extension serayuzgur.crates
fi
# *********** install neovim plugins rust language **********
echo 'install vim/neovim plugins rust language'
# Install latest nodejs
if [ ! -x "$(command -v node)" ]; then
    echo 'install nodejs'
    curl --fail -LSs https://install-node.now.sh/latest | sh
    export PATH="/usr/local/bin/:$PATH"
fi

# Install yarn
if [ ! -x "$(command -v yarn)" ]; then
    echo 'install yarn'
    curl --fail -o- -LSs https://yarnpkg.com/install.sh | sh
    export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
fi
# Use package feature to install coc.nvim
echo "install coc.nvim"
git clone https://github.com/neoclide/coc.nvim.git --depth=1
DIR_NEOVIM=~/.local/share/nvim/site/pack/coc/start
# For vim user, the directory is different
DIR_VIM=~/.vim/pack/coc/start
DIRS=( $DIR_NEOVIM $DIR_VIM)
for DIR in "${DIRS[@]}"
do
    mkdir -p $DIR
    cp -rf coc.nvim $DIR
done
rm -rf coc.nvim
for DIR in "${DIRS[@]}"
do
    cd $DIR/coc.nvim && ./install.sh nightly
done
# Install extensions
mkdir -p ~/.config/coc/extensions
cd ~/.config/coc/extensions
if [ ! -f package.json ];then
    echo '{"dependencies":{}}'> package.json
fi
yarn add coc-rls coc-json coc-snippets coc-highlight coc-yaml
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
# set default rust compiler to nightly version
rustup default nightly
# ************** install nightly rust component *****************
rustup component add rustfmt
rustup component add clippy
rustup component add rls
rustup component add rust-src
rustup component add rust-analysis
rustup component add llvm-tools-preview
# ************* install racer for code completion rust **********
cargo install racer
# set environment variable RUST_SRC_PATH
if [ -f "$HOME/.bashrc" ]; then
    echo "export RUST_SRC_PATH=\$(rustc --print sysroot)/lib/rustlib/src/rust/src" >> "$HOME/.bashrc"
fi
if [ -f "$HOME/.zshrc" ]; then
    echo "export RUST_SRC_PATH=\$(rustc --print sysroot)/lib/rustlib/src/rust/src" >> "$HOME/.zshrc"
fi
export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
# ******************* useful rust command line tools *********************
if [ "$1" == "all" ];then
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
    cargo install pf
    cargo install note-rs
fi
# ********************** set alias update rust command *******************
if [ -f "$HOME/.bashrc" ]; then
    echo 'alias uprust="rustup update && cargo install-update -a"' >> "$HOME/.bashrc"
fi
if [ -f "$HOME/.zshrc" ]; then
    echo 'alias uprust="rustup update && cargo install-update -a"' >> "$HOME/.zshrc"
fi
echo 'for update rust and other tools run command $ uprust'
echo 'Install Finish !'
