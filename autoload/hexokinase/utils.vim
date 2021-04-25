let s:hexadecimals = ['0', '1', '2', '3',
            \ '4', '5', '6', '7',
            \ '8', '9', 'A', 'B',
            \ 'C', 'D', 'E', 'F']

fun! hexokinase#utils#get_colour_pattern(patterns_list) abort
    return '\%\(' . join(a:patterns_list, '\|') . '\)'
endf

" Combine the filetype specific pattern/processor map with the global one
fun! hexokinase#utils#get_pat_proc_map() abort
    let pattern_processor_map = {}
    if has_key(g:Hexokinase_ft_patterns, &filetype)
        call extend(pattern_processor_map, g:Hexokinase_ft_patterns[&filetype])
    endif
    call extend(pattern_processor_map, g:Hexokinase_patterns)
    return pattern_processor_map
endf

" rgbList should be a list of numbers
fun! hexokinase#utils#rgb_to_hex(rgbList) abort
    let r = a:rgbList[0]
    let g = a:rgbList[1]
    let b = a:rgbList[2]
    let hex = '#'
    let hex .= s:hexadecimals[r / 16]
    let hex .= s:hexadecimals[r % 16]
    let hex .= s:hexadecimals[g / 16]
    let hex .= s:hexadecimals[g % 16]
    let hex .= s:hexadecimals[b / 16]
    let hex .= s:hexadecimals[b % 16]
    return hex
endf

" returns a list of numbers
fun! hexokinase#utils#hex_to_rgb(hex) abort
    let raw_hex = [0, 0, 0, 0, 0, 0]
    for i in range(1, 6)
        let raw_hex[i - 1] = index(s:hexadecimals, toupper(a:hex[i]))
    endfor
    let r = (raw_hex[0] * 16) + raw_hex[1]
    let g = (raw_hex[2] * 16) + raw_hex[3]
    let b = (raw_hex[4] * 16) + raw_hex[5]
    return [r, g, b]
endf

fun! hexokinase#utils#get_background_rgb() abort
    return hexokinase#utils#hex_to_rgb(hexokinase#utils#get_background_hex())
endf

fun! hexokinase#utils#get_background_hex() abort
    if !empty(get(g:, 'Hexokinase_alpha_bg', ''))
        return g:Hexokinase_alpha_bg
    elseif len(g:Hexokinase_highlighters) == 1 && g:Hexokinase_highlighters[0] ==# 'sign_column'
        return synIDattr(hlID('SignColumn'), 'bg')
    else
        return synIDattr(hlID('Normal'), 'bg')
    endif
endf

fun! hexokinase#utils#valid_rgb(rgbList) abort
    let [r, g, b] = a:rgbList
    if r > 255 || r < 0 || g > 255 || g < 0 || b > 255 || b < 0
        return 0
    else
        return 1
    endif
endf

fun! hexokinase#utils#apply_alpha_to_rgb(primary_rgb, alpha) abort
    let [bg_r, bg_g, bg_b] = hexokinase#utils#get_background_rgb()
    let [old_r, old_g, old_b] = a:primary_rgb

    let new_r = float2nr(bg_r + ((old_r - bg_r) * a:alpha))
    let new_g = float2nr(bg_g + ((old_g - bg_g) * a:alpha))
    let new_b = float2nr(bg_b + ((old_b - bg_b) * a:alpha))
    return [new_r, new_g, new_b]
endf

fun! hexokinase#utils#tmpname() abort
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

fun! hexokinase#utils#getPatModifications() abort
    if has_key(g:Hexokinase_ftOptOutPatterns, &filetype)
        let dp = g:Hexokinase_ftOptOutPatterns[&filetype]
        if type(dp) == 1
            return ['-dp', substitute(dp, '\s', '', 'g')]
        elseif type(dp) == 3
            return ['-dp', join(dp, ',')]
        else
            echohl Error | echom printf('ERROR: g:Hexokinase_ftOptOutPatterns[%s] must be a string or a list', &filetype) | echohl None
        endif
    elseif has_key(g:Hexokinase_ftOptInPatterns, &filetype)
        let ep = g:Hexokinase_ftOptInPatterns[&filetype]
        if type(ep) == 1
            return ['-ep', substitute(ep, '\s', '', 'g')]
        elseif type(ep) == 3
            return ['-ep', join(ep, ',')]
        else
            echohl Error | echom printf('ERROR: g:Hexokinase_ftOptInPatterns[%s] must be a string or a list', &filetype) | echohl None
        endif
    elseif !empty(g:Hexokinase_optOutPatterns)
        if type(g:Hexokinase_optOutPatterns) == 1
            return ['-dp', substitute(g:Hexokinase_optOutPatterns, '\s', '', 'g')]
        elseif type(g:Hexokinase_optOutPatterns) == 3
            return ['-dp', join(g:Hexokinase_optOutPatterns, ',')]
        else
            echohl Error | echom 'ERROR: g:Hexokinase_optOutPatterns must be a string or a list' | echohl None
        endif
    elseif !empty(g:Hexokinase_optInPatterns)
        if type(g:Hexokinase_optInPatterns) == 1
            return ['-ep', substitute(g:Hexokinase_optInPatterns, '\s', '', 'g')]
        elseif type(g:Hexokinase_optInPatterns) == 3
            return ['-ep', join(g:Hexokinase_optInPatterns, ',')]
        else
            echohl Error | echom 'ERROR: g:Hexokinase_optInPatterns must be a string or a list' | echohl None
        endif
    endif
    return []
endf

fun! hexokinase#utils#create_fg_hl(hex) abort
    let hlname = 'v2hexokinaseHighlight'.strpart(a:hex, 1)
    exe 'hi '.hlname.' guifg='.a:hex
    return hlname
endf

fun! hexokinase#utils#create_bg_hl(hex) abort
    let hlname = 'v2hexokinaseHighlight_withfg'.strpart(a:hex, 1)
    let [r, g, b] = hexokinase#utils#hex_to_rgb(a:hex)
    " This calculation is from the following:
    " https://www.w3.org/TR/WCAG20/#relativeluminancedef
    if 0.2126 * r + 0.7152 * g + 0.0722 * b > 179
        let fg = '#000000'
    else
        let fg = '#ffffff'
    endif
    exe 'hi '.hlname.' guibg='.a:hex.' guifg='.fg
    return hlname
endf
