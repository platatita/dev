Attribute VB_Name = "FormatData"
Option Explicit

Sub FormatData()

' Procedura ta ma za zadanie przekszta³cenie daty pobranej z internetu na datê
' dopasowan¹ do programu. Np: z "01.05.1995" na "1995-05-01"


Dim Obszar As Range
Dim Zawartosc As String, Litera As String
Dim DlTekstu As Integer, iTekstu As Integer

Dim Kolumny As Long
Dim Wiersze As Long
Dim i As Long, i2 As Long
Dim Rok As Integer, Lewy As Boolean, Prawy As Boolean
Dim Komunikat As String


'
Komunikat = "Zaznacz obszar w którym chcesz formatowaæ datê na np.1999-02-12."

' Przypisanie zaznaczonego obiektu do zmiennej Obszar.
Set Obszar = Application.InputBox(prompt:=Komunikat, Title:="Formatowanie daty", Type:=8)

'
DoEvents

'
Kolumny = Obszar.Columns.Count
Wiersze = Obszar.Rows.Count
Lewy = False
Prawy = False


'
For i = 1 To Kolumny
    
    '
    For i2 = 1 To Wiersze
        
        
        '
        DlTekstu = Len(Obszar(i2, i))
        
        '
        If IsNumeric(Obszar(i2, i)) = False And DlTekstu = 10 Then
               
                Zawartosc = ""
                Rok = 0
               
                '
                For iTekstu = 1 To DlTekstu
                                
                    Litera = Mid(Obszar(i2, i), iTekstu, 1)
                    
                    '
                    If IsNumeric(Litera) Then
                        
                        Zawartosc = Zawartosc & Litera
                        Rok = Rok + 1
                        
                    Else
                        
                        
                        If Rok = 2 Then
                            Lewy = False: Prawy = True
                        ElseIf Rok = 4 Then
                            Lewy = True: Prawy = False
                        End If
                        
                        Rok = Rok + 1
                        
                        Litera = "-"
                        Zawartosc = Zawartosc & Litera
                    
                    End If
                
                Next iTekstu
                
                
                'PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
                
                    ' wywo³uje procedurê ZmienKolejnosc()
                    Call ZmienKolejnosc(i2, i, Obszar, Zawartosc, Lewy, Prawy)
                
                'PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
          
        End If
        
    Next i2
    
Next i


MsgBox "Koniec programu", vbExclamation, "Formatowanie daty"


End Sub

Private Sub ZmienKolejnosc(i2, i, Obszar, Zawartosc, Lewy, Prawy)

' Procedura ta ma zadanie zmieniæ kolejnoœæ wystêpowanie roku w dacie.

Dim Rok1 As String, Zawartosc1 As String
Dim Miesiac As String, Dzien As String

  
If Prawy = True And Lewy = False Then
    
    Rok1 = Right(Zawartosc, 4)
    Miesiac = Mid(Zawartosc, 4, 2)
    Dzien = Left(Zawartosc, 2)
    Obszar(i2, i) = Rok1 & "-" & Miesiac & "-" & Dzien
        
End If


End Sub
