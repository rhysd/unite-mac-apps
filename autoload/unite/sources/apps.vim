let s:save_cpo = &cpo
set cpo&vim

let s:source = {
            \ 'name' : 'apps',
            \ 'description' : 'MacOS Applications',
            \ 'default_action' : 'open_app',
            \ 'action_table' : {},
            \ }

let g:unite_mac_apps_path = get(g:, 'unite_mac_apps_path','/Applications,'.$HOME.'/Applications')

" get script local ID
function! s:get_SID()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_')
endfunction
let s:SID = s:get_SID()
delfunction s:get_SID

function! s:gather_app_names(args,context)
    let apps = []
    for path in split(g:unite_mac_apps_path, ',')
        let apps += split(glob(path.'/*'), "\n")
    endfor

    return map(apps, "{
                \ 'word' : fnamemodify(v:val, ':t'),
                \ 'action__path' : v:val,
                \ }")
endfunction

let s:source.gather_candidates = function(s:SID.'gather_app_names' )

let s:source.action_table.open_app = {
            \ 'name' : 'open_app',
            \ 'description' : 'open Mac Apps with open command',
            \ 'is_selectable' : 1,
            \ }

function! s:open_app(candidates)
    for c in a:candidates
        call system('open ' . shellescape(c.action__path))
    endfor
endfunction

let s:source.action_table.open_app.func = function(s:SID.'open_app')

function! unite#sources#apps#define()
    return s:source
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
