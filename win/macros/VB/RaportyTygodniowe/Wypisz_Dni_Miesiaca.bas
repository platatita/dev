Attribute VB_Name = "Wypisz_Dni_Miesiaca"
Option Explicit

'********************************************************
'Marcin Szewczyk
'********************************************************

'
Public Sub WypiszDniMiesiaca()
    '
    Dim win As win_date
    '
    Set win = win_date
    Set win.m_workbook = Application.ThisWorkbook
    
    '
    win.ShowDialog (0)
    
End Sub


