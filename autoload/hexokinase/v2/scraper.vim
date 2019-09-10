fun! hexokinase#v2#scraper#toggle() abort
    let b:hexokinase_is_on = get(b:, 'hexokinase_is_on', 0)
    if b:hexokinase_is_on
        call hexokinase#v2#scraper#off()
    else
        call hexokinase#v2#scraper#on()
    endif
endf

fun! hexokinase#v2#scraper#on() abort
    call s:cancel_cur_job()

    let b:hexokinase_is_on = 1
    let tmpname = hexokinase#utils#tmpname()
    let fail = writefile(getbufline(bufnr('%'), 1, '$'), tmpname)
    if fail
        let b:hexokinase_is_on = 0
    else
        let opts = {
                    \ 'tmpname': tmpname,
                    \ 'on_stdout': function('s:on_stdout'),
                    \ 'on_stderr': function('s:on_stderr'),
                    \ 'on_exit': function('s:on_exit'),
                    \ 'bufnr': bufnr('%'),
                    \ 'colours': []
                    \ }
        let cmd = printf('%s -r -simplified -files=%s', g:Hexokinase_executable_path, tmpname)
        let cmd .= hexokinase#utils#getPatModifications()
        let cmd .= ' -bg='.hexokinase#utils#get_background_hex()
        if !empty(g:Hexokinase_palettes)
            let cmd .= ' -palettes='.join(g:Hexokinase_palettes, ',')
        endif
        if get(g:, 'Hexokinase_checkBoundary', 1)
            let cmd .= ' -boundary'
        endif

        let b:hexokinase_job_id = jobstart(cmd, opts)
    endif
endf

fun! hexokinase#v2#scraper#off() abort
    let b:hexokinase_is_on = 0
    call s:cancel_cur_job()
    call s:clear_hl(bufnr('%'))
endf

fun! s:clear_hl(bufnr) abort
    for F in g:Hexokinase_tearDownCallbacks
        call F(a:bufnr)
    endfor
endf

fun! s:cancel_cur_job() abort
    let b:hexokinase_job_id = get(b:, 'hexokinase_job_id', -1)
    try
        call chanclose(b:hexokinase_job_id)
    catch /E900/
    endtry
endf

fun! s:on_stdout(id, data, event) abort dict
    for line in a:data
        let parts = split(line, ':')
        if len(parts) == 4
            let colour = {
                        \ 'lnum': parts[1],
                        \ 'start': split(parts[2], '-')[0],
                        \ 'end': split(parts[2], '-')[1],
                        \ 'hex': parts[3]
                        \ }
            call add(self.colours, colour)
        endif
    endfor
endf

fun! s:on_stderr(id, data, event) abort dict
    if get(g:, 'Hexokinase_logging', 0)
        echohl Error | echom string(a:data) | echohl None
    endif
endf

fun! s:on_exit(id, status, event) abort dict
    call delete(self.tmpname)
    call s:clear_hl(self.bufnr)
    if a:status
        return
    endif
    call setbufvar(self.bufnr, 'hexokinase_colours', self.colours)
    for F in g:Hexokinase_highlightCallbacks
        call F(self.bufnr)
    endfor
endf
