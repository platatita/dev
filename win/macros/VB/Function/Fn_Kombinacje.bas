Attribute VB_Name = "Fun_Kombinacje"
Option Explicit

Function Funkcja_Kombinacje(Zakres_liczbowy As Integer, D³ugoœæ_ci¹gu As Integer) As Variant

' Funkcja ta oblicza liczbê kombinacji dla danego zakresu liczbowego o danej
' d³ugoœci ci¹gu. Np dla liczb od 1 do 80 dla ci¹gu d³ugoœci 3 lub 10 liczb.
' Wystarczy podaæ zakres liczbowy i d³ugoœæ ci¹gu.


Dim mianownik1 As Integer
Dim wynikdul As Variant
Dim wynikgora As Variant

Dim nd As Integer
Dim ng As Integer

  
  mianownik1 = Zakres_liczbowy - D³ugoœæ_ci¹gu + 1
  wynikdul = 1
  wynikgora = 1
  
    For nd = 1 To D³ugoœæ_ci¹gu
      wynikdul = wynikdul * nd
    Next nd
    
    For ng = mianownik1 To Zakres_liczbowy
      wynikgora = wynikgora * ng
    Next ng
          
      
     Funkcja_Kombinacje = wynikgora / wynikdul

End Function

