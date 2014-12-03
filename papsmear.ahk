
#NoEnv
#MaxThreadsBuffer On
#SingleInstance, Force
FileRead, paplist, papsmear.csv
return


F1::
; Loop, parse, paplist, `n, `r
; loop, parse, A_Loopfield, CSV

; FindbyName()
; ShowNameDOB()
; Open Chart()
; ReviewPap()
; OpenPreventiveUpdate()
; AddPapInfo()
; SignAndContinue()

return

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




