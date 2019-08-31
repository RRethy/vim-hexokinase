augroup hexokinase_background_autocmds
    autocmd!
    " TODO figure out how many of these can be cut down on
    autocmd BufEnter,BufWinEnter,WinNew,TabNew,BufNew,BufAdd * call s:showhl()
augroup END

fun! s:showhl() abort
    call s:hidehl()
    for it in get(b:, 'hexokinase_colours', [])
        if has_key(it, 'bg_check')
            let id = matchaddpos(it.hlname, it.positions)
            call add(w:hexokinase_bg_match_ids, id)
        endif
    endfor
endf

fun! s:hidehl() abort
    for it in get(w:, 'hexokinase_bg_match_ids', [])
        try
            call matchdelete(it)
        catch /\v(E803|E802)/
        endtry
    endfor
    let w:hexokinase_bg_match_ids = []
endf

fun! hexokinase#highlighters#background#highlightv2(bufnr) abort
    for it in getbufvar(a:bufnr, 'hexokinase_colours', [])
        let buflines = getbufline(a:bufnr, it.lnum)
        if len(buflines) == 0
            continue
        endif

        let line = buflines[0]
        if line[it.end - 1] ==# ')'
            let [_, _, first_char] = matchstrpos(line, '(', it.start)
            let it['positions'] = [[it.lnum, first_char, 1], [it.lnum, it.end, 1]]
        elseif line[it.start - 1] ==# '#'
            let it['positions'] = [[it.lnum, it.start, 1]]
        else
            let it['positions'] = [[it.lnum, it.start, it.end - it.start + 1]]
        endif

        let it['hlname'] = hexokinase#utils#create_bg_hl(it.hex)
        let it['bg_check'] = 1
    endfor

    if a:bufnr == bufnr('%')
        call s:showhl()
    endif
endf

fun! hexokinase#highlighters#background#tearDownv2(bufnr) abort
    let b:hexokinase_colours = []
    if a:bufnr == bufnr('%')
        call s:hidehl()
    endif
endf

fun! hexokinase#highlighters#background#highlight(lnum, hex, hl_name, start, end) abort
    let b:bg_match_ids = get(b:, 'bg_match_ids', [])
    let bg_hl_name = 'background'.a:hl_name
    exe 'hi '.bg_hl_name.' guibg='.a:hex.' guifg=NONE'
    if getline(a:lnum)[a:end - 1] ==# ')'
        let [_, _, first_char] = matchstrpos(getline(a:lnum), '(', a:start)
        call add(b:bg_match_ids, matchaddpos(bg_hl_name, [[a:lnum, first_char, 1], [a:lnum, a:end, 1]]))
    elseif getline(a:lnum)[a:start - 1] ==# '#'
        call add(b:bg_match_ids, matchaddpos(bg_hl_name, [[a:lnum, a:start, 1]]))
    else
        call add(b:bg_match_ids, matchaddpos(bg_hl_name, [[a:lnum, a:start, a:end - a:start + 1]]))
    endif
endf

fun! hexokinase#highlighters#background#tearDown() abort
    let b:bg_match_ids = get(b:, 'bg_match_ids', [])
    for id in b:bg_match_ids
        try
            call matchdelete(id)
        catch /\v(E803|E802)/
        endtry
    endfor
    let b:bg_match_ids = []
endf
