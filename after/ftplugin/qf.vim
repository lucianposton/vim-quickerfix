" Quickerfix - quickfix, but quicker
"
" Largely inspired from these other plugins:
" https://github.com/romainl/vim-qf/blob/master/after/ftplugin/qf.vim
" https://github.com/mileszs/ack.vim/blob/master/autoload/ack.vim
"
" Open quickix (:copen), and press ? for the help screen


if !exists("s:quickerfix_hotkeys")
    let s:quickerfix_hotkeys = {
                \ "o": "<CR><C-W>p",
                \ "O": "<CR>:cclose<CR>",
                \ "t": "<C-W><CR><C-W>T",
                \ "T": "<C-W><CR><C-W>TgT<C-W>j",
                \ "h": ":aboveleft split+<C-R>=line('.')<CR>cc<CR>",
                \ "gh": ":aboveleft split+<C-R>=line('.')<CR>cc<CR><C-W>p",
                \ "v": "<C-W><CR><C-W>L<C-W>p<C-W>J<C-W>p",
                \ "gv": "<C-W><CR><C-W>L<C-W>p<C-W>J",
                \ "[": ":colder<CR>",
                \ "]": ":cnewer<CR>",
                \ "q": ":cclose<CR>",
                \ "?": ":call <SID>quickerfixHelp()<CR>" }

    " https://github.com/vim/vim/pull/3220 for better v/gv implementation
    let s:quickerfix_loc_hotkeys = {
                \ "o": "<CR><C-W>p",
                \ "O": "<CR>:lclose<CR>",
                \ "t": "<C-W><CR><C-W>T",
                \ "T": "<C-W><CR><C-W>TgT<C-W>j",
                \ "h": ":aboveleft split+<C-R>=line('.')<CR>ll<CR>",
                \ "gh": ":aboveleft split+<C-R>=line('.')<CR>ll<CR><C-W>p",
                \ "v": "<C-W><CR>:let bnqf=bufnr('%')<CR>:hide<CR><C-W>p<C-W>k:vert sb <C-r>=bnqf<CR><CR><C-W>j<CR>",
                \ "gv": "<C-W><CR>:let bnqf=bufnr('%')<CR>:hide<CR><C-W>p<C-W>k:vert sb <C-r>=bnqf<CR><CR><C-W>j<CR><C-W>p",
                \ "[": ":lolder<CR>",
                \ "]": ":lnewer<CR>",
                \ "q": ":lclose<CR>",
                \ "?": ":call <SID>quickerfixHelp()<CR>" }

    function s:isLoclist(...) abort
        let l:winnr = a:0 ? a:1 : winnr()
        let l:info = filter(getwininfo(), {i,v -> v.winnr == l:winnr})[0]
        return l:info.quickfix && l:info.loclist
    endfunction

    function s:quickerfix(isLoc)
        if a:isLoc
            lopen
        else
            botright copen
        endif
        call <SID>quickerfixSetup()
        "redraw!
    endfunction

    function s:quickerfixSetup()
        let b:isLoc = <SID>isLoclist()
        if !b:isLoc
            wincmd J
        endif

        let l:hotkeys = b:isLoc ? s:quickerfix_loc_hotkeys : s:quickerfix_hotkeys
        for key_map in items(l:hotkeys)
            execute printf("nnoremap <buffer> <nowait> <silent> %s %s", get(key_map, 0), get(key_map, 1))
        endfor

        setlocal number norelativenumber nowrap
        setlocal colorcolumn=
        setlocal nobuflisted
    endfunction

    function s:quickerfixHelp()
        let l:isLoc = b:isLoc
        execute 'view' globpath(&rtp, 'doc/quickerfix_quick_help.txt')
        execute printf("nnoremap <buffer> <nowait> <silent> ? :q!<CR>:call <SID>quickerfix(%s)<CR>", l:isLoc)
        execute printf("nnoremap <buffer> <nowait> <silent> q :q!<CR>:call <SID>quickerfix(%s)<CR>", l:isLoc)

        silent normal gg
        setlocal colorcolumn=
        setlocal buftype=nofile bufhidden=hide nobuflisted
        setlocal nomodifiable noswapfile
        setlocal filetype=help
        setlocal nonumber norelativenumber nowrap
        setlocal foldmethod=diff foldlevel=20
    endfunction
endif

call <SID>quickerfixSetup()
