let s:group_prefix = 'hexokinase-sign_column'

fun! s:signs_api_hl(bufnr) abort
    let n = 0
    for it in getbufvar(a:bufnr, 'hexokinase_colours', [])
        let it['hlname'] = hexokinase#utils#create_fg_hl(it.hex)

        let sign_name = it.hlname . 'sign'
        let sign_id = 4000 + n
        let n += 1
        call sign_define(sign_name,
                    \     {
                    \         'text': g:Hexokinase_signIcon,
                    \         'texthl': it.hlname,
                    \     }
                    \ )
        call sign_place(
                    \     sign_id,
                    \     s:group_prefix.string(a:bufnr),
                    \     sign_name,
                    \     a:bufnr,
                    \     { 'lnum': it.lnum }
                    \ )
    endfor
endf

fun! s:signs_api_tear_down(bufnr) abort
    if !bufexists(a:bufnr)
        return
    endif

    call sign_unplace(s:group_prefix.string(a:bufnr))
endf

fun! s:signs_command_hl(bufnr) abort
    let sign_ids = []
    for it in getbufvar(a:bufnr, 'hexokinase_colours', [])
        let it['hlname'] = hexokinase#utils#create_fg_hl(it.hex)

        let sign_name = it.hlname . 'sign'
        let sign_id = 4000 + it.lnum
        exe 'sign define ' . sign_name . ' text=' . g:Hexokinase_signIcon . ' texthl=' . it.hlname
        exe 'sign place ' . sign_id . ' line=' . it.lnum . ' name=' . sign_name . ' buffer=' . a:bufnr

        call add(sign_ids, sign_id)
    endfor
    call setbufvar(a:bufnr, 'sign_ids', sign_ids)
endf

fun! s:signs_command_tear_down(bufnr) abort
    if !bufexists(a:bufnr)
        return
    endif

    let sign_ids = getbufvar(a:bufnr, 'sign_ids', [])
    for sign_id in sign_ids
        exe 'sign unplace ' . sign_id . ' buffer=' . a:bufnr
    endfor

    call setbufvar(a:bufnr, 'sign_ids', [])
endf

fun! hexokinase#highlighters#sign_column#highlightv2(bufnr) abort
    if exists('*sign_place')
        call s:signs_api_hl(a:bufnr)
    else
        call s:signs_command_hl(a:bufnr)
    endif
endf

fun! hexokinase#highlighters#sign_column#tearDownv2(bufnr) abort
    if exists('*sign_place')
        call s:signs_api_tear_down(a:bufnr)
    else
        call s:signs_command_tear_down(a:bufnr)
    endif
endf

fun! hexokinase#highlighters#sign_column#highlight(lnum, hex, hl_name, start, end) abort
    let b:sign_ids = get(b:, 'sign_ids', [])

    let sign_name = a:hl_name . 'sign'
    let sign_id = 4000 + a:lnum
    exe 'sign define ' . sign_name . ' text=' . g:Hexokinase_signIcon . ' texthl=' . a:hl_name
    exe 'sign place ' . sign_id . ' line=' . a:lnum . ' name=' . sign_name . ' buffer=' . bufnr('%')

    call add(b:sign_ids, sign_id)
endf

fun! hexokinase#highlighters#sign_column#tearDown() abort
    call hexokinase#highlighters#sign_column#tearDownv2(bufnr('%'))
endf
