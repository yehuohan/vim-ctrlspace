let s:config = ctrlspace#context#Configuration()
let s:modes  = ctrlspace#modes#Modes()

function! ctrlspace#keys#buffer#Init()
	call ctrlspace#keys#AddMapping("ctrlspace#keys#buffer#LoadBuffer"                  , "Buffer" , ["CR"])
	call ctrlspace#keys#AddMapping("ctrlspace#keys#buffer#LoadManyBuffers"             , "Buffer" , ["Space"])
	call ctrlspace#keys#AddMapping("ctrlspace#keys#buffer#ToggleAllMode"               , "Buffer" , ["a"])
	call ctrlspace#keys#AddMapping("ctrlspace#keys#buffer#LoadBufferVS"                , "Buffer" , ["v"])
	call ctrlspace#keys#AddMapping("ctrlspace#keys#buffer#LoadManyBuffersVS"           , "Buffer" , ["V"])
	call ctrlspace#keys#AddMapping("ctrlspace#keys#buffer#LoadBufferSP"                , "Buffer" , ["s"])
	call ctrlspace#keys#AddMapping("ctrlspace#keys#buffer#LoadManyBuffersSP"           , "Buffer" , ["S"])
	call ctrlspace#keys#AddMapping("ctrlspace#keys#buffer#LoadBufferT"                 , "Buffer" , ["t"])
	call ctrlspace#keys#AddMapping("ctrlspace#keys#buffer#LoadManyBuffersT"            , "Buffer" , ["T"])
	call ctrlspace#keys#AddMapping("ctrlspace#keys#buffer#NewTabLabel"                 , "Buffer" , ["m"])
	call ctrlspace#keys#AddMapping("ctrlspace#keys#buffer#RemoveTabLabel"              , "Buffer" , ["M"])
	call ctrlspace#keys#AddMapping("ctrlspace#keys#buffer#MoveTab"                     , "Buffer" , ["=", "-"])
	call ctrlspace#keys#AddMapping("ctrlspace#keys#buffer#SwitchTab"                   , "Buffer" , ["[", "]"])
	call ctrlspace#keys#AddMapping("ctrlspace#keys#buffer#MoveBufferToTab"             , "Buffer" , ["{", "}"])
	call ctrlspace#keys#AddMapping("ctrlspace#keys#buffer#DeleteBuffer"                , "Buffer" , ["d"])
	call ctrlspace#keys#AddMapping("ctrlspace#keys#buffer#DeleteHiddenNonameBuffers"   , "Buffer" , ["D"])
	call ctrlspace#keys#AddMapping("ctrlspace#keys#buffer#DetachBuffer"                , "Buffer" , ["f"])
	call ctrlspace#keys#AddMapping("ctrlspace#keys#buffer#DeleteForeignBuffers"        , "Buffer" , ["F"])
	call ctrlspace#keys#AddMapping("ctrlspace#keys#buffer#CloseBuffer"                 , "Buffer" , ["c"])
	call ctrlspace#keys#AddMapping("ctrlspace#keys#buffer#CloseTab"                    , "Buffer" , ["C"])
	call ctrlspace#keys#AddMapping("ctrlspace#keys#buffer#EditFile"                    , "Buffer" , ["e"])
endfunction

function! ctrlspace#keys#buffer#LoadBuffer(k)
	call ctrlspace#buffers#LoadBuffer()
endfunction

function! ctrlspace#keys#buffer#LoadManyBuffers(k)
	call ctrlspace#buffers#LoadManyBuffers()
endfunction

function! ctrlspace#keys#buffer#LoadBufferVS(k)
	call ctrlspace#buffers#LoadBuffer("vs")
endfunction

function! ctrlspace#keys#buffer#LoadManyBuffersVS(k)
	call ctrlspace#buffers#LoadManyBuffers("vs")
endfunction

function! ctrlspace#keys#buffer#LoadBufferSP(k)
	call ctrlspace#buffers#LoadBuffer("sp")
endfunction

