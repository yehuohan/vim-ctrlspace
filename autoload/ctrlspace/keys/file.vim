let s:config = ctrlspace#context#Configuration()
let s:modes  = ctrlspace#modes#Modes()

function! ctrlspace#keys#file#Init()
    call ctrlspace#keys#AddMapping("ctrlspace#keys#file#LoadFile"                , "File" , ["CR"])
    call ctrlspace#keys#AddMapping("ctrlspace#keys#file#LoadManyFiles"           , "File" , ["Space"])
    call ctrlspace#keys#AddMapping("ctrlspace#keys#file#LoadFileVS"              , "File" , ["v"])
    call ctrlspace#keys#AddMapping("ctrlspace#keys#file#LoadManyFilesVS"         , "File" , ["V"])
    call ctrlspace#keys#AddMapping("ctrlspace#keys#file#LoadFileSP"              , "File" , ["s"])
    call ctrlspace#keys#AddMapping("ctrlspace#keys#file#LoadManyFilesSP"         , "File" , ["S"])
    call ctrlspace#keys#AddMapping("ctrlspace#keys#file#LoadFileT"               , "File" , ["t"])
    call ctrlspace#keys#AddMapping("ctrlspace#keys#file#LoadManyFilesT"          , "File" , ["T"])
    call ctrlspace#keys#AddMapping("ctrlspace#keys#file#Refresh"                 , "File" , ["r"])
endfunction

function! ctrlspace#keys#file#LoadFile(k)
    call ctrlspace#files#LoadFile()
endfunction

function! ctrlspace#keys#file#LoadManyFiles(k)
    call ctrlspace#files#LoadManyFiles()
endfunction

function! ctrlspace#keys#file#LoadFileVS(k)
    call ctrlspace#files#LoadFile("vs")
endfunction

function! ctrlspace#keys#file#LoadManyFilesVS(k)
    call ctrlspace#files#LoadManyFiles("vs")
endfunction

function! ctrlspace#keys#file#LoadFileSP(k)
    call ctrlspace#files#LoadFile("sp")
endfunction

function! ctrlspace#keys#file#LoadManyFilesSP(k)
    call ctrlspace#files#LoadManyFiles("sp")
endfunction

function! ctrlspace#keys#file#LoadFileT(k)
    call ctrlspace#files#LoadFile("tabnew")
endfunction

function! ctrlspace#keys#file#LoadManyFilesT(k)
    call s:modes.NextTab.Enable()
    call ctrlspace#files#LoadManyFiles("tabnew", "tabprevious")
endfunction

function! ctrlspace#keys#file#Refresh(k)
    call ctrlspace#files#RefreshFiles()
endfunction
