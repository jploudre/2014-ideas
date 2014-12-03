InitialSetup()
return

/* CSV reading
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

; Functions
InitialSetup()
{
global
; AHK Program Variables
#NoEnv
#MaxThreadsBuffer On
#SingleInstance, Force

; Colors from http://ethanschoonover.com/solarized
base0 = 839496
base1 = 93a1a1
base2 = eee8d5
base3 = fdf6e3
base00 = 657b83
base01 = 586e75
base02 = 073642
base03 = 002b36
cyan = 2aa198
yellow = b58900
orange = cb4b16
red = dc322f
magenta = d33682
violet = 6c71c4
blue = 268bd2
cyan = 2aa198
green = 859900

; Install the Custom Files
;FileInstall, preventative_spreadsheet.csv, %A_Temp%\preventative_spreadsheet.csv, 0
; FileRead, icdlist, %A_Temp%\icdlist.txt

}



; Need to read the first line as 'name variables' Then the line selected above at the specific recommendations.
; Does ASC input work on different computers reliably?

makecheckbox(index,title,description)
{
if (A_Index = index) {
    if (description = "") {
        return
    } Else {
    SendInput {asc 09744} ^b%title%:^b %description%{enter}
    }
}
}

makesectiontitle(index,title)
{
    if (A_Index = index) {
    SendInput {enter 2}^+>^u^b%title%^b^u{Enter}^+<
    }
}

makegillsans:
{
SendInput ^a
SendInput ^+F
SendInput gill sans{enter}
Return
}