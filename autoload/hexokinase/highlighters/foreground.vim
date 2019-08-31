augroup hexokinase_foreground_autocmds
    autocmd!
    " TODO figure out how many of these can be cut down on
    autocmd BufEnter,BufWinEnter,WinNew,TabNew,BufNew,BufAdd * call s:showhl()
augroup END

fun! s:showhl() abort
    call s:hidehl()
    for it in get(b:, 'hexokinase_colours', [])
        if has_key(it, 'fg_check')
            let id = matchaddpos(it.hlname, it.positions)
            call add(w:hexokinase_fg_match_ids, id)
        endif
    endfor
endf

fun! s:hidehl() abort
    for it in get(w:, 'hexokinase_fg_match_ids', [])
        try
            call matchdelete(it)
        catch /\v(E803|E802)/
        endtry
    endfor
    let w:hexokinase_fg_match_ids = []
endf

fun! hexokinase#highlighters#foreground#highlightv2(bufnr) abort
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

        let it['hlname'] = hexokinase#utils#create_fg_hl(it.hex)
        let it['fg_check'] = 1
    endfor

    if a:bufnr == bufnr('%')
        call s:showhl()
    endif
endf

fun! hexokinase#highlighters#foreground#tearDownv2(bufnr) abort
    let b:hexokinase_colours = []
    if a:bufnr == bufnr('%')
        call s:hidehl()
    endif
endf

fun! hexokinase#highlighters#foreground#highlight(lnum, hex, hl_name, start, end) abort
    let b:fg_match_ids = get(b:, 'fg_match_ids', [])
    if getline(a:lnum)[a:end - 1] ==# ')'
        let [_, _, first_char] = matchstrpos(getline(a:lnum), '(', a:start)
        call add(b:fg_match_ids, matchaddpos(a:hl_name, [[a:lnum, first_char, 1], [a:lnum, a:end, 1]]))
    else
        call add(b:fg_match_ids, matchaddpos(a:hl_name, [[a:lnum, a:start, 1]]))
    endif
endf

fun! hexokinase#highlighters#foreground#tearDown() abort
    let b:fg_match_ids = get(b:, 'fg_match_ids', [])
    for id in b:fg_match_ids
        try
            call matchdelete(id)
        catch /\v(E803|E802)/
        endtry
    endfor
    let b:fg_match_ids = []
endf
