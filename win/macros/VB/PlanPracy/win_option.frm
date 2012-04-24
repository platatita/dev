VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} win_option 
   Caption         =   "Opcje"
   ClientHeight    =   5610
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4065
   OleObjectBlob   =   "win_option.frx":0000
   StartUpPosition =   1  'CenterOwner
End
Attribute VB_Name = "win_option"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit


'
Public WithEvents m_workbook   As Workbook
Attribute m_workbook.VB_VarHelpID = -1
'
Private m_worksheet             As Worksheet
Private m_plik                  As String
Private m_odrow, m_odcolumn     As Integer
Private m_skl                   As New Collection



'************************************************************************************************************
'************************************************************************************************************
'
Private Sub UserForm_Initialize()
          
    '
    Dim i As Integer
    
    '
    i = 0
    Me.cb_dzien.AddItem "Brak", i: i = i + 1
    Me.cb_dzien.AddItem "Poniedzia³ek", i: i = i + 1
    Me.cb_dzien.AddItem "Wtorek", i: i = i + 1
    Me.cb_dzien.AddItem "Œroda", i: i = i + 1
    Me.cb_dzien.AddItem "Czwartek", i: i = i + 1
    Me.cb_dzien.AddItem "Pi¹tek", i: i = i + 1
    Me.cb_dzien.AddItem "Sobota", i: i = i + 1
    Me.cb_dzien.AddItem "Niedziela", i: i = i + 1
    Me.cb_dzien.ListIndex = 0
    
    '
    i = 0
    Me.cb_tydzien.AddItem "Brak", i: i = i + 1
    Me.cb_tydzien.AddItem "Parzysty", i: i = i + 1
    Me.cb_tydzien.AddItem "Nieparzysty", i: i = i + 1
    Me.cb_tydzien.ListIndex = 0
    
    '
    m_plik = "Trasy.xls"
    Me.tx_baza.Text = Application.ActiveWorkbook.Path + "\" + m_plik
        
    '
    Me.ob_miasto.SetFocus
    Me.ob_miasto.Value = True
        
End Sub



'================================================================================================
'================================================================================================
'
Private Sub bt_anuluj_Click()

    Me.Hide
    Unload Me

End Sub

Private Sub bt_ok_Click()

    '
    If Not IsDay Then
        Exit Sub
    End If
    
    
    '
    Dim bk  As Workbook
    Dim Sh  As Worksheet


    '
    If IsOpen(m_plik) Then
        Set bk = Workbooks(m_plik)
    Else
        Set bk = Workbooks.Open(Filename:=Me.tx_baza.Text)
    End If
    
    
    '
    For Each Sh In bk.Sheets
        '
        If Add_Sklep(Sh, Me.tx_miasto.Text, Me.cb_dzien.Text, Me.cb_tydzien.Text) Then
            Exit For
        End If
        
    Next Sh
    
    
    '
    Call WriteCollection
    
    '
    Set bk = Nothing
    
    
    '
    Call bt_anuluj_Click
    
End Sub

'
Private Function IsDay() As Boolean

    '
    Dim res
    '
    If Me.cb_dzien.ListIndex = 0 Then
        '
        res = MsgBox("Nie wybrano dnia! Czy chcesz zakoñczyæ?", vbExclamation + vbYesNo + vbDefaultButton1, "Dzieñ")
        '
        If res = vbYes Then
            Call bt_anuluj_Click
        End If
        
        '
        IsDay = False
        
    ElseIf Me.cb_tydzien.ListIndex = 0 Then
        '
        res = MsgBox("Nie wybrano typu tygodnia! Czy chcesz zakoñczyæ?", vbExclamation + vbYesNo + vbDefaultButton1, "Tydzieñ")
        '
        If res = vbYes Then
            Call bt_anuluj_Click
        End If
        
        '
        IsDay = False
        
    Else
        '
        IsDay = True
        
    End If
    

End Function

