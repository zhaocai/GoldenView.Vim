" =============== ============================================================
" Name           : regex.vim
" Description    : vim library: Regular Expression
" Author         : Zhao Cai <caizhaoff@gmail.com>
" HomePage       : https://github.com/zhaocai/zl.vim
" Date Created   : Mon 03 Sep 2012 09:05:14 AM EDT
" Last Modified  : Thu 20 Sep 2012 04:25:12 PM EDT
" Tag            : [ vim, library, regex ]
" Copyright      : © 2012 by Zhao Cai,
"                  Released under current GPL license.
" =============== ============================================================








" ============================================================================
" Regex Escape:                                                           ⟨⟨⟨1
" ============================================================================
function! GoldenView#zl#regex#escape(text, ...) " (text, ?magic='m')            ⟨⟨⟨2
    "--------- ------------------------------------------------
    " Desc    : escape common special characters.
    "
    " Args    :
    "
    "   - text to escape
    "   - magic : one of m, M, v, V. See :help 'magic'
    "
    " Return  : escaped text
    " Raise   :
    "
    " Example : echo GoldenView#zl#regex#escape('I|||love&you\\\', 'v')
    "
    " Refer   :
    "--------- ------------------------------------------------

    let l:magic =  a:0 >= 1  ?  a:1  :  'm'

    if l:magic =~# '^\\\?m$'
        return escape(a:text, '^$.*\[]~')
    elseif l:magic =~# '^\\\?M$'
        return escape(a:text, '^$\')
    elseif l:magic =~# '^\\\?V$'
        return escape(a:text, '\')
    elseif l:magic =~# '^\\\?v$'
        return substitute(a:text, '[^0-9a-zA-Z_]', '\\&', 'g')
    else
        throw 'unsupported magic type'
        return a:text
    endif
endfunction " ⟩⟩⟩



" ----------------------------------------------------------------------------
" Regex Builder:                                                          ⟨⟨⟨1


function! GoldenView#zl#regex#or(list, ...) "⟨⟨⟨
    let opts =
        \ { 'is_capturing' : 0
        \ , 'magic' : 'm'
        \ }
    if a:0 >= 1 && GoldenView#zl#var#is_dict(a:1)
        call extend(opts, a:1)
    endif

    let begin = opts['is_capturing'] ? '\(' : '\%('
    let or    = '\|'
    let end   = '\)'

    if opts['magic'] =~# '^\\\?v$'
        let begin = opts['is_capturing'] ? '(' : '%('
        let or    = '|'
        let end   = ')'
    endif

    return  begin
        \ . join(map(
        \     a:list, 'GoldenView#zl#regex#escape(v:val, "' . opts['magic'] . '")'),
        \     or)
        \ . end
endfunction "⟩⟩⟩

" ⟩⟩⟩


" ============================================================================
" Modeline:                                                               ⟨⟨⟨1
" ============================================================================
" vim: set ft=vim ts=4 sw=4 tw=78 fdm=marker fmr=⟨⟨⟨,⟩⟩⟩ fdl=1 :
