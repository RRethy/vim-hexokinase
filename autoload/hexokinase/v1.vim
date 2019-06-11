scriptencoding utf-8

fun! hexokinase#v1#setup() abort
    if has('nvim')
        let g:Hexokinase_highlighters = get(g:, 'Hexokinase_highlighters', ['virtual'])
    else
        let g:Hexokinase_highlighters = get(g:, 'Hexokinase_highlighters', ['sign_column'])
    endif

    let g:Hexokinase_virtualText = get(g:, 'Hexokinase_virtualText', '■')
    let g:Hexokinase_signIcon = get(g:, 'Hexokinase_signIcon', '■')

    " initialize various patterns that are supported by default
    let g:Hexokinase_optInPatterns = get(g:, 'Hexokinase_optInPatterns', ['full_hex', 'triple_hex', 'rgb', 'rgba'])
    let g:Hexokinase_patterns = get(g:, 'Hexokinase_patterns', {})
    for pat in g:Hexokinase_optInPatterns
        if pat ==# 'full_hex'
            let g:Hexokinase_patterns[hexokinase#patterns#full_hex#get_pattern()] = function('hexokinase#patterns#full_hex#process')
        elseif pat ==# 'triple_hex'
            let g:Hexokinase_patterns[hexokinase#patterns#triple_hex#get_pattern()] = function('hexokinase#patterns#triple_hex#process')
        elseif pat ==# 'rgb'
            let g:Hexokinase_patterns[hexokinase#patterns#rgb#get_pattern()] = function('hexokinase#patterns#rgb#process')
        elseif pat ==# 'rgba'
            let g:Hexokinase_patterns[hexokinase#patterns#rgba#get_pattern()] = function('hexokinase#patterns#rgba#process')
        elseif pat =~# 'colou\?r_names'
            let g:Hexokinase_patterns[hexokinase#patterns#colour_names#get_pattern()] = function('hexokinase#patterns#colour_names#process')
        endif
    endfor

    let g:Hexokinase_ft_patterns = get(g:, 'Hexokinase_ft_patterns', {})

    let g:Hexokinase_builtinHighlighters = get(g:, 'Hexokinase_builtinHighlighters', ['virtual', 'sign_column', 'background', 'foreground', 'foregroundfull'])

    " initialize various highlighters
    let g:Hexokinase_highlightCallbacks = get(g:, 'Hexokinase_highlightCallbacks', [])
    let g:Hexokinase_tearDownCallbacks = get(g:, 'Hexokinase_tearDownCallbacks', [])
    for mode in g:Hexokinase_highlighters
        if index(g:Hexokinase_builtinHighlighters, mode) >= 0
            call add(g:Hexokinase_highlightCallbacks, function('hexokinase#highlighters#' . mode . '#highlight'))
            call add(g:Hexokinase_tearDownCallbacks, function('hexokinase#highlighters#' . mode . '#tearDown'))
        endif
    endfor

    command! HexokinaseToggle call hexokinase#toggle_scraping()
    command! HexokinaseRefresh call hexokinase#tear_down() | call hexokinase#scrape_colours()

    let g:Hexokinase_refreshEvents = get(g:, 'Hexokinase_refreshEvents', ['BufWritePost'])
    let g:Hexokinase_ftAutoload = get(g:, 'Hexokinase_ftAutoload', [])

    if has('autocmd')
        augroup hexokinase_autocmds
            autocmd!
            for event in g:Hexokinase_refreshEvents
                exe 'autocmd '.event.' * call s:on_refresh_event()'
            endfor
            if !empty(g:Hexokinase_ftAutoload)
                exe 'autocmd FileType '.join(g:Hexokinase_ftAutoload, ',').' call hexokinase#on_autoload_ft_set()'
            endif
        augroup END
    endif

    fun! s:on_refresh_event() abort
        if exists('b:hexokinase_scraper_on') && b:hexokinase_scraper_on
            HexokinaseRefresh
        endif
    endf

    fun! s:toggle() abort
        HexokinaseToggle
    endf
endf
