
if has("gui_running")
  " GUI is running or is about to start.
  " set lines=25 columns=95
else
    " This is console Vim.
	if exists("+lines")
		" set lines=50
	endif
	if exists("+columns")
		" set columns=100
	endif
endif
