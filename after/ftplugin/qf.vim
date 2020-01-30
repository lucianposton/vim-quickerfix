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
                \ "ih": ":call <SID>splitMove(0,0,0)<CR>",
                \ "gih": ":call <SID>splitMove(0,1,0)<CR>",
                \ "v": "<C-W><CR><C-W>L<C-W>p<C-W>J<C-W>p",
                \ "gv": "<C-W><CR><C-W>L<C-W>p<C-W>J",
                \ "iv": ":call <SID>splitMove(1,0,0)<CR>",
                \ "giv": ":call <SID>splitMove(1,1,0)<CR>",
                \ "[": ":colder<CR>",
                \ "]": ":cnewer<CR>",
                \ "q": ":cclose<CR>",
                \ "?": ":call <SID>quickerfixHelp()<CR>" }

    let s:quickerfix_loc_hotkeys = {
                \ "o": "<CR><C-W>p",
                \ "O": "<CR>:lclose<CR>",
                \ "t": "<C-W><CR><C-W>T",
                \ "T": "<C-W><CR><C-W>TgT<C-W>j",
                \ "h": ":aboveleft split+<C-R>=line('.')<CR>ll<CR>",
                \ "gh": ":aboveleft split+<C-R>=line('.')<CR>ll<CR><C-W>p",
                \ "ih": ":call <SID>splitMove(0,0,0)<CR>",
                \ "gih": ":call <SID>splitMove(0,1,0)<CR>",
                \ "v": ":call <SID>splitMove(1,0,'k')<CR>",
                \ "gv": ":call <SID>splitMove(1,1,'k')<CR>",
                \ "iv": ":call <SID>splitMove(1,0,0)<CR>",
                \ "giv": ":call <SID>splitMove(1,1,0)<CR>",
                \ "[": ":lolder<CR>",
                \ "]": ":lnewer<CR>",
                \ "q": ":lclose<CR>",
                \ "?": ":call <SID>quickerfixHelp()<CR>" }

    function s:splitMove(vertical, keep_qf_active, split_dir) abort
        if !has("patch-8.1.2020")
            echoerr "vim-8.1.2020 or later is required for this function"
            return
        endif
        let l:flags = {}
        let l:flags.vertical = a:vertical
        let l:last_win_id=win_getid(winnr('#'))
        let l:qf_win_id=win_getid()
        exec "normal! \<C-W>\<CR>"
        if empty(a:split_dir)
            call win_splitmove(winnr(), win_id2win(l:last_win_id), l:flags)
        else
            let l:target_win = winnr(a:split_dir)
            if l:target_win == 0 || l:target_win == winnr()
                " new window will appear above, and since we only need to
                " handle a:split_dir=='k' for now, noop
            else
                call win_splitmove(winnr(), l:target_win, l:flags)
            endif
        endif
        let l:new_win_id=win_getid()
        if a:keep_qf_active
            call win_gotoid(l:last_win_id)
            call win_gotoid(l:qf_win_id)
        else
            call win_gotoid(l:qf_win_id)
            call win_gotoid(l:new_win_id)
        endif
    endfunction

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
