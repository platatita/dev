Attribute VB_Name = "FormatowanieKomorekData"
Option Explicit

Dim Tytul As String
Dim Obszar As Range
Dim LiWierszy As Long, LiKolumn As Long
Dim PWr As Long, PKl As Long
Dim Dzien As Integer, Dzien1 As Integer



Sub FormatKomorData()

' Program ten formatuje wiersze na ca³ej jego d³ugoœci. W tym przypadku program
' ten ma za zadanie pogrubiæ górn¹ linie komórki, która spe³nia postawione przez
' urzytkownika kryteria. Urzytkownik musi zaznaczyæ komórki, w których s¹ wpisane
' daty poszczególnych losowañ, a program bogrubi górn¹ linie danego wiersza
' je¿eli rozpozna, ¿e data w tym wierszu jest pierwszym dniem ka¿dego miesi¹ca.
' Daty musz¹ byæ wpisane w wierszach.


Dim kom As String


Tytul = "Formatowanie komórek ze wzglêdu na datê"

kom = "Zaznacz obszar komórek, w których znajduj¹ siê daty " & Chr(13)
kom = kom & "poszczególnych losowañ. Komórki te powinny znajdowaæ" & Chr(13)
kom = kom & "siê w poszczególnych wierszach" & Chr(13)

'
Set Obszar = Application.InputBox(prompt:=kom, Title:=Tytul, Type:=8)



'PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP

    '
    Call Przeszukiwanie
    
'PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP

MsgBox "Koniec dzia³ania tego programu", vbExclamation, Tytul

End Sub

Private Sub Przeszukiwanie()

'
Dim i As Long, i1 As Long
Dim Arkusz As String


'
Arkusz = Obszar.Worksheet.Name
'
Worksheets(Arkusz).Activate


LiWierszy = Obszar.Rows.Count
LiKolumn = Obszar.Columns.Count

PWr = Obszar.Row - 1
PKl = Obszar.Column - 1


For i = 1 To LiWierszy
    
    For i1 = 1 To LiKolumn
    
        If IsDate(Obszar(i, i1)) = True Then
        
            'PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
                
                '
                Call Formatowanie(i, i1)
            
            'PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
        
        End If
    
    Next i1

Next i


End Sub

Private Sub Formatowanie(i, i1)

'

Dzien = Day(Obszar(i, i1))

If Dzien < Dzien1 Or Day(Obszar(i, i1)) = 1 Then
   
        Cells(i + PWr, i1 + PKl).EntireRow.Select
        
        With Selection.Borders(xlEdgeTop)
            .LineStyle = xlContinuous
            .Weight = xlThick
            .ColorIndex = xlAutomatic
        End With

   
End If

Dzien1 = Dzien

End Sub
