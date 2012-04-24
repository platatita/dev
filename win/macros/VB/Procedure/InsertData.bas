Attribute VB_Name = "InsertData"
Option Explicit

Public Sub InsertData()
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
    Set begin_range = Application.InputBox( _
        prompt:="Zaznacz komórkê od której chcesz rozpocz¹æ wstawianie daty:", _
        Title:=tytul, _
        Type:=8)
    '
    rok = InputBox("Podaj rok?", tytul, CInt(Year(Now)))
    '
    miesiac = InputBox("Podaj miesi¹c od 1 do 12?", tytul, CInt(Month(Now)))
    '
    from_day = InputBox("Podaj od którego dnia rozpocz¹æ wstawianie?", tytul, 1)
    '
    interval = InputBox("Podaj odstêp miêdzy kratkami?", tytul, 2)
    
    white_weekend = MsgBox("Z weekend-ami?", vbQuestion + vbDefaultButton1 + vbYesNo, tytul)
    '
    days = from_day
    
    
    '
    max_day = GetMonthMaxDays(rok, miesiac)
    
   
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
        If i = days Then
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
    SetText = m + "." + d
    
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
