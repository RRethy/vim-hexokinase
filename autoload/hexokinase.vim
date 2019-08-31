" This file is for v1, v2 is all in the subdirectories

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
    " Builds a map of patterns to processors
    let pattern_processor_map = hexokinase#utils#get_pat_proc_map()
    " Builds a regex that handles all colour patterns
    let pattern = hexokinase#utils#get_colour_pattern(keys(pattern_processor_map))

    for lnum in range(1, line('$'))

        let line_text = getline(lnum)
        let n = 1
        let colorsInfo = []

        let [colourMatch,start,end] = matchstrpos(line_text, pattern, 0, n)
        " Try to process the colour to a six digit hex code
        while colourMatch !=# ''
            let processed = 0
            for pattern_regex in keys(pattern_processor_map)
                if colourMatch =~# '^' . pattern_regex . '$'
                    " Call the appropriate pocessor to get a six digit hex or empty str
                    let colourMatch = pattern_processor_map[pattern_regex](colourMatch)
                    if !empty(colourMatch)
                        let processed = 1
                        break
                    endif
                endif
            endfor

            if processed
                call add(colorsInfo, [colourMatch, start, end])
            endif
            let n += 1
            let [colourMatch,start,end] = matchstrpos(line_text, pattern, 0, n)
        endwhile

        " Reverse such that the last highlighting is the first color and thus
        " can overwrite other highlighting (sign_column, virtual)
        " https://github.com/RRethy/vim-hexokinase/issues/12
        call reverse(colorsInfo)

        for [colourMatch,start,end] in colorsInfo
            " Create the highlight group
            let hl_name = 'hexokinaseHighlight'.strpart(colourMatch, 1)
            exe 'hi '.hl_name.' guifg='.colourMatch
            for F in g:Hexokinase_highlightCallbacks
                call F(lnum, colourMatch, hl_name, start + 1, end)
            endfor
        endfor
    endfor
endf

fun! hexokinase#tear_down() abort
    for F in g:Hexokinase_tearDownCallbacks
        call F()
    endfor
endf
