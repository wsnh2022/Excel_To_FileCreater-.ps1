#Requires AutoHotkey v2.0+
#SingleInstance force
#Include C:\Users\The_Thinker\Documents\AutoHotkey_V2\lib\GuiEnhancerKit.ahk
#Include C:\Users\The_Thinker\Documents\AutoHotkey_V2\lib\ColorButton.ahk

~Escape::ExitApp
~!Space::Reload
;; ========== Template Manager
; Set the folder where your template files are stored
templateDir := "D:\Templates"

; Create the main GUI window
; /** @var {GuiExt} GetT_GUI */
GetT_GUI := Gui()
GetT_GUI.SetDarkMenu()
GetT_GUI.SetDarkTitle()
GetT_GUI.SetWindowAttribute(33, 2) ;GuiEnhancerKit.ahk function
GetT_GUI.OnEvent("Close", (*) => ExitApp())
GetT_GUI.Title := "Template Manager"
GetT_GUI.BackColor := "202020"
GetT_GUI.SetFont("s10 c03000c", "Trebuchet MS") ;"Cascadia Code"

; Create a ListView to display template files
LV := GetT_GUI.Add("ListView", "r10 w200 h400 Background333333 cFFFFFF", ["Template Name               Sort ↕️"])
LV.OnEvent("DoubleClick", CopySelectedTemplate)

btc := "c000000"     ; Button color
bfc := "ff6e6e"     ; Button font color
; bol := "00daa3"     ; Button Outline color
; Add buttons
GetT_GUI_button := GetT_GUI.Add("Button","w60 y10","Copy"),GetT_GUI_button.OnEvent("Click", CopySelectedTemplate),GetT_GUI_button.SetColor(btc, bfc,, bfc, 9)
GetT_GUI_button := GetT_GUI.Add("Button","w60 y+10","Refresh"),GetT_GUI_button.OnEvent("Click", RefreshTemplateList),GetT_GUI_button.SetColor(btc, bfc,, bfc, 9)
GetT_GUI_button := GetT_GUI.Add("Button","w60 y+10","Add New"),GetT_GUI_button.OnEvent("Click", CreateNewTemplate),GetT_GUI_button.SetColor(btc, bfc,, bfc, 9)
GetT_GUI_button := GetT_GUI.Add("Button","w60 y+10","Delete"),GetT_GUI_button.OnEvent("Click", DeleteSelectedTemplate),GetT_GUI_button.SetColor(btc, bfc,, bfc, 9)
GetT_GUI_button := GetT_GUI.Add("Button","w60 y+10","Reload"),GetT_GUI_button.OnEvent("Click", (*) => Reload()),GetT_GUI_button.SetColor(btc, bfc,, bfc, 9)

; Function to refresh the template list
RefreshTemplateList(*) {
    LV.Delete()
    Loop Files, templateDir "\*.txt"
        LV.Add(, StrReplace(A_LoopFileName, ".txt"))
}

; Function to copy selected template content to clipboard
CopySelectedTemplate(*) {
    if (rowNumber := LV.GetNext()) {
        fileName := LV.GetText(rowNumber, 1) . ".txt"
        filePath := templateDir "\" fileName
        try {
            content := FileRead(filePath)
            A_Clipboard := content
            if !ClipWait(1)
                throw Error("Failed to set clipboard")
            ToolTip("Template copied to clipboard!")
            SetTimer () => ToolTip(), -2000  ; Remove tooltip after 2 seconds
        } catch as err {
            MsgBox("Error: " err.Message, "Template Error", 16)
        }
    }
}

; Function to create a new template file
CreateNewTemplate(*) {
    NewTemplateGui := Gui()
    NewTemplateGui.OnEvent("Close", (*) => NewTemplateGui.Destroy())
    NewTemplateGui.Title := "Create New Template"
    NewTemplateGui.BackColor := "202020"
    NewTemplateGui.SetFont("s10 cFFFFFF", "Cascadia Code")

    NewTemplateGui.Add("Text",, "Template Name:")
    nameEdit := NewTemplateGui.Add("Edit", "w200 vTemplateName Background050505")
    NewTemplateGui.Add("Text", "xm", "Template Content:")
    contentEdit := NewTemplateGui.Add("Edit", "r10 w300 vTemplateContent Background000000")

    NewTemplateGui.Add("Button", "w100 Default", "Save").OnEvent("Click", (*) => SaveNewTemplate(NewTemplateGui, nameEdit, contentEdit))
    NewTemplateGui.Show()
}

; Function to save a new template file
SaveNewTemplate(gui, nameEdit, contentEdit) {
    templateName := nameEdit.Value
    templateContent := contentEdit.Value

    if (templateName != "" and templateContent != "") {
        filePath := templateDir "\" templateName ".txt"
        try {
            FileAppend(templateContent, filePath)
            ; MsgBox("Template saved successfully!", "Success")
            gui.Destroy()
            RefreshTemplateList()
            CreateHotstrings()
        } catch as err {
            MsgBox("Error saving template: " err.Message, "Error", 16)
        }
    } else {
        MsgBox("Please enter both template name and content.", "Error", 16)
    }
}

; Function to delete the selected template
DeleteSelectedTemplate(*) {
    if (rowNumber := LV.GetNext()) {
        fileName := LV.GetText(rowNumber, 1) . ".txt"
        filePath := templateDir "\" fileName
        result := MsgBox("Are you sure you want to delete this template?", "Confirm Delete", 4)
        if (result == "Yes") {
            try {
                FileDelete(filePath)
                RefreshTemplateList()
                CreateHotstrings()
                MsgBox("Template deleted successfully!", "Success")
            } catch as err {
                MsgBox("Error deleting template: " err.Message, "Error", 16)
            }
        }
    } else {
        MsgBox("Please select a template to delete.", "Error", 16)
    }
}

; Function to set up text shortcuts
CreateHotstrings() {
    Hotstring("Reset")
    Loop Files, templateDir "\*.txt" {
        triggerName := StrReplace(A_LoopFileName, ".txt")
        Hotstring(":*:" triggerName, InsertTemplate.Bind(A_LoopFilePath))
    }
}

; Function to insert template content
InsertTemplate(filePath, *) {
    try {
        content := FileRead(filePath)
        A_Clipboard := content
        if !ClipWait(1)
            throw Error("Failed to set clipboard")
        Send "^v"
    } catch as err {
        MsgBox("Error with template: " err.Message, "Template Error", 16)
    }
}

; Initial setup
CreateHotstrings()
RefreshTemplateList()

; Refresh hotstrings every 30 seconds
SetTimer(CreateHotstrings, 30000)

; Show the main GUI
GetT_GUI.Show()


;;========