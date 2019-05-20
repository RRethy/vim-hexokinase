scriptencoding utf-8

fun! hexokinase#v2#setup() abort
   if has('nvim')
      let g:Hexokinase_highlighters = get(g:, 'Hexokinase_highlighters', ['virtual'])
   else
      let g:Hexokinase_highlighters = get(g:, 'Hexokinase_highlighters', ['sign_column'])
   endif

   let g:Hexokinase_virtualText = get(g:, 'Hexokinase_virtualText', '■')
   let g:Hexokinase_signIcon = get(g:, 'Hexokinase_signIcon', '■')

   " let g:Hexokinase_builtinHighlighters = get(g:, 'Hexokinase_builtinHighlighters', ['virtual', 'sign_column', 'background', 'foreground', 'foregroundfull'])
   " let g:Hexokinase_highlightCallbacks = get(g:, 'Hexokinase_highlightCallbacks', [])
   " let g:Hexokinase_tearDownCallbacks = get(g:, 'Hexokinase_tearDownCallbacks', [])
   " for mode in g:Hexokinase_highlighters
   "    if index(g:Hexokinase_builtinHighlighters, mode) >= 0
   "       call add(g:Hexokinase_highlightCallbacks, function('hexokinase#highlighters#' . mode . '#highlightv2'))
   "       call add(g:Hexokinase_tearDownCallbacks, function('hexokinase#highlighters#' . mode . '#tearDownv2'))
   "    endif
   " endfor

   command! HexokinaseToggle call hexokinase#v2#toggle()
   command! HexokinaseRefresh call hexokinase#v2#refresh()
   command! HexokinaseTurnOn call hexokinase#v2#on()
   command! HexokinaseTurnOff call hexokinase#v2#off()

   let g:Hexokinase_refreshEvents = get(g:, 'Hexokinase_refreshEvents', ['TextChanged', 'InsertLeave'])
   let g:Hexokinase_ftAutoload = get(g:, 'Hexokinase_ftAutoload', ['text', 'css'])

   if has('autocmd')
      augroup hexokinase_autocmds
         autocmd!
         for event in g:Hexokinase_refreshEvents
            exe 'autocmd '.event.' * call s:on_refresh_event()'
         endfor
         " if !empty(g:Hexokinase_ftAutoload)
         "    exe 'autocmd FileType '.join(g:Hexokinase_ftAutoload, ',').' call hexokinase#on_autoload_ft_set()'
         " endif
      augroup END
   endif

   fun! s:on_refresh_event() abort
      if exists('b:hexokinase_scraper_on') && b:hexokinase_scraper_on
         HexokinaseRefresh
      endif
   endf

   fun! s:toggle() abort
      HexokinaseToggle
   endf
endf
