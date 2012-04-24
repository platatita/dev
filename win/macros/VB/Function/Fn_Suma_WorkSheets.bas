Attribute VB_Name = "Fn_Suma_WorkSheets"
Option Explicit


Public Function Suma_WorkSheets(ByVal range1 As range) As Double

    '
    Dim WS As Worksheet
    Dim suma As Double
    
    Dim R As Integer
    Dim C As Integer
    
    '
    On Error Resume Next
    '
    R = range1.Row
    C = range1.Column
    
       
    '
    For Each WS In range1.Application.Worksheets
        '
        suma = suma + WS.Cells(R, C).Value
    Next

    '
    Suma_WorkSheets = suma
    

End Function
