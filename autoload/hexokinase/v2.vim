scriptencoding utf-8

fun! hexokinase#v2#setup() abort
    if has('nvim')
        let g:Hexokinase_highlighters = get(g:, 'Hexokinase_highlighters', ['virtual'])
    else
        let g:Hexokinase_highlighters = get(g:, 'Hexokinase_highlighters', ['sign_column'])
    endif
    if len(g:Hexokinase_highlighters) == 1 && g:Hexokinase_highlighters[0] == 'sign_column' && &signcolumn == 'no'
        echom "[vim-hexokinase] You seem to be using sign_column for highlighting but 'signcolumn' is set to 'no', try enabling it to see colours."
    endif

    let g:Hexokinase_virtualText = get(g:, 'Hexokinase_virtualText', '■')
    let g:Hexokinase_signIcon = get(g:, 'Hexokinase_signIcon', '■')

    let g:Hexokinase_optOutPatterns = get(g:, 'Hexokinase_optOutPatterns', '')
    let g:Hexokinase_optInPatterns = get(g:, 'Hexokinase_optInPatterns', 'full_hex,rgb,rgba,hsl,hsla,colour_names')
    let g:Hexokinase_ftOptOutPatterns = get(g:, 'Hexokinase_ftOptOutPatterns', {})
    let g:Hexokinase_ftOptInPatterns = get(g:, 'Hexokinase_ftOptInPatterns', {})
    let g:Hexokinase_palettes = get(g:, 'Hexokinase_palettes', [])

    let g:Hexokinase_builtinHighlighters = get(g:, 'Hexokinase_builtinHighlighters', [
                \     'virtual',
                \     'sign_column',
                \     'background',
                \     'backgroundfull',
                \     'foreground',
                \     'foregroundfull'
                \ ])
    let g:Hexokinase_highlightCallbacks = get(g:, 'Hexokinase_highlightCallbacks', [])
    let g:Hexokinase_tearDownCallbacks = get(g:, 'Hexokinase_tearDownCallbacks', [])
    for highlighter in g:Hexokinase_highlighters
        if index(g:Hexokinase_builtinHighlighters, highlighter) >= 0
            call add(g:Hexokinase_highlightCallbacks, function('hexokinase#highlighters#' . highlighter . '#highlightv2'))
            call add(g:Hexokinase_tearDownCallbacks, function('hexokinase#highlighters#' . highlighter . '#tearDownv2'))
        endif
    endfor

    command! HexokinaseToggle call hexokinase#v2#scraper#toggle()
    command! HexokinaseTurnOn call hexokinase#v2#scraper#on()
    command! HexokinaseTurnOff call hexokinase#v2#scraper#off()

    let g:Hexokinase_refreshEvents = get(g:, 'Hexokinase_refreshEvents', ['TextChanged', 'InsertLeave', 'BufRead'])
    let g:Hexokinase_ftDisabled = get(g:, 'Hexokinase_ftDisabled', [])
    let g:Hexokinase_termDisabled = get(g:, 'Hexokinase_termDisabled', 0)

    augroup hexokinase_autocmds
        autocmd!
        exe 'autocmd '.join(g:Hexokinase_refreshEvents, ',').' * call s:on_refresh_event()'
        autocmd ColorScheme * call s:on_refresh_event()
    augroup END
endf

fun! s:on_refresh_event() abort
    let b:hexokinase_is_on = get(b:, 'hexokinase_is_on', 0)
    let b:hexokinase_is_disabled = get(b:, 'hexokinase_is_disabled', 0)
    if b:hexokinase_is_on
        call hexokinase#v2#scraper#on()
        return
    endif

    if b:hexokinase_is_disabled
        return
    endif

    if g:Hexokinase_termDisabled && &buftype ==# 'terminal'
        return
    endif

    if !empty(g:Hexokinase_ftDisabled)
        if index(g:Hexokinase_ftDisabled, &filetype) > -1
            return
        endif
    elseif has_key(g:, 'Hexokinase_ftEnabled')
        if index(g:Hexokinase_ftEnabled, &filetype) == -1
            return
        endif
    endif

    call hexokinase#v2#scraper#on()
endf
