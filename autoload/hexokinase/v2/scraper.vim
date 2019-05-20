fun! hexokinase#v2#toggle() abort
   let b:hexokinase_is_scraping = get(b:, 'hexokinase_is_scraping', 0)
   if b:hexokinase_is_scraping
      return
   endif

   let b:hexokinase_is_on = get(b:, 'hexokinase_is_on', 0)
   if b:hexokinase_is_on
      call hexokinase#v2#off()
   else
      call hexokinase#v2#on()
   endif
endf

fun! hexokinase#v2#on() abort
   let b:hexokinase_is_scraping = 1
   let tmpname = s:tmpname()
   let success = writefile(getbufline(bufnr('%'), 1, '$'), tmpname)
   if success
      let b:hexokinase_is_scraping = 0
      return
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
      call jobstart(printf('hexokinase -r -simplified -files%s', tmpname), opts)
   endif
endf

fun! hexokinase#v2#off() abort
endf

fun! hexokinase#v2#refresh() abort
endf

fun! s:tear_down() abort
endf

fun! s:on_stdout(id, data, event) abort dict
   for line in a:data
      let colour = split(res, ':')
      if len(colour) == 4
         call add(self.colours, colour)
      endif
   endfor
endf

fun! s:on_exit(id, status, event) abort dict
   call delete(self.tmpname)
   if a:status
      return
   endif
   call s:tear_down()
   for colour in self.colourss
      let lnum = str2nr(colour[1])
      let hex = colour[3]
      let [start, end] = split(colour[2], '-')
      let hl_name = 'v2hexokinaseHighlight'.strpart(hex, 1)
      exe 'hi '.hl_name.' guifg='.hex
      for F in g:Hexokinase_highlightCallbacks
         call F(self.bufnr, lnum, hex, hl_name, start, end)
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
