VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} win_date 
   Caption         =   "Rozpisywanie daty"
   ClientHeight    =   4215
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5565
   OleObjectBlob   =   "win_date.frx":0000
   StartUpPosition =   1  'CenterOwner
End
Attribute VB_Name = "win_date"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'********************************************************
'Marcin Szewczyk
'********************************************************


'
Public WithEvents m_workbook    As Workbook
Attribute m_workbook.VB_VarHelpID = -1
'
Private m_worksheet             As Worksheet
Private m_result                As Boolean
Private m_sobniedz              As Boolean
Private m_day                   As Integer
Private m_week                  As Byte
Private m_month                 As Integer
Private m_year                  As Integer
Private m_data                  As String
Private m_fromrow               As Long
Private m_fromcolumn            As Long
Private m_intervalrow           As Integer


'
Private Sub UserForm_Initialize()
    '
    m_result = False
    '
    Me.lb_dzis.Caption = "Dziœ - " + CStr(Date)
    Me.lb_date.Caption = CStr(GetFromDay(Date))
    '
    Me.mv_date.Visible = True
    Me.mv_date.Day = Day(Date)
    Me.mv_date.Month = Month(Date)
    Me.mv_date.Year = Year(Date)
    '
    Me.ch_sobiniedz.Value = False
    Me.ch_autorozm.Value = True
    
End Sub
'
Private Function GetFromDay(data As Date) As String
    '
    Dim i As Byte
    Dim max_d As Byte
    
    '
    max_d = GetMonthMaxDays(Year(data), CByte(Month(data)))
    
    '
    For i = 1 To max_d
        '
        If Not IsWeekend(CStr(Month(data)) + "," + CStr(i) + "," + CStr(Year(data))) Then
            '
            GetFromDay = CStr(Year(data)) + "-" + GetValLen(Month(data)) + "-" + GetValLen(i)
            '
            Exit Function
        End If
    
    Next i
    
    '
    GetFromDay = CStr(Year(data)) + "-" + GetValLen(Month(data)) + "-" + "01"
    
End Function
'
Private Function GetValLen(ByVal v As Integer) As String
    '
    If Len(CStr(v)) = 1 Then
        GetValLen = "0" + CStr(v)
    Else
        GetValLen = CStr(v)
    End If
    
End Function
'
Private Sub UserForm_Terminate()
    '
    Set m_worksheet = Nothing
    '
    Set m_workbook = Nothing
    
End Sub
'
Private Sub UserForm_Activate()
    '
    Me.m_workbook.Worksheets(1).Activate
    
    '
    Call SetAutoRange
    '
    Call GetPosition(Me.m_workbook.Worksheets(1), 11, 2)
    
End Sub
'
Public Function ShowDialog(ByVal modal As Byte) As Boolean
    '
    Me.Show (modal)
    
    '
    ShowDialog = m_result
    
End Function
'
Private Sub ch_autorozm_Change()
    '
    If Me.ch_autorozm.Value = True Then
        Me.tx_cowiersze.Enabled = False
        Me.ch_sobiniedz.Enabled = False
        Me.ch_sobiniedz.Value = False
    Else
        Me.tx_cowiersze.Enabled = True
        Me.ch_sobiniedz.Enabled = True
    End If

End Sub
'
Private Sub bt_ok_Click()
    '
    m_result = True
    '
    m_day = Me.mv_date.Day
    m_week = Me.mv_date.Week
    m_month = Me.mv_date.Month
    m_year = Me.mv_date.Year
    '
    m_sobniedz = Me.ch_sobiniedz.Value
    m_intervalrow = CInt(Me.tx_cowiersze.Value)
    
    
    '
    If Me.tx_zaznkomorka.Text = "" Then
    '
        MsgBox "Nie zaznaczy³eœ komórki od której ma siê rozpocz¹æ wstawianie daty", vbExclamation + vbOKOnly, "Data"
        Exit Sub
    End If
    
    
    '
    Call InsertDate
    '
    MsgBox "Koniec dzia³ania programu", vbInformation + vbOKOnly, "Rozpisywanie daty"
    '
    Call bt_anuluj_Click
    
End Sub
'
Private Sub bt_anuluj_Click()
    '
    Me.Hide
    Unload Me
    
End Sub
'
Private Sub mv_date_SelChange(ByVal StartDate As Date, ByVal EndDate As Date, Cancel As Boolean)
    '
    Me.lb_date.Caption = Me.mv_date.Value
    '
        '
    If Me.ch_autorozm.Value = True Then
        Call SetAutoRange
    End If
    
End Sub
'
Private Sub SetAutoRange()
    '
    Dim d As Byte, max_days As Byte, r As Long
    Dim dd As String
        
    '
    max_days = GetMonthMaxDays(Me.mv_date.Year, Me.mv_date.Month)
    '
    For d = 1 To max_days
        '
        dd = CStr(Me.mv_date.Month) + "," + CStr(d) + "," + CStr(Me.mv_date.Year)
        '
        If Not IsWeekend(dd) Then Exit For
        
    Next d
    
    '
    Me.mv_date.Day = d
    '
    d = Weekday(dd)
    '
    r = 11 + (2 * (d - 2))
    '
    Me.m_workbook.Worksheets(1).Range("B" + CStr(r)).Select
        
