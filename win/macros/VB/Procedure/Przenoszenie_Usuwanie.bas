Attribute VB_Name = "Przenoszenie_Usuwanie"
Option Explicit
Option Base 1


' Funkcja WinApi - odlicza milisekundy od otwarcia systemu.
Public Declare Function GetTickCount Lib "kernel32" () As Long


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
' obszar(1)- zaznaczony wiersz 1 i tak az do ostatniego, a ostatni obszar(n) w tablicy
' zawiera zawsze obszar ostatnie zaznaczonej kolumny w wierszu g³ównym.
Dim Obszar() As Range
'parametr(1) - obszar g³ówny, parametr(2)- parametry wiersza pierwszego(rozpoczynaj¹cego)
Dim Parametry() As NewType1


'
Dim tytul As String
' OdsWierszy - jest zmienn¹ przechowuj¹c¹ liczbê wierszy dziel¹cych wiersze g³ówne.
'   Np: co 4 - wiersz jest wierszem g³ównym, do któego przenoszone s¹ wartoœci.
' LiWiPrzen - jest zmienn¹ przechowuj¹c¹ liczbê wierszy któr¹ u¿ytkownik podaje,
'   ¿e chce je przeniœæ. Nastêpnie musi je zaznaczyæ i w takiej kolejnoœci jak je zaznaczy
'   bêd¹ one przenoszone.
Dim PunktX As Integer, PunktY As Integer, OdsWierszy As Integer, LiWiPrzen As Integer
' odpowidz dotycz¹ca usuniêcia pustych wierszy.
Dim odp As Long
' czas2 - zmienna ta przechwytuje czas zakoñczenia dzia³ania programu.
Dim czas2 As Long
'
Dim szybko As Boolean


'***************************************************************************************

Public Sub Przenoszenie_Usuwanie()

' Program ten ma za zadanie przenieœæ zawartoœæ wierszy znajduj¹cych siê pod
' wierszem g³ównym. u¿ytkownik musi najpierw zaznaczyæ obszar g³ówny w jaki ma byæ
' wykonywany progarm, a nastêpnie musi podaæ co ile wierszy znajduje siê wiersz
' g³ówny(wiersz do którego s¹ przenoszone zawartoœci komórek z wierszy znajduj¹cych
' siê poni¿ej). Nastêpnie podaje ile wierszy ma byæ za ka¿dym razem przeniesionych.
' W czwartym kroku u¿ytkownik zaznacza zadeklarowan¹ wczeœniej liczbê wierszy pojedynczo.
' Ostatni krok s³u¿y do wskazania ostatnij kolumny wiersza g³ównego, po której to kolumnie
' nast¹pi wstawianie zawartoœci komórek. Odstêpy pomiêdzy wierszami g³ównymi musz¹
' byæ takie same aby program zadzia³a³ poprawnie.

Dim czas1 As Long
Dim WynikCzas As Long
Dim CzasDzialania As Variant


'
tytul = "Przenoszeni i usuwanie pustych wierszy."
PunktX = 450
PunktY = 100


'PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
    
    '  wywo³ywanie procedury
    Call Obszar_glowny

'PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP

'PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP

    ' wywo³ywanie procedury
    Call Obszary
    
'PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP


                      ' wy³¹czenie funkcji wyœwietlaj¹cej informacje postêpie wykonywania
                      ' programu, w celu przyœpieszenia dzia³ania programu.
If szybko = True Then Application.ScreenUpdating = False


' pobranie czasu wejœcia do g³ównego Ÿród³a programu.
czas1 = GetTickCount

'PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
    
    '  wywo³ywanie procedury
    Call Przenoszenie

'PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP


' obliczenie ró¿nicy w czasie dzia³ania programu.
WynikCzas = ((czas2 - czas1) / 1000)

' przekszta³cenie wyniku w czas mgodzin, minut, sekund.
CzasDzialania = TimeSerial(0, 0, WynikCzas)


                      ' ponowne w³¹czenie funkcji.
If szybko = True Then Application.ScreenUpdating = True



    ' wyœwietlanie komunikatu zakoñczenia pracy
    MsgBox "Koniec dzia³ania programu. Czas dzia³ania wynosi - " & CzasDzialania, vbInformation, tytul
    

