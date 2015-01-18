; Opens Centricity, Logs In, Performs common acctions, logs to CSV, and exits.

; Variables
centricitylocation = "C:/asdfasdf/asdfasdf/Centricity.exe"
username = "centricity-perf"
password = "asdf1234"
; A_TickCount has 10ms Resolution
csvfile = "performance-results.csv"

OpenandLogin()
PerformCommonActions()
LogResultstoCSV()
ExitApp
return;

; Functions ----------------------------

OpenandLogin(){
global
Run

}

PerformCommonActions(){
global

}

LogResultstoCSV(){
global

}