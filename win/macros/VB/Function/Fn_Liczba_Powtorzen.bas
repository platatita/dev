Attribute VB_Name = "Fun_Liczba_Powtorzen"
Option Explicit
Option Base 1

Public Function Fun_Liczba_Powtorzen(Zakres1 As Range, Zakres2 As Range) As Variant

' Zadaniem tej funkcji jest sprawdzenie ile liczb powtórzy³o sie w losowaniu
' porównuj¹c to do losowania poprzedzaj¹cego to losowanie.



Dim LWZa1 As Long, LKZa1 As Integer, i As Integer
Dim LWZa2 As Long, LKZa2 As Integer, i1 As Integer


'
LWZa1 = Zakres1.Rows.Count
LWZa2 = Zakres2.Rows.Count


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
                
                End If
            
            Next i1

line1:

    Next i

    
    
    '
    Fun_Liczba_Powtorzen = LiPoLiczby


koniec:



End Function