End Sub

Private Sub Przenoszenie()

' Procedura ta przenosi zawartoœæ zaznaczonych wierszy w zaznaczonym
' g³ównym obszarze do g³ównegwiersza znajduj¹cego siê co zmienna "OdsWierszy"

'
Dim i1 As Integer, i2 As Integer, Dodatek As Integer, Przes As Integer, w As Integer
Dim p As Long, LKwstaw As Integer
Dim k1 As Integer, k2 As Integer
Dim kp1 As Integer, kp2 As Integer, w1 As Long


'
Dodatek = 0
Przes = 0
w = 0
p = 1
LKwstaw = 0


'
For i1 = 1 To Parametry(1).LiWier ' liczba wierszy w obszarze g³ównym.


    '
    If i1 = (Parametry(LiWiPrzen + 2).NrWier - Parametry(1).NrWier) + Dodatek + 1 Then
        
        Dodatek = Dodatek + 1
        Przes = Przes + 1
        
        ' ustawianie parametrów wierszy i kolumn do zaznaczenie
        w = Parametry(Przes + 1).NrWier - Parametry(1).NrWier + p
        k1 = Parametry(Przes + 1).NrKolum - Parametry(1).NrKolum + 1
        k2 = Parametry(Przes + 1).LiKolum + Parametry(Przes + 1).NrKolum - Parametry(1).NrKolum
        
        ' zaznaczanie wierszy do przeniesienie wed³ug zaznaczonego g³ównego obszaru
        ObszarGl.Range(Cells(w, k1), Cells(w, k2)).Select
       
       '------------------------------------------------------------------------------------
       
       ' ustawianie parametrów wierszy i kolumn zaznaczonych przeznaczonych
       ' do przeniesienia.
       w1 = Parametry(LiWiPrzen + 2).NrWier + p - 1
       kp1 = Parametry(LiWiPrzen + 2).NrKolum + LKwstaw + 1
       kp2 = Parametry(LiWiPrzen + 2).NrKolum + Parametry(Przes + 1).LiKolum + LKwstaw
       
        ' przenoszenie zaznaczonego wiersza do wskazanego miejsca.
        Selection.Cut Destination:=Range(Cells(w1, kp1), Cells(w1, kp2))
                
       '------------------------------------------------------------------------------------
        
        ' ustawianie nowej kolumny do wstawiania zawartoœci wierszy. Kolumna pierwsza
        ' i ostatnia zwiêksza siê za ka¿dym razem o liczbê kolumn, które zosta³y wstawione
        ' z wierszy zaznaczonych przez u¿ytkownika.
        LKwstaw = LKwstaw + Parametry(Przes + 1).LiKolum
        
        '
        If Przes = LiWiPrzen Then
            Dodatek = (CInt(OdsWierszy) + Dodatek) - LiWiPrzen
            Przes = 0
            p = p + CInt(OdsWierszy)
            LKwstaw = 0
        End If
        
    
    End If

    '
    DoEvents
    
Next i1

'---------------------------------------------------------------------------------

' zapisanie czasu zakoñczenia dzia³ania programu.
czas2 = GetTickCount

If odp = 6 Then

    'PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
        
        ' wywo³ywanie procedury usuwaj¹cej puste wiersze w zaznaczonym obszarze.
        Call UsuwanieWierszy
    
    'PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP

End If


End Sub

Private Sub UsuwanieWierszy()

' Procedura ta usuwa puste wiersze w zaznaczonym obszarze po przeniesieniu
' zawartoœci wierszy do jednego g³ównego.

Dim suma As Long, i As Long, i2 As Long
Dim usun As String
Dim PustaKom As Boolean
' Zmienna ta przechwujê liczbe usuniêtych wierszy z zaznaczonego obszaru.
Dim LUW As Long


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
        'ObszarGl.Range(usun).EntireRow.Delete
        suma = suma - 1
        LUW = LUW + 1
    End If
    
    '
    DoEvents
    
Loop

