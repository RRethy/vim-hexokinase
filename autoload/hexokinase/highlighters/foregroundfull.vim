fun! hexokinase#highlighters#foregroundfull#highlightv2(bufnr, lnum, hex, hl_name, start, end) abort
	if a:bufnr != bufnr('%')
		return
	endif

	let b:fg_match_ids = get(b:, 'fg_match_ids', [])
	call add(b:fg_match_ids, matchaddpos(a:hl_name, [[a:lnum, a:start, a:end - a:start + 1]]))
	augroup hexokinase_foregroundfull_autocmds
		autocmd!
		autocmd BufHidden * call hexokinase#highlighters#foreground#tearDown()
	augroup END
endf

fun! hexokinase#highlighters#foregroundfull#tearDownv2(bufnr) abort
	if a:bufnr != bufnr('%')
		return
	endif

	augroup hexokinase_foregroundfull_autocmds
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

fun! hexokinase#highlighters#foregroundfull#highlight(lnum, hex, hl_name, start, end) abort
	call hexokinase#highlighters#foregroundfull#highlightv2(bufnr('%'), a:lnum, a:hex, a:hl_name, a:start, a:end)
endf

fun! hexokinase#highlighters#foregroundfull#tearDown() abort
	call hexokinase#highlighters#foregroundfull#tearDownv2(bufnr('%'))
endf
