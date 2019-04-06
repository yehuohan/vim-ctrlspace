let s:config = ctrlspace#context#Configuration()
let s:modes  = ctrlspace#modes#Modes()

function! ctrlspace#keys#help#Init()
	call ctrlspace#keys#AddMapping("ctrlspace#keys#common#ToggleHelp", "Help", ["?"])
	call ctrlspace#keys#AddMapping("ctrlspace#keys#common#Close",      "Help", ["q", "Esc"])

	call s:map("Down",            "j")
	call s:map("Up",              "k")
	call s:map("Top",             "K")
	call s:map("Bottom",          "J")
	call s:map("HalfScrollDown",  'C-j')
	call s:map("HalfScrollUp",    'C-k')
	call s:map("OpenInNewWindow", "CR")
endfunction

function! s:map(fn, ...)
	call ctrlspace#keys#AddMapping("ctrlspace#keys#help#" . a:fn, "Help", a:000)
endfunction

function! ctrlspace#keys#help#OpenInNewWindow(k)
	call ctrlspace#help#OpenInNewWindow()
endfunction

function! ctrlspace#keys#help#Up(k)
	call ctrlspace#window#MoveCursor("up")
endfunction

function! ctrlspace#keys#help#Down(k)
	call ctrlspace#window#MoveCursor("down")
endfunction

function! ctrlspace#keys#help#Top(k)
	call ctrlspace#window#MoveCursor(1)
endfunction

function! ctrlspace#keys#help#Bottom(k)
	call ctrlspace#window#MoveCursor(line("$"))
endfunction

function! ctrlspace#keys#help#HalfScrollDown(k)
	call ctrlspace#window#MoveCursor("half_pgdown")
endfunction

function! ctrlspace#keys#help#HalfScrollUp(k)
	call ctrlspace#window#MoveCursor("half_pgup")
endfunction
