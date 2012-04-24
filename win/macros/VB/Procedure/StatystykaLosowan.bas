Attribute VB_Name = "StatystykaLosowan"
Option Base 1
Option Explicit


Dim Tytul As String
Dim Wiersze As Long, Kolumny As Long
Dim Cykl As Byte
Dim NrWier As Long, NrKolum As Long
Dim NameNewSheet As String
Dim Dzien As String
Dim Zapis As Long
Dim LiczbaZ As Long


Dim TabPobrana() As Long
Dim TabZakresowa() As Integer
Dim TabWyniki() As Long

Dim GZTab As Integer


Sub StatystykaLosowan()

' G³ówna procedura tego programu. Od tegeo miejsca zaczyna siê dzia³anie programu.
' Zadaniem tego programu jest przeanalizowanie danych wprowadzonych przez urzytkownika
' wed³ug podanych kryteriów. Za przyk³ad mog¹ tutaj pos³u¿yæ wylosowane liczby w
' MULTILOTKU. Program ten ma pobraæ w pierwszej kolejnoœci liczby z zaznaczonego obszaru
' w arkuszu EXCEL-a do tablicy programowej "TabPobrana" i w niej rozpocz¹æ przeszukiwanie.
' Kryteria wed³ug których ma siê rozpocz¹æ przeszukiwanie podaje urzytkownik np.
' Ile razy by³a losowana liczba 78, dwa dni po wczeœniej wylosowanej liczbie 2.
' Program ten sprawdza t¹ zale¿noœæ dla wszystkich liczb z tablicy "TabZakresowa",
' a wyniki s¹ przechowywane w tablicy "TabWyniki" dla ka¿dej liczby i zapisywane w
' arkuszu EXCEL-a od mijsca podanego przez urzytkownika i w zadeklarowanym arkuszu.
' Kryteria te s¹ ustalane przez urzytkownika po uruchomieniu programu w sposób udzielania
' odpowiedzi na postawione pytanie przez program.



Tytul = "Statystyka liczbowa"


'PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
        
        '
        Call Pobieranie

'PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP


'PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
        
        '
        Call ZbieranieInfor

'PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP


'PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
        
        '
        Call Wype³nianieTabZakresowa

'PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP


'PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP

        '
        Call WypelnianieTabWyniki

'PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP


'PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP

        '
        Call Przeszukiwanie

'PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP


'
Zapis = 0

End Sub

Private Sub Pobieranie()

'Procedura ta jest wywo³ywana w g³ównej procedurze "StatystykaLosowan".
'Jej zadaniem jest pobranie liczb z zaznaczonego obszaru i przypisanie
'ich do poszczególnych elementów tablicy.


Dim kom As String
Dim PobObszar  As Range
Dim i1 As Long, i2 As Long



kom = "Zaznacz obszar z liczbami do przeszukiwania." & Chr(13)

'
Set PobObszar = Application.InputBox(prompt:=kom, Title:=Tytul, Type:=8)

Kolumny = PobObszar.Columns.Count
Wiersze = PobObszar.Rows.Count

ReDim TabPobrana(Wiersze, Kolumny)



For i1 = 1 To Wiersze
    
    For i2 = 1 To Kolumny
        
        TabPobrana(i1, i2) = PobObszar(i1, i2)
    
    Next i2

Next i1


End Sub

Private Sub Wype³nianieTabZakresowa()

'

Dim i1 As Byte

'
ReDim TabZakresowa(GZTab)


For i1 = 1 To GZTab

    TabZakresowa(i1) = i1
    
Next i1



End Sub

Private Sub WypelnianieTabWyniki()

'

Erase TabWyniki

ReDim TabWyniki(GZTab)


End Sub

Private Sub Przeszukiwanie()

'

Dim i As Integer, i1 As Long, i2 As Long



For i = 1 To GZTab

        For i1 = 1 To Wiersze
        
            For i2 = 1 To Kolumny
                    
                    
                If TabPobrana(i1, i2) = TabZakresowa(i) Then
                
                    LiczbaZ = LiczbaZ + 1
                
                'PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
                
                    '
                    Call Zliczanie(i1)
                
                'PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
                
                   
                End If
                
                
            Next i2
            
        Next i1
        
    
        'PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
        
            '
            Call ZapisywanieWynikow(i)
            
        'PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
        
        LiczbaZ = 0
