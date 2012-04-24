Attribute VB_Name = "Usuwanie_Wierszy"
Option Explicit
Option Base 1


' w³asny typ, który ma przechowywaæ nr. kolumn, nr. wiersza, liczbê wierszy
' i liczbê kolumn z zaznaczonych obszarów.
Private Type NewType1

    NrWier As Long
    NrKolum As Long
    LiWier As Long
    LiKolum As Long
    
End Type


' ObszarGl - zmienna ta przechowuje wszystkie w³aœciwoœci i parametry
' zaznaczonego g³ównego obszaru w którym bêdzie siê odbywa³o przenoszenie wartoœci
' komórek i usuwanie pustych wierszy.
Dim ObszarGl As Range
'parametr(1) - obszar g³ówny, parametr(2)- parametry wiersza pierwszego(rozpoczynaj¹cego)
Dim Parametry() As NewType1


'
Dim tytul As String



Public Sub Usuwanie_Wierszy()

' Procedura ta usuwa puste wiersze w zaznaczonym obszarze po przeniesieniu
' zawartoœci wierszy do jednego g³ównego.

Dim suma As Long, i As Long, i2 As Long
Dim usun As String
Dim PustaKom As Boolean
' Zmienna ta przechwujê liczbe usuniêtych wierszy z zaznaczonego obszaru.
Dim LUW As Long

'
tytul = "Usuwanie wierszy"


    '
    Call Obszar_glowny


'
PustaKom = False
suma = 0
usun = ""
i = 0
i2 = 0
LUW = 0


' G³ówna pêtla usuwaj¹ca puste wiersze.
Do While (i < Parametry(1).LiWier)
    
    '
    i = i + 1
    suma = suma + 1
    ' zerowanie zmiennych wskazuj¹cych na brak zawartoœci w komórkach.
    PustaKom = False

    '
    For i2 = 1 To Parametry(1).LiKolum 'liczba kolumn w obszarze g³ównym
    
            If IsEmpty(ObszarGl.Cells(suma, i2)) = True Then
                PustaKom = True
            Else
                PustaKom = False
            End If

    Next i2

    '
    If PustaKom = True Then
    
        usun = CStr((suma + Parametry(1).NrWier - 1)) & ":" & CStr((suma + Parametry(1).NrWier - 1))
        Range(usun).EntireRow.Delete
        '
        suma = suma - 1
        LUW = LUW + 1
    End If
    
    '
    DoEvents
    
Loop


    '
    MsgBox "Usuniêto - " & LUW & " - wierszy z zaznaczonego obszaru - " & Parametry(1).LiWier & " - wierszy.", vbInformation, tytul


End Sub


Private Sub Obszar_glowny()

' W tej procedurze zostaje zaznaczony g³ówny obszar przez u¿ytkownika
' i zostaj¹ pobrane jego parametry do tablicy Parametry(), która to przechowuje
' w³aœciwoœci wszystkich zaznaczonych obszarów.

Dim kom As String

'
kom = "Zaznacz obszar, w którym chcesz usun¹æ puste wiersze?"
'
Set ObszarGl = Application.InputBox(prompt:=kom, Title:=tytul, Left:=450, _
                                    Top:=450, Type:=8)



' ustawianie wstêpnego rozmiaru tablicy Parametry().
ReDim Parametry(1)


' pobieranie parametrów obszaru g³ównego.
Parametry(1).LiKolum = ObszarGl.Columns.Count
Parametry(1).LiWier = ObszarGl.Rows.Count
Parametry(1).NrKolum = ObszarGl.Column
Parametry(1).NrWier = ObszarGl.Row



End Sub

