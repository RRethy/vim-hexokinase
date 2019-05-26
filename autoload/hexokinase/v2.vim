scriptencoding utf-8

fun! hexokinase#v2#setup() abort
   if has('nvim')
      let g:Hexokinase_highlighters = get(g:, 'Hexokinase_highlighters', ['virtual'])
   else
      let g:Hexokinase_highlighters = get(g:, 'Hexokinase_highlighters', ['sign_column'])
   endif

   let g:Hexokinase_virtualText = get(g:, 'Hexokinase_virtualText', '■')
   let g:Hexokinase_signIcon = get(g:, 'Hexokinase_signIcon', '■')

	let g:Hexokinase_optOutPatterns = get(g:, 'Hexokinase_optOutPatterns', '')
	let g:Hexokinase_palettes = get(g:, 'Hexokinase_palettes', [])

   let g:Hexokinase_builtinHighlighters = get(g:, 'Hexokinase_builtinHighlighters', ['virtual', 'sign_column', 'background', 'foreground', 'foregroundfull'])
   let g:Hexokinase_highlightCallbacks = get(g:, 'Hexokinase_highlightCallbacks', [])
   let g:Hexokinase_tearDownCallbacks = get(g:, 'Hexokinase_tearDownCallbacks', [])
   for mode in g:Hexokinase_highlighters
      if index(g:Hexokinase_builtinHighlighters, mode) >= 0
         call add(g:Hexokinase_highlightCallbacks, function('hexokinase#highlighters#' . mode . '#highlightv2'))
         call add(g:Hexokinase_tearDownCallbacks, function('hexokinase#highlighters#' . mode . '#tearDownv2'))
      endif
   endfor

   command! HexokinaseToggle call hexokinase#v2#scraper#toggle()
   command! HexokinaseTurnOn call hexokinase#v2#scraper#on()
   command! HexokinaseTurnOff call hexokinase#v2#scraper#off()

   let g:Hexokinase_refreshEvents = get(g:, 'Hexokinase_refreshEvents', ['TextChanged', 'InsertLeave'])
   let g:Hexokinase_ftAutoload = get(g:, 'Hexokinase_ftAutoload', ['text', 'css', 'html'])
	let g:Hexokinase_disabledPatterns = get(g:, 'Hexokinase_disabledPatterns', ['names'])

	if has('autocmd')
		augroup hexokinase_autocmds
			autocmd!
			exe 'autocmd '.join(g:Hexokinase_refreshEvents, ',').' * call s:on_refresh_event()'
			if get(g:, 'Hexokinase_autoenable', 1)
				autocmd BufRead,BufWrite * call s:check_colours()
			else
				if !empty(g:Hexokinase_ftAutoload)
					exe 'autocmd FileType '.join(g:Hexokinase_ftAutoload, ',').' call hexokinase#v2#scraper#on()'
				endif
			endif
		augroup END
	endif

	fun! s:check_colours() abort
		let b:hexokinase_is_on = get(b:, 'hexokinase_is_on', 0)
		if !b:hexokinase_is_on
			call hexokinase#checker#check()
      endif
	endf

   fun! s:on_refresh_event() abort
		let b:hexokinase_is_on = get(b:, 'hexokinase_is_on', 0)
		if b:hexokinase_is_on
         call hexokinase#v2#scraper#on()
      endif
   endf
endf
