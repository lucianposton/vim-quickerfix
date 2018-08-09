# quickerfix.vim

Adds a few useful features and hotkeys to quickfix and location list windows.
Press `?` while in a quickfix window to bring up the list of hotkeys.

## Installation

Install using your favorite package manager, or use Vim's built-in package
support:

    mkdir -p ~/.vim/pack/foobar/start
    cd ~/.vim/pack/foobar/start
    git clone https://github.com/lucianposton/vim-quickerfix.git
    vim -u NONE -c "helptags vim-quickerfix/doc" -c q

## Usage

Press `?` while after opening the quickfix windows, `:copen`, to see the full
list of hotkeys and their features. Some of the hotkeys from the
[help text](doc/quickerfix_quick_help.txt) are listed below.

* ↳: Open selected result
* o: Open, keep focus on results
* O: Open, close the results
* t: Open in new tab
* T: Open in new tab, keep focus on results
* h: Open in h-split
* gh: Open in h-split, keep focus on results
* v: Open in v-split
* gv: Open in v-split, keep focus on results
* [: Go to older error list
* ]: Go to newer error list
