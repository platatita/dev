Attribute VB_Name = "Koszty"
Option Explicit



'*************************************************************************************************************
'               SUMA_KM
'*************************************************************************************************************
'funkcja sumujaca kilometry zwrócone przez funkcjê "Kopiuj_KM"
Public Function SUMA_KM(ByVal obszar As Range) As Single
    '
    Dim i As Integer
    Dim l As Single, s As Single

    '
    On Error GoTo er
    For i = 1 To obszar.Rows.Count
        '
        l = CSng(IIf(obszar(i, 1).Value <> "", obszar(i, 1), 0))
        '
        s = s + l
        
    Next i
    
    '
    SUMA_KM = s
    '
    Exit Function
    
'
er:
    '
    MsgBox "B³¹d funkcji SUMA_KM", vbCritical + vbOKOnly, "B³¹d"
    '
    SUMA_KM = 0
    
End Function







'*************************************************************************************************************
'               Kopiuj_KM
'*************************************************************************************************************
'funkcja ta s³u¿y do wyszukania w obszarze "Obszar_Wyszukiwania" szukanych danych "Szukane_Dane"
'i zwrócenia wartoœci z kolumny o przekazanym numerze w obrêbie obszaru "Obszar_Wyszukiwania".
Public Function Kopiuj_KM(Obszar_Wyszukiwania As Range, Szukane_Dane As String, Kolumna_Daty As Integer, Kolumna_KM As Integer) As String
    '
    Dim i As Integer
    Dim j As Integer
    Dim s As String, d As String, words() As String
    
    
    '
    For i = 1 To Obszar_Wyszukiwania.Rows.Count
        '
        d = Obszar_Wyszukiwania.Cells(i, Kolumna_Daty)
        '
        j = ParseTextArray(d, words, ".")
        
        '
        If j > 0 Then
            '
            If CByte(Szukane_Dane) = CByte(words(0)) Then
                '
                s = Obszar_Wyszukiwania.Cells(i, Kolumna_KM)
                '
                Exit For
                
            End If
            
        End If
        
    Next i
    
    '
    Kopiuj_KM = s
    
End Function
'
Public Function ParseTextArray(ByVal tekst As String, ByRef words() As String, ParamArray separators() As Variant) As Integer
    '
    Dim i As Integer, j As Integer
    Dim w As Integer
    Dim si As String
    Dim word As String
    
    
    '
    For i = 1 To Len(tekst)
        '
        si = Mid(tekst, i, 1)
        
        '
        For j = 0 To UBound(separators)
            '
            If si = separators(j) And word <> "" Then
                '
                ReDim Preserve words(w)
                '
                words(w) = word
                word = ""
                '
                w = w + 1
                
            Else
                '
                word = word + si
                
            End If
        
        Next j
        
    Next i

    '
    If word <> "" Then
        '
        ReDim Preserve words(w)
        '
        words(w) = word
        word = ""
        w = w + 1
    End If

    
    '
    ParseTextArray = w
    
End Function







'*************************************************************************************************************
'               Get_Date
'*************************************************************************************************************
'funkcja ta s³u¿y do formatowania przekazanej daty. Zamienia miesi¹c numeryczny na s³owny.
Public Function Get_Date(ByVal Data As Range) As String
    '
    Dim ss As String
    
    '
    ss = ParseText(Data.Value)

    '
    Get_Date = ss
    
End Function
'
'funkcja ta s³u¿y do formatowania przekazanego tekstu. W miejscu wskazanym w tekœcie za pomoc¹
'takiego ci¹gu znaków "{d}" powoduje wstawienie w to miejsce s³ownej daty zamiast numerycznej.
Public Function Get_DateS(ByVal Data As Range, tekst As String) As String
    '
    Dim i As Integer
    Dim si As String
    Dim ss As String
    Dim st As String
    Dim kom As String
    Dim begin As Boolean
    
    '
    ss = LCase(ParseText(Data.Value))
    
    '
    For i = 1 To Len(tekst)
    
        '
        si = Mid(tekst, i, 1)
        

        '
        If si = "{" Then
            begin = True
        ElseIf si = "}" Then
            '
            begin = False
            '
            If kom = "d" Then
                st = st + ss
            End If
            
        Else
            '
            If begin = False Then
                st = st + si
            Else
                kom = kom + si
            End If
        End If
             
    Next i

    '
    Get_DateS = st
    
End Function
'
Private Function ParseText(s As String) As String
    '
    Dim i As Integer
    Dim ss As String
    Dim month As String
    Dim year As String
    Dim backslash As Boolean
    
    '
    For i = 1 To Len(s)
        '
        ss = Mid(s, i, 1)
        '
        If ss = "/" Then
            backslash = True
        Else
            '
            If backslash = False Then
                month = month + ss
            Else
                year = year + ss
            End If
            
        End If
        
    Next i
    
    
    '
    s = GetMonth(CByte(month))
    s = s + " " + CStr(year) + " roku"
    
    
    '
    ParseText = s
    
