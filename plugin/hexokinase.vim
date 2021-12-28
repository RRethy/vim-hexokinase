" hexokinase.(n)vim - (Neo)Vim plugin for colouring hex codes
" Maintainer: Adam P. Regasz-Rethy (RRethy) <rethy.spud@gmail.com>
" Vertion 2.0

if exists('g:loaded_hexokinase')
    finish
endif

let g:loaded_hexokinase = 1

function! hexokinase#get_exec_path()

    let Expand_Guard = { a, b -> empty(a) ? '' : expand(a) . b }
    let paths = [
        \ get(g:, 'Hexokinase_executable_path'),
        \ Expand_Guard('<sfile>:h:h', '/hexokinase/hexokinase'),
        \ Expand_Guard($GOBIN, '/hexokinase'),
        \ Expand_Guard($GOPATH, '/bin/hexokinase'),
        \ Expand_Guard($HOME, '/go/bin/hexokinase'),
    \ ]

    for exec_path in paths
        if !empty(exec_path) && executable(exec_path)
            return exec_path
        endif
    endfor

    return ''

endfunction

let g:Hexokinase_executable_path = hexokinase#get_exec_path()
let g:Hexokinase_v2 = get(g:, 'Hexokinase_v2', 1)

if g:Hexokinase_v2
    if !empty(g:Hexokinase_executable_path)
        call hexokinase#v2#setup()
    else
        echohl Error | echom 'vim-hexokinase needs updating. Run `make hexokinase` in project root. See `:h hexokinase-installation` for more info.' | echohl None
    endif
else
    call hexokinase#v1#setup()
endif

