" =============== ============================================================
" Name           : rule.vim
" Synopsis       : vim script library: rule
" Author         : Zhao Cai <caizhaoff@gmail.com>
" HomePage       : https://github.com/zhaocai/zl.vim
" Date Created   : Sat 03 Sep 2011 03:54:00 PM EDT
" Last Modified  : Sat 29 Sep 2012 01:03:24 AM EDT
" Tag            : [ vim, rule ]
" Copyright      : © 2012 by Zhao Cai,
"                  Released under current GPL license.
" =============== ============================================================



" ============================================================================
" Rule:                                                                   [[[1
" ============================================================================

" [TODO]( list for at type ) @zhaocai @start(2012-09-27 08:05)

let s:rule_types =  [
    \   'filetype', 'buftype', 'mode'  , 'cword',
    \   'bufname' , 'at'     , 'syntax', 'expr' ,
    \ ]
let s:nrule = {
    \ 'eval_order'  : s:rule_types ,
    \ 'eval_negate' : []           ,
    \ 'logic'       : 'or'         ,
    \ 'rule'        : {}           ,
    \ }

function! GoldenView#zl#rule#norm(urule, ...)
    "--------- ------------------------------------------------
    " Desc    : normalize rules
    "
    " Rule    :
    "   - "urule" : "Unnormalized RULE", rules written by users.
    "   - "nrule" : "Nnormalized RULE", rules completed with
    "               optional items and internal items.
    "
    " Args    :
    "   - urule: un-normalized rule
    "   - opts :
    "     - eval_order   : order in s:rule_types,
    "     - eval_negate  : reverse eval result
    "     - logic :
    "       - {or}     : 'v:filetype || v:bufname || ...'
    "       - {and}    : 'v:filetype && v:bufname && ...'
    "       - {string} : similar to v:val for filter()
    "
    " Return  : normalized rules
    " Raise   :
    "
    " Example : >
    "
    " Refer   :
    "--------- ------------------------------------------------
    let nrule = deepcopy(s:nrule)

    if a:0 >= 1 && GoldenView#zl#var#is_dict(a:1)
        call extend(nrule, a:1)
    endif

    let type_expr = {
                  \   'buftype'  : '&buftype'          , 
                  \   'filetype' : '&ft'               , 
                  \   'bufname'  : "bufname('%')"      , 
                  \   'cword'    : "expand('<cword>')" , 
                  \ }

    let type_pat = {}
    for type in ['filetype', 'buftype', 'syntax']
        if has_key(a:urule, type)
            let type_pat[type] = '^\%(' . join(a:urule[type], '\|') . '\)$'
        endif
    endfor
    for type in ['bufname', 'cword']
        if has_key(a:urule, type)
            let type_pat[type] = '^\%('
            \ . join(map(a:urule[type], 'GoldenView#zl#regex#escape(v:val)'), '\|')
            \ . '\)$'
        endif
    endfor


    " normalize each type of rules
    for type in ['mode']
        if has_key(a:urule, type)
            let nrule.rule[type] = a:urule[type]
        endif
    endfor

    for type in ['filetype', 'buftype', 'bufname', 'cword']
        if has_key(a:urule, type)
            let nrule.rule[type] =
                \ {
                \ 'eval_expr' : 1               ,
                \ 'expr'      : type_expr[type] ,
                \ 'pat'       : type_pat[type]  ,
                \ }
        endif
    endfor


    for type in ['syntax']
        if has_key(a:urule, type)
            let nrule.rule[type] = type_pat[type]
        endif
    endfor

    for type in ['mode', 'at']
        if has_key(a:urule, type)
            let nrule.rule[type] = a:urule[type]
        endif
    endfor

    for type in ['expr']
        if has_key(a:urule, type)
            try | let nrule.rule[type] =
                \ join(
                \   map(
                \     map(
                \       copy(a:urule[type])
                \       ,"join(v:val,' || ')"
                \     )
                \     , "'('.v:val.')'"
                \   )
                \   ,' && '
                \ )
            catch /^Vim\%((\a\+)\)\=:E714/ " E714: List required
                throw 'zl(rule): expr rule should be written as list of lists.'
            endtry
        endif
    endfor

    call filter(
    \   nrule['eval_order']
    \   , 'has_key(nrule.rule, v:val) && !empty(nrule.rule[v:val])'
    \ )

    return nrule
endfunction


function! GoldenView#zl#rule#is_true(nrule, ...)
    try
        return call('GoldenView#zl#rule#logic_'.a:nrule['logic'], [a:nrule] + a:000)
    catch /^Vim\%((\a\+)\)\=:E129/
        throw 'zl(rule): undefined logic funcref'
    endtry
endfunction


function! GoldenView#zl#rule#is_false(nrule, ...)
    return !call('GoldenView#zl#rule#is_true', [a:nrule] + a:000)
endfunction


" rule logic
function! s:_return(nrule, type, ret)
    return
    \ index(a:nrule.eval_negate, a:type) >= 0
    \ ? !a:ret
    \ : a:ret
endfunction

