CoordMode, Mouse, Window
FileRead, PECCC, PE-CCC.csv
Setkeydelay 200
PreviousExamTab := 0

return

#IfWinActive, Update
`::PatternHotKey(".->GotoChart","..->SwapTextView")
return
[::
Send ^{PgUp}
return
]::
Send ^{PgDn}
return
\::
Send ^e
return

#IfWinActive, End Update
\::PatternHotKey(".->HoldUpdate", "..->SendToBrandie")
return

!+h::
Click, 316, 351
WinWaitNotActive
SendInput Freema{Enter}
Sleep, 50
Click, 240, 345
WinWaitNotActive
Click, 301, 506
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

#IfWinActive, Centricity Practice Solution Browser:
\::
Send !{F4}
return

#IfWinActive, Update Problems
; Long Hold is Top/Bottom. Tap is Up/Down
Up::PatternHotKey(".->UpdateProblemsUp","_->UpdateProblemsTop")
Down::PatternHotKey(".->UpdateProblemsDown","_->UpdateProblemsBottom")
Left::
Click, 736, 146
return
Right::
Click, 786, 146
return
BackSpace::
Delete::PatternHotKey(".->UpdateProblemsRemove")
; OK is 'Done'
\::
Click, 694, 599
return
; Enter should always do OK.
Enter::
Click, 694, 599
return

#IfWinActive

F2::
ExamClick(1)
ExamClick(2)
ExamClick(3)
ExamClick(4)
ExamClick(5)
ExamClick(6)
ExamClick(10)
ExamClick(11)
ExamClick(21)
ExamDone()
return

+F2::
ExamClick(1)
ExamClick(10)
ExamClick(11)
ExamClick(24)
ExamDone()
return

F1::
ExamClick(1, 1)
ExamDone()
return

+F1::
ExamClick(1, "No Specific Exam today, counselling visit.")
ExamDone()
return

; Hyper-Space: I'm Done
!#^+Space::
IfWinActive, Centricity Practice Solution Browser:
	Send !{F4}
IfWinActive, End Update ; Holds Document
	Click, 402, 515
return

; Hyper-Escape: Ruh-oh

; Shift Ctrl-a: Open Append
^+a::
; Doesn't check location precisely yet, Assumes in Desktop:Documents
; Three Finger TipTap Middle

IfWinActive, Chart
	{
	; X position of control is defined from right boarder.
	WinGetPos,,,winwidth,,A
	xpos := winwidth - 205
	Click, %xpos%, 129
	}
return


; Shift Ctrl-O: Open Attachment
^+o::
; Doesn't check location precisely yet, Assumes in Desktop:Documents
; Two Finger 'Right TipTap

IfWinActive, Chart
	{
	; X position of control is defined from right boarder.
	WinGetPos,,,winwidth,,A
	xpos := winwidth - 70
	Click, %xpos%, 385
	}
return

; Shift Ctrl-u: Open Update
^+u::
; Doesn't check location precisely yet, Assumes in Desktop:Documents
; Two Finger left TipTap

IfWinActive, Chart
	{
	; X position of control is defined from right boarder.
	WinGetPos,,,winwidth,,A
	xpos := winwidth - 350
	Click, %xpos%, 129
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

ExamClick(Theline, howtohandle := 0)
{
	global
	; Hardwire the PECCC
	Loop, parse, PECCC, `n, `r
	{
		if (theline != A_Index)
		continue
		else
		{
		loop, parse, A_Loopfield, CSV
		{
			if (A_Index = "1"){
			CurrentExamTab := A_LoopField
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
	If (CurrentExamTab != PreviousExamTab)
	{
	Click %ExamTabxpos%, %ExamTabypos%
	Sleep 500
	; Now Set the Previous Tab
	PreviousExamTab := CurrentExamTab
	}
	if (howtohandle = 0) ; Default is Normal
	{
	Click %ExamSectionNormalxpos%, %ExamSectionNormalypos%
	Sleep 300
	return
	}
	if (howtohandle = 1) ; Select the field (use for last item)
	{
	Click %ExamSectionTextxpos%, %ExamSectionTextypos%
	Sleep 300
	return	
	}
	else
	{
	Click %ExamSectionTextxpos%, %ExamSectionTextypos%
	Sleep 300
	Clip(howtohandle)
	return	
	}
}

ExamDone()
{
	global
	PreviousExamTab := 0
}

GotoChart:
WinActivate, Chart
return

SwapTextView:
Send +{F8}
return

SaveUpdate:
Send !s
return

HoldUpdate:
Send !o
return

SendToBrandie:
; Assumes End Update
IfWinActive, End Update
{
	Click, 316, 351
	WinWaitNotActive
	SendInput Freema{Enter}
	Sleep, 50
	Click, 240, 345
	WinWaitNotActive
	Send !o
}
else
{
return	
}
return

; Update Problems Functions

UpdateProblemsTop:
Click, 762, 100
return

UpdateProblemsBottom:
Click, 762, 189
return

UpdateProblemsUp:
Click, 762, 122
return

UpdateProblemsDown:
Click, 762, 170
return

UpdateProblemsRemove:
Click, 508, 572
WinWaitNotActive
Send {Enter}
return


; Downloaded Functions ----------------------------------------------------------------------------------

Clip(Text="", Reselect="") ; http://www.autohotkey.com/forum/viewtopic.php?p=467710 , modified August 2012
{
	Static BackUpClip, Stored, LastClip
	If (A_ThisLabel = A_ThisFunc) {
		If (Clipboard == LastClip)
			Clipboard := BackUpClip
		BackUpClip := LastClip := Stored := ""
	} Else {
		If !Stored {
			Stored := True
			BackUpClip := ClipboardAll
		} Else
			SetTimer, %A_ThisFunc%, Off
		LongCopy := A_TickCount, Clipboard := "", LongCopy -= A_TickCount
		If (Text = "") {
			Send, ^c
			ClipWait, LongCopy ? 0.5 : 0.25
		} Else {
			Clipboard := LastClip := Text
			ClipWait, 10
			Send, ^v
		}
		SetTimer, %A_ThisFunc%, -700
		If (Text = "")
			Return LastClip := Clipboard
		Else If (ReSelect = True) or (Reselect and (StrLen(Text) < 3000)) {
			Sleep 30
			StringReplace, Text, Text, `r, , All
			SendInput, % "{Shift Down}{Left " StrLen(Text) "}{Shift Up}"
		}
	}
	Return
	Clip:
	Return Clip()
}

