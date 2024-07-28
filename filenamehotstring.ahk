#Requires AutoHotkey v2.0  ; This script needs AutoHotkey version 2.0 or later to run
#SingleInstance Force  ; If this script is run again, replace the old running one

~Escape::ExitApp
~!Space::Reload


; Set the folder where your template files are stored
templateDir := "D:\Templates"

; This function sets up the text shortcuts
CreateHotstrings() {
    Hotstring("Reset")  ; Clear all existing text shortcuts
    Loop Files, templateDir "\*.txt" {  ; Look at each .txt file in the template folder
        triggerName := StrReplace(A_LoopFileName, ".txt")  ; Remove .txt from the filename
        Hotstring(":*:" triggerName, InsertTemplate.Bind(A_LoopFilePath))  ; Create a shortcut using the filename
    }
}

; This function inserts the content of a template file
InsertTemplate(filePath, *) {
    try {
        content := FileRead(filePath)  ; Read the content of the template file
        A_Clipboard := content  ; Copy the content to the clipboard
        if !ClipWait(1)  ; Wait for the clipboard to contain data
            throw Error("Failed to set clipboard")  ; If it takes too long, report an error
        Send "^v"  ; Paste the content (Ctrl+V)
    } catch as err {
        MsgBox("Error with template: " err.Message, "Template Error", 16)  ; Show an error message if something goes wrong
    }
}

; Set up the text shortcuts when the script starts
CreateHotstrings()

; Refresh the text shortcuts every 30 seconds (30000 milliseconds)
SetTimer(CreateHotstrings, 30000)

; When you press Ctrl+Alt+T, this shows a list of all your templates
^!t:: {
    templateList := "Loaded Templates:`n"  ; Start a list of template names
    Loop Files, templateDir "\*.txt"  ; Look at each .txt file in the template folder
        templateList .= StrReplace(A_LoopFileName, ".txt") "`n"  ; Add each filename (without .txt) to the list
    MsgBox(templateList)  ; Show the list in a popup window
}

; ;;---- v1
; :X:NPE::
; {
;     str := "
;     (LTrim
;     Neck aROM/pain
;     Flexion() Extension()
;     Rotation r/L: -/- Lateral flexion r/L: -/-
;     Kemp's r/L: -/-
;     Spurling r/L: -/- Lhermitte's sign: -
;     ...
;     )"
;     SendString(str)
; }

; :X:ADHDr::
; {
;     str := "
;     (LTrim
;     [Attention]
;     #無法注意細節或容易粗心犯錯()
;     #工作或遊戲難以持續注意力()
;     #無法遵循指示完成功課/家事()
;     #對話時好像沒在聽()#組織和活動上有困難()
;     #逃避、討厭需要持久心力工作()
;     #經常遺失工作活動所需物品()
;     .....
;     )"
;     SendString(str)
; }

; SendString(String) {
;     bak := A_Clipboard
;     A_Clipboard := ""
;     A_Clipboard := String
;     if !ClipWait(1) {
;         MsgBox("Couldn't set Clipboard text.", "Error", 16)
;         return
;     }
;     Send "^v"
;     Sleep 100
;     A_Clipboard := bak
; }


;;---- v2
; :X:NPE::UseTemplate("NPE")
; :X:ADHDr::UseTemplate("ADHDr")

; UseTemplate(Filename) {
;     bak := A_Clipboard
;     A_Clipboard := ""
;     try {
;         A_Clipboard := FileRead("D:\Templates\" Filename ".txt")
;     } catch as err {
;         MsgBox("Couldn't read template file: " err.Message, "Error", 16)
;         return
;     }

;     if !ClipWait(1,1) {
;         MsgBox("Couldn't set template text.", "Error", 16)
;         return
;     }

;     Send "^v"
;     Sleep 100
;     A_Clipboard := bak
; }