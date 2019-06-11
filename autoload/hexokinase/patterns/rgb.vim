let s:REGEX_NUM = '\d\{1,3}'
let s:REGEX_PERCENTAGE = s:REGEX_NUM.'%'

fun! hexokinase#patterns#rgb#get_pattern() abort
    let val = '\('.s:REGEX_NUM.'\|'.s:REGEX_PERCENTAGE.'\)'
    let _ = '\s*'
    return 'rgb('._.val._.','._.val._.','._.val._.')'
endf

fun! hexokinase#patterns#rgb#process(str) abort
    let [r, g, b] = hexokinase#patterns#rgb#rgb_str_to_nums(a:str)
    if !hexokinase#utils#valid_rgb([r, g, b])
        return ''
    endif
    return hexokinase#utils#rgb_to_hex([r, g, b])
endf

fun! hexokinase#patterns#rgb#rgb_str_to_nums(rgb_str) abort
    let r = s:get_formatted_value('(', ',', a:rgb_str)
    let g = s:get_formatted_value(',', ',', a:rgb_str)
    let b = s:get_formatted_value(',', ')', a:rgb_str)
    return [r, g, b]
endf

fun! s:get_formatted_value(prefix, postfix, str) abort
    let _ = '\s*'
    if match(a:str, a:prefix._.s:REGEX_NUM._.a:postfix) != -1
        return str2nr(matchstr(a:str, a:prefix._.'\zs'.s:REGEX_NUM.'\ze'._.a:postfix))
    else
        return str2nr(matchstr(a:str, a:prefix._.'\zs'.s:REGEX_NUM.'\ze'.'%'._.a:postfix)) * 255 / 100
    endif
endf