Next i



MsgBox "Koniec dzia³ania programu", vbExclamation, Tytul


End Sub

Private Sub Zliczanie(i1)

'
Dim i3 As Long, i4 As Long


For i3 = 1 To Kolumny
    
    For i4 = 1 To GZTab
    
            If (i1 + Cykl) > Wiersze Then Exit Sub
            
            If TabPobrana(i1 + Cykl, i3) = TabZakresowa(i4) Then
                
                TabWyniki(i4) = TabWyniki(i4) + 1
                Exit For
                
            End If
    
    Next i4
    
Next i3


End Sub

Private Sub ZapisywanieWynikow(i)

'
Dim W1 As Long


Worksheets(NameNewSheet).Activate
Range(Cells(NrWier + Zapis, NrKolum), Cells(NrWier + Zapis, NrKolum + GZTab - 1)).Select


'PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP

        '
        Call FormatowanieKomorek

'PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP


'
Cells(NrWier + Zapis, NrKolum) = "   " & Cykl & " - " & Dzien & " po wylosowanej liczbie -  " & i & "  -  " & LiczbaZ & " razy"



'======================================================================================
' Pêtla wype³niaj¹ca komórki w podanym arkuszu.
For W1 = 0 To GZTab - 1
    
        Cells(NrWier + Zapis + 1, NrKolum + W1) = TabZakresowa(W1 + 1)
        Cells(NrWier + Zapis + 2, NrKolum + W1) = TabWyniki(W1 + 1)
                
Next W1
'======================================================================================


'PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP

        '
        Call FormatowanieKomorek2

'PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP


'
Zapis = Zapis + 4


'PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
    
    '
    Call WypelnianieTabWyniki
    
'PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP


DoEvents

End Sub

Private Sub FormatowanieKomorek()

'

    With Selection
        .ColumnWidth = 5
        .MergeCells = True
        .HorizontalAlignment = xlLeft
    End With
    
    With Selection.Interior
        .ColorIndex = 35
        .Pattern = xlSolid
    End With

    With Selection.Borders(xlEdgeLeft)
        .LineStyle = xlContinuous
        .Weight = xlMedium
        .ColorIndex = xlAutomatic
    End With
    With Selection.Borders(xlEdgeTop)
        .LineStyle = xlContinuous
        .Weight = xlMedium
        .ColorIndex = xlAutomatic
    End With
    With Selection.Borders(xlEdgeBottom)
        .LineStyle = xlContinuous
        .Weight = xlMedium
        .ColorIndex = xlAutomatic
    End With
    With Selection.Borders(xlEdgeRight)
        .LineStyle = xlContinuous
        .Weight = xlMedium
        .ColorIndex = xlAutomatic
    End With
    
    With Selection.Font
        .Name = "Arial CE"
        .Size = 12
        .Strikethrough = False
        .Superscript = False
        .Subscript = False
        .OutlineFont = False
        .Shadow = False
        .Underline = xlUnderlineStyleNone
        .ColorIndex = xlAutomatic
    End With
    Selection.Font.Bold = True
    

End Sub

Private Sub FormatowanieKomorek2()

'

'Nastêpna linia kodu zaznacza zakres komórek do których zosta³y wpisane
'wyniki analizy dla poszczególnych liczb.
Range(Cells(NrWier + Zapis + 1, NrKolum), Cells(NrWier + Zapis + 2, NrKolum + GZTab - 1)).Select


