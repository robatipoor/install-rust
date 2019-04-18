#!/usr/bin/env bash

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
    echo 'install rust vscode extension'
    code --install-extension rust-lang.rust
    code --install-extension polypus74.trusty-rusty-snippets
    code --install-extension serayuzgur.crates
fi
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
# ****************************** other tools ***************************
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
echo 'add uprust alias for simple command for update rust'
if [ -f "$HOME/.bashrc" ]; then
    echo 'alias uprust="rustup update && cargo install-update -a"' >> "$HOME/.bashrc"
fi
if [ -f "$HOME/.zshrc" ]; then
    echo 'alias uprust="rustup update && cargo install-update -a"' >> "$HOME/.zshrc"
fi