function! ctrlspace#keys#buffer#LoadManyBuffersSP(k)
	call ctrlspace#buffers#LoadManyBuffers("sp")
endfunction

function! ctrlspace#keys#buffer#LoadBufferT(k)
	call ctrlspace#buffers#LoadBuffer("tabnew")
endfunction

function! ctrlspace#keys#buffer#LoadManyBuffersT(k)
	call s:modes.NextTab.Enable()
	call ctrlspace#buffers#LoadManyBuffers("tabnew", "tabprevious")
endfunction

function! ctrlspace#keys#buffer#NewTabLabel(k)
	call ctrlspace#tabs#NewTabLabel(0)
	call ctrlspace#util#SetStatusline()
	redraws
endfunction

function! ctrlspace#keys#buffer#MoveTab(k)
	if v:version < 704
		if a:k ==# "="
			silent! exe "tabm" . tabpagenr()
		elseif a:k ==# "-"
			silent! exe "tabm" . (tabpagenr() - 2)
		endif
	else
		silent! exe "tabm" . a:k . "1"
	endif

	call ctrlspace#util#SetStatusline()
	redraws
endfunction

function! ctrlspace#keys#buffer#RemoveTabLabel(k)
	call ctrlspace#tabs#RemoveTabLabel(0)
	call ctrlspace#util#SetStatusline()
	redraw!
endfunction

function! ctrlspace#keys#buffer#SwitchTab(k)
	call ctrlspace#window#Kill(0, 1)

	if a:k ==# "["
		silent! exe "normal! gT"
	elseif a:k ==# "]"
		silent! exe "normal! gt"
	endif

	call ctrlspace#window#Toggle(0)
endfunction

function! ctrlspace#keys#buffer#MoveBufferToTab(k)
	if s:modes.Buffer.Data.SubMode ==# "all"
		return 0
	endif

	let curTab = tabpagenr()

	if a:k ==# "{"
		if curTab > 1
			call ctrlspace#buffers#MoveBufferToTab(curTab - 1)
		endif
	elseif a:k ==# "}"
		if curTab < tabpagenr("$")
			call ctrlspace#buffers#MoveBufferToTab(curTab + 1)
		endif
	endif
endfunction

function! ctrlspace#keys#buffer#DeleteBuffer(k)
	call ctrlspace#buffers#DeleteBuffer()
endfunction

function! ctrlspace#keys#buffer#DeleteHiddenNonameBuffers(k)
	call ctrlspace#buffers#DeleteHiddenNonameBuffers(0)
	call ctrlspace#ui#DelayedMsg()
endfunction

function! ctrlspace#keys#buffer#DetachBuffer(k)
	if s:modes.Buffer.Data.SubMode ==# "single"
		call ctrlspace#buffers#DetachBuffer()
	endif
endfunction

function! ctrlspace#keys#buffer#DeleteForeignBuffers(k)
	call ctrlspace#buffers#DeleteForeignBuffers(0)
	call ctrlspace#ui#DelayedMsg()
endfunction

function! ctrlspace#keys#buffer#CloseBuffer(k)
	call ctrlspace#buffers#CloseBuffer()
endfunction

function! ctrlspace#keys#buffer#CloseTab(k)
	call ctrlspace#tabs#CloseTab()
	call ctrlspace#ui#Msg("Current tab closed.")
endfunction

function! ctrlspace#keys#buffer#ToggleAllMode(k)
	if s:modes.Buffer.Data.SubMode !=# "all"
		call s:modes.Buffer.SetData("SubMode", "all")
	else
		call s:modes.Buffer.SetData("SubMode", "single")
	endif

	if !empty(s:modes.Search.Data.Letters)
		call s:modes.Search.SetData("NewSearchPerformed", 1)
	endif

	call ctrlspace#window#Kill(0, 0)
	call ctrlspace#window#Toggle(1)
endfunction

function! ctrlspace#keys#buffer#EditFile(k)
	call ctrlspace#files#EditFile()
endfunction