End Sub
'
Private Sub m_workbook_SheetSelectionChange(ByVal Sh As Object, ByVal t As Range)
    
    '
    Call GetPosition(t.Worksheet, t.row, t.column)
 
End Sub
'
Private Sub GetPosition(w As Worksheet, ByVal row As Long, ByVal column As Long)
    '
    m_fromrow = row
    m_fromcolumn = column
    
    '
    Set m_worksheet = Nothing
    Set m_worksheet = w
    
    '
    Me.tx_zaznkomorka.Text = "Wiersz-" + CStr(row) + "; Kolumna-" + CStr(column)
    
End Sub



'====================================================================================================
'====================================================================================================
'
Private Sub InsertDate()
    
    '
    Call InsertWeek
    '
    Call InsertNameMonth
    

    '
    Dim ws As Worksheet
    Dim i As Long, to_row As Long
    Dim max_days As Byte, d As Byte, weekend As Byte
    Dim re_month As Single
    Dim dd As String
    Dim workdays As Byte
    
    
    '
    d = m_day
    '
    max_days = GetMonthMaxDays(m_year, m_month)

    
    
    '
    If m_sobniedz Then
        weekend = 0
        to_row = m_fromrow + (6 * m_intervalrow)
    Else
        weekend = 2
        to_row = m_fromrow + (4 * m_intervalrow)
    End If
    
     
    '
    Call ClearRanges(m_fromcolumn, to_row, m_intervalrow)
    

    '
    For Each ws In m_workbook.Worksheets
        '
        workdays = 0
        '
        For i = m_fromrow To to_row Step m_intervalrow
            
            '
            If weekend <> 0 Then
                '
                For d = d To max_days
                    '
                    dd = CStr(m_month) + "," + CStr(d) + "," + CStr(m_year)
                    '
                    If Not IsWeekend(dd) Then
                        Exit For
                    Else
                        GoTo line1
                    End If
                    
                Next d
            Else
                '
                dd = CStr(m_month) + "," + CStr(d) + "," + CStr(m_year)
                
            End If
            
            
            '
            If d > max_days Then
                '
                ws.Cells(4, 1).Value = workdays
                '
                Exit Sub
            End If
            
           
            '
            ws.Cells(i, m_fromcolumn).NumberFormat = "@"
            ws.Cells(i, m_fromcolumn).Value = SetFormatDate(CStr(d), CStr(m_month))
            workdays = workdays + 1
            '
            d = d + 1
            
            
        Next i
        
line1:

        '
        d = d + weekend
        '
        m_fromrow = 11
        '
        ws.Cells(4, 1).Value = workdays
        
    Next ws
    
    
End Sub
'
Private Sub ClearRanges(ByVal column As Integer, ByVal to_row As Long, ByVal interval As Integer)
    '
    Dim i As Long
    Dim ws As Worksheet
    
    '
    For Each ws In m_workbook.Worksheets
        '
        ws.Cells(4, 1).Value = ""
        '
        For i = 11 To to_row Step interval
            '
            ws.Cells(i, m_fromcolumn).Value = ""
            
        Next i
        
    Next ws
    
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
    re_year = m_year Mod 4
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
Private Function SetFormatDate(ByVal d As String, ByVal m As String) As String
    '
    If Len(d) = 1 Then d = "0" + d
    '
    If Len(m) = 1 Then m = "0" + m
    
    '
    SetFormatDate = d + "." + m

End Function
'
Private Sub InsertWeek()
    '
    m_worksheet.Cells(1, 1).Value = m_week

End Sub
'
Private Sub InsertNameMonth()
    '
    Dim st As String
    
    '
    Select Case m_month
        Case 1
            st = "Styczeñ"
        Case 2
            st = "Luty"
        Case 3
            st = "Marzec"
        Case 4
            st = "Kwiecieñ"
        Case 5
            st = "Maj"
        Case 6
            st = "Czerwiec"
        Case 7
            st = "Lipiec"
        Case 8
            st = "Sierpieñ"
        Case 9
            st = "Wrzesieñ"
        Case 10
            st = "PaŸdziernik"
        Case 11
            st = "Listopad"
        Case 12
            st = "Grudzieñ"
        Case Else
            st = "Brak"
    End Select
    
    '
    m_worksheet.Cells(2, 21).Value = "/" + st

End Sub


'====================================================================================================
'====================================================================================================
'
Public Property Get Data_() As String
    '
    Data_ = m_data
    
End Property
'
Public Property Get Year_() As String
    '
    Year_ = m_year
    
End Property
'
Public Property Get Month_() As String
    '
    Month_ = m_month
    
End Property
'
Public Property Get Day_() As String
    '
    Day_ = m_day
    
End Property
'
Public Property Get SobNiedz() As String
    '
    SobNiedz = m_sobniedz
    
End Property



