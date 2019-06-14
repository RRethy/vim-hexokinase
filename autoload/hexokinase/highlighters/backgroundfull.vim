fun! hexokinase#highlighters#backgroundfull#highlightv2(bufnr, lnum, hex, hl_name, start, end) abort
    if a:bufnr != bufnr('%')
        return
    endif

    let b:bg_full_match_ids = get(b:, 'bg_full_match_ids', [])
    let bg_hl_name = 'backgroundfull'.a:hl_name
    exe 'hi '.bg_hl_name.' guibg='.a:hex.' guifg=NONE'
    call add(b:bg_full_match_ids, matchaddpos(bg_hl_name, [[a:lnum, a:start, a:end - a:start + 1]]))
    augroup hexokinase_backgroundfull_autocmds
        autocmd!
        autocmd BufHidden * call hexokinase#highlighters#backgroundfull#tearDown()
    augroup END
endf

fun! hexokinase#highlighters#backgroundfull#tearDownv2(bufnr) abort
    if a:bufnr != bufnr('%')
        return
    endif

    augroup hexokinase_backgroundfull_autocmds
        autocmd!
    augroup END
    let b:bg_full_match_ids = get(b:, 'bg_full_match_ids', [])
    for id in b:bg_full_match_ids
        try
            call matchdelete(id)
        catch /\v(E803|E802)/
        endtry
    endfor
    let b:bg_full_match_ids = []
endf

fun! hexokinase#highlighters#backgroundfull#highlight(lnum, hex, hl_name, start, end) abort
    call hexokinase#highlighters#backgroundfull#highlightv2(bufnr('%'), a:lnum, a:hex, a:hl_name, a:start, a:end)
endf

fun! hexokinase#highlighters#backgroundfull#tearDown() abort
    call hexokinase#highlighters#backgroundfull#tearDownv2(bufnr('%'))
endf