; http://www.autohotkey.com/board/topic/66855-patternhotkey-map-shortlong-keypress-patterns-to-anything/?hl=%2Bpatternhotkey

; PatternHotKey / KeyPressPattern

; PatternHotKey registers one or multiple patterns of a hotkey to either sending keys, going to a
;               label or calling a function with zero or one parameter.
;
; Usage : hotkey::PatternHotKey("command1", ["command2", "command3", length(integer), period(float)])
;
;     where commands match one of the following formats:
;         "pattern:keys"                  ; Maps pattern to send keys
;         "pattern->label"                ; Maps pattern to label (GoSub)
;         "pattern->function()"           ; Maps pattern to function myfunction with
;                                           no parameter
;         "pattern->function(value)"      ; Maps pattern to function myfunction with
;                                           the first parameter equal to 'value'
;
;         and patterns match the following formats:
;             '.' or '0' represents a short press
;             '1' to '9' and 'A' to 'Z' represents a long press of
;                                       the specified length (base 36)
;             '-' or '_' represents a long press of any length
;             '?' represents any press
;             '~' as prefix marks the following string as a
;                 regular expression for the pattern
;
;     length : Maximum length of returned pattern. Automatically detected unless
;              using custom regular expression patterns. Keeping this value to the
;              minimum will speed up keypress detection.
;     period : Amount of time in seconds to wait for additional keypresses.
;
;     e.g. "01->mylabel" maps a short press followed by a 0.2 to 0.4 seconds press to
;                        the 'mylabel' label.
;          "_:{Esc}" maps a long press to sending the Esc key.
;          ".?-_0->myfunction(1)" maps a short press followed by any press followed by
;                                 2 long press to calling 'myfunction(1)'.
;          "~^[6-9A-Z]$->myfunction()" maps the regular expression '^[6-9A-Z]$' (exact
;                                      length match a long press of length '6' to 'Z')
;                                      to calling 'myfunction()'.
PatternHotKey(arguments*)
{
    period = 0.2
    length = 1

    ; Parse input
    for index, argument in arguments
    {
        ; Use any float as period
        if argument is float
            period := argument, continue

        ; Use any integer as length. Automatically calculated
        ; unless using custom patterns ('~' prefix).
        if argument is integer
            length := argument, continue

        ; Check for Send command (':')
        separator := InStr(argument, ":", 1) - 1
        if ( separator >= 0 )
        {
            pattern   := SubStr(argument, 1, separator)
            command    = Send
            parameter := SubStr(argument, separator + 2)
        }
        else
        {
            ; Check for Function or GoSub command ('->')
            separator := InStr(argument, "->", 1) - 1
            if ( separator >= 0 )
            {
                pattern := SubStr(argument, 1, separator)

                call := Trim(SubStr(argument, separator + 3))
                parenthesis := InStr(call, "(", 1, separator) - 1
                if ( parenthesis >= 0 )
                {
                    ; Parse function name and single parameter
                    command   := SubStr(call, 1, parenthesis)
                    parameter := Trim(SubStr(call, parenthesis + 1), "()"" `t")
                }
                else
                {
                    command    = GoSub
                    parameter := call
                }
            }
            else
                continue
        }

        ; Convert pattern to regular expression
        ;
        ; Note: Treat '~' as an escape character for custom regular expressions.
        ;       Custom regular expressions can't have the pattern length
        ;       automatically calculated, so the length parameter might be
        ;       necessary.
        if ( Asc(pattern) = Asc("~") )
            pattern := SubStr(pattern, 2)
        else
        {
            ; Short press
            StringReplace, pattern, pattern, ., 0, All

            ; Long press
            StringReplace, pattern, pattern, -, [1-9A-Z], All
            StringReplace, pattern, pattern, _, [1-9A-Z], All

            ; Any press
            StringReplace, pattern, pattern, ?, [0-9A-Z], All

            ; Exact length match
            pattern := "^" . pattern . "$"

            ; Record max pattern length
            if ( length < separator )
                length := separator
        }

        patterns%index%   := pattern
        commands%index%   := command
        parameters%index% := parameter
    }

    ; Record key press pattern
    keypress := KeyPressPattern(length, period)

    ; Try to find matching pattern
    Loop %index%
    {
        pattern   := patterns%A_Index%
        command   := commands%A_Index%
        parameter := parameters%A_Index%

        if ( pattern && RegExMatch(keypress, pattern) )
        {
            if ( command = "Send" )
                Send % parameter
            else if ( command = "GoSub" and IsLabel(parameter) )
                gosub, %parameter%
            else if ( IsFunc(command) )
                %command%(parameter)
        }
    }
}

