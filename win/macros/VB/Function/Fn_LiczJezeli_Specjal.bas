Attribute VB_Name = "Fun_LiczJezeliSpecjal"
Option Explicit

'
Dim LWKryterium As Long
Dim Wynik As String


Function LiczJezeliSpecjal(Zakres As Range, Kryteria As Range) As Variant

' Funkcja ta jest ulepszon¹ wersj¹ funkcji Licz.Je¿eli wbydowanej do arkusza
' kalkulacyjnego. Ulepszenie jej polega na tym, ¿e funkcja ta zwraca do zaznaczonej
' komórki arkusza jako wynik liczby, które zosta³y znalezione przez nia w podanym
' zakresie zawieraj¹cym liczby do przeszukiwania.


Dim P As Long


Wynik = ""
LWKryterium = 0
P = 0



    'PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
    
        '
        Call Przeszukiwanie(Zakres, Kryteria, P)
    
    'PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP



    If P = 0 Then
        
        LiczJezeliSpecjal = 0
        
    ElseIf P < LWKryterium Then
        
        LiczJezeliSpecjal = Wynik
    
    ElseIf P = LWKryterium Then
    
        LiczJezeliSpecjal = "Tak"
    
    End If



End Function

Private Sub Przeszukiwanie(Zakres, Kryteria, P)

'
Dim i1 As Long, i2 As Long
Dim LKZakresu As Long


LKZakresu = Zakres.Columns.Count
LWKryterium = Kryteria.Rows.Count



For i1 = 1 To LWKryterium

    For i2 = 1 To LKZakresu
    
        If Zakres(1, i2) = Kryteria(i1, 1) Then
        
            P = P + 1
            
            If Wynik = "" Then
                Wynik = Kryteria(i1, 1)
            Else
                Wynik = Wynik & ", " & Kryteria(i1, 1)
            End If
            
        End If
        
    Next i2
    
Next i1



End Sub
