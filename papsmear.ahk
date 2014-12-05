
#NoEnv
#MaxThreadsBuffer On
#SingleInstance, Force
; Main Variables: PatientName, PapSmearDate & LineNum (from papsmear.csv)
return


F1::
PatientName = GetPatientName.(LineNum)
PapSmearDate = GetPapSmearDate(LineNum)
FindbyName(PatientName)
; Open Chart()
; ReviewPap()
OpenPreventiveUpdate()
; AddPapInfo()
; SignAndContinue()
return

GetPatientName(LineNum){
FileReadLine, PaptoEnter, papsmear.csv, LineNum
; loop, parse, A_Loopfield, CSV

}

FindbyName(){
global 

Send ^f
WinWaitActive, Find Patient
WaitforCitrix()
Send 
}


OpenPreventiveUpdate(){
; Assumes Pap Document is selected
Send ^j
WinWaitActive, Append to
WaitforCitrix()
Send !F
WinWaitActive, Append Document
WaitforCitrix()
Send Clin{Down 4}{Enter}
WinWaitActive, Update
WaitforCitrix()
; Swtich from Text to Template View
Send +{F8}
WaitforCitrix()
Send ^{PgDn}
WaitforCitrix()
}




WaitforCitrix(){
; Additional Pauses to account for Interface Lag
Sleep, 100
}

/* CSV reading example
F10::
FileRead, preventative_recs, %A_Temp%\preventative_spreadsheet.csv
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
*/




