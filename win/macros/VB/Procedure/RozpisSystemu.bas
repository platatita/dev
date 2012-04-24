Attribute VB_Name = "RozpisSystemu"
Option Explicit
Option Base 1

Dim KolumnaPocz As Long, WierszPocz As Long
' D³ugoœæ systemu np. 5 liczb.
Dim DlSys As Byte

Dim TabPobLiczb() As Long
Dim TabRobocza() As Long

Sub RozpisSystemu()

'Program ten rozpisuje w arkuszu EXCEL-a pe³n¹ kombinacje liczb o podanej
'd³ugoœci i od podanego miejsca w arkuszu. Najpierw program musi pobraæ liczby
'z zaznaczonego miejsca w arkuszu(liczby te mog¹ byæ dowolnej wielkoœci ale
'musz¹ sie znajdowaæ w jednym wierszu) w nastepnym kroku u¿ytkownik podaje d³ugoœæ
'rozpisywanego ci¹gu, a w ostatnim kroku u¿ytkownik musi zaznaczyæ miejsce w arkuszu
'(czyli komórkê) od którego ma nast¹piæ rozpisywanie i wstawianie liczb do kolejnych
'komórek.


Dim kom As String, kom1 As String, Tytul As String
Dim Obszar1 As Range, Obszar2 As Range
Dim kolumny1 As Long


Tytul = "Rozpisanie szczêœliwego systemu"

kom = "Zaznacz komórki z podanymi liczbami, które" & Chr(13)
kom = kom & "zostan¹ rozpisane w systemie." & Chr(13) & Chr(13)

'
Set Obszar1 = Application.InputBox(prompt:=kom, Title:=Tytul, Left:=100, Top:=100, Type:=8)

kolumny1 = Obszar1.Columns.Count


'PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
    
    '
    Call PobranieLiczb(kolumny1, Obszar1)

'PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP




kom1 = "Podaj na ile liczb ma zostaæ rozpisany system?" & Chr(13)
DlSys = InputBox(kom1, Tytul, 5)


'WsPuPocz -zmienna ta ma przechowywæ wspó³¿êdne zaznaczonej komórki.
Dim WsPuPocz As Range
Dim kom2 As String


kom2 = "Zaznacz komórkê, w której ma siê rozpocz¹æ rozpisywanie."

'
Set WsPuPocz = Application.InputBox(prompt:=kom2, Title:=Tytul, Type:=8)

' wspó³¿êdne punktu pocz¹tkowego.
KolumnaPocz = WsPuPocz.Column
WierszPocz = WsPuPocz.Row


'PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
    
    '
    Call KombinacjeSystemu(kolumny1)
    
'PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP



End Sub

Private Sub PobranieLiczb(kolumny1, Obszar1)

'

Dim i1 As Long

ReDim TabPobLiczb(kolumny1)


    
    For i1 = 1 To kolumny1
        
        TabPobLiczb(i1) = Obszar1(i1)
       
    Next i1


End Sub

Private Sub KombinacjeSystemu(kolumny1)

'

Dim i1 As Long, i As Long
Dim KonPetli As Integer, pozycja As Integer
Dim WejscieDoPetli As Boolean

'
Dim Flagi() As Long


' Ustawia rozmiar tablicy, równy d³ugoœci ci¹gu.
ReDim TabRobocza(DlSys)
ReDim Flagi(DlSys)


WejscieDoPetli = False


    For i = 1 To DlSys
        
        TabRobocza(i) = i
        
    Next i
    
    
'PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP

    '
    Call Wypelnianie_Komorek

'PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP

    
    pozycja = DlSys
    KonPetli = kolumny1 - DlSys + 1
    
petla:

Do While TabRobocza(1) < KonPetli
    
    TabRobocza(pozycja) = TabRobocza(pozycja) + 1
    
    If TabRobocza(pozycja) = (pozycja + kolumny1 - DlSys) Then Flagi(pozycja) = 1: _
        pozycja = pozycja - 1: WejscieDoPetli = True: Call Wypelnianie_Komorek: GoTo petla
    
    
    If WejscieDoPetli = True Then
        
        
        For i1 = 1 To DlSys
        
            If Flagi(i1) = 1 Then Flagi(i1) = 0: pozycja = pozycja + 1: _
                      TabRobocza(i1) = TabRobocza(i1 - 1) + 1
        
        Next i1
    
    
        WejscieDoPetli = False
    
    End If
    
    
    '
    Call Wypelnianie_Komorek
    
Loop


End Sub

Private Sub Wypelnianie_Komorek()

'
Dim i As Integer


For i = 1 To DlSys
    
    If i = 1 Then
        Range(Cells(WierszPocz, KolumnaPocz), Cells(WierszPocz, KolumnaPocz)) = TabPobLiczb(TabRobocza(i))
    Else
        Range(Cells(WierszPocz, KolumnaPocz + (i - 1)), Cells(WierszPocz, KolumnaPocz + (i - 1))) = TabPobLiczb(TabRobocza(i))
    End If
    
Next i


WierszPocz = WierszPocz + 1


End Sub
