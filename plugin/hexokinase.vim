" hexokinase.(n)vim - (Neo)Vim plugin for colouring hex codes
" Maintainer: Adam P. Regasz-Rethy (RRethy) <rethy.spud@gmail.com>
" Vertion 2.0

if exists('g:loaded_hexokinase')
    finish
endif

let g:loaded_hexokinase = 1

function! hexokinase#get_exec_path()

	let lPaths = [
				\ get(g:, 'Hexokinase_executable_path', expand('<sfile>:h:h') . '/hexokinase/hexokinase'),
				\ expand($GOBIN) . '/hexokinase',
				\ expand($GOPATH) . '/bin/hexokinase',
				\ expand($HOME) . '/go/bin/hexokinase',
				\ ]

	let lPaths = filter(lPaths, {_, v -> executable(v) == 1 })
	if len(lPaths) > 0
		return lPaths[0]
	endif

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
