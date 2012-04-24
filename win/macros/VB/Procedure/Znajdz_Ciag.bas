Attribute VB_Name = "Znajdz_Ciag"
Option Explicit
Option Base 1


Dim tytul As String
Dim WejscieZPetli As Boolean
Dim P As Long
Dim zakres As Range
Dim Wiersze As Long, Kolumny As Long
Dim Razy As Integer
Dim SciezkaZapisu As String


' DlugoscCiagu - liczba cyfr, z których bêdzie sk³ada³ siê ci¹g liczbowy
' np: 10 oznacza, ¿e ci¹g bêdzie sk³ada³ siê z 10 liczb(1,2,3,4,5,6,7,8,9,10).
Const DlugoscCiagu = 3
' maxNumer - zmienna ta zawiera liczbê cyfr do kombinacji ci¹gów
' np: 15 oznacza, ¿e kombinacja bêdzie tworzona z 15 liczb(1-15).
Const maxNumer = 80


' Tablica zawieraj¹ca liczbê cyfr z których bêdzie sk³ada³ siê ci¹g liczbowy.
Dim InTablica() As Integer
' Tablica flagi ma sygnalizowaæ która liczba osi¹gne³a maxNumer i przejœæ do
' pozycji wczeœniejszej, aby jej wartoœæ zwiêkszyæ o jeden.
Dim Flagi() As Integer


Public Sub Znajdz_Ciag()

' Procedur ta ma za zadanie przeszukaæ zaznaczony fragmêt tabeli i zlicyæ ile razy
' wystepuje w niej dany ci¹g liczbowy.

'
tytul = "Inicjalizacja"


'PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP

        ' wywo³uje procedurê SprawdzenieZaznaczenia()
        Call SprawdzenieZaznaczenia

'PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP


'PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP

        ' wywo³uje procedurê TworzPlik()
        Call TworzPlik

'PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP


Load UserForm1
UserForm1.Show


'--------------------------------------------------------------------------------------

Dim i As Integer, pozycja As Integer
Dim EndPetli As Integer


'
WejscieZPetli = False


' Ustawianie rozmiaru tablicy
ReDim InTablica(DlugoscCiagu) As Integer
' Ustawianie rozmiaru tablicy
ReDim Flagi(DlugoscCiagu) As Integer


' Pierwsze wype³nianie tablic Flagi i InTablica. Elementy tablicy Flagi s¹ ustawiane
' na "0" a elementy tablicy InTablica na 1,2...
    For i = 1 To DlugoscCiagu
               
        InTablica(i) = i
        Flagi(i) = 0
    
    Next i
    
    
            ' Tu wstaw odwo³anie do szukania SzukajPodanegoCiagu
            ' wywo³uje procedurê SzukajPodanegoCiagu()
            Call SzukajPodanegoCiagu

    ' pozycja - zmienna ta ustawia w którym miejscu(na którym elemencie tablicy "InTablica")
    ' ma siê rozpocz¹æ praca pêtli.
    pozycja = DlugoscCiagu
    
    ' EndPetli - zmienna ta sugnalizuje kiedy ma siê zakonczyæ wykonywanie pêtli.
    EndPetli = maxNumer - pozycja + 1
    
    
petla:

    Do While InTablica(1) < EndPetli
    
        ' zwiêksza wartoœc danego elementu tablicy o jeden "1".
        InTablica(pozycja) = InTablica(pozycja) + 1
                
        If InTablica(pozycja) = (maxNumer + pozycja - (DlugoscCiagu)) Then Flagi(pozycja) = 1: _
                pozycja = pozycja - 1: WejscieZPetli = True: Call SzukajPodanegoCiagu: GoTo petla ': Call SzukajPodanegoCiagu
        
        
        
        If WejscieZPetli = True Then
        
            For i = 1 To DlugoscCiagu
                         
              If Flagi(i) = 1 Then Flagi(i) = 0: pozycja = pozycja + 1: _
                      InTablica(i) = InTablica(i - 1) + 1
                      
            Next i
        
            WejscieZPetli = False
        
        End If
        
            ' Tu wstaw odwo³anie do szukania SzukajPodanegoCiagu
            ' wywo³uje procedurê SzukajPodanegoCiagu()
            Call SzukajPodanegoCiagu
            
            DoEvents

    Loop

' Zatrzymanie wykonywania programu.
Stop


Dim Odp As Integer

Odp = msgbox("Koniec programu" & "  " & P, vbInformation, tytul)


End Sub

Private Sub SzukajPodanegoCiagu()

' Przeszukiwanie tablicy zaznaczon¹ tablicê szukaj¹æ danego ci¹gu.

Dim i1 As Long, i2 As Long, i As Byte
Dim ciag As Byte


P = P + 1: UserForm1.Label1.Caption = P

For i1 = 1 To Wiersze

    For i2 = 1 To Kolumny


            For i = 1 To DlugoscCiagu
                
                If zakres(i1, i2) = InTablica(i) Then ciag = ciag + 1
                If ciag = 0 And i2 > (Kolumny - DlugoscCiagu) Then GoTo line1
                If zakres(i1, 1) > InTablica(1) Then GoTo line1
                
            Next i
                        
    
    Next i2

line1:

    
    If ciag = DlugoscCiagu Then Razy = Razy + 1
    
    ciag = 0
    
Next i1


    'PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
    
            ' wywo³uje procedurê Zapisywanie()
            Call Zapisywanie
    
    'PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP

End Sub

Private Sub Zapisywanie()

' Procedura ta zapisuje wynik do pliku tekstowego.

Dim LiczbaIni As String, LiczbaIni1 As String

