coordmode mouse, relative
DetectHiddenText, Off
dropboxloc = C:\Users\jkploudre\Dropbox\sounds\
SetTitleMatchMode, 2
SetKeyDelay, 200
#Persistent

;SetTimer, CheckFreeText, 250
Return

; Usability. Ignore Winkey, additional keys.
<#Esc::run taskmgr.exe
<#Up::Send {PgUp}
<#Down::Send {PgDn}
<#Backspace::Send {Delete}
RWin::return
LWin::return
#L::return

#Include i'mdone2(7).ahk

; Chart Autocompleter

`::
ifWinActive, Patient Chart
{
WinGetText wintext
IfInString, wintext, pcsProgressNote
{
run, unfocus-icd(2012).ahk
}
}
return

;Add chronic pain diagnosis 
#+c::
gosub, newassessment
pickicd(338.29)
return

; Add a hotkey for faster typing
!h::
#h::  
AutoTrim Off  ; Retain any leading and trailing whitespace on the clipboard.
ClipboardOld = %ClipboardAll%
Clipboard =  ; Must start off blank for detection to work.
Send ^c
ClipWait 1
if ErrorLevel  ; ClipWait timed out.
    return
StringReplace, Hotstring, Clipboard, ``, ````, All  ; Do this replacement first to avoid interfering with the others below.
StringReplace, Hotstring, Hotstring, `r`n, ``r, All  ; Using `r works better than `n in MS Word, etc.
StringReplace, Hotstring, Hotstring, `n, ``r, All
StringReplace, Hotstring, Hotstring, %A_Tab%, ``t, All
StringReplace, Hotstring, Hotstring, `;, ```;, All
Clipboard = %ClipboardOld%  ; Restore previous contents of clipboard.
SetTimer, MoveCaret, 10
InputBox, Hotstring, New Hotstring, Type your abreviation at the indicated insertion point. You can also edit the replacement text if you wish.`n`nExample entry: :R:btw`::by the way,,,,,,,, ::`::%Hotstring%
if ErrorLevel  ; The user pressed Cancel.
    return
