fun! hexokinase#toggle_scraping() abort
  let b:hexokinase_scraper_on = !get(b:, 'hexokinase_scraper_on', 0)
  let g:Hexokinase_silent = get(g:, 'Hexokinase_silent', 0)
  if b:hexokinase_scraper_on
    call hexokinase#scrape_colours()
    if !g:Hexokinase_silent
      echo 'Turned on highlighting'
    endif
  else
    call hexokinase#tear_down()
    if !g:Hexokinase_silent
      echo 'Turned off highlighting'
    endif
  endif
endf

fun! hexokinase#on_autoload_ft_set() abort
  let b:hexokinase_scraper_on = !get(b:, 'hexokinase_scraper_on', 0)
  if b:hexokinase_scraper_on
    call hexokinase#scrape_colours()
  endif
endf

fun! hexokinase#scrape_colours() abort
  let lnum = 1
  let pattern = hexokinase#utils#build_pattern(keys(g:Hexokinase_patterns))
  for lnum in range(1, line('$'))
    let line_text = getline(lnum)
    let n = 1
    " Builds a regex that handles all colour patterns
    let colourMatch = matchstr(line_text, pattern, 0, n)

    " match all colours on the line
    while colourMatch !=# ''
      let processed = 0
      for pattern_regex in keys(g:Hexokinase_patterns)
        if colourMatch =~# '^' . pattern_regex . '$'
          let colourMatch = g:Hexokinase_patterns[pattern_regex](colourMatch)
          if !empty(colourMatch)
            let processed = 1
            break
          endif
        endif
      endfor

      " The colour that got matched was invalid so avoid matching it and
      " continue
      " This could happen for something like rgb(500,500,500)
      if !processed
        let n += 1
        let colourMatch = matchstr(line_text, pattern, 0, n)
        continue
      endif

      " Create the highlight group
      let hl_name = 'hexokinaseHighlight'.strpart(colourMatch, 1)
      exe 'hi '.hl_name.' guifg='.colourMatch
      for F in g:Hexokinase_highlightCallbacks
        call F(lnum, colourMatch, hl_name)
      endfor
      let n += 1
      let colourMatch = matchstr(line_text, pattern, 0, n)
    endwhile
  endfor
endf

fun! hexokinase#tear_down() abort
  for F in g:Hexokinase_tearDownCallbacks
    call F()
  endfor
endf
