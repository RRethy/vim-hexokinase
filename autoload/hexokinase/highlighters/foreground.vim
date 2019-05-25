fun! hexokinase#highlighters#foreground#highlightv2(bufnr, lnum, hex, hl_name, start, end) abort
	if a:bufnr != bufnr('%')
		return
	endif

	let b:fg_match_ids = get(b:, 'fg_match_ids', [])
	if getline(a:lnum)[a:end - 1] ==# ')'
		let [_, _, first_char] = matchstrpos(getline(a:lnum), '(', a:start)
		call add(b:fg_match_ids, matchaddpos(a:hl_name, [[a:lnum, first_char, 1], [a:lnum, a:end, 1]]))
	else
		call add(b:fg_match_ids, matchaddpos(a:hl_name, [[a:lnum, a:start, 1]]))
	endif
	augroup hexokinase_foreground_autocmds
		autocmd!
		autocmd BufHidden * call hexokinase#highlighters#foreground#tearDown()
	augroup END
endf

fun! hexokinase#highlighters#foreground#tearDownv2(bufnr) abort
	if a:bufnr != bufnr('%')
		return
	endif

	augroup hexokinase_foreground_autocmds
		autocmd!
	augroup END
	let b:fg_match_ids = get(b:, 'fg_match_ids', [])
	for id in b:fg_match_ids
		try
			call matchdelete(id)
		catch /\v(E803|E802)/
		endtry
	endfor
	let b:fg_match_ids = []
endf

fun! hexokinase#highlighters#foreground#highlight(lnum, hex, hl_name, start, end) abort
	call hexokinase#highlighters#foreground#highlightv2(bufnr('%'), a:lnum, a:hex, a:hl_name, a:start, a:end)
endf

fun! hexokinase#highlighters#foreground#tearDown() abort
	call hexokinase#highlighters#foreground#tearDownv2(bufnr('%'))
endf
