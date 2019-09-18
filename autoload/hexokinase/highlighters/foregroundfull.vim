let s:isNvim040 = exists('*nvim_buf_add_highlight')
if s:isNvim040
    let s:namespace = nvim_create_namespace('')
endif

if !s:isNvim040
    augroup hexokinase_foregroundfull_autocmds
        autocmd!
        " TODO figure out how many of these can be cut down on
        autocmd BufEnter,BufWinEnter,WinNew,TabNew,BufNew,BufAdd * call s:showhl()
    augroup END

    fun! s:showhl() abort
        call s:hidehl()
        for it in get(b:, 'hexokinase_colours', [])
            if has_key(it, 'fgfull_check')
                let id = matchaddpos(it.hlname, it.positions)
                call add(w:hexokinase_fgfull_match_ids, id)
            endif
        endfor
    endf

    fun! s:hidehl() abort
        for it in get(w:, 'hexokinase_fgfull_match_ids', [])
            try
                call matchdelete(it)
            catch /\v(E803|E802)/
            endtry
        endfor
        let w:hexokinase_fgfull_match_ids = []
    endf
end

fun! hexokinase#highlighters#foregroundfull#highlightv2(bufnr) abort
    for it in getbufvar(a:bufnr, 'hexokinase_colours', [])
        let it['hlname'] = hexokinase#utils#create_fg_hl(it.hex)
        if s:isNvim040
            call nvim_buf_add_highlight(
                        \     a:bufnr,
                        \     s:namespace,
                        \     it.hlname,
                        \     str2nr(it.lnum)-1,
                        \     str2nr(it.start)-1,
                        \     str2nr(it.end)
                        \ )
        else
            let it['positions'] = [[it.lnum, it.start, it.end - it.start + 1]]
            let it['fgfull_check'] = 1
        endif
    endfor

    if a:bufnr == bufnr('%') && !s:isNvim040
        call s:showhl()
    endif
endf

fun! hexokinase#highlighters#foregroundfull#tearDownv2(bufnr) abort
    if s:isNvim040
        if !bufexists(a:bufnr)
            return
        endif

        if exists('*nvim_buf_clear_namespace')
            call nvim_buf_clear_namespace(a:bufnr, s:namespace, 0, -1)
        endif
    else
        let b:hexokinase_colours = []
        if a:bufnr == bufnr('%')
            call s:hidehl()
        endif
    endif
endf

fun! hexokinase#highlighters#foregroundfull#highlight(lnum, hex, hl_name, start, end) abort
    let b:fgfull_match_ids = get(b:, 'fgfull_match_ids', [])
    call add(b:fgfull_match_ids, matchaddpos(a:hl_name, [[a:lnum, a:start, a:end - a:start + 1]]))
endf

fun! hexokinase#highlighters#foregroundfull#tearDown() abort
    let b:fgfull_match_ids = get(b:, 'fgfull_match_ids', [])
    for id in b:fgfull_match_ids
        try
            call matchdelete(id)
        catch /\v(E803|E802)/
        endtry
    endfor
    let b:fgfull_match_ids = []
endf
