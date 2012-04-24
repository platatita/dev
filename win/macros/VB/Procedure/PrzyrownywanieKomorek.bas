Attribute VB_Name = "PrzyrownywanieKomorek"
Option Explicit

Sub PrzyrownywanieKomorek()

' Program ten ma za zadanie przenieœæ lub przyrównaæ zawartoœæ komórek z pierwszego
' zaznaczonego obszaru przez urzytkownika do drugiego obszar. Liczba kolumn
' drugiego obszaru ma byæ równa liczbie wierszy z pierwszego obszaru.
' Czyli tak zwane przepisanie i przeformowanie danych zawartych w kolumnach
' do zawartoœci w wierszach.


Dim Obszar1 As Range, Obszar2 As Range
Dim kolumny1 As Long, Wiersz1 As Long, Kolumny2 As Long, Wiersz2 As Long
Dim WierszP As Long, KolumnaP As Long
Dim Komunikat1 As String, Komunikat2 As String, Tytul As String
Dim Komunikat As String, Odp As Long
Dim NazwaArkusza As String


'Wy³¹cza obs³ugê b³êdów.
On Error GoTo koniec

'===============================================================================================
Tytul = "Przyrównywanie komorek."
Komunikat = "Chcesz przyrównaæ komórki czy te¿ tylko przepisaæ ich wartoœci?" & Chr(13)
Komunikat = Komunikat & "Przyrównanie - TAK - " & Chr(13)
Komunikat = Komunikat & "Przepisanie - NIE - " & Chr(13)

Odp = MsgBox(Komunikat, vbInformation + vbYesNoCancel, Tytul)

    If Odp = 2 Then
        Exit Sub
    End If


Komunikat1 = "Zaznacz obszar, z którego chcesz przepisaæ czy te¿ przyrównaæ liczby."
    
    ' Pobranie obszaru zawieraj¹cego liczby do przeniesienia.
    Set Obszar1 = Application.InputBox(prompt:=Komunikat1, Title:=Tytul, Type:=8)

Wiersz1 = Obszar1.Rows.Count
kolumny1 = Obszar1.Columns.Count



Komunikat2 = "Zaznacz obszar do którego maj¹ byæ przeniesione liczby. "
Komunikat2 = Komunikat2 & "Liczba wierszy musi byæ równa liczbie kolumn, "
Komunikat2 = Komunikat2 & "a liczba kolumn musi odpowiadaæ liczbie wierszy." & Chr(13)
Komunikat2 = Komunikat2 & "Liczba zaznaczonych wierszy = " & Wiersz1 & Chr(13)
Komunikat2 = Komunikat2 & "Liczba zaznaczonych kolumn = " & kolumny1 & Chr(13)

    ' Pobranie obszaru do którego maj¹ byæ przeniesione wartoœci z poprzednio pobranego obszaru.
    Set Obszar2 = Application.InputBox(prompt:=Komunikat2, Title:=Tytul, Type:=8)
'===============================================================================================


WierszP = Obszar1.Row - Obszar2.Row
KolumnaP = Obszar1.Column - Obszar2.Column

Wiersz2 = Obszar2.Rows.Count
Kolumny2 = Obszar2.Columns.Count

NazwaArkusza = Obszar1.Worksheet.Name & "!"



'PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
If Wiersz1 = Kolumny2 And kolumny1 = Wiersz2 Then

    'BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
    If Odp = vbYes Then
        
        '
        Call Przyrownanie(WierszP, KolumnaP, Wiersz1, kolumny1, Obszar1, Obszar2, NazwaArkusza)
        
    ElseIf Odp = vbNo Then
        
        '
        Call Przepisanie(WierszP, KolumnaP, Wiersz1, kolumny1, Obszar1, Obszar2, NazwaArkusza)
        
    End If
    'BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB

Else

    Dim KomunikatBledu1 As String
    
    KomunikatBledu1 = "Liczba wierszy lub kolumn w docelowym obszarze przeniesienia" & Chr(13)
    KomunikatBledu1 = KomunikatBledu1 & "jest wiêksza od od liczby wierszy lub kolumn w obszarze zaznaczonym." & Chr(13) & Chr(13)
    
    MsgBox KomunikatBledu1, vbExclamation, Tytul

End If
'PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
    
    MsgBox "Koniec programu.", vbInformation, Tytul
    Exit Sub


'££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££
koniec:
    
    Dim KomBledu As String
    
    KomBledu = "Nie zaznaczy³eœ poprawnego obszaru." & Chr(13)
    KomBledu = KomBledu & "Koniec dzia³ania programu." & Chr(13)
    KomBledu = KomBledu & "Uruchom makro jeszcze raz." & Chr(13) & Chr(13)
    
    MsgBox KomBledu, vbExclamation, Tytul

'££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££


End Sub

Private Sub Przepisanie(WierszP, KolumnaP, Wiersz1, kolumny1, Obszar1, Obszar2, NazwaArkusza)
'

Dim i As Long, i2 As Long


i = 1
i2 = 1

'
For i = 1 To Wiersz1
      
    '
    For i2 = 1 To kolumny1
        
        
            Obszar2(i2, i) = Obszar1(i, i2)
        
    
    Next i2
    
        WierszP = WierszP + 1
        KolumnaP = KolumnaP - 1
    
Next i

End Sub

Private Sub Przyrownanie(WierszP, KolumnaP, Wiersz1, kolumny1, Obszar1, Obszar2, NazwaArkusza)

'

Dim i As Long, i2 As Long


i = 1
i2 = 1

'
For i = 1 To Wiersz1
      
    '
    For i2 = 1 To kolumny1
        
        
            If i2 > 1 Then
                Obszar2(i2, i).FormulaR1C1 = "=" & NazwaArkusza & "R[" & (WierszP - i2 + 1) & "]C[" & (KolumnaP + i2 - 1) & "]"
            Else
                Obszar2(i2, i).FormulaR1C1 = "=" & NazwaArkusza & "R[" & WierszP & "]C[" & KolumnaP & "]"
            End If
        
    
    Next i2
    
        WierszP = WierszP + 1
        KolumnaP = KolumnaP - 1
    
Next i

End Sub
