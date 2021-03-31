" hexokinase.(n)vim - (Neo)Vim plugin for colouring hex codes
" Maintainer: Adam P. Regasz-Rethy (RRethy) <rethy.spud@gmail.com>
" Vertion 2.0

if exists('g:loaded_hexokinase')
    finish
endif

let g:loaded_hexokinase = 1

let g:Hexokinase_executable_path = get(g:, 'Hexokinase_executable_path',
            \ executable(expand('<sfile>:h:h').'/hexokinase/hexokinase')
            \   ? expand('<sfile>:h:h').'/hexokinase/hexokinase'
            \   : expand($GOPATH).'/bin/hexokinase')
let g:Hexokinase_v2 = get(g:, 'Hexokinase_v2', 1)

if g:Hexokinase_v2
    if executable(g:Hexokinase_executable_path)
        call hexokinase#v2#setup()
    else
        echohl Error | echom 'vim-hexokinase needs updating. Run `make hexokinase` in project root. See `:h hexokinase-installation` for more info.' | echohl None
    endif
else
    call hexokinase#v1#setup()
endif
