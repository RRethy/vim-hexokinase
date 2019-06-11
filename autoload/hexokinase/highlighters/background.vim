fun! hexokinase#highlighters#background#highlightv2(bufnr, lnum, hex, hl_name, start, end) abort
    if a:bufnr != bufnr('%')
        return
    endif

    let b:bg_match_ids = get(b:, 'bg_match_ids', [])
    let bg_hl_name = 'background'.a:hl_name
    exe 'hi '.bg_hl_name.' guibg='.a:hex.' guifg='.a:hex
    if getline(a:lnum)[a:end - 1] ==# ')'
        let [_, _, first_char] = matchstrpos(getline(a:lnum), '(', a:start)
        call add(b:bg_match_ids, matchaddpos(bg_hl_name, [[a:lnum, first_char, 1], [a:lnum, a:end, 1]]))
    else
        call add(b:bg_match_ids, matchaddpos(bg_hl_name, [[a:lnum, a:start, 1]]))
    endif
    augroup hexokinase_background_autocmds
        autocmd!
        autocmd BufHidden * call hexokinase#highlighters#background#tearDown()
    augroup END
endf

fun! hexokinase#highlighters#background#tearDownv2(bufnr) abort
    if a:bufnr != bufnr('%')
        return
    endif

    augroup hexokinase_background_autocmds
        autocmd!
    augroup END
    let b:bg_match_ids = get(b:, 'bg_match_ids', [])
    for id in b:bg_match_ids
        try
            call matchdelete(id)
        catch /\v(E803|E802)/
        endtry
    endfor
    let b:bg_match_ids = []
endf

fun! hexokinase#highlighters#background#highlight(lnum, hex, hl_name, start, end) abort
    call hexokinase#highlighters#background#highlightv2(bufnr('%'), a:lnum, a:hex, a:hl_name, a:start, a:end)
endf

fun! hexokinase#highlighters#background#tearDown() abort
    call hexokinase#highlighters#background#tearDownv2(bufnr('%'))
endf
