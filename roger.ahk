; Dragon Button
NumpadSub::
IfWinActive, Free Text
{
WinGetPos, xpos, ypos, width, height, A
run, Notepad
WinWaitActive, Untitled - Notepad
WinMove, A,,%xpos%,%ypos%,%width%,%height%
Send {NumpadAdd}
return
}
ifWinActive, Update -
{
run, Notepad
WinWaitActive, Untitled - Notepad
Send {NumpadAdd}
return
}
IfWinActive, Untitled - Notepad
{
Send {NumpadAdd}
sleep 100
Send {Control down}
Send a
Send x
Send {Control up}
Sleep 100
Send {Alt down}
Send FX
Send {Alt up}
WinWaitNotActive
Sleep, 100
IfWinExist, Free Text
{
WinActivate, Free Text
WinWaitActive, Free Text
Send {Control down}
Send v
Send {Control up}
send !s
}
IfWinExist, Update -
{
WinActivate, Update -
WinWaitActive, Update -
Sleep 500
Send {Control down}
Send v
Send {Control up}
sleep 500
WinActivate, Update -
sleep 500
}
return
}
return

; Toggle Update and Chart
#IfWinActive, Update
`::
WinActivate, Chart
return

#IfWinActive, Chart
`::
IfWinExist, Update
WinActivate, Update
IfWinNotExist, Update
{
	WinGetPos,,,,winheight,A
	ypos := winheight - 161
	Click, 13, %ypos%
}
return
#IfWinActive