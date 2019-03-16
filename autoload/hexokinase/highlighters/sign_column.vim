fun! hexokinase#highlighters#sign_column#highlight(lnum, hex, hl_name) abort
  let b:sign_ids = get(b:, 'sign_ids', [])

  let sign_name = a:hl_name . 'sign'
  let sign_id = 4000 + a:lnum
  exe 'sign define ' . sign_name . ' text=' . g:hexokinase.sign_icon . ' texthl=' . a:hl_name
  exe 'sign place ' . sign_id . ' line=' . a:lnum . ' name=' . sign_name . ' file=' . expand('%:p')

  call add(b:sign_ids, sign_id)
endf

fun! hexokinase#highlighters#sign_column#tearDown() abort
  for sign_id in b:sign_ids
    exe 'sign unplace ' . sign_id . ' file=' . expand('%:p')
  endfor

  let b:sign_ids = []
endf
