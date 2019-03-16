let s:namespace = nvim_create_namespace('')

fun! hexokinase#highlighters#virtual#highlight(lnum, hex, hl_name) abort
  if has('nvim')
    call nvim_buf_set_virtual_text(
          \   bufnr('%'),
          \   s:namespace,
          \   a:lnum - 1,
          \   [[g:hexokinase.virtual_text, a:hl_name]],
          \   {}
          \ )
  endif
endf

fun! hexokinase#highlighters#virtual#tearDown() abort
  if has('nvim')
    call nvim_buf_clear_namespace(bufnr('%'), s:namespace, 0, -1)
  endif
endf
