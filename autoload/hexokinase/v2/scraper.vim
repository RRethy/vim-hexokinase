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
   let tmpname = s:tmpname()
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
		let cmd = printf('hexokinase -r -simplified -dp=names -files=%s', tmpname)
		if !empty(g:Hexokinase_optOutPatterns)
			let cmd .= ' -dp='.g:Hexokinase_optOutPatterns
		endif
		if !empty(g:Hexokinase_palettes)
			let cmd .= ' -palettes='.join(g:Hexokinase_palettes, ',')
		endif
		if !empty(g:Hexokinase_disabledPatterns)
			let cmd .= ' -dp='.join(g:Hexokinase_disabledPatterns, ',')
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
   if a:status
      return
   endif
	call s:clear_hl(bufnr('%'))
   for colour in self.colours
      let hl_name = 'v2hexokinaseHighlight'.strpart(colour.hex, 1)
      exe 'hi '.hl_name.' guifg='.colour.hex
      for F in g:Hexokinase_highlightCallbacks
         call F(self.bufnr, colour.lnum, colour.hex, hl_name, colour.start, colour.end)
      endfor
   endfor
endf

fun! s:tmpname() abort
   let l:clear_tempdir = 0

   if exists('$TMPDIR') && empty($TMPDIR)
      let l:clear_tempdir = 1
      let $TMPDIR = '/tmp'
   endif

   try
      let l:name = tempname()
   finally
      if l:clear_tempdir
         let $TMPDIR = ''
      endif
   endtry

   return l:name
endf
