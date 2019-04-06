let s:config = ctrlspace#context#Configuration()
let s:modes  = ctrlspace#modes#Modes()
let s:files  = []
let s:items  = []

function! ctrlspace#files#Files()
	return s:files
endfunction

function! ctrlspace#files#ClearAll()
	let s:files = []
	let s:items = []
endfunction

function! ctrlspace#files#Items()
	return s:items
endfunction

function! ctrlspace#files#SelectedFileName()
	return s:modes.File.Enabled ? s:files[ctrlspace#window#SelectedIndex()] : ""
endfunction

function! ctrlspace#files#CollectFiles()
	if empty(s:files)
		let s:items = []

		" try to pick up files from cache
		call s:loadFilesFromCache()

		if empty(s:files)
			let action = "Collecting files..."
			call ctrlspace#ui#Msg(action)

			let uniqueFiles = {}

			for fname in empty(s:config.GlobCommand) ? split(globpath('.', '**'), '\n') : split(system(s:config.GlobCommand), '\n')
				let fnameModified = fnamemodify(has("win32") ? substitute(fname, "\r$", "", "") : fname, ":.")

				if isdirectory(fnameModified) || (fnameModified =~# s:config.IgnoredFiles)
					continue
				endif

				let uniqueFiles[fnameModified] = 1
			endfor

			let s:files = keys(uniqueFiles)
			call s:saveFilesInCache()
		else
			let action = "Loading files..."
			call ctrlspace#ui#Msg(action)
		endif

		let s:items = map(copy(s:files), '{ "index": v:key, "text": v:val, "indicators": "" }')

		redraw!

		call ctrlspace#ui#Msg(action . " Done (" . len(s:files) . ").")
	endif

	return s:files
endfunction

function! ctrlspace#files#LoadFile(...)
	let idx = ctrlspace#window#SelectedIndex()
	let file = fnamemodify(s:files[idx], ":p")

	call ctrlspace#window#Kill(0, 1)

	let commands = len(a:000)

	if commands > 0
		exec ":" . a:1
	endif

	call s:loadFileOrBuffer(file)

	if commands > 1
		silent! exe ":" . a:2
	endif
endfunction

function! ctrlspace#files#LoadManyFiles(...)
	let idx   = ctrlspace#window#SelectedIndex()
	let file  = fnamemodify(s:files[idx], ":p")
	let curln = line(".")

	call ctrlspace#window#Kill(0, 0)
	call ctrlspace#window#GoToStartWindow()

	let commands = len(a:000)

	if commands > 0
		exec ":" . a:1
	endif

	call s:loadFileOrBuffer(file)
	normal! zb

	if commands > 1
		silent! exe ":" . a:2
	endif

	call ctrlspace#window#Toggle(1)
	call ctrlspace#window#MoveSelectionBar(curln)
endfunction

function! ctrlspace#files#RefreshFiles()
	let s:files = []
	call s:saveFilesInCache()
	call ctrlspace#window#Kill(0, 0)
	call ctrlspace#window#Toggle(1)
endfunction

function! ctrlspace#files#EditFile()
	let nr   = ctrlspace#window#SelectedIndex()
	let path = fnamemodify(s:modes.File.Enabled ? s:files[nr] : resolve(bufname(nr)), ":.:h")

	if !isdirectory(path)
		return
	endif

	let newFile = ctrlspace#ui#GetInput("Edit a new file: ", path . '/', "file")

	if empty(newFile)
		return
	endif

	let newFile = expand(newFile)

	if isdirectory(newFile)
		call ctrlspace#window#Kill(0, 1)
		enew
		return
	endif

	if !s:ensurePath(newFile)
		return
	endif

	let newFile = fnamemodify(newFile, ":p")

	call ctrlspace#window#Kill(0, 1)
	silent! exe "e " . fnameescape(newFile)
endfunction

function! s:saveFilesInCache()
	let filename = ctrlspace#util#FilesCache()

	if empty(filename)
		return
	endif

	call writefile(s:files, filename)
endfunction

function! s:loadFilesFromCache()
	let filename = ctrlspace#util#FilesCache()

	if empty(filename) || !filereadable(filename)
		return
	endif

	let s:files = readfile(filename)
endfunction

function! s:loadFileOrBuffer(file)
	if buflisted(a:file)
		silent! exe ":b " . bufnr(a:file)
	else
		exec ":e " . fnameescape(a:file)
	endif
endfunction

function! s:ensurePath(file)
	let directory = fnamemodify(a:file, ":.:h")

	if !isdirectory(directory)
		if !ctrlspace#ui#Confirmed("Directory '" . directory . "' will be created. Continue?")
			return 0
		endif

		call mkdir(fnamemodify(directory, ":p"), "p")
	endif

	return 1
endfunction
