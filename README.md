dotfiles
========

Hello.

For neovim, you likely need these:

    brew install tree-sitter
    npm install -g typescript typescript-language-server diagnostic-languageserver eslint_d prettier

For neovide, the app itself doesn't like to open.

1. Drag it to /Applications.
2. Right-click to open it.
3. Right-click to open it again.
4. `sudo ln -s /Applications/Neovide.app/Contents/MacOS/neovide /opt/homebrew/bin/neovide`
5. `neovide`

Neovide seems touchy about fonts. Ensure your `guifont` is set to the exact correct name of the font and that the font is definitely a monospaced variant (even if the font itself is monospaced always (Iosevka)).