IfInString, Hotstring, :R`:::
{
    MsgBox You didn't provide an abbreviation. The hotstring has not been added.
    return
}
FileAppend, `n%Hotstring%, %A_ScriptFullPath%  ; Put a `n at the beginning in case file lacks a blank line at its end.
Reload
Sleep 200 ; If successful, the reload will close this instance during the Sleep, so the line below will never be reached.
MsgBox, 4,, The hotstring just added appears to be improperly formatted.  Would you like to open the script for editing? Note that the bad hotstring is at the bottom of the script.
IfMsgBox, Yes, Edit
return

MoveCaret:
IfWinNotActive, New Hotstring
    return
Send {Home}{Right 2}
SetTimer, MoveCaret, Off
return

; The 'Heather' Button
#+h::
if WinActive("Taskman") or WinActive("Forward Message") or WinActive("New Message") 
click, 19, 97
ifWinActive, Patient Chart 
{
WinGetText wintext
IfInString, wintext, Doc&uments
	{
	click, 977, 150
	WinWaitActive, Taskman
	sleep 100
	click, 19, 97
	return
	}
}
return

; The Medical Records Button
#m::
if WinActive("Taskman") or WinActive("Forward Message") or WinActive("New Message") 
click, 201, 120
return

; Adds a Medication Management ICD to a visit note.
#+m::
gosub, newassessment
pickicd("v58.69")
return

; Notify Pt in Order Tracking
#+n::
ifWinActive, Patient Chart
{
click, 51, 182
sleep 100
click, 70, 211
}
return

; The Ploudre Sign-Off Macro. Burst!
#+p::
ifWinActive, Note Conclusion
{
	SoundPlay, %dropboxloc%goodburst.wav
	sleep 1000
click, 112, 412
sendInput ludcan12{enter}
}
return

; Close note to print screen
#p::
ifWinActive, Patient Chart 
{
WinGetText wintext
IfInString, wintext, Visit
	{
	click, 396, 86
	sleep, 100
	Send !s
	return
	}
IfInString, wintext, Doc&uments
	{
	click, 431, 159
	return
	}
IfInString, wintext, pcsProgressNote
	{
	click, 394, 85
	Sleep 100
	Send !s
	return
	}
}
ifWinActive, e-MDs Chart
{
click, 405, 117
Sleep 100
Send !s
}
ifWinActive, Note Conclusion
{
	SoundPlay, %dropboxloc%goodburst.wav
	sleep 1000
click, 112, 412
sendInput ludcan12{enter}

}
return

; Maps Win-S to work for Alt-S
#s::
Send !s
return


; Use for ROS and for "Neg"
F1::
SetTitleMatchMode 2
ifWinActive, Patient Chart
{
click, 383, 228
sleep 100
opentemplate(421, 152, 1050, 425)
}
ifWinActive, Level
{
SelectROSAnswer(1)
}
ifWinActive, Order Tracking
{
MouseGetPos, xposition, yposition
newx := xposition + 40
newy := yposition + 80
mouseclick, right
sleep, 50
click, newx, newy
}
Coordmode mouse, relative
return

+F1::
SetTitleMatchMode 2
ifWinActive, Patient Chart
{
click, 383, 228
sleep 100
click, 474, 180
}
return

;JKP Constitutional Negative ROS
#F1::
ROS_preclick("Constitu")
return

;JKP HTN Negative ROS
+#F1::
ROS_preclick("HTN")
return

; Exam
F2::
ifWinActive, Patient Chart
{
click, 390, 372
Sleep 100
opentemplate(421, 152, 1050, 425)
}
SetTitleMatchMode 2
ifWinActive, Level
{
SelectROSAnswer(2)
}
return

#F2::
EXAM_preclick("URI",") E/M")
return

#+F2::
EXAM_preclick("Basic",") E/M")
return

; Assessment
F3::
SetTitleMatchMode 2
ifWinActive, Level
{
SelectROSAnswer(3)
}
return

; FU Assessment
+F3::
SetTitleMatchMode 2
ifWinActive, Patient Chart
{
click, 411, 430
sleep 100
click, 445, 456
return
}
Return

F4::
ifWinActive, Patient Chart
{
click, 393, 209
openfreetext(428,162,780,240)
WinGetPos, xpos, ypos, width, height, A
run, Notepad
WinWaitActive, Untitled - Notepad
WinMove, A,,%xpos%,%ypos%,%width%,%height%
Send {NumpadAdd}
return

}
return


; Open the first 5 items to the plan template.
F5::
ifWinActive, Patient Chart
{
	navigatetoassessment(1)
	openplantemplate()
	unfocusplan()
}
return

F6::
ifWinActive, Patient Chart
{
	navigatetoassessment(2)
	openplantemplate()
	unfocusplan()
}
return

F7::
ifWinActive, Patient Chart
{
	navigatetoassessment(3)
	openplantemplate()
	unfocusplan()
}
return

F8::
ifWinActive, Patient Chart
{
	navigatetoassessment(4)
	openplantemplate()
	unfocusplan()
}
return

F9::
ifWinActive, Patient Chart
{
	navigatetoassessment(5)
	openplantemplate()
	unfocusplan()
}
return

; Preventive Checklist Macro
F10::
Clipboard = 
; Open Preventative worksheet, pull out the age/sex variable.
emdschartclick("538","88")
WinWaitActive, Select Form/Letter
Sleep 200
SendInput Preventative Worksheet
Send {Enter}
Send {Enter}
WinWaitActive, e-MDs Merge
sleep 2000
Send {Down}
Send {Shift Down}
Send {Down}
Send {Shift Up}
Send ^x
agesex := clipboard
newclipboard := ""
sleep 2000

; Now get the preventative data.
FileRead, preventative_recs, preventative_spreadsheet.csv
Loop, parse, preventative_recs, `n, `r
{
	if (a_Index = 1) {
		loop, parse, A_Loopfield, CSV
		{
		Array%A_Index% := A_Loopfield
		}
	}
	; First column is for searching, not a checkbox. Skip
	IfNotInString, A_Loopfield, %agesex% 
	{
		continue
	}
	
	; Loop through preventative items
	loop, parse, A_Loopfield, CSV
	{
		if (a_index = 1) {
		continue	
		}
		; Section Titles
		makesectiontitle(2,"Daily Living")
		makesectiontitle(7,"Shots")
		makesectiontitle(9,"Heart Healthy")
		makesectiontitle(14,"Testing")
		
		; Checkboxes
		makecheckbox(A_Index,array%A_index%,A_LoopField)
	}
}
return

F11::
SendInput !FPL
return

Pgdn::
ifWinActive, Patient Chart 
{
WinGetText wintext
IfInString, wintext, pcsProgressNote
	{
	scroller(TemdsNoteViewer4)
	}
	return
}

send {PgDn}
return

pgup::
ifwinactive, Patient Chart
{
PixelGetColor, color, 1270, 714
	if(color="0xFFFFFF"){
	click, 1270, 170
	return
	}
	else {
	click, 1252, 399
	return
	}
}
send {PgUp}
return

; Growl Notifier
growl(topic = 0,title = 0,message = "")
{
run growlnotify /ai:"C:\Users\jkploudre\Dropbox\sounds\%topic%" /t:"%title%" "%message%"
}

; The Dragon Macro. Assumes Numpad+ Turns on Microphone.

F12::
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

#IfWinActive, Level
`::
CoordMode, mouse, screen
click, 260, 40
CoordMode, mouse, relative
unfocusplan()
return

