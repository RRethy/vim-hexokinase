" Experimental and unused currently
finish

fun! hexokinase#checker#check() abort
    call s:cancel_cur_job()

    let tmpname = hexokinase#utils#tmpname()
    let fail = writefile(getbufline(bufnr('%'), 1, '$'), tmpname)
    if !fail
        let opts = {
                    \ 'tmpname': tmpname,
                    \ 'on_exit': function('s:on_exit'),
                    \ 'bufnr': bufnr('%'),
                    \ }
        let cmd = printf('%s -check=%s ', g:Hexokinase_executable_path, tmpname)
        let cmd .= hexokinase#utils#getPatModifications()
        if !empty(g:Hexokinase_palettes)
            let cmd .= ' -palettes='.join(g:Hexokinase_palettes, ',')
        endif
        let b:hexokinase_job_id = jobstart(cmd, opts)
    endif
endf

fun! s:on_exit(id, status, event) abort dict
    call delete(self.tmpname)
    if !a:status
        if bufnr('%') == self.bufnr
            call hexokinase#v2#scraper#on()
        endif
    endif
endf

fun! s:cancel_cur_job() abort
    let b:hexokinase_checker_job_id = get(b:, 'hexokinase_checker_job_id', -1)
    try
        call chanclose(b:hexokinase_checker_job_id)
    catch /E900/
    endtry
endf