; KeyPressPattern returns a base-36 string pattern representing the recorded
;                 keypresses for the current hotkey. Each digit represents a
;                 keypress, indicating how much "pressed down time" (in amount
;                 of period) a key was down, with 0 representing a short press.
;
;     length       : Maximum length of returned pattern. Keeping this value to
;                    the minimum will speed up keypress detection.
;     period       : Amount of time in seconds to wait for additional keypresses.
;
;     e.g. (Using the default period of 0.2 seconds)
;          "01" is a short press followed by a 0.2 to 0.4 seconds press
;          "30" is a 0.6 to 0.8 seconds press followed by a short press
;          "000" is triple-click (3 short press)
KeyPressPattern(length = 2, period = 0.2)
{
    ; Find pressed key
    key := RegExReplace(A_ThisHotKey, "[\*\~\$\#\+\!\^]")
    IfInString, key, %A_Space%
        StringTrimLeft, key, key, % InStr(key, A_Space, 1)

    ; Find modifiers
    if key in Alt,Ctrl,Shift,Win
        modifiers := "{L" key "}{R" key "}"

    current = 0
    loop
    {
        ; Wait for key up
        KeyWait %key%, T%period%
        ; If key up was received...
        if ( ! ErrorLevel )
        {
            ; Append code in base 36 to pattern and reset current code
            pattern .= current < 10
                       ? current
                       : Chr(55 + ( current > 36 ? 36 : current ))
            current = 0
        }
        else
            current++

        ; Return pattern if it is of desired length
        if ( StrLen(pattern) >= length )
            return pattern

        ; If key up was received...
        if ( ! ErrorLevel )
        {
            ; Wait for next key down of the same key
            ;
            ; Capslock, mouse buttons and hotkeys using the no reentry ('$' prefix) cannot use
            ; Input. KeyWait is used instead, but it cannot detect cancelled patterns (a different
            ; key is pressed before timeout) or modifier keys.
            if ( key in Capslock, LButton, MButton, RButton or Asc(A_ThisHotkey) = Asc("$") )
            {
                KeyWait, %key%, T%period% D

                ; If key down timed out, return pattern
                if ( ErrorLevel )
                    return pattern
            }
            else
            {
                Input,, T%period% L1 V,{%key%}%modifiers%

                ; If key down timed out, return pattern
                if ( ErrorLevel = "Timeout" )
                    return pattern
                ; If a different key is pressed, cancel pattern
                else if ( ErrorLevel = "Max" )
                    return
                ; If input is cancelled, cancel pattern
                else if ( ErrorLevel = "NewInput" )
                    return
            }
        }
    }
}
