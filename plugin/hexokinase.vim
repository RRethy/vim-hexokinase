scriptencoding utf-8

" hexokinase.(n)vim - (Neo)Vim plugin for colouring hex codes
" Maintainer: Adam P. Regasz-Rethy (RRethy) <rethy.spud@gmail.com>
" Vertion 0.1

if exists('g:loaded_hexokinase')
  finish
endif

let g:loaded_hexokinase = 1

if has('nvim')
  let g:hexokinase_highlighters = get(g:, 'hexokinase_highlighters', ['virtual'])
else
  let g:hexokinase_highlighters = get(g:, 'hexokinase_highlighters', ['sign_column'])
endif

let g:hexokinase = get(g:, 'hexokinase', {})
if type(g:hexokinase) != 4
  echoerr 'Variable g:hexokinase must be a dict'
  finish
endif

let g:hexokinase.virtual_text = get(g:, 'hexokinase.virtual_text', '■')
let g:hexokinase.sign_icon = get(g:, 'hexokinase.sign_icon', '■')

" initialize various patterns that are supported by default
let g:hexokinase.patterns = get(g:, 'hexokinase.patterns', {})
let g:hexokinase.patterns[hexokinase#patterns#full_hex#get_pattern()] = function('hexokinase#patterns#full_hex#process')
let g:hexokinase.patterns[hexokinase#patterns#triple_hex#get_pattern()] = function('hexokinase#patterns#triple_hex#process')
let g:hexokinase.patterns[hexokinase#patterns#rgb#get_pattern()] = function('hexokinase#patterns#rgb#process')
let g:hexokinase.patterns[hexokinase#patterns#rgba#get_pattern()] = function('hexokinase#patterns#rgba#process')

let g:hexokinase.builtin_highlighters = get(g:, 'hexokinase.builtin_highlighters', [])
call add(g:hexokinase.builtin_highlighters, 'virtual')
call add(g:hexokinase.builtin_highlighters, 'sign_column')

" initialize various highlighters
let g:hexokinase.highlightCallbacks = get(g:, 'hexokinase.highlightCallbacks', [])
let g:hexokinase.tearDownCallbacks = get(g:, 'hexokinase.tearDownCallbacks', [])
for mode in g:hexokinase_highlighters
  if index(g:hexokinase.builtin_highlighters, mode) >= 0
    call add(g:hexokinase.highlightCallbacks, function('hexokinase#highlighters#' . mode . '#highlight'))
    call add(g:hexokinase.tearDownCallbacks, function('hexokinase#highlighters#' . mode . '#tearDown'))
  endif
endfor

command! HexokinaseToggle call hexokinase#toggle_scraping()
command! HexokinaseRefresh call hexokinase#tear_down() | call hexokinase#scrape_colours()

let g:hexokinase.refresh_events = get(g:, 'hexokinase.refresh_events', ['BufWritePost'])
let g:hexokinase.ft_autoload = get(g:, 'hexokinase.ft_autoload', [''])

if has('autocmd')
  augroup hexokinase_autocmds
    autocmd!
    for event in g:hexokinase.refresh_events
      exe 'autocmd '.event.' * call s:on_refresh_event()'
    endfor
    exe 'autocmd FileType '.join(g:hexokinase.ft_autoload).' call s:toggle()'
  augroup END
endif

fun! s:on_refresh_event() abort
  if exists("b:hexokinase_scraper_on") && b:hexokinase_scraper_on 
    HexokinaseRefresh
  endif
endf

fun! s:toggle() abort
  HexokinaseToggle
endf
