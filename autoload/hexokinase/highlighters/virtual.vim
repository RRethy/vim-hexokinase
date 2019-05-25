if exists('*nvim_create_namespace')
	let s:namespace = nvim_create_namespace('')
else
	echoerr 'virtual highlighting only works with Neovim v0.3.2 - please upgrade'
endif

fun! hexokinase#highlighters#virtual#highlightv2(bufnr, lnum, hex, hl_name, start, end) abort
	if exists('*nvim_buf_set_virtual_text')
		call nvim_buf_set_virtual_text(
					\   a:bufnr,
					\   s:namespace,
					\   a:lnum - 1,
					\   [[g:Hexokinase_virtualText, a:hl_name]],
					\   {}
					\ )
	endif
endf

fun! hexokinase#highlighters#virtual#tearDownv2(bufnr) abort
	if exists('*nvim_buf_clear_namespace')
		call nvim_buf_clear_namespace(a:bufnr, s:namespace, 0, -1)
	endif
endf

fun! hexokinase#highlighters#virtual#highlight(lnum, hex, hl_name, start, end) abort
	call hexokinase#highlighters#virtual#highlightv2(bufnr('%'), a:lnum, a:hex, a:hl_name, a:start, a:end)
endf

fun! hexokinase#highlighters#virtual#tearDown() abort
	call hexokinase#highlighters#virtual#highlightv2(bufnr('%'))
endf
