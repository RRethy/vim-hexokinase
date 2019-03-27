fun! hexokinase#highlighters#background#highlight(lnum, hex, hl_name, start, end) abort
  let b:bg_match_ids = get(b:, 'bg_match_ids', [])
  let bg_hl_name = 'background'.a:hl_name
  exe 'hi '.bg_hl_name.' guibg='.a:hex.' guifg='.a:hex
  if getline(a:lnum)[a:end - 1] == ')'
    let [_, _, first_char] = matchstrpos(getline(a:lnum), '(', a:start)
    call add(b:bg_match_ids, matchaddpos(bg_hl_name, [[a:lnum, first_char, 1], [a:lnum, a:end, 1]]))
  else
    call add(b:bg_match_ids, matchaddpos(bg_hl_name, [[a:lnum, a:start, 1]]))
  endif
endf

fun! hexokinase#highlighters#background#tearDown() abort
  let b:bg_match_ids = get(b:, 'bg_match_ids', [])
  for id in b:bg_match_ids
    call matchdelete(id)
  endfor
endf
