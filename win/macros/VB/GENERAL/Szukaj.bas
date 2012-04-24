Attribute VB_Name = "Szukaj"
Option Explicit

Public Function Szukaj(obszar As Range, nr_col_find As Integer, nr_col_get As Integer, command As String) As String
    '
    Dim i As Integer, j As Integer
    Dim result As String, get_val As String, coms() As String
    
    '
    If ParseTextArray(command, coms, "-") <= 0 Then
        Exit Function
    End If
    
    '
    On Error GoTo er
    '
    For j = 0 To UBound(coms)
        '
        For i = 1 To obszar.Rows.Count
            '
            If obszar(i, nr_col_find).Value = coms(j) Then
                '
                If result = "" Then
                    result = CStr(obszar(i, nr_col_get).Value)
                Else
                    result = result + "-" + CStr(obszar(i, nr_col_get).Value)
                End If
                
                '
                Exit For
                
            End If
            
        Next i
                
    Next j
    
    '
    Szukaj = result
    '
    Exit Function
    
'
er:
    '
    Debug.Print "Szukaj"
    
End Function
