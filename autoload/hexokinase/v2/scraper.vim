fun! hexokinase#v2#scraper#toggle() abort
   let b:hexokinase_is_scraping = get(b:, 'hexokinase_is_scraping', 0)
   if b:hexokinase_is_scraping
      return
   endif

   let b:hexokinase_is_on = get(b:, 'hexokinase_is_on', 0)
   if b:hexokinase_is_on
      call hexokinase#v2#scraper#off()
   else
      call hexokinase#v2#scraper#on()
   endif
endf

fun! hexokinase#v2#scraper#on() abort
   let b:hexokinase_is_scraping = 1
	let b:hexokinase_is_on = 1
   let tmpname = s:tmpname()
   let fail = writefile(getbufline(bufnr('%'), 1, '$'), tmpname)
   if fail
		let b:hexokinase_is_scraping = 0
		let b:hexokinase_is_on = 0
   else
      let opts = {
               \ 'tmpname': tmpname,
               \ 'on_stdout': function('s:on_stdout'),
               \ 'on_exit': function('s:on_exit'),
               \ 'on_stderr': function('s:on_stderr'),
               \ 'bufnr': bufnr('%'),
               \ 'colours': []
               \ }
      " TODO do we need the returned job id
      call jobstart(printf('hexokinase -r -simplified -files=%s', tmpname), opts)
   endif
endf

fun! hexokinase#v2#scraper#off() abort
endf

fun! hexokinase#v2#scraper#refresh() abort
endf

fun! s:tear_down(bufnr) abort
	for F in g:Hexokinase_tearDownCallbacks
      call F(a:bufnr)
   endfor
	" TODO cancel job
endf

fun! s:on_stdout(id, data, event) abort dict
   for line in a:data
		echom line
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

fun! s:on_exit(id, status, event) abort dict
   call delete(self.tmpname)
   if a:status
      return
   endif
	let b:hexokinase_is_scraping = 0
   call s:tear_down(self.bufnr)
   for colour in self.colours
      let hl_name = 'v2hexokinaseHighlight'.strpart(colour.hex, 1)
      exe 'hi '.hl_name.' guifg='.colour.hex
      for F in g:Hexokinase_highlightCallbacks
         call F(self.bufnr, colour.lnum, colour.hex, hl_name, colour.start, colour.end)
      endfor
   endfor
endf

fun! s:on_stderr(id, data, event) abort dict
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
