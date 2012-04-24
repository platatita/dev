Attribute VB_Name = "Parse_Text_Lotto"
Option Explicit


' Funkcja WinApi - odlicza milisekundy od otwarcia systemu.
Public Declare Function GetTickCount Lib "kernel32" () As Long

'
'deklaracja globalnej zmiennej
Private tytul As String


Public Sub Parse_Text_Lotto()
    '
    'Program ten s³u¿y do parsowania tekstu, czyli rozbijania na poszczególne litery lub ci¹gi znaków.
    'W obecnej postaci jest on przystosowany do wyszukiwania liczb, numerów losowañ i dat losowañ
    'w pobranych z internetu tekstach. Program ten dzia³a na zasadzie rozpoznawania, która litera w
    'przeszukiwanym ci¹gu znaków jest typu numerycznego. Je¿eli miêdzy znalezionymi liczbami nie
    'wystepuje ¿aden separator(czyli inny znak od cyfry) oprócz separatorów zadeklarowanych traktuje ten
    'ci¹g tekstowy jako jedn¹ liczbê. Nastepnie ka¿d¹ rozpoznan¹ liczbê czy te¿ datê w tekscie dodaje
    'do listy, która to w jedny cyklu(jedny obrocie pêtli) zawiera rozbity tekst. Tak wype³niona list jest
    'przekazywana do wpisania w komórki od miejsca wczeœniej wskazanego. I tak wkó³ko a¿ do przeszukania
    'ca³ego zaznaczonego tekstu.
    '
    
    'deklaracja lokalnych zmiennych
    Dim znaki
    Dim i As Long, j As Long
    Dim parse_text As String
    Dim past_range As Range
    Dim search_range As Range
    Dim al As New ArrayList
    Dim odp As Byte
    Dim czas1 As Long, czas2 As Long, czas As Single
    
    
    '
    tytul = "Parse Text"
    '
    'zapisywanie do zmiennej separatorów akceptowanych przez program
    znaki = Array("-")
    
    
    '
    'pobieranie do zmiennej zaznaczonego obszaru przeszukiwañ
    Set search_range = Application.InputBox( _
        prompt:="Zaznacz obszar w którym maj¹ zostaæ podzielone i posortowane dane:", _
        Title:=tytul, _
        Type:=8)
    '
    'pobieranie do zmiennej obszaru od którego ma nast¹piæ wpisywanie rozbitego tekstu
    Set past_range = Application.InputBox( _
        prompt:="Zaznacz komórkê od której zostan¹ wstawione dane:", _
        Title:=tytul, _
        Type:=8)
        
    '
    odp = MsgBox("Chcesz przyœpieszyæ dzia³anie programu?", _
                    vbInformation + vbYesNo + vbDefaultButton1, tytul)
    '
    If odp = vbYes Then
        Application.ScreenUpdating = False 'wy³¹czanie odœwie¿ania ekranu na czas dzia³ania programu
    End If
    
    
    
    
    'pobranie czasu rozpoczêcia dzia³ania programu
    czas1 = GetTickCount
    
    
    '
    'g³ówna pêtla programu
    For i = 1 To search_range.Rows.Count 'liczba wierszy w zaznaczonym obszarze
        '
        For j = 1 To search_range.Columns.Count 'liczba kolumn w zaznaczonym obszarze
        
            'pobieranie do zmiennej zawartoœci komórki wskazanej przez zmienne i, j
            'z zaznczonego obszaru przeszukiwañ
            parse_text = search_range(i, j)
            
            'sprawdzanie czy komórk jest pusta, je¿eli tak to j¹ pomija w przeszukiwaniu
            If parse_text <> "" Then
                'wywo³ywanie funkcij rozbijaj¹cej tekst i zapisuj¹cej poszczególne liczby do list
                Call ParseText(znaki, parse_text, al)
                'wywo³ywanie procedury sortuj¹cej zawartoœæ listy
                Call al.Sort1(2, al.Get_Count)
                'wywo³. procedury wpisuj¹cej zawartoœæ list w poszczególne komórki
                Call PastText(i, al, past_range)
                'czyszczenie listy
                al.Clear
            End If
            
        Next j
        
        '
        DoEvents

    Next i
    
    
    ''pobranie czasu rozpoczêcia dzia³ania programu
    czas2 = GetTickCount
    'obliczenia ró¿nicy. Ró¿nicê nale¿y podzieliæ przez 1000 poniewa¿ czas jest mierzony w milisekundach
    czas = ((czas2 - czas1) / 1000)
    
    
    '
    If odp = vbYes Then
        Application.ScreenUpdating = True 'w³¹czenie odœwie¿ania ekranu
    End If
    
    
    
    'wyœwietlenie koñcowego komunikatu i czasu dzia³ania programu
    MsgBox "Koniec. Czas dzia³ania - " & czas & " s", vbInformation + vbOKOnly + vbDefaultButton1, tytul
    
    
    '
    'koniec
    '
        
End Sub

Private Function ParseText(ByVal zns, ByVal text As String, ByRef all As ArrayList) As Boolean
    '
    Dim nr As String, z As String
    Dim isnr As Boolean
    Dim i As Integer
    
    '
    isnr = False
    
    '
    For i = 1 To Len(text)
        '
        z = Mid(text, i, 1)
        
        '
        If IsNumeric(z) Or TestChars(zns, z) Then
            '
            isnr = True
            '
            nr = nr + z
        Else
            '
            If isnr Then
                '
                all.Add = nr
                '
                nr = ""
                isnr = False
                
            End If
            
        End If
        
    Next i

    
End Function

Private Function TestChars(ByVal znss, ByVal zn As String) As Boolean
    '
    Dim i As Integer
    
    '
    For i = 0 To UBound(znss)
        '
        If zn = znss(i) Then
            '
            TestChars = True
            '
            Exit Function
            
        End If
    
    Next i
    
    '
    TestChars = False

End Function

Private Sub PastText(ByVal row As Long, ByVal all As ArrayList, ByRef prg As Range)
    '
    Dim i As Integer
    
    '
    For i = 0 To all.Get_Count
        '
        prg(row, i + 1) = all.Get_Data(i)
    
    Next i
    
End Sub