Dim FSO As New FileSystemObject
Dim texktStream As TextStream
Dim TextFile As File
Dim i As Byte

Set TextFile = FSO.GetFile(SciezkaZapisu)

Set texktStream = TextFile.OpenAsTextStream(ForAppending)


For i = 1 To DlugoscCiagu

    LiczbaIni = LiczbaIni & CStr(InTablica(i)) & ", "
    
Next i


If Razy < DlugoscCiagu Then Razy = 0

LiczbaIni1 = LiczbaIni & "  " & " =  " & Razy & " razy"

' zapisywanie do pliku tekstowego wyniku szukania.
texktStream.WriteLine CStr(LiczbaIni1)


' zamykanie pliku *.txt
texktStream.Close

End Sub

Private Sub SprawdzenieZaznaczenia()

' Procedura ta sprawdza, czy zosta³ zaznaczony obszar do przeszukania,
' je¿eli tak to pobiera jego rozmiary.

Dim Odp As Integer
Dim komunikat As String, KomunikatInput As String



    ' Sprawdzanie, czy zosta³ zaznaczony jakiœ obszar. Je¿eli nie to ostrze¿eni
    ' albo koniec programu.
    If IsArray(Selection) Then
        
        ' Przypisanie zmiennej zakres w³aœciwoœci Range, czyli zaznaczonego obszaru.
        Set zakres = Selection
        
    Else
        
        
        komunikat = "Zaznacz obszar, który chcesz przeszukiwaæ." & Chr(13) & Chr(13)
        komunikat = komunikat & "Chcesz teraz zaznaczyæ ten obszar?" & Chr(13) & Chr(13)

        Odp = msgbox(komunikat, vbExclamation + vbYesNo, tytul)
        
            If Odp = vbYes Then
                
                KomunikatInput = "Zaznacz obszar, który ma zostaæ przeszukany"

                ' Przypisanie zmiennej zakres w³aœciwoœci Range, czyli zaznaczonego obszaru.
                Set zakres = Application.InputBox(prompt:=KomunikatInput, Title:=tytul, Type:=8)
                
            ElseIf Odp = vbNo Then
                
                End
                
            End If
        
    
    End If



Wiersze = zakres.Rows.Count
Kolumny = zakres.Columns.Count


End Sub

Private Sub TworzPlik()

' Procedura ta ma zadanie utworzyæ plik tekstowy je¿eli jeszcze  nie istnieje.

Dim FSO As New FileSystemObject
Dim txtStream As TextStream
Dim CzyIstniejPlik  As Boolean, CzyIstniejPlikRand As Boolean
Dim LiczbaRandomize  As Integer, SciezkaZapisuRand As String

Dim DlSciezki As Integer
Dim i As Integer


' Ustawienie wartoœæ pocz¹tkowych
CzyIstniejPlikRand = False
CzyIstniejPlik = False


' Scie¿ka dostêpu do pliku i jego zapisu.
SciezkaZapisu = "C:\Mój szukaj\Mój Szukaj.txt"

    
    CzyIstniejPlik = FSO.FileExists(SciezkaZapisu)

    If CzyIstniejPlik = False Then
    
            ' Tworzenie pliku tekstowego o podanej nazwie i w podanym miejscu.
            Set txtStream = FSO.CreateTextFile(SciezkaZapisu, False)
            
            
            ' zamykanie pliku tekstowego
            txtStream.Close
            
    ElseIf CzyIstniejPlik = True Then

            Dim NrPliku As Integer
            NrPliku = 1000
            
            DlSciezki = Len(SciezkaZapisu) - 4
            
            SciezkaZapisuRand = Left(SciezkaZapisu, DlSciezki)
            
            
            For i = 1 To NrPliku
                
                
                    LiczbaRandomize = i
                    
                    SciezkaZapisuRand = SciezkaZapisuRand & CStr(LiczbaRandomize) & ".txt"
                    
                    ' Sprawdzanie, czy jstnieje nastêpuj¹cy plik.
                    CzyIstniejPlikRand = FSO.FileExists(SciezkaZapisuRand)
                    
                    
                    ' Je¿eli tak!
                    If CzyIstniejPlikRand = True Then
                        
                        SciezkaZapisuRand = Left(SciezkaZapisu, DlSciezki)

                        GoTo line1
                    ' Je¿eli nie!
                    Else
                        
                        SciezkaZapisu = SciezkaZapisuRand
                        
                        Exit For
                    
                    End If
line1:
                    
            Next i
                 
            ' Je¿eli wyst¹pi b³¹d to program przechodzi do nastêpnej lini.
            On Error Resume Next
            
            ' Tworzenie pliku tekstowego o podanej nazwie i w podanym miejscu.
            Set txtStream = FSO.CreateTextFile(SciezkaZapisu, False)
            
            ' Odczytywanie kodu b³êdu.
            If Err.Number = 58 Then
                
                Dim KomunikatError As String
                
                    KomunikatError = "Nie mo¿na utworzyæ nowego pliku tekstowego, poniewa¿" & Chr(13)
                    KomunikatError = KomunikatError & "utworzy³eœ ich ju¿ ponad  " & NrPliku & "  w tym folderze" & Chr(13)
                    KomunikatError = KomunikatError & "i musisz zmieniæ folder lub usun¹æ niktóre pliki tekstowe," & Chr(13)
                    KomunikatError = KomunikatError & "aby rozpocz¹æ zapisywanie danych do pliku. " & Chr(13) & Chr(13) & Chr(13)
                
                    msgbox KomunikatError, vbExclamation, tytul
                    
                    End
            End If
            
            
            ' zamykanie pliku tekstowego
            txtStream.Close
   
    
    End If


End Sub