LButton::
Splashimage, Off
Click
Return
#IfWinActive



; Functions And Sub-routines -------------------------------------------------

unfocusplan()
{
Run, C:\Users\jkploudre\Documents\GitHub\undevelop\unfocus-basic.ahk
}



scroller(thecontrol)
{
ControlGetPos, xpos, ypos, width, height, %thecontrol%, A
msgbox  %xpos%, %ypos%, %width%, %height%, %thecontrol%
xpos := xpos + width - 7
ypos := ypos + (height /2)
mouseclick, right, %xpos%, %ypos%
xpos := xpos - 15
; just down for now
ypos := ypos + 95
Click, %xpos%, %ypos%
}
Return

pickicd(icd)
{
send !c
send %icd%{enter}
sleep 300
send !w
send {Tab}{Down}{Enter}	
}
Return

; ROS Adult Preclick Picker
ROS_preclick(uniquesearchterm)
; Unique Search Term leaves only 1 choice to select so make it specific enough
{
	ifWinActive, Patient Chart
	{
		WinGetText wintext
		IfInString, wintext, pcsProgressNote
		{
		click, 383, 228
		sleep 100
		opentemplate(426, 164, 726, 464)
		click, 36, 28
		sleep 100
		click, 101, 34
		sleep 100
		send %uniquesearchterm%
		send !s
		click, 51, 66
		return
		}
	}
}
Return

SelectROSAnswer(item)
{
Coordmode mouse, screen
MouseGetPos, xposition, yposition
Click
WinWaitNotActive
ypos := (item = 1) ? 65 : (item = 2) ? 89 : (item = 3) ? 114 : 0
click, 492, %ypos%
click, 342, 39
Mousemove, %xposition%, %yposition%	
}
return

