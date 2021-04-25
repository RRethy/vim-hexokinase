" Used for Vim because it has a shit api
let s:chan_infos = {}

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
    let b:hexokinase_is_disabled = 0
    let tmpname = hexokinase#utils#tmpname()
    let fail = writefile(getbufline(bufnr('%'), 1, '$'), tmpname)
    if fail
        let b:hexokinase_is_on = 0
    else
        if has('nvim')
            let opts = {
                        \ 'tmpname': tmpname,
                        \ 'on_stdout': function('s:on_stdout'),
                        \ 'on_stderr': function('s:on_stderr'),
                        \ 'on_exit': function('s:on_exit'),
                        \ 'bufnr': bufnr('%'),
                        \ 'colours': []
                        \ }
        else
            let opts = {
                        \ 'out_cb': function('s:on_stdout_vim'),
                        \ 'close_cb': function('s:on_exit_vim'),
                        \ }
        endif
        let cmd = [g:Hexokinase_executable_path, '-simplified', '-files', tmpname]
        " Neovim has multiple sign columns, in which case we don't want a
        " reversed output.
        if get(g:, 'Hexokinase_prioritizeHead', 1)
                    \ && get(b:, 'Hexokinase_prioritizeHead', 1)
                    \ && (index(g:Hexokinase_highlighters, 'sign_column') == -1 || &signcolumn !~# '\v(auto|yes):[2-9]')
            call add(cmd, '-r')
        endif
        call extend(cmd, hexokinase#utils#getPatModifications())
        call add(cmd, '-bg')
        call add(cmd, hexokinase#utils#get_background_hex())
        if !empty(g:Hexokinase_palettes)
            call add(cmd, '-palettes')
            call add(cmd, join(g:Hexokinase_palettes, ','))
        endif
        if get(g:, 'Hexokinase_checkBoundary', 1)
            call add(cmd, '-boundary')
        endif

        if has('nvim')
            let b:hexokinase_job_id = jobstart(cmd, opts)
        else
            let b:hexokinase_job = job_start(cmd, opts)
            let s:chan_infos[ch_info(job_getchannel(b:hexokinase_job)).id] = {
                        \     'tmpname': tmpname,
                        \     'colours': [],
                        \     'bufnr': bufnr('%')
                        \ }
        endif
    endif
endf

fun! hexokinase#v2#scraper#off() abort
    let b:hexokinase_is_on = 0
    let b:hexokinase_is_disabled = 1
    call s:cancel_cur_job()
    call s:clear_hl(bufnr('%'))
endf

fun! s:clear_hl(bufnr) abort
    for F in g:Hexokinase_tearDownCallbacks
        call F(a:bufnr)
    endfor
endf

fun! s:cancel_cur_job() abort
    try
        if has('nvim')
            let b:hexokinase_job_id = get(b:, 'hexokinase_job_id', -1)
            call chanclose(b:hexokinase_job_id)
        else
            if has_key(b:, 'hexokinase_job')
                call ch_close(b:hexokinase_job)
            endif
        endif
    catch /E90[06]/
    endtry
endf

fun! s:on_stdout_vim(chan, line) abort
    let colour = s:parse_colour(a:line)
    if !empty(colour)
        call add(s:chan_infos[ch_info(a:chan).id].colours, colour)
    endif
endf

fun! s:on_exit_vim(chan) abort
    let info = s:chan_infos[ch_info(a:chan).id]
    call delete(info.tmpname)
    call s:clear_hl(info.bufnr)
    call setbufvar(info.bufnr, 'hexokinase_colours', info.colours)
    for F in g:Hexokinase_highlightCallbacks
        call F(info.bufnr)
    endfor
endf

fun! s:on_stdout(id, data, event) abort dict
    for line in a:data
        let colour = s:parse_colour(line)
        if !empty(colour)
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

fun! s:parse_colour(line) abort
    let parts = split(a:line, ':')
    if len(parts) < 4
         return ''
     endif
    " If a system allows `:` inside the filename, then we join together all
    " parts before the final 3 (which are guaranteed to be the form
    " lnum:col:hex). This allows the filename to remain intact. For example,
    " Windows can prefix the filename with the drive (e.g. C:/foo/bar.txt)
    let parts = insert(parts[-3:], join(parts[:-4], ':'))

    return { 'lnum': parts[1],
                \ 'start': split(parts[2], '-')[0],
                \ 'end': split(parts[2], '-')[1],
                \ 'hex': parts[3]
                \ }
endf