'
Private Sub WriteCollection()
    '
    Dim v   As Integer
    Dim s   As Sklep
    Dim ss  As Sklep
    
    
    '
    v = m_odrow
    '
    For m_odrow = 1 To m_skl.Count
        '
        Set s = m_skl.Item(m_odrow)
        
        '
        If Me.tx_miasto.Text <> "-1" Then
            Call WriteRange(m_odrow + v - 1, m_odcolumn, s.Nazwa, False)
        Else
            '
            If m_odrow = 1 Then
                Call WriteRange(m_odrow + v - 1, m_odcolumn, s.Miasto, True)
                Call WriteRange(m_odrow + v, m_odcolumn, s.Nazwa, False)
                '
                v = v + 1
            Else
                '
                Set ss = m_skl.Item(m_odrow - 1)

                '
                If s.Miasto = ss.Miasto Then
                    Call WriteRange(m_odrow + v - 1, m_odcolumn, s.Nazwa, False)
                Else
                    Call WriteRange(m_odrow + v - 1, m_odcolumn, s.Miasto, True)
                    Call WriteRange(m_odrow + v, m_odcolumn, s.Nazwa, False)
                    '
                    v = v + 1
                End If
            End If
        End If
        
    Next m_odrow
    
    '
    m_worksheet.Activate

    
End Sub
'
Private Sub WriteRange(ByVal i As Integer, ByVal j As Integer, ByVal s As String, ByVal bold As Boolean)
    
    m_worksheet.Cells(i, j).Value = s
    m_worksheet.Cells(i, j).Font.bold = bold
     
End Sub

'
Private Function Add_Sklep(ByVal Sh As Worksheet, ByVal Miasto As String, ByVal dzien As String, ByVal tydzien As String) As Boolean

    '
    Dim s As String
    Dim i As Integer
        
 
    '
    If StrConv(Sh.Cells(2, 3).Value, vbLowerCase) <> StrConv(dzien, vbLowerCase) Or _
        StrConv(Sh.Cells(2, 6).Value, vbLowerCase) <> StrConv(tydzien, vbLowerCase) Then
        '
        Add_Sklep = False
        Exit Function
    End If
    
    
    '
    For i = 7 To 40
        '
        Dim punkt   As New Sklep
        
        '
        punkt.Nazwa = Sh.Cells(i, 3).Value
        punkt.Miasto = Sh.Cells(i, 4).Value
        punkt.Adres = Sh.Cells(i, 5).Value

        '
        If (Miasto <> "-1") Then
            If StrConv(Sh.Cells(i, 4).Value, vbLowerCase) = StrConv(Miasto, vbLowerCase) Then
                Call Test_Sklep(punkt)
            End If
        Else
            Call Test_Sklep(punkt)
        End If
        
        '
        Set punkt = Nothing
        
    Next i
    
     
    '
    Add_Sklep = True
    
End Function
'
Private Function Test_Sklep(punkt As Sklep) As Boolean
    
    '
    Dim p As New Sklep
    
    '
    For Each p In m_skl
        '
        If p.Nazwa = punkt.Nazwa And p.Miasto = punkt.Miasto And p.Adres = punkt.Adres Then
            Test_Sklep = True
            Exit Function
        End If

    Next p

    '
    m_skl.Add Item:=punkt
     
    '
    Test_Sklep = False
    
End Function
'
Private Function IsOpen(ByVal name As String) As Boolean
    
    '
    Dim v As Variant
    
    '
    For Each v In Application.Workbooks
        '
        If v.name = name Then
            '
            IsOpen = True
            '
            Exit Function
        End If
    Next v

    '
    IsOpen = False

End Function



'================================================================================================
'================================================================================================
'
Private Sub ob_miasto_Change()

    '
    If Me.ob_miasto.Value = True Then
        Me.tx_miasto.Enabled = True
        Me.tx_odkomorki.Enabled = False
        Me.tx_miasto.SetFocus
    End If
    
End Sub
'
Private Sub ob_odkomorki_Change()
    
    '
    If Me.ob_odkomorki.Value = True Then
        Me.tx_miasto.Enabled = False
        Me.tx_odkomorki.Enabled = True
        Me.tx_odkomorki.SetFocus
    End If

End Sub
'
Private Sub m_workbook_SheetSelectionChange(ByVal Sh As Object, ByVal r As Range)
    
    '
    Me.tx_rows.Value = r.Row
    Me.tx_columns.Value = r.Column
    
    '
    If Me.ob_miasto.Value Then
        '
        Me.tx_miasto.Text = r.Value
        
    ElseIf Me.ob_odkomorki Then
        '
        Me.tx_odkomorki.Text = r.Value
        m_odrow = r.Row
        m_odcolumn = r.Column
        '
        Set m_worksheet = r.Worksheet
    End If
    
End Sub

'************************************************************************************************************
'************************************************************************************************************
