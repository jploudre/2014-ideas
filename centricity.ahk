CoordMode, Mouse, Window
FileRead, PECCC, PE-CCC.csv
FileRead, QTinput, qtinput.csv
Setkeydelay 200

return

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

^1::
AddQTfromCSV(QTinput)
return

F2::
ExamFromCSV(PECCC, 1)
ExamFromCSV(PECCC, 2)
ExamFromCSV(PECCC, 3)
ExamFromCSV(PECCC, 4)
ExamFromCSV(PECCC, 5)
ExamFromCSV(PECCC, 6)
ExamFromCSV(PECCC, 10)
ExamFromCSV(PECCC, 11)
ExamFromCSV(PECCC, 21)


return

+F2::
ExamFromCSV(PECCC, 1)
ExamFromCSV(PECCC, 10)
ExamFromCSV(PECCC, 11)
ExamFromCSV(PECCC, 24)

return

; Hyper-Space: I'm Done
!#^+Space::
IfWinActive, Centricity Practice Solution Browser:
	Send !{F4}
IfWinActive, End Update ; Holds Document
	Click, 402, 515
return

; Hyper-Escape: Ruh-oh


; Shift Ctrl-O: Open Attachment
^+o::
; Doesn't check location precisely yet, Assumes in Desktop:Documents
; Two Finger Left TipTap

IfWinActive, Chart
	{
	; X position of control is defined from right boarder.
	WinGetPos,,,winwidth,,A
	xpos := winwidth - 70
	Click, %xpos%, 385
	}
return

; Hyper-S: Sign
!#^+s::
; Doesn't check location precisely yet, Assumes in Desktop:Documents
; Triple Finger Double Tap
IfWinActive, Chart
	{
	; X position of control is defined from right boarder.
	WinGetPos,,,winwidth,,A
	xpos := winwidth - 250
	Click, %xpos%, 126
	}
IfWinActive, End Update ; Signs Document
	Click, 295, 515
return

; Functions

ExamFromCSV(ByRef CSVfile, Theline, howtohandle := 0)
{
	Loop, parse, CSVfile, `n, `r
	{
		if (theline != A_Index)
		continue
		else
		{
		loop, parse, A_Loopfield, CSV
		{
			if (A_Index = "1"){
			}
			if (A_Index = "2"){
			}
			if (A_Index = "3"){
			ExamTabxpos := A_LoopField
			}
			if (A_Index = "4"){
			ExamTabypos := A_LoopField
			}
			if (A_Index = "5"){
			ExamSectionNormalxpos := A_LoopField
			}
			if (A_Index = "6"){
			ExamSectionNormalypos := A_LoopField
			}
			if (A_Index = "7"){
			ExamSectionTextxpos := A_LoopField
			}
			if (A_Index = "8"){
			ExamSectionTextypos := A_LoopField
			}
		}
		}
		
	}
	Click %ExamTabxpos%, %ExamTabypos%
	Sleep 1000
	if (howtohandle = 0) ; Default is Normal
	{
	Click %ExamSectionNormalxpos%, %ExamSectionNormalypos%
	Sleep 200
	return
	}
	if (howtohandle = 1) ; Select the field (use for last item)
	{
	Click %ExamSectionTextxpos%, %ExamSectionTextypos%
	Sleep 200
	return	
	}
	else
	{
	Click %ExamSectionTextxpos%, %ExamSectionTextypos%
	Sleep 200
	SetKeyDelay, 200
	Send %howtohandle%
	return	
	}
}

AddQTfromCSV(ByRef CSVfile)
{
	; Assume: In the Preferences
	ifWinActive, Preferences
	{

	Loop, parse, CSVfile, `n, `r
	{
		loop, parse, A_Loopfield, CSV
		{
			if (A_Index = "1"){ 
			abbreviation := A_Loopfield
			}
			if (A_Index = "2"){ 
			expansion := A_Loopfield
			}	
		}
	Click, 335, 176
	Send %abbreviation%
	Sleep 100
	Send {tab}
	Sleep 100
	Send %expansion%
	Sleep 100
	Click, 673, 234
	Sleep 1000
	}
	}
	else {
	return ; not in preferences window
	}
}