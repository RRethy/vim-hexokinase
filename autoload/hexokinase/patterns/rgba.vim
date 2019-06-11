let s:REGEX_NUM = '\d\{1,3}'
let s:REGEX_PERCENTAGE = s:REGEX_NUM.'%'

fun! hexokinase#patterns#rgba#get_pattern() abort
    let val = '\('.s:REGEX_NUM.'\|'.s:REGEX_PERCENTAGE.'\)'
    let regex_alpha = '\([01]\|[01]\.\d\)'
    let _ = '\s*'
    return 'rgba('._.val._.','._.val._.','._.val._.','._.regex_alpha._.')'
endf

fun! hexokinase#patterns#rgba#process(str) abort
    let val = '\('.s:REGEX_NUM.'\|'.s:REGEX_PERCENTAGE.'\)'
    let _ = '\s*'
    let [old_r, old_g, old_b] = hexokinase#patterns#rgb#rgb_str_to_nums(
                \   matchstr(a:str, '('._.val._.','._.val._.','._.val._) . ')'
                \ )
    let alpha = str2float(matchstr(a:str, ',\s*\zs\([01]\|[01]\.\d\)\ze\s*)'))
    let alpha = alpha > 1.0 ? 1.0 : alpha
    if !hexokinase#utils#valid_rgb([old_r, old_g, old_b]) || alpha == 0.0
        return ''
    endif

    return hexokinase#utils#rgb_to_hex(
                \  hexokinase#utils#apply_alpha_to_rgb(
                \      [old_r, old_g, old_b], alpha
                \  )
                \)
endf
