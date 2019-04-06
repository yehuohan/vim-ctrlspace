let s:config        = ctrlspace#context#Configuration()
let s:modes         = ctrlspace#modes#Modes()
let s:sizes         = ctrlspace#context#SymbolSizes()
let s:textBuffer    = []
let s:externalBufnr = -1

let s:helpMap = {
            \ "Search":    {},
            \ "Nop":       {},
            \ "Buffer":    {},
            \ "File":      {},
            \ "Tab":       {},
            \ "Workspace": {},
            \ "Bookmark":  {}
            \ }

let s:descriptions = {
            \ "ctrlspace#keys#common#ToggleHelp":                   "Toggle the Help view",
            \ "ctrlspace#keys#common#Down":                         "Move the selection bar down",
            \ "ctrlspace#keys#common#Up":                           "Move the selection bar up",
            \ "ctrlspace#keys#common#Previous":                     "Move the selection bar to the previously opened item",
            \ "ctrlspace#keys#common#Next":                         "Move the selection bar to the next opened item",
            \ "ctrlspace#keys#common#Top":                          "Move the selection bar to the top of the list",
            \ "ctrlspace#keys#common#Bottom":                       "Move the selection bar to the bottom of the list",
            \ "ctrlspace#keys#common#ScrollDown":                   "Move the selection bar one screen down",
            \ "ctrlspace#keys#common#ScrollUp":                     "Move the selection bar one screen up",
            \ "ctrlspace#keys#common#HalfScrollDown":               "Move the selection bar a half screen down",
            \ "ctrlspace#keys#common#HalfScrollUp":                 "Move the selection bar a half screen up",
            \ "ctrlspace#keys#common#Close":                        "Close the list",
            \ "ctrlspace#keys#common#EnterSearchMode":              "Enter Search Mode",
            \ "ctrlspace#keys#common#BackOrClearSearch":            "Return to the previous list (if any) or clear the searched text",
            \ "ctrlspace#keys#common#ToggleFileMode":               "Toggle File List ([O]pen List) view",
            \ "ctrlspace#keys#common#ToggleFileModeAndSearch":      "Enter the File List ([O]pen List) in Search Mode",
            \ "ctrlspace#keys#common#ToggleBufferMode":             "Toggle Buffer List view ([H]ome List)",
            \ "ctrlspace#keys#common#ToggleBufferModeAndSearch":    "Enter the Buffer List ([H]ome List) in Search Mode",
            \ "ctrlspace#keys#common#ToggleWorkspaceMode":          "Toggle Workspace List view",
            \ "ctrlspace#keys#common#ToggleWorkspaceModeAndSearch": "Enter the Workspace List in Search Mode",
            \ "ctrlspace#keys#common#ToggleTabMode":                "Toggle Tab List view (Tab [L]ist)",
            \ "ctrlspace#keys#common#ToggleTabModeAndSearch":       "Enter the Tab List (Tab [L]ist) in Search Mode",
            \ "ctrlspace#keys#common#ToggleBookmarkMode":           "Toggle Bookmark List view",
            \ "ctrlspace#keys#common#ToggleBookmarkModeAndSearch":  "Enter the Bookmark List in Search Mode",
            \ "ctrlspace#keys#search#ClearOrRemoveLetter":          "Remove a previously entered character",
            \ "ctrlspace#keys#search#AddLetter":                    "Add a character to search",
            \ "ctrlspace#keys#search#SwitchOff":                    "Exit Search Mode",
            \ "ctrlspace#keys#search#SwitchOffCR":                  "Exit Search Mode and accept first result",
            \ "ctrlspace#keys#search#SwitchOffSpace":               "Exit Search Mode and accept first result but stay in the plugin window",
            \ "ctrlspace#keys#search#ClearLetters":                 "Clear search phrase",
            \ "ctrlspace#keys#buffer#LoadBuffer":                   "Open selected buffer",
            \ "ctrlspace#keys#buffer#LoadManyBuffers":              "Open selected buffer and stay in the plugin window",
            \ "ctrlspace#keys#buffer#LoadBufferVS":                 "Open selected buffer in a new vertical split",
            \ "ctrlspace#keys#buffer#LoadManyBuffersVS":            "Open selected buffer in a new vertical split but stay in the plugin window",
            \ "ctrlspace#keys#buffer#LoadBufferSP":                 "Open selected buffer in a new horizontal split",
            \ "ctrlspace#keys#buffer#LoadManyBuffersSP":            "Open selected buffer in a new horizontal split but stay in the plugin window",
            \ "ctrlspace#keys#buffer#LoadBufferT":                  "Open selected buffer in a new tab",
            \ "ctrlspace#keys#buffer#LoadManyBuffersT":             "Open selected buffer in a new tab but stay in the plugin window",
            \ "ctrlspace#keys#buffer#NewTabLabel":                  "Change the tab name",
            \ "ctrlspace#keys#buffer#RemoveTabLabel":               "Remove a custom tab name",
            \ "ctrlspace#keys#buffer#MoveTab":                      "Move the current tab previous/next",
            \ "ctrlspace#keys#buffer#SwitchTab":                    "Go to the previous/next tab",
            \ "ctrlspace#keys#buffer#MoveBufferToTab":              "Move the selected buffer to to the previous/next tab",
            \ "ctrlspace#keys#buffer#DeleteBuffer":                 "Delete the selected buffer (close it)",
            \ "ctrlspace#keys#buffer#DeleteHiddenNonameBuffers":    "Close all empty noname buffers",
            \ "ctrlspace#keys#buffer#ToggleAllMode":                "Enter the All Mode",
            \ "ctrlspace#keys#buffer#DetachBuffer":                 "Forget the current buffer (make it foreign to the current tab)",
            \ "ctrlspace#keys#buffer#DeleteForeignBuffers":         "Delete (close) all foreign buffers (detached from tabs)",
            \ "ctrlspace#keys#buffer#CloseBuffer":                  "Try to close selected buffer (delete if possible, forget otherwise)",
            \ "ctrlspace#keys#buffer#CloseTab":                     "Close the current tab, then perform F, and then D",
            \ "ctrlspace#keys#buffer#EditFile":                     "Edit a new file or a sibling of selected buffer",
            \ "ctrlspace#keys#file#LoadFile":                       "Open selected file",
            \ "ctrlspace#keys#file#LoadManyFiles":                  "Open selected file but stays in the plugin window",
            \ "ctrlspace#keys#file#LoadFileVS":                     "Open selected file in a new vertical split",
            \ "ctrlspace#keys#file#LoadManyFilesVS":                "Open selected file in a new vertical split but stay in the plugin window",
            \ "ctrlspace#keys#file#LoadFileSP":                     "Open selected file in a new horizontal split",
            \ "ctrlspace#keys#file#LoadManyFilesSP":                "Open selected file in a new horizontal split but stay in the plugin window",
            \ "ctrlspace#keys#file#LoadFileT":                      "Open selected file in a new tab",
            \ "ctrlspace#keys#file#LoadManyFilesT":                 "Open selected file in a new (or next) tab but stay in the plugin window",
            \ "ctrlspace#keys#file#Refresh":                        "Refresh the file list (force reloading)",
            \ "ctrlspace#keys#bookmark#GoToBookmark":               "Jump to selected bookmark (CR - open, Space - stay)",
            \ "ctrlspace#keys#bookmark#Add":                        "Add a new bookmark",
            \ "ctrlspace#keys#bookmark#Delete":                     "Delete selected bookmark",
            \ "ctrlspace#keys#bookmark#Append":                     "Append bookmarked file(t - new tab, s/v - split)",
            \ "ctrlspace#keys#bookmark#Sort":                       "Toggle sort mode between path and name",
            \ "ctrlspace#keys#tab#GoToTab":                         "Open a selected tab (Tab - close, Space - stay)",
            \ "ctrlspace#keys#tab#CloseTab":                        "Close the selected tab, then foreign buffers and nonames",
            \ "ctrlspace#keys#tab#AddTab":                          "Create a new tab",
            \ "ctrlspace#keys#tab#SwitchTab":                       "Go to the previous/next tab",
            \ "ctrlspace#keys#tab#MoveTab":                         "Move the selected tab backward/forward",
            \ "ctrlspace#keys#tab#NewTabLabel":                     "Change the selected tab name",
            \ "ctrlspace#keys#tab#RemoveTabLabel":                  "Remove the selected tab name",
            \ "ctrlspace#keys#tab#CollectUnsavedBuffers":           "Create a new tab with unsaved buffers",
            \ "ctrlspace#keys#tab#CollectForeignBuffers":           "Create a new tab with foreign buffers",
            \ "ctrlspace#keys#workspace#Load":                      "Load selected workspace (CR - close, Space - stay)",
            \ "ctrlspace#keys#workspace#Append":                    "Append a selected workspace to new tab",
            \ "ctrlspace#keys#workspace#Add":                       "Add new workspace in current project root",
            \ "ctrlspace#keys#workspace#Close":                     "Clear workspace - close all buffers and tabs",
            \ "ctrlspace#keys#workspace#Save":                      "Save selected workspace",
            \ "ctrlspace#keys#workspace#Delete":                    "Delete selected workspace",
            \ "ctrlspace#keys#workspace#Rename":                    "Rename selected workspace",
            \ "ctrlspace#keys#workspace#Sort":                      "Toggle sort mode between path and name",
            \ "ctrlspace#keys#nop#ToggleAllMode":                   "Enter the All Mode if in Buffer Mode already",
            \ }

