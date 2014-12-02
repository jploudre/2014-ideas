CoordMode, Mouse, Window
SetKeyDelay, 30
return

; Novice users get confused when using Windows key and having start menu shift focus.
; Option to turn off?
RWin::return
LWin::return

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
\::PatternHotKey(".->HoldUpdate", "..->SendToCA")
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

; Preventive Update, Assumes in Chart::Documents.
#p::
Gosub, OpenAppendType
Send Clin{Down 4}{Enter}
WinWaitActive, Update
Gosub, SwapTextView
WaitforCitrix()
Send ^{PgDn}
return

; Replies with Web Message. Assumes in Chart::Documents.
#r::
Gosub, OpenAppendType
Send Web{Enter}
WinWaitActive, Update
Gosub, SwapTextView
return

; CPOE Append. Assumes in Chart::Documents.
#c::
Gosub, OpenAppendType
Send CPOE{Enter}
WinWaitActive, Update
Gosub, SwapTextView
return

#IfWinActive, Centricity Practice Solution Browser:
\::
Send !{F4}
return

; End of Window Specific Hotkeys. 
#IfWinActive

F10::
; Send a patient a blank letter
Send ^p
WaitforCitrix()
Send l
WaitforCitrix()
Send {Down 2}
WaitforCitrix()
Send {Right 2}
WaitforCitrix()
Send l
WaitforCitrix()
Send {Down 2}
Click, 241, 59
Send B
WaitforCitrix()
Click, 392, 351
return

; Functions
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

WaitforCitrix(){
; Small Delay to reduce chance of errors from Citrix lag
; Where not using Citrix could use more accurate measures like WinWaitActive, or wait for text to appear, etc.
Sleep, 100
return
}

SendToCA:
; Assumes End Update
IfWinActive, End Update
{
	Click, 316, 351
	WinWaitNotActive
	WaitforCitrix()
	WaitforCitrix()
	SendInput Gaylor{Enter}
	WaitforCitrix()
	WaitforCitrix()
	Click, 240, 345
	WinWaitNotActive
	WaitforCitrix()
	WaitforCitrix()
	Send !o
}
else
{
return	
}
return

OpenAppendType:
; Works in Desktop but not in Chart
Send ^j
WinWaitActive, Append to
Send !F
WinWaitActive, Append Document
return

; http://www.autohotkey.com/board/topic/66855-patternhotkey-map-shortlong-keypress-patterns-to-anything/?hl=%2Bpatternhotkey

;         "pattern:keys"                  ; Maps pattern to send keys
;         "pattern->label"                ; Maps pattern to label (GoSub)
;         "pattern->function()"           ; Maps pattern to function myfunction with
;                                           no parameter
;         "pattern->function(value)"      ; Maps pattern to function myfunction with
;                                           the first parameter equal to 'value'
;
;         and patterns match the following formats:
;             '.' or '0' represents a short press
;             '-' or '_' represents a long press of any length
;             '?' represents any press

PatternHotKey(arguments*)
{
    period = 0.2
    length = 1
    for index, argument in arguments
    {
        if argument is float
            period := argument, continue
        if argument is integer
            length := argument, continue
        separator := InStr(argument, ":", 1) - 1
        if ( separator >= 0 )
        {
            pattern   := SubStr(argument, 1, separator)
            command    = Send
            parameter := SubStr(argument, separator + 2)
        }
        else
        {
            separator := InStr(argument, "->", 1) - 1
            if ( separator >= 0 )
            {
                pattern := SubStr(argument, 1, separator)

                call := Trim(SubStr(argument, separator + 3))
                parenthesis := InStr(call, "(", 1, separator) - 1
                if ( parenthesis >= 0 )
                {
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

        if ( Asc(pattern) = Asc("~") )
            pattern := SubStr(pattern, 2)
        else
        {
            StringReplace, pattern, pattern, ., 0, All
            StringReplace, pattern, pattern, -, [1-9A-Z], All
            StringReplace, pattern, pattern, _, [1-9A-Z], All
            StringReplace, pattern, pattern, ?, [0-9A-Z], All
            pattern := "^" . pattern . "$"
            if ( length < separator )
                length := separator
        }
        patterns%index%   := pattern
        commands%index%   := command
        parameters%index% := parameter
    }
    keypress := KeyPressPattern(length, period)
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
KeyPressPattern(length = 2, period = 0.2)
{
    key := RegExReplace(A_ThisHotKey, "[\*\~\$\#\+\!\^]")
    IfInString, key, %A_Space%
        StringTrimLeft, key, key, % InStr(key, A_Space, 1)
    if key in Alt,Ctrl,Shift,Win
        modifiers := "{L" key "}{R" key "}"
    current = 0
    loop
    {
        KeyWait %key%, T%period%
        if ( ! ErrorLevel )
        {
            pattern .= current < 10
                       ? current
                       : Chr(55 + ( current > 36 ? 36 : current ))
            current = 0
        }
        else
            current++
        if ( StrLen(pattern) >= length )
            return pattern
        if ( ! ErrorLevel )
        {
            if ( key in sllle, LButton, MButton, RButton or Asc(A_ThisHotkey) = Asc("$") )
            {
                KeyWait, %key%, T%period% D
                if ( ErrorLevel )
                    return pattern
            }
            else
            {
                Input,, T%period% L1 V,{%key%}%modifiers%
                if ( ErrorLevel = "Timeout" )
                    return pattern
                else if ( ErrorLevel = "Max" )
                    return
                else if ( ErrorLevel = "NewInput" )
                    return
            }
        }
    }
}
