fun! hexokinase#highlighters#sign_column#highlightv2(bufnr) abort
    let b:sign_ids = get(b:, 'sign_ids', [])
    for it in getbufvar(a:bufnr, 'hexokinase_colours', [])
        let it['hlname'] = hexokinase#utils#create_fg_hl(it.hex)

        let sign_name = it.hlname . 'sign'
        let sign_id = 4000 + it.lnum
        exe 'sign define ' . sign_name . ' text=' . g:Hexokinase_signIcon . ' texthl=' . it.hlname
        exe 'sign place ' . sign_id . ' line=' . it.lnum . ' name=' . sign_name . ' buffer=' . bufnr('%')

        call add(b:sign_ids, sign_id)
    endfor
endf

fun! hexokinase#highlighters#sign_column#tearDownv2(bufnr) abort
    if !bufexists(a:bufnr)
        return
    endif

    let b:sign_ids = get(b:, 'sign_ids', [])
    for sign_id in b:sign_ids
        exe 'sign unplace ' . sign_id . ' buffer=' . a:bufnr
    endfor

    let b:sign_ids = []
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