function! GoldenView#zl#rule#logic_or(nrule, ...)
    let opts = {}
    if a:0 >= 1 && GoldenView#zl#var#is_dict(a:1)
        call extend(opts, a:1)
    endif

    for type in a:nrule['eval_order']
        if s:_return(a:nrule, type, s:eval_{type}(a:nrule['rule'], opts))
            return 1
        endif
    endfor
    return 0
endfunction

function! GoldenView#zl#rule#logic_and(nrule, ...)
    let opts = {}
    if a:0 >= 1 && GoldenView#zl#var#is_dict(a:1)
        call extend(opts, a:1)
    endif

    for type in a:nrule['eval_order']
        if !s:_return(a:nrule, type, s:eval_{type}(a:nrule['rule'], opts))
            return 0
        endif
    endfor
    return 1
endfunction

function! GoldenView#zl#rule#logic_expr(nrule, ...)
    let opts = {}
    if a:0 >= 1 && GoldenView#zl#var#is_dict(a:1)
        call extend(opts, a:1)
    endif

    let str = a:nrule['expr']
    for type in a:nrule['eval_order']
        let str = substitute(str
                \ , 'v:'.type
                \ , string(
                \     s:_return(a:nrule, type,
                \       s:eval_{type}(a:nrule['rule'], opts)
                \     )
                \   )
                \ , 'ge'
                \ )
    endfor

    try
        return eval(str)
    catch /^Vim\%((\a\+)\)\=:E/
        throw printf('zl(rule): eval(%s) raises %s', str, v:exception)
    endtry
endfunction



" nrule eval
function! s:eval_filetype(nrule, ...)
    return call('s:_eval_match', ['filetype', a:nrule] + a:000)
endfunction

function! s:eval_cword(nrule, ...)
    return call('s:_eval_match', ['cword', a:nrule] + a:000)
endfunction

function! s:eval_buftype(nrule, ...)
    return call('s:_eval_match', ['buftype', a:nrule] + a:000)
endfunction

function! s:eval_bufname(nrule, ...)
    return call('s:_eval_match', ['bufname', a:nrule] + a:000)
endfunction


function! s:eval_at(nrule, ...)
    return search(get(a:nrule, 'at', '\%#'), 'bcnW')
endfunction

function! s:eval_mode(nrule, ...)
    let mode_pat  = get(a:nrule, 'mode', [])
    let mode_expr =
    \ a:0 >= 1 && GoldenView#zl#var#is_dict(a:1)
    \ ? get(a:1, 'mode', mode())
    \ : mode()

    return
    \ !empty(
    \   filter(
    \     mode_pat
    \     , 'stridx(mode_expr, v:val) == -1'
    \   )
    \ )
endfunction

function! s:eval_syntax(nrule, ...)
    let pat = get(a:nrule, 'syntax', '')

    let opts = {}
    if a:0 >= 1 && GoldenView#zl#var#is_dict(a:1)
        call extend(opts, a:1)
    endif
    let syn_names = GoldenView#zl#syntax#synstack_names(opts)

    return !empty(filter(syn_names, 'match(v:val, pat) != -1'))
endfunction

function! s:eval_expr(nrule, ...)
    try
        return eval(get(a:nrule, 'expr', 1))
    catch /^Vim\%((\a\+)\)\=:E/
        return 0
    endtry
endfunction

function! s:_eval_match(type, nrule, ...)
    "--------- ------------------------------------------------
    " Desc    : internal match evluation
    " Rule    :
    "   { 'type' :
    "     {
    "       'eval_expr' : (1|0)  ,
    "       'expr'      : {expr} ,
    "       'pat'       : {pat}  ,
    "     }
    "   }
    "
    " Args    : [{type}, {nrule}[, {opts}]]
    " Return  :
    "   - 0 : false
    "   - 1 : true
    " Raise   : zl(rule)
    "
    " Refer   : vimhelp:match()
    "--------- ------------------------------------------------

    let rule = copy(get(a:nrule, a:type, {}))
    if empty(rule)
        throw 'zl(rule): ' . v:exception
    endif

    " opt for {expr} from runtime opts
    if a:0 >= 1 && GoldenView#zl#var#is_dict(a:1) && has_key(a:1, a:type)
        let rt_rule = a:1[a:type]
        if GoldenView#zl#var#is_dict(rt_rule)
            call extend(rule, rt_rule)
        elseif GoldenView#zl#var#is_string(rt_rule)
            let rule['expr']      = rt_rule
            let rule['eval_expr'] = 0
        endif
    endif
    if rule['eval_expr']
        let rule['expr'] = eval(rule['expr'])
    endif
    try
        return call('match', [rule['expr'], rule['pat']]) != -1
    catch /^Vim\%((\a\+)\)\=:E/
        throw 'zl(rule): ' . v:exception
    endtry
endfunction


" ============================================================================
" Modeline:                                                               [[[1
" ============================================================================
" vim: set ft=vim ts=4 sw=4 tw=78 fdm=syntax fmr=[[[,]]] fdl=1 :
