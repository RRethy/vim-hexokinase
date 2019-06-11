fun! hexokinase#checker#check() abort
	call s:cancel_cur_job()

   let tmpname = s:tmpname()
   let fail = writefile(getbufline(bufnr('%'), 1, '$'), tmpname)
   if !fail
      let opts = {
               \ 'tmpname': tmpname,
               \ 'on_exit': function('s:on_exit'),
               \ 'bufnr': bufnr('%'),
               \ }
		let cmd = printf('./hexokinase/hexokinase -check=%s -dp=names', tmpname)
		if !empty(g:Hexokinase_optOutPatterns)
			let cmd .= ' -dp='.g:Hexokinase_optOutPatterns
		endif
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