End Function
'
Private Function GetMonth(m As Byte) As String
    '
    Dim ms As String
    
    '
    Select Case (m)
    
        Case Is = 1
            ms = "Styczeñ"
        Case Is = 2
            ms = "Luty"
        Case Is = 3
            ms = "Marzec"
        Case Is = 4
            ms = "Kwiecieñ"
        Case Is = 5
            ms = "Maj"
        Case Is = 6
            ms = "Czerwiec"
        Case Is = 7
            ms = "Lipiec"
        Case Is = 8
            ms = "Sierpieñ"
        Case Is = 9
            ms = "Wrzesieñ"
        Case Is = 10
            ms = "PaŸdziernik"
        Case Is = 11
            ms = "Listopad"
        Case Is = 12
            ms = "Grudzieñ"
            
    End Select
    
    '
    GetMonth = ms
    
End Function




'*************************************************************************************************************
'               Insert_Data
'*************************************************************************************************************
Public Sub Insert_Data()
    '
    Dim begin_range As Range
    Dim miesiac As Byte
    Dim rok As Integer
    Dim days As Byte, from_day As Byte, max_day As Byte, reszta As Single, i As Integer
    Dim tytul As String
    Dim interval As Byte, next_row As Integer
    Dim white_weekend As Byte
        
    
    
    
    '
    tytul = "Insert date"
    
    '
    On Error GoTo koniec
    Set begin_range = Application.InputBox( _
        prompt:="Zaznacz komórkê od której chcesz rozpocz¹æ wstawianie daty:", _
        Title:=tytul, _
        Type:=8)
    '
    rok = InputBox("Podaj rok?", tytul, CInt(year(Now)))
    '
    miesiac = InputBox("Podaj miesi¹c od 1 do 12?", tytul, CInt(month(Now)))
    '
    from_day = InputBox("Podaj od którego dnia rozpocz¹æ wstawianie?", tytul, 1)
    '
    interval = 2 'InputBox("Podaj odstêp miêdzy kratkami?", tytul, 2)
    
    white_weekend = vbNo 'MsgBox("Z weekend-ami?", vbQuestion + vbDefaultButton1 + vbYesNo, tytul)
    '
    days = from_day
    
    
    '
    max_day = GetMonthMaxDays(rok, miesiac)
    '
    next_row = -1
   
line1:
    '
    For i = from_day To max_day
        '
        If white_weekend = vbNo Then
            '
            If IsWeekend(CStr(miesiac) + "," + CStr(i) + "," + CStr(rok)) Then
                from_day = i + 1
                GoTo line1
            End If
        
        End If
        
        
        '
        If next_row = -1 Then
            '
            next_row = begin_range.row
            '
            Call PastValue(begin_range.row, begin_range.column, SetText(CStr(miesiac), CStr(i)))
        Else
            '
            next_row = next_row + interval
            '
            Call PastValue(next_row, begin_range.column, SetText(CStr(miesiac), CStr(i)))
        End If
    
    Next i
    
koniec:
    
End Sub
'
Private Function IsWeekend(ByVal dd As String) As Boolean
    '
    If Weekday(dd) > 1 And Weekday(dd) < 7 Then
        IsWeekend = False
    Else
        IsWeekend = True
    End If
        
End Function
'
Private Function SetText(ByVal m As String, ByVal d As String) As String
    '
    If (Len(m) = 1) Then
        m = "0" + m
    End If
    '
    If (Len(d) = 1) Then
        d = "0" + d
    End If
    
    '
    SetText = d + "." + m 'm + "." + d
    
End Function
'
Private Sub PastValue(ByVal row As Integer, ByVal column As Integer, ByVal text As String)
    '
    Cells(row, column).NumberFormat = "@"
    '
    Cells(row, column).Value = text

End Sub
'
Private Function GetMonthMaxDays(ByVal y As Long, ByVal m As Byte) As Byte
    '
    Dim l As Byte
    
    '
    l = GetFebruaryDays(y)
    '
    GetMonthMaxDays = GetMonthDays(m, l)

End Function
'
Private Function GetFebruaryDays(ByVal y As Long) As Byte
    '
    Dim re_year As Single
    
    '
    re_year = y Mod 4
    '
    If re_year > 0 Then
        GetFebruaryDays = 28
    Else
        GetFebruaryDays = 29
    End If

End Function
'
Private Function GetMonthDays(ByVal m As Byte, ByVal luty As Byte) As Byte
    '
    Dim re_month As Single
    
    '
    If m = 2 Then
        GetMonthDays = luty
    ElseIf m = 8 Then
        GetMonthDays = 31
    Else
        '
        If m > 7 Then m = m + 1
        
        '
        re_month = m Mod 2
        '
        If re_month > 0 Then
            GetMonthDays = 31
        Else
            GetMonthDays = 30
        End If
        
    End If

End Function