EXAM_preclick(preclicksearchterm,templatesearchterm)
{
ifWinActive, Patient Chart
{
WinGetText wintext
IfInString, wintext, pcsProgressNote
	{
	click, 392, 383
	sleep 100
	opentemplate(426, 164, 726, 464)
	WinWaitActive, Template Quick Picks
	click, 33, 183
	sleep 500
	click, 33, 183
	WinWait,,Search
	click, 101, 34
	Send %templatesearchterm%
	Send {enter}
	click, 37, 58
	sleep 300
	click, 101, 34
	sleep 300
	send %preclicksearchterm%
	send {enter}
	click, 51, 66
	return
	}
}
}
Return

makecheckbox(index,title,description)
{
if (A_Index = index) {
	if (description = "") {
		return
} Else {
	;newclipboard = %newclipboard% `n`r__ %title%... %description%`n`r
	SendInput {asc 09744} %title%: %description%{enter}
	}
}
}
Return

makesectiontitle(index,title)
{
	if (A_Index = index) {
	;newclipboard = %newclipboard%`n`r`n`r%title%`n`r	
	SendInput {enter 2}%title%{Enter}
	}
}
Return

navigatetoassessment(assessmentnumber)
{
click, 412, 487
ypos := (assessmentnumber = 1) ? 568 : (assessmentnumber = 2) ? 586 : (assessmentnumber = 3) ? 606 : (assessmentnumber = 4) ? 621 : (assessmentnumber = 5) ? 640 : 0
click, 466, %ypos%
;sleep 100
}
Return

newassessment:
{
click, 415, 444
sleep 200
click, 460, 444
}
Return

openplantemplate()
{
	global dropboxloc
	opentemplate(421, 152, 1050, 425)
	ImageSearch, FoundX, FoundY, 0, 0, 471, 200, *n8 %dropboxloc%ncfporder.png
	; Or scroll down and check again 2x
	if (ErrorLevel = 1)
	{
		click 460, 152
		ImageSearch, FoundX, FoundY, 0, 0, 471, 200, *n8 %dropboxloc%ncfporder.png
	}
	if (ErrorLevel = 1)
	{
		click 460, 152
		ImageSearch, FoundX, FoundY, 0, 0, 471, 200, *n8 %dropboxloc%ncfporder.png
	}
	click, %FoundX%, %FoundY%
	WinWaitActive, Level
	Return
}
return

opentemplate(x,y,x2,y2)
{
	global dropboxloc
	ImageSearch, FoundX, FoundY, x, y, x2, y2, *n8 %dropboxloc%templatechooser.png
	click, %FoundX%, %FoundY%
	WinWaitActive, Template Quick Picks	
}
return

openfreetext(x,y,x2,y2)
{
	global dropboxloc
	ImageSearch, FoundX, FoundY, x, y, x2, y2, *n8 %dropboxloc%freetext.png
	FoundX := FoundX + 3
	FoundY := FoundY +2
	click, %FoundX%, %FoundY%
	WinWaitActive, Free Text	
}
return

#Include abbrevs.ahk

::asscy::asymptomatically
::rxvitd::Recommend Vitamin D supplementation (50K IU Once weekly for 12 weeks, recheck serum level in 3 months) Please send to pts pharmacy.
::dnoabx::discussed reasoning behind no antibiotics for this.
::dusptf::reviewed all appropriate USPTF recommendations in checklist format
::dnytanxy::Recommended the patient read New York Times article 'Understanding the Anxious Mind'.
::dmedad::Discussed  on medication adherence issues.
::dpcl::Reviewed a personalized checklist of preventive recommendations based on USPTF.
::cgm::continuous glucose monitor
::nomedad::No significant medication adherence issues noted.
::dcgm::Discussed continuous glucose monitoring.
::pmprv::PMP reviewed, as expected.
::rpt::Patient was seen and evaluated with resident. Key parts of history and exam reviewed. Plan was created with my input. {Enter 2}Jonathan Ploudre, MD.{Up 2}
::lcmp::We checked your CMP.
::+lcmp::We also checked your CMP.
::3xbp:: Average of 3 automated readings with 60 second pause between readings.
::3bp:: 3 blood pressures were measured 1 minute apart and averaged.