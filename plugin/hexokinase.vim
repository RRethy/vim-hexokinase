" hexokinase.(n)vim - (Neo)Vim plugin for colouring hex codes
" Maintainer: Adam P. Regasz-Rethy (RRethy) <rethy.spud@gmail.com>
" Vertion 0.1

if exists('g:loaded_hexokinase')
   finish
endif

let g:loaded_hexokinase = 1

let g:Hexokinase_v2 = get(g:, 'Hexokinase_v2', executable('./hexokinase/hexokinase'))

if g:Hexokinase_v2
   call hexokinase#v2#setup()
else
   call hexokinase#v1#setup()
endif

