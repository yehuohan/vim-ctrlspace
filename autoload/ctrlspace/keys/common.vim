let s:config       = ctrlspace#context#Configuration()
let s:modes        = ctrlspace#modes#Modes()
let s:commonMap    = {}
let s:helpMap      = {}
let s:lastListView = "Buffer"

function! ctrlspace#keys#common#Init()
	call s:map("ToggleHelp",                   "?")
	call s:map("Down",                         "j")
	call s:map("Up",                           "k")
	call s:map("Previous",                     "p")
	call s:map("Next",                         "n")
	call s:map("Top",                          "K")
	call s:map("Bottom",                       "J")
	call s:map("HalfScrollDown",               'C-j')
	call s:map("HalfScrollUp",                 'C-k')
	call s:map("Close",                        "q", "Esc")
	call s:map("EnterSearchMode",              "/")
	call s:map("BackOrClearSearch",            "BS")
	call s:map("ToggleFileMode",               "o")
	call s:map("ToggleFileModeAndSearch",      "O")
	call s:map("ToggleBufferMode",             "h")
	call s:map("ToggleBufferModeAndSearch",    "H")
	call s:map("ToggleWorkspaceMode",          "w")
	call s:map("ToggleWorkspaceModeAndSearch", "W")
	call s:map("ToggleTabMode",                "l")
	call s:map("ToggleTabModeAndSearch",       "L")
	call s:map("ToggleBookmarkMode",           "b")
	call s:map("ToggleBookmarkModeAndSearch",  "B")

	let keyMap  = ctrlspace#keys#KeyMap()
	let helpMap = ctrlspace#help#HelpMap()

	for m in ["Buffer", "File", "Tab", "Workspace", "Bookmark"]
		call extend(keyMap[m], s:commonMap)
		call extend(helpMap[m], s:helpMap)
	endfor
endfunction

function! s:map(func, ...)
	let fn = "ctrlspace#keys#common#" . a:func
	let Ref = function(fn)

	for k in a:000
		let s:helpMap[k] = fn
		let s:commonMap[k] = Ref
	endfor
endfunction

function! ctrlspace#keys#common#EnterSearchMode(k)
	call ctrlspace#search#SwitchSearchMode(1)
endfunction

function! ctrlspace#keys#common#ToggleHelp(k)
	call ctrlspace#window#Kill(0, 0)

	if s:modes.Help.Enabled
		call s:modes.Help.Disable()
	else
		call s:modes.Help.Enable()
	endif

	call ctrlspace#window#Toggle(1)
endfunction

function! ctrlspace#keys#common#Up(k)
	call ctrlspace#window#MoveSelectionBar("up")
endfunction

function! ctrlspace#keys#common#Down(k)
	call ctrlspace#window#MoveSelectionBar("down")
endfunction

function! ctrlspace#keys#common#Previous(k)
	call ctrlspace#jumps#Jump("previous")
endfunction

function! ctrlspace#keys#common#Next(k)
	call ctrlspace#jumps#Jump("next")
endfunction

function! ctrlspace#keys#common#Top(k)
	call ctrlspace#window#MoveSelectionBar(1)
endfunction

function! ctrlspace#keys#common#Bottom(k)
	call ctrlspace#window#MoveSelectionBar(line("$"))
endfunction

function! ctrlspace#keys#common#HalfScrollDown(k)
	call ctrlspace#window#MoveSelectionBar("half_pgdown")
endfunction

function! ctrlspace#keys#common#HalfScrollUp(k)
	call ctrlspace#window#MoveSelectionBar("half_pgup")
endfunction

function! ctrlspace#keys#common#Close(k)
	call ctrlspace#window#Kill(0, 1)
endfunction

function! s:toggleListViewAndSearch(k, mode)
	if !s:modes[a:mode].Enabled
		if !function("ctrlspace#keys#common#Toggle" . a:mode . "Mode")(a:k)
			return 0
		endif
	endif

	call ctrlspace#search#SwitchSearchMode(1)
	return 1
endfunction

function! s:toggleListView(k, mode)
	" TODO Temporary place
	if s:modes.Workspace.Enabled
		call s:modes.Workspace.SetData("LastBrowsed", line("."))
	endif

    " For toggle back
	if s:modes[a:mode].Enabled
		if s:lastListView ==# a:mode
			return 0
		else
			return function("ctrlspace#keys#common#Toggle" . s:lastListView . "Mode")(a:k)
		endif
	endif

	let s:lastListView = ctrlspace#modes#CurrentListView().Name

	call ctrlspace#window#Kill(0, 0)
	call s:modes[a:mode].Enable()
	call ctrlspace#window#Toggle(1)

	return 1
endfunction

function! ctrlspace#keys#common#BackOrClearSearch(k)
	if !empty(s:modes.Search.Data.Letters)
		call ctrlspace#search#ClearSearchMode()
	elseif !empty(s:lastListView)
		if ctrlspace#modes#CurrentListView().Name ==# s:lastListView
			return 0
		else
			return function("ctrlspace#keys#common#Toggle" . s:lastListView . "Mode")(a:k)
		endif
	endif
endfunction

function! ctrlspace#keys#common#ToggleFileModeAndSearch(k)
	return s:toggleListViewAndSearch(a:k, "File")
endfunction

function! ctrlspace#keys#common#ToggleFileMode(k)
	if !ctrlspace#roots#ProjectRootFound()
		return 0
	endif

	return s:toggleListView(a:k, "File")
endfunction

function! ctrlspace#keys#common#ToggleBufferModeAndSearch(k)
	return s:toggleListViewAndSearch(a:k, "Buffer")
endfunction

function! ctrlspace#keys#common#ToggleBufferMode(k)
	return s:toggleListView(a:k, "Buffer")
endfunction

function! ctrlspace#keys#common#ToggleWorkspaceModeAndSearch(k)
	return s:toggleListViewAndSearch(a:k, "Workspace")
endfunction

" FUNCTION: ctrlspace#keys#common#ToggleWorkspaceMode(k) {{{
function! ctrlspace#keys#common#ToggleWorkspaceMode(k)
    if empty(ctrlspace#workspaces#CacheWorkspaces())
        return ctrlspace#workspaces#AddNewWorkspace()
	else
		return s:toggleListView(a:k, "Workspace")
	endif
endfunction
" }}}

function! ctrlspace#keys#common#ToggleTabModeAndSearch(k)
	return s:toggleListViewAndSearch(a:k, "Tab")
endfunction

function! ctrlspace#keys#common#ToggleTabMode(k)
	return s:toggleListView(a:k, "Tab")
endfunction

function! ctrlspace#keys#common#ToggleBookmarkModeAndSearch(k)
	return s:toggleListViewAndSearch(a:k, "Bookmark")
endfunction

function! ctrlspace#keys#common#ToggleBookmarkMode(k)
	if empty(ctrlspace#bookmarks#Bookmarks())
		call ctrlspace#bookmarks#AddFirstBookmark()
		return 0
	else
		return s:toggleListView(a:k, "Bookmark")
	endif
endfunction

