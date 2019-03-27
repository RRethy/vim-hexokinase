fun! hexokinase#highlighters#foreground#highlight(lnum, hex, hl_name, start, end) abort
  let b:fg_match_ids = get(b:, 'fg_match_ids', [])
  if getline(a:lnum)[a:end - 1] == ')'
    let [_, _, first_char] = matchstrpos(getline(a:lnum), '(', a:start)
    call add(b:fg_match_ids, matchaddpos(a:hl_name, [[a:lnum, first_char, 1], [a:lnum, a:end, 1]]))
  else
    call add(b:fg_match_ids, matchaddpos(a:hl_name, [[a:lnum, a:start, 1]]))
  endif
endf

fun! hexokinase#highlighters#foreground#tearDown() abort
  let b:fg_match_ids = get(b:, 'fg_match_ids', [])
  for id in b:fg_match_ids
    call matchdelete(id)
  endfor
endf
