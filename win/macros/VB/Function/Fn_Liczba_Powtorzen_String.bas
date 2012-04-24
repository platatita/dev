Attribute VB_Name = "Fun_Liczba_Powtorzen_String"
Option Explicit
Option Base 1

Public Function Fun_Liczba_Powtorzen_String(Zakres1 As Range, Zakres2 As Range) As String

' Zadaniem tej funkcji jest sprawdzenie ile liczb powtórzy³o sie w losowaniu
' i wypisanie jakie to by³y liczby. Funkcja ta porównuje dwa losowania zaznaczone
' przez urzytkownika. Wynik tej funkcji jest wpisywany do aktywnej komórki.
' Wynik zwrucony przez funkcjê: Np. 7 razy - 1, 4, 12, 15, 65, 66, 75


Dim LWZa1 As Long, LKZa1 As Integer, i As Integer
Dim LWZa2 As Long, LKZa2 As Integer, i1 As Integer
Dim TabLiczbowa() As Long


'
LWZa1 = Zakres1.Rows.Count
LWZa2 = Zakres2.Rows.Count
'
Erase TabLiczbowa()


If LWZa1 > 1 Or LWZa2 > 1 Then
    
    If LWZa1 > 1 And LWZa2 > 1 Then
    
            Fun_Liczba_Powtorzen = "Zaznaczy³eœ za du¿o wierszy w zakresie 1 i 2."
            GoTo koniec
    
    ElseIf LWZa1 > 1 Then
        
            Fun_Liczba_Powtorzen = "Zaznaczy³eœ za du¿o wierszy w zakresie 1."
            GoTo koniec
            
    ElseIf LWZa2 > 1 Then
        
            Fun_Liczba_Powtorzen = "Zaznaczy³eœ za du¿o wierszy w zakresie 2."
            GoTo koniec
           
    End If
    
End If
    
'------------------------------------------------------------------------------------
'
Dim LiPoLiczby As Integer

LiPoLiczby = 0
LKZa1 = Zakres1.Columns.Count
LKZa2 = Zakres2.Columns.Count



    For i = 1 To LKZa1
        
        If Zakres1(1, i) = 0 Then GoTo line1
        
            For i1 = 1 To LKZa2
                 
                If Zakres1(1, i) = Zakres2(1, i1) Then
                
                    LiPoLiczby = LiPoLiczby + 1
                    '
                    ReDim Preserve TabLiczbowa(LiPoLiczby)
                    TabLiczbowa(LiPoLiczby) = Zakres1(1, i)
                    
                    
                End If
            
            Next i1

line1:

    Next i

'====================================================================================

    Dim Ciag_Liczb As String
    
    ' wywo³ywanie procedury i przekazanie do niej tablicy za pomoc¹ ByRef.
    Call Wpis_Liczb(TabLiczbowa(), Ciag_Liczb, LiPoLiczby)
    
    '
    Fun_Liczba_Powtorzen = CStr(LiPoLiczby) & " razy - ( " & Ciag_Liczb & " )"


koniec:



End Function

Private Sub Wpis_Liczb(ByRef Tab_Przek() As Long, Ciag_Liczb, ByVal Licz_El As Integer)

'

Dim i As Integer


For i = 1 To Licz_El

    If i = 1 Then

        Ciag_Liczb = CStr(Tab_Przek(i))
    
    Else
    
        Ciag_Liczb = Ciag_Liczb & ", " & CStr(Tab_Przek(i))
    
    End If

Next i



End Sub