'W tych liniach kody nastepuje sortowanie liczb wed³óg dwóch wierszy malej¹co.
Selection.Sort key1:=Range(Cells(NrWier + Zapis + 2, GZTab), Cells(NrWier + Zapis + 2, GZTab)), _
                Order1:=xlDescending, Key2:=Range(Cells(NrWier + Zapis + 1, GZTab), Cells(NrWier + Zapis + 1, GZTab)), _
                Order2:=xlDescending, Header:=xlGuess, OrderCustom:=1, MatchCase:=False, Orientation:=xlLeftToRight
                
    
    With Selection.Interior
        .ColorIndex = 34
        .Pattern = xlSolid
    End With
    Selection.Borders(xlDiagonalDown).LineStyle = xlNone
    Selection.Borders(xlDiagonalUp).LineStyle = xlNone
    With Selection.Borders(xlEdgeLeft)
        .LineStyle = xlContinuous
        .Weight = xlThin
        .ColorIndex = xlAutomatic
    End With
    With Selection.Borders(xlEdgeTop)
        .LineStyle = xlContinuous
        .Weight = xlThin
        .ColorIndex = xlAutomatic
    End With
    With Selection.Borders(xlEdgeBottom)
        .LineStyle = xlContinuous
        .Weight = xlThin
        .ColorIndex = xlAutomatic
    End With
    With Selection.Borders(xlEdgeRight)
        .LineStyle = xlContinuous
        .Weight = xlThin
        .ColorIndex = xlAutomatic
    End With
    With Selection.Borders(xlInsideVertical)
        .LineStyle = xlContinuous
        .Weight = xlThin
        .ColorIndex = xlAutomatic
    End With
    With Selection.Borders(xlInsideHorizontal)
        .LineStyle = xlContinuous
        .Weight = xlThin
        .ColorIndex = xlAutomatic
    End With


End Sub

Private Sub ZbieranieInfor()

'
Dim kom As String, kom2 As String, kom3 As String, kom4 As String
Dim OdpZI As Integer, OdpZI2 As Range



kom4 = "Podaj z jakiego zakresu chcesz szukaæ liczby od 1 do ..."

'
GZTab = CInt(InputBox(kom4, Tytul, 80))


'1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
kom = "Je¿eli chcesz, aby wyniki dzia³nia tego programu " & Chr(13)
kom = kom & "by³y wstawione do nowego arkusza naciœnij  -  " & Chr(168) & "TAK" & Chr(168) & Chr(13)
kom = kom & "W przeciwnym razie daj odpowied¿  -  " & Chr(168) & "NIE" & Chr(168) & Chr(13)


OdpZI = MsgBox(kom, vbInformation + vbYesNoCancel + vbDefaultButton1, Tytul)


Select Case OdpZI
    Case 2
        
        End
        
    Case 6
        
        '
        Call SprawdzanieArkuszy
        
        NrWier = 1
        NrKolum = 1
        
        '
        kom3 = "Podaj co ile dni po ka¿dym losowaniu maj¹ byæ" & Chr(13)
        kom3 = kom3 & "sprawdzane wylosowane liczby? " & Chr(13)
        
        Cykl = InputBox(kom3, Tytul, 2)
        
        If Cykl = 1 Then
            Dzien = "dzieñ"
        Else
            Dzien = "dni"
        End If
        
        Exit Sub
        
End Select



'2222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222




kom2 = "Uaktywnij arkusz i zaznacz dowolna komórê w tym arkuszu, "
kom2 = kom2 & "od której ma sie rozpocz¹æ wpisywanie wyników." & Chr(13)

'
Set OdpZI2 = Application.InputBox(prompt:=kom2, Title:=Tytul, Default:=ActiveSheet.Name & "!" & "$A$1", Type:=8)

NameNewSheet = OdpZI2.Worksheet.Name

NrWier = OdpZI2.Row
NrKolum = OdpZI2.Column


'
kom3 = "Podaj co ile dni po ka¿dym losowaniu maj¹ byæ" & Chr(13)
kom3 = kom3 & "sprawdzane wylosowane liczby?" & Chr(13)

Cykl = InputBox(kom3, Tytul, 2)

If Cykl = 1 Then
    Dzien = "dzieñ"
Else
    Dzien = "dni"
End If


End Sub

Private Sub SprawdzanieArkuszy()

'
Dim Arkusz As Object, Nazwa As String, Name1 As String
Dim i As Integer


NameNewSheet = "Statystyka"
Name1 = NameNewSheet

For Each Arkusz In Worksheets
       
    Nazwa = Arkusz.Name
    
    If Nazwa = Name1 Then
                
        i = i + 1
        Name1 = NameNewSheet & i
        
    End If
    
Next Arkusz

'
NameNewSheet = Name1


    Worksheets.Add after:=Worksheets(Worksheets.Count)
    ActiveSheet.Name = NameNewSheet
    

End Sub
