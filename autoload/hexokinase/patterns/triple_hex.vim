fun! hexokinase#patterns#triple_hex#get_pattern() abort
    return '\<#\x\{3}\>'
endf

fun! hexokinase#patterns#triple_hex#process(str) abort
    return '#' . a:str[1] . a:str[1] . a:str[2] . a:str[2] . a:str[3] . a:str[3]
endf
