F1::
; Read CSV by line and parse for Patient Name and Pap Date
Loop, read, papsmear.csv
{
    Loop, parse, A_LoopReadLine, CSV
    {
        ; Column 1 Has Date
        if (%A_Index% = 1){
        PapSmearDate = %A_LoopField%
        }
        ; And 3 has Pt Name
        if (%A_Index% = 3){
        PatientName = %A_LoopField%
        }
    }
    FindbyName(PatientName)
    OpenChart()
    ReviewPap(PatientName, PapSmearDate)
    OpenPreventiveUpdate()
    AddPapInfo(PatientName, PapSmearDate)
    ; SignAndContinue()
}
return
}

FindbyName(PatientName){
Send ^f
WinWaitActive, Find Patient
WaitforCitrix()
Send %PatientName%
Send {Enter}
}

OpenChart(){
; Assumes we're in Find Patient Dialog
; Need to check if there are duplicate names
; If there are no black pixels on the second line, there's only one.
    ; PixelSearch, , , X1, Y1, X2, Y2, ####Black , 3, Fast
    if Errorlevel {
    ; No other names, so Open
    Send {Enter}
    } else {
    ; Wait for Person to select a name
    WinWaitNotActive, Find Patient
    }
}

ReviewPap(PatientName, PapSmearDate){
; Try to bring Pap on screen
; Go to Documents, Labs
; If Date is > 2 years, look for red to double click
; Scroll 3x looking for red with pixelsearch

ToolTip, Select Pap from %PapSmearDate%`nThen hit 'F1', 100, 150

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

; Wait for F1
KeyWait, F1
Tooltip
}

WaitforCitrix(){
; Additional Pauses to account for Interface Lag
Sleep, 100
}



