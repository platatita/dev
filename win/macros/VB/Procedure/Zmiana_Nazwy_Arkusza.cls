VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ThisWorkbook"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

'
Private Sub Workbook_SheetChange(ByVal Sh As Object, ByVal r As Range)
    '
    Dim res As Single
    Dim an As String, nm As String
    Dim s As Worksheet
    
    
    '
    If r.Row = 2 And r.Column = 6 Then
        
        '
        Call Err.Clear
            
        '
        If r.Value = "" Or r.Value <= 0 Then
            Exit Sub
        End If
        
        
        '
        Set s = Sh
        an = s.name
        
        '
        res = r.Value Mod 2
        
        '
        If res <> 0 Then
            nm = "Nieparzysty"
        Else
            nm = "Parzysty"
        End If
        
        '
        On Error GoTo errorline
        '
        If nm <> s.name Then
            '
            s.name = nm
            '
            MsgBox "Zmieniono nazwê arkusza z (" + an + ") na (" + nm + ").", _
            vbOKOnly + vbInformation, _
            "Zmiana nazwy arkusza"
        End If
          
        '
        Exit Sub
        
    End If
    
    
'
errorline:
    '
    Select Case Err.Number
        Case 1004
            '
            Dim ws As Worksheet
            '
            For Each ws In Me.Worksheets
                '
                If LCase(ws.name) = LCase(nm) Then
                    '
                    ws.name = ws.name + " uniewa¿niono!"
                    '
                    Exit For
                End If
                                
            Next ws
            
            '
            s.name = nm
            '
            Resume Next
                    
    End Select
        

End Sub