' zapisanie czasu zakoñczenia dzia³ania programu.
czas2 = GetTickCount

    '
    MsgBox "Usuniêto - " & LUW & " - wierszy z zaznaczonego obszaru - " & Parametry(1).LiWier & " - wierszy.", vbInformation, tytul


End Sub

Private Sub Obszar_glowny()

' W tej procedurze zostaje zaznaczony g³ówny obszar przez u¿ytkownika
' i zostaj¹ pobrane jego parametry do tablicy Parametry(), która to przechowuje
' w³aœciwoœci wszystkich zaznaczonych obszarów.

Dim kom As String

'
kom = "Zaznacz obszar, w którym chcesz uszeregowaæ wartoœci komórek?"
'
Set ObszarGl = Application.InputBox(prompt:=kom, Title:=tytul, Left:=PunktX, _
                                    Top:=PunktY, Type:=8)



' ustawianie wstêpnego rozmiaru tablicy Parametry().
ReDim Parametry(1)


' pobieranie parametrów obszaru g³ównego.
Parametry(1).LiKolum = ObszarGl.Columns.Count
Parametry(1).LiWier = ObszarGl.Rows.Count
Parametry(1).NrKolum = ObszarGl.Column
Parametry(1).NrWier = ObszarGl.Row


' ustawianie rozmiaru tablicy na liczbê zaznaczonych wierszy w obszarze g³ównym.
ReDim TabPustWier(Parametry(1).LiWier)


End Sub

Private Sub Obszary()

' Zaznaczanie wierszy zadeklarowanych przez u¿ytkownika i pobranie ich w³aœciwoœci
' do tablicy Parametry().

Dim kom1 As String, kom2 As String
Dim i As Integer


'
LiWiPrzen = 0
OdsWierszy = 0

'
kom2 = "Podaj co ile wierszy znajduje siê wiersz g³ówny?"
' pobieranie od u¿ytkownika liczby wierszy do przeniesienia.
OdsWierszy = InputBox(kom2, tytul, 5, PunktX + 8500, PunktY + 3500)

'
kom2 = "Podaj ile wierszy chcesz przenieœæ?"
' pobieranie od u¿ytkownika liczby wierszy do przeniesienia.
LiWiPrzen = InputBox(kom2, tytul, 3, PunktX + 8500, PunktY + 3500)


' ustawianie rozmiaru tablicy.
ReDim Obszar(LiWiPrzen + 1)
ReDim Preserve Parametry(LiWiPrzen + 2)

'
For i = 1 To LiWiPrzen + 1
    
    If i = (LiWiPrzen + 1) Then
        '
        kom1 = "Zaznacz ostatni¹ kolumnê wiersza, po którego ma siê " & Chr(10)
        kom1 = kom1 & "rozpocz¹æ wstawienie zawartoœci komórek z wierszy " & Chr(10)
        kom1 = kom1 & "znajduj¹cych siê poni¿ej?" & Chr(10)
    Else
        '
        kom1 = "Zaznacz " & i & " wiersz, który ma byæ przeniesiony."
    End If
    
    
    Set Obszar(i) = Application.InputBox(prompt:=kom1, Title:=tytul, _
                                        Left:=PunktX, Top:=PunktY + 10 + (i * 10), Type:=8)
    
    ' pobieranie do tablicy parametrów poszczególnych obszarów zaznaczonych
    ' przez u¿ytkownika.
    Parametry(i + 1).LiKolum = Obszar(i).Columns.Count
    Parametry(i + 1).LiWier = Obszar(i).Rows.Count
    Parametry(i + 1).NrKolum = Obszar(i).Column
    Parametry(i + 1).NrWier = Obszar(i).Row
        
Next i

odp = MsgBox("Chcesz przyœpieszyæ dzia³anie programu?", _
                    vbInformation + vbYesNo + vbDefaultButton1, tytul)
If odp = 6 Then
    szybko = True
Else
    szybko = False
End If

'
odp = MsgBox("Czy chcesz usun¹æ puste wiersze z zaznaczonego obszaru?", _
                    vbInformation + vbYesNo + vbDefaultButton1, tytul)


End Sub

'***************************************************************************************
