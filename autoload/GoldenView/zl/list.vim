" =============== ============================================================
" Synopsis       : list helper functions
" Author         : Zhao Cai <caizhaoff@gmail.com>
" HomePage       : https://github.com/zhaocai/zl.vim
" Version        : 0.1
" Date Created   : Sat 03 Sep 2011 03:54:00 PM EDT
" Last Modified  : Thu 20 Sep 2012 04:25:10 PM EDT
" Tag            : [ vim, list ]
" Copyright      : (c) 2012 by Zhao Cai,
"                  Released under current GPL license.
" =============== ============================================================



" ============================================================================
" Sort:                                                                   [[[1
" ============================================================================

function! GoldenView#zl#list#unique_sort(list, ...) "                                [[[2
    "--------- ------------------------------------------------
    " Args    : list, [func]
    " Return  : unique sorted list
    " Raise   :
    "
    " Refer   : http://vim.wikia.com/wiki/Unique_sorting
    "--------- ------------------------------------------------
    let list = copy(a:list)

    if exists('a:1') && type(a:1) == type(function('function'))
        call sort(list, a:1)
    else
        call sort(list)
    endif
    if len(list) <= 1 | return list | endif
    let result = [ list[0] ]
    let last = list[0]
    let i = 1
    while i < len(list)
        if last != list[i]
            let last = list[i]
            call add(result, last)
        endif
        let i += 1
    endwhile
    return result
endfunction



function! GoldenView#zl#list#sort_by(list, expr)
    "--------- ------------------------------------------------
    " Desc    : sort list by expr
    "
    " Args    : v:val is used in {expr}
    " Return  : sroted list
    " Raise   :
    "
    " Example : >
    "   let list = [{'a' : 1}, {'a' : 22}, {'a' : 3}]
    "   echo GoldenView#zl#list#sort_by(list, 'v:val["a"]')
    "
    " Refer   : vital.vim
    "--------- ------------------------------------------------

    let pairs = map(a:list, printf('[v:val, %s]', a:expr))
    return map(GoldenView#zl#list#sort(pairs,
                \ 'a:a[1] ==# a:b[1] ? 0 : a:a[1] ># a:b[1] ? 1 : -1'),
                \ 'v:val[0]')
endfunction

function! s:_compare(a, b)
    return eval(s:expr)
endfunction

function! GoldenView#zl#list#sort(list, expr)
    "--------- ------------------------------------------------
    " Desc    : sort list with expr to compare two values.
    "
    " Args    : a:a and a:b can be used in {expr}
    " Return  : sroted list
    " Raise   :
    "
    " Refer   : vital.vim
    "--------- ------------------------------------------------

    if type(a:expr) == type(function('function'))
        return sort(a:list, a:expr)
    endif
    let s:expr = a:expr
    return sort(a:list, 's:_compare')
endfunction


function! GoldenView#zl#list#uniq(list, ...)
    let list = a:0
             \ ? map(copy(a:list), printf('[v:val, %s]', a:1))
             \ : copy(a:list)
    let i = 0
    let seen = {}
    while i < len(list)
        let key = string(a:0 ? list[i][1] : list[i])
        if has_key(seen, key)
            call remove(list, i)
        else
            let seen[key] = 1
            let i += 1
        endif
    endwhile
    return a:0 ? map(list, 'v:val[0]') : list
endfunction












" ============================================================================
" Modeline:                                                               [[[1
" ============================================================================
" vim: set ft=vim ts=4 sw=4 tw=78 fdm=marker fmr=[[[,]]] fdl=1 :
