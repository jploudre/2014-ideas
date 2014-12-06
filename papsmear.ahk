F12::
; Assumes in Desktop. papsmear.csv in same folder. 
; Read CSV by line and parse for Patient Name and Pap Date
Loop, read, papsmear.csv
{
    Loop, parse, A_LoopReadLine, CSV
    {
        ; Column 1, Date; Column 3, Name
        if (%A_Index% = 1)
        PapSmearDate = %A_LoopField%
        if (%A_Index% = 3)
        PatientName = %A_LoopField%
    }
    FindbyName(PatientName)
    OpenChart()
    ReviewPap(PatientName, PapSmearDate)
    OpenPreventiveUpdate()
    AddPapInfo(PatientName, PapSmearDate)
    SignAndContinue()
}
return

FindbyName(PatientName){
Send ^f
WinWaitActive, Find Patient
WaitforCitrix()
Send %PatientName%
Send {Enter}
}

OpenChart(){
; Assumes we're in Find Patient Dialog
; Check for duplicate names (black pixels on second line.
    ; PixelSearch, , , X1, Y1, X2, Y2, ####Black , 3, Fast
    if Errorlevel {
    Send {Enter}
    } else {
    ; Wait for Person to select a name
    WinWaitNotActive, Find Patient
    }
}

ReviewPap(PatientName, PapSmearDate){
ToolTip, Select Pap on %PapSmearDate%`nThen hit 'F1', 100, 150
; Could Try to bring Pap on screen
; Go to Documents, Labs
; If Date is > 2 years, look for red to double click

; Wait for F1 Key
KeyWait, F1
Tooltip ; removes tool tip
}

OpenPreventiveUpdate(){
; Assumes Pap Document is selected
; Opens Update using keyboard shortcuts.
Send ^j
WinWaitActive, Append to
WaitforCitrix()
Send !F
WinWaitActive, Append Document
WaitforCitrix()
Send Clin{Down 4}{Enter}
WinWaitActive, Update
WaitforCitrix()
Send +{F8}
WaitforCitrix()
Send ^{PgDn}
WaitforCitrix()
}

AddPapInfo(PatientName, PapSmearDate){
ToolTip, Pap Date %PapSmearDate%`nThen hit 'F1', 100, 150
; Could Auto-enter Pap Normal, and Date
; Wait for F1
KeyWait, F1
Tooltip
}

SignAndContinue(){
; End/Sign
Send, ^e
WinWaitActive, End Update
WaitforCitrix()
Send, !s
WinWaitNotActive, End Update
WaitforCitrix()
; Switch to Desktop
WinGetPos,,,,winheight,A
ypos := winheight - 161
Click, 13, %ypos%
}

WaitforCitrix(){
; Additional Pauses to account for Interface Lag
Sleep, 100
}



