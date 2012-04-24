Attribute VB_Name = "Fn_RaportTygodniowy"
Option Explicit

'********************************************************
'Marcin Szewczyk
'********************************************************



'********************************************************
'   Is_Number
'********************************************************
'Funkcja sprawdzaj¹ca, czy przekazany obszar zawiera liczby przeznaczone do wykonywania na nich obliczeñ.
Public Function Is_Number(r As Range) As Boolean
    '
    If IsNumeric(r.Value) And r.Value > 0 Then
        Is_Number = True
    Else
        Is_Number = TestTekst(CStr(r.Value))
    End If
    
End Function
'
Private Function TestTekst(ss As String) As Boolean
    '
    Dim i As Integer, cr As Integer
    Dim s As String
    Dim r As Boolean
    
    '
    r = True
    
    '
    For i = 1 To Len(ss)
        '
        s = Mid(ss, i, 1)
        '
        If Not IsNumeric(s) Then
            '
            If s = "/" Or s = "\" Then
                r = True
                cr = cr + 1
            Else
                r = False
                Exit For
            End If
            
        End If
        
    Next i
    
    '
    TestTekst = IIf(cr = 1 And r = True, True, False)
    
End Function




'********************************************************
'   Get_Data
'********************************************************
'Funkcja ta parsuje tekst w celu zwrócenia odpowiedniej liczby.
'Liczba zwracana to tak, której numer jest przekazany jako parametr funkcji "Index"
'znaki separacji "/" lub "\"
Public Function Get_Data(ss As String, index As Byte) As Integer
    '
    Dim v() As Integer
    Dim i As Integer, vi As Integer
    Dim s As String, vs As String
    Dim r As Boolean
    
    '
    vi = 0
    r = True
    
    '
    For i = 1 To Len(ss)
        '
        s = Mid(ss, i, 1)
        '
        If IsNumeric(s) Then
            vs = vs + s
        Else
            Call AddArray(vi, vs, v)
        End If
        
    Next i
    
    '
    If Len(vs) > 0 Then Call AddArray(vi, vs, v)
        
    '
    If vi > 0 And index <= vi Then
        Get_Data = v(index - 1)
    Else
        Get_Data = 0
    End If
    
End Function
'
Private Function AddArray(ByRef vi As Integer, ByRef vs As String, ByRef v() As Integer) As Integer
    '
    If Len(vs) > 0 And IsNumeric(vs) Then
        '
        ReDim Preserve v(vi)
        '
        v(vi) = CInt(vs)
        vi = vi + 1
        vs = ""
    End If
    
    '
    AddArray = vi
    
End Function

