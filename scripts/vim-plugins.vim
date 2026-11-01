" Executed noninteractively by vim-plugins.sh after loading ~/.vimrc.
set nomore
if !exists('g:plugs') || !exists(':PlugInstall') || !exists(':PlugUpdate')
  echoerr 'vim-plug is not initialized'
  cquit 1
endif

try
  if $DOTFILES_VIM_PLUGIN_ACTION ==# 'update'
    PlugUpdate --sync
  elseif $DOTFILES_VIM_PLUGIN_ACTION ==# 'install'
    PlugInstall --sync
  else
    throw 'Unknown vim-plug action'
  endif
catch
  echoerr 'vim-plug: ' . v:exception
  cquit 1
endtry

" vim-plug can report failed jobs without setting a nonzero Vim exit status.
let s:failed = []
for [s:name, s:spec] in items(g:plugs)
  if has_key(s:spec, 'uri') && (!isdirectory(s:spec.dir) ||
        \ (!isdirectory(s:spec.dir . '/.git') && !filereadable(s:spec.dir . '/.git')))
    call add(s:failed, s:name . ' (missing checkout)')
  endif
endfor
for s:buf in range(1, bufnr('$'))
  if bufexists(s:buf) && fnamemodify(bufname(s:buf), ':t') =~# '^\[Plugins\]'
    for s:line in getbufline(s:buf, 1, '$')
      if s:line =~# '^x '
        call add(s:failed, s:line)
      endif
    endfor
  endif
endfor
if !empty(s:failed)
  echoerr 'Failed Vim plugins: ' . join(s:failed, ', ')
  cquit 1
endif
qa!