function! ctrlspace#help#AddMapping(funcName, mapName, entry)
    if has_key(s:helpMap, a:mapName)
        let s:helpMap[a:mapName][a:entry] = a:funcName
    endif
endfunction

function! ctrlspace#help#HelpMap()
    return s:helpMap
endfunction

function! ctrlspace#help#Descriptions()
    return s:descriptions
endfunction

function! s:init()
    call extend(s:descriptions, s:config.Help)
endfunction

call s:init()

function! ctrlspace#help#CloseExternalWindow()
    if bufexists(s:externalBufnr)
        let curtab = tabpagenr()

        for t in range(1, tabpagenr("$"))
            let bufs = map(keys(ctrlspace#buffers#Buffers(t)), "str2nr(v:val)")

            if index(bufs, s:externalBufnr) != -1 && len(bufs) > 1
                silent! exe "normal! " . t . "gt"

                if bufwinnr(s:externalBufnr) == 1 && winnr("$") == 1
                    silent! exe ":CtrlSpaceGoDown"
                endif

                silent! exe "normal! " . curtab . "gt"
            endif
        endfor

        silent! exe "bw " . s:externalBufnr
    endif
endfunction

" FUNCTION: ctrlspace#help#OpenInNewWindow() {{{
function! ctrlspace#help#OpenInNewWindow()
    let mi     = s:modeInfo()
    let header = "Key Reference for " . mi[0] . " LIST"
    let fname  = fnameescape(mi[0] . " LIST KEY REFERENCE")

    if len(mi) > 1
        let header .= " (" . join(mi[1:], ", ") . ")"
    endif

    call add(s:textBuffer, header . " - press <q> to close")
    call add(s:textBuffer, "")

    for info in b:helpKeyDescriptions
        call add(s:textBuffer, info.key . " | " . info.description)
    endfor

    call ctrlspace#window#Kill(0, 1)
    call ctrlspace#help#CloseExternalWindow()

    if winnr("$") > 1
        new
        wincmd K
        wincmd _
    else
        enew
    endif

    let s:externalBufnr = bufnr("%")

    silent! exe "file " . fname

    setlocal noswapfile
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal buflisted
    setlocal filetype=ctrlspace_help

    setlocal modifiable

    silent! put! =s:flushTextBuffer()
    normal! GkJ
    normal! gg
    normal! 0

    noremap <silent><buffer> q :call ctrlspace#help#CloseExternalWindow()<CR>

    setlocal nomodifiable
endfunction
" }}}

" FUNCTION: ctrlspace#help#DisplayHelp(fill) {{{
function! ctrlspace#help#DisplayHelp(fill)
    if s:modes.Nop.Enabled
        let mapName = "Nop"
    elseif s:modes.Search.Enabled
        let mapName = "Search"
    else
        let mapName = ctrlspace#modes#CurrentListView().Name
    endif

    call s:collectKeysInfo(mapName)

    let mi     = s:modeInfo()
    let header = "Key Reference for " . mi[0] . " LIST"

    if len(mi) > 1
        let header .= " (" . join(mi[1:], ", ") . ")"
    endif

    call s:puts(s:config.Symbols.CS . " CtrlSpace 5.0.7 (engine: " . s:config.FileEngineName . ")")
    call s:puts(header . " - press <CR> to expand")
    call s:puts("")

    if !empty(b:helpKeyDescriptionsMode)
        call s:puts("=============== " . mapName . " Keys ===============")
        for info in b:helpKeyDescriptionsMode
            call s:puts(info.key . " | " . info.description)
        endfor
    endif
    call s:puts("")

    if mapName ==# "Nop" || mapName ==# "Search"
        call s:puts("=============== " . mapName . " Keys ===============")
    else
        call s:puts("=============== Common Keys ===============")
    endif
    for info in b:helpKeyDescriptions
        call s:puts(info.key . " | " . info.description)
    endfor

    call s:puts("")
    call s:puts("Copyright (c) 2013-2015 Szymon Wrozynski and Contributors")

    setlocal modifiable

    let b:size = len(s:textBuffer)

    if b:size > s:config.Height
        let maxHeight = ctrlspace#window#MaxHeight()

        if b:size < maxHeight
            silent! exe "resize " . b:size
        else
            silent! exe "resize " . maxHeight
        endif
    endif

    silent! put! =s:flushTextBuffer()
    normal! GkJ

    while winheight(0) > line(".")
        silent! put =a:fill
    endwhile

    normal! gg
    normal! 0

    setlocal nomodifiable
endfunction
" }}}

function! s:puts(str)
    let str = "  " . a:str

    if &columns < (strwidth(str) + 2)
        let str = strpart(str, 0, &columns - 2 - s:sizes.Dots) . s:config.Symbols.Dots
    endif

    while strwidth(str) < &columns
        let str .= " "
    endwhile

    call add(s:textBuffer, str)
endfunction

function! s:flushTextBuffer()
    let text = join(s:textBuffer, "\n")
    let s:textBuffer = []
    return text
endfunction

" FUNCTION: s:keyHelp(key, description, ismode) {{{
function! s:keyHelp(key, description, ismode)
    if !exists("b:helpKeyDescriptions")
        let b:helpKeyDescriptions = []
        let b:helpKeyDescriptionsMode = []
        let b:helpKeyWidth = 0
    endif

    if a:ismode
        call add(b:helpKeyDescriptionsMode, { "key": a:key, "description": a:description })
    else
        call add(b:helpKeyDescriptions, { "key": a:key, "description": a:description })
    endif

    if strwidth(a:key) > b:helpKeyWidth
        let b:helpKeyWidth = strwidth(a:key)
    else
        for keyInfo in b:helpKeyDescriptions
            if strwidth(keyInfo.key) < b:helpKeyWidth
                let keyInfo.key .= repeat(" ", b:helpKeyWidth - strwidth(keyInfo.key))
            endif
        endfor
        for keyInfo in b:helpKeyDescriptionsMode
            if strwidth(keyInfo.key) < b:helpKeyWidth
                let keyInfo.key .= repeat(" ", b:helpKeyWidth - strwidth(keyInfo.key))
            endif
        endfor
    endif
endfunction
" }}}

" FUNCTION: s:collectKeysInfo(mapName) {{{
function! s:collectKeysInfo(mapName)
    for key in sort(keys(s:helpMap[a:mapName]))
        let fn = s:helpMap[a:mapName][key]

        if has_key(s:descriptions, fn) && !empty(s:descriptions[fn])
            if (fn =~# "^" . "ctrlspace#keys#buffer" ||
                \ fn =~# "^" . "ctrlspace#keys#file" ||
                \ fn =~# "^" . "ctrlspace#keys#bookmark" ||
                \ fn =~# "^" . "ctrlspace#keys#tab" ||
                \ fn =~# "^" . "ctrlspace#keys#workspace")
                call s:keyHelp(key, s:descriptions[fn], 1)
            else
                call s:keyHelp(key, s:descriptions[fn], 0)
            endif
        endif
    endfor
endfunction
" }}}

" FUNCTION: s:modeInfo() {{{
function! s:modeInfo()
    let info = []
    let clv  = ctrlspace#modes#CurrentListView()

    if clv.Name ==# "Workspace"
        call add(info, "WORKSPACE")
    elseif clv.Name ==# "Tab"
        call add(info, "TAB")
    elseif clv.Name ==# "Bookmark"
        call add(info, "BOOKMARK")
    else
        if clv.Name ==# "File"
            call add(info, "FILE")
        elseif clv.Name ==# "Buffer"
            call add(info, "BUFFER")
            if clv.Data.SubMode ==# "visible"
                call add(info, "VISIBLE")
            elseif clv.Data.SubMode ==# "single"
                call add(info, "SINGLE")
            elseif clv.Data.SubMode ==# "all"
                call add(info, "ALL")
            endif
        endif

        if s:modes.NextTab.Enabled
            call add(info, "NEXT TAB")
        endif
    endif

    if s:modes.Search.Enabled
        call add(info, "SEARCH")
    endif

    if s:modes.Zoom.Enabled
        call add(info, "ZOOM")
    endif

    if s:modes.Nop.Enabled
        call add(info, "NOP")
    endif

    return info
endfunction
" }}}
