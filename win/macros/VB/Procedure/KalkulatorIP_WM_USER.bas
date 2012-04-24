Attribute VB_Name = "KalkulatorIP_WM_USER"
'************************************
'    Program napisany przez
'       Marcina Szewczyka
'    tel. kom. 888-894-841
'************************************

'Wszelkiego rodzaju zmiany powinny byæ konsultowane z autorem tego programu.
'Wykorzystywanie tego programu do innych celów ni¿ wskazane jest zabronione i 
'mo¿e spowodowaæ wadliwe dzia³anie systemu w takich przypadkach.

'**************************************************************************************************

Option Explicit

'
Declare Function GetWindowLong Lib "user32" Alias "GetWindowLongA" (ByVal hwnd As Long, ByVal nIndex As Long) As Long
Declare Function EnumWindows Lib "user32" (ByVal lpEnumFunc As Long, ByVal lParam As Long) As Boolean
Declare Function GetWindowText Lib "user32" Alias "GetWindowTextA" (ByVal hwnd As Long, ByVal lpString As String, ByVal cch As Long) As Long
Declare Function GetWindowTextLength Lib "user32" Alias "GetWindowTextLengthA" (ByVal hwnd As Long) As Long
Declare Function EnumChildWindows Lib "user32" (ByVal hWndParent As Long, ByVal lpEnumFunc As Long, ByVal lParam As Long) As Long
'Funkcja UpdateWindow(hwnd) - odœwierza zawartoœæ kontrolki lub okna o podanym handlerze.
Declare Function UpdateWindow Lib "user32" (ByVal hwnd As Long) As Long
Declare Function RedrawWindow Lib "user32" (ByVal hwnd As Long, lprcUpdate As Any, ByVal hrgnUpdate As Long, ByVal fuRedraw As Long) As Long
Declare Function GetClassName Lib "user32" Alias "GetClassNameA" (ByVal hwnd As Long, ByVal lpClassName As String, ByVal nMaxCount As Long) As Long
Declare Function SendMessage Lib "user32" Alias "SendMessageA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Integer, ByVal lParam As Any) As Long
'
'Declare Function CallWindowProc Lib "user32" Alias "CallWindowProcA" (ByVal lpPrevWndFunc As Long, ByVal hwnd As Long, ByVal Msg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
'Declare Function DefWindowProc Lib "user32" Alias "DefWindowProcA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
'Declare Function SetClassLong Lib "user32" Alias "SetClassLongA" (ByVal hwnd As Long, ByVal nIndex As Long, ByVal dwNewLong As Long) As Long
'Declare Function GetClassLong Lib "user32" Alias "GetClassLongA" (ByVal hwnd As Long, ByVal nIndex As Long) As Long
'Declare Function ShowCaret Lib "user32" (ByVal hwnd As Long) As Long


' do GetClassLong
Const GCL_WNDPROC = (-24)
Const GCL_STYLE = (-26)


'komunikaty wysy³ane do okna lub kontrolek.
Const WM_CLEAR = &H303
Const WM_COMMAND = &H111
Const WM_COPY = &H301
Const WM_CUT = &H300
Const WM_KEYDOWN = &H100
Const WM_SYSKEYDOWN = &H104
Const WM_KEYUP = &H101
Const WM_KILLFOCUS = &H8
Const WM_PASTE = &H302
Const WM_SETFOCUS = &H7
Const WM_UNDO = &H304
Const WM_USER = &H400
Const WM_SETTEXT = &HC
Const WM_GETTEXT = &HD
Const WM_GETTEXTLENGTH = &HE
Const WM_LBUTTONDBLCLK = &H203
Const WM_LBUTTONDOWN = &H201
Const WM_MBUTTONDBLCLK = &H209
Const WM_MBUTTONDOWN = &H207
Const WM_NCLBUTTONDBLCLK = &HA3
Const WM_NCLBUTTONDOWN = &HA1
Const WM_NCMBUTTONDBLCLK = &HA9
Const WM_NCMBUTTONDOWN = &HA7
Const WM_NCRBUTTONDBLCLK = &HA6
Const WM_NCRBUTTONDOWN = &HA4
Const WM_RBUTTONDBLCLK = &H206
Const WM_RBUTTONDOWN = &H204

'kody klawiszy
Const VK_RETURN = &HD 'enter
Const VK_LBUTTON = &H1
Const VK_RBUTTON = &H2
Const VK_NUMPAD0 = &H60
Const VK_NUMPAD1 = &H61
Const VK_NUMPAD2 = &H62
Const VK_NUMPAD3 = &H63
Const VK_NUMPAD4 = &H64
Const VK_NUMPAD5 = &H65
Const VK_NUMPAD6 = &H66
Const VK_NUMPAD7 = &H67
Const VK_NUMPAD8 = &H68
Const VK_NUMPAD9 = &H69

' klawisze myszy
Public Const MK_LBUTTON = &H1
Public Const MK_MBUTTON = &H10
Public Const MK_RBUTTON = &H2

' do GetWindowLong
Const GWL_ID = (-12)

' do RedrawWindow
Const RDW_INVALIDATE = &H1

' komunikaty do kontrolek typu EDIT przez SendMessage
Const EM_SETMODIFY = &HB9
Const EM_GETMODIFY = &HB8
Const EM_SETSEL = &HB1
Const EM_GETSEL = &HB0
Const EM_REPLACESEL = &HC2
Const EN_SETFOCUS = &H100
Const EM_SETRECT = &HB3
Const EM_GETRECT = &HB2
Const EN_CHANGE = &H300
' styl kontrolki edit
Const ES_READONLY = &H800&

' flagi do przycisków.
Const BN_CLICKED = 0
Const BN_DOUBLECLICKED = 5
Const BM_SETSTATE = &HF3
Const BM_GETSTATE = &HF2


' Zmienna "OldHwndChild"- przechowuje za ka¿dym razem handler kontrolki,
' która posiada³a fokusa ostatnim razem.
Dim OldHwndChild As Long
Dim Is_Window As Boolean
Dim Is_Zakladka As Boolean
Dim Wejscie As Boolean
Dim tytul As String
Dim Wpisz As Integer
'
Dim Hwnd_Przelicz  As Long, Hwnd_Odsetki As Long, Hwnd_Kwota As Long
Dim Hwnd_DataZak As Long, Hwnd_DataRoz As Long
Dim HwndWin As Long


'*********************************************************************************************

Public Sub Kalkulator()

' Zadaniem tego programu jest pod³¹czenie siê do innego programu o nazwie "Kalkulator IP"
' i sterowanie nim. Przekazaniem do niego danych z excel lub access-a i zwróceniem przez ten
' program wartoœci po przeliczeniu i wstawieniu w konkretne miejsce we wskazanym programie.


'zerowanie zmiennych.
OldHwndChild = 0
Is_Window = False
Is_Zakladka = False
Wejscie = False
HwndWin = 0
Wpisz = 0
' zerowanie zmiennych przechowuj¹cych handlery do kontrolek.
Hwnd_Przelicz = 0
Hwnd_Odsetki = 0
Hwnd_Kwota = 0
Hwnd_DataZak = 0
Hwnd_DataRoz = 0


'
tytul = "Sterowanie programem - 'Kalkulator IP - Odsetki'."


' wywo³ywanie funkcji enumeruj¹cej, wszystkie otwarte w tym momêcie wywo³ania, okna.
KalkulatorIP_WM_USER.EnumWindows AddressOf my_EnumWindows, ByVal 0&


'Sprawdzanie warunku, czy uruchomiony jest odpowiedni program
'i czy jest aktywna odpowiednia zak³adka w tym programie.
If (Is_Window = True And Is_Zakladka = True) Then
    
        '
        KalkulatorIP_WM_USER.EnumChildWindows HwndWin, AddressOf my_EnumChildWindows, ByVal 0&
        '
        Call Przelicz_Odsetki
        '
        Call Wstaw_Odsetki
        
ElseIf (Is_Window = True And Is_Zakladka = False) Then

    Dim kom As String
    kom = "Program, którym ma sterowaæ musi mieæ aktywn¹ zak³adkê 'Odsetki ustawowe'."
    
    MsgBox kom, vbInformation + vbDefaultButton1 + vbOKOnly, tytul

ElseIf (Is_Window = False And Is_Zakladka = False) Then

    Dim kom1 As String
    kom1 = "Uruchom program 'Kalkulator IP - Odsetki' i zak³adkê 'Odsetki ustawowe' w tym programie."
    
    MsgBox kom1, vbInformation + vbDefaultButton1 + vbOKOnly, tytul

End If


End Sub

Private Function my_EnumWindows(ByVal hwnd As Long, ByVal iParam As Long) As Boolean

' Funkcja ta enumeruje wszystkie aktualnie otwarte okna w systemie.
Dim NazwaBuffor As String * 255
Dim Nazwa As String
Dim DL As Long


'GetWindowTextLength(hwnd) - funkcja ta zwraca d³ugoœæ nazwy w wyswietlanym oknie
DL = KalkulatorIP_WM_USER.GetWindowTextLength(hwnd)
'GetWindowText hwnd, NazwaBuffor, DL + 1 - funk. ta zwraca pe³n¹ nazwê wyœwietlanom
'   w danym oknie. Nazaw ta jest umieszczana w buforze stringowym NazwaBuffor.
KalkulatorIP_WM_USER.GetWindowText hwnd, NazwaBuffor, DL + 1

'
If DL <> 0 Then
    Nazwa = Left(NazwaBuffor, DL)
    '
    If Nazwa = "Kalkulator IP - Odsetki" Then
        '
        Is_Window = True
        HwndWin = hwnd
        '
        KalkulatorIP_WM_USER.EnumChildWindows hwnd, AddressOf my_EnumChildWindows_S, ByVal 0&
    End If
   
End If


'
my_EnumWindows = True

End Function

Private Function my_EnumChildWindows_S(ByVal hwndChild As Long, ByVal lParam As Long) As Boolean

'
Dim NazwaBuffor As String * 255
Dim Zawartosc As String
Dim DLCh As Long
Dim DlNClass1 As Long
Dim NazwaClassy As String * 255
Dim NazwaClassy1 As String



'GetWindowTextLength(hwnd) - funkcja ta zwraca d³ugoœæ nazwy w wyswietlej kontrolce
DLCh = KalkulatorIP_WM_USER.GetWindowTextLength(hwndChild)
'GetWindowText hwnd, NazwaBuffor, DLCh + 1 - funk. ta zwraca pe³n¹ nazwê wyœwietlanom
'   w danym oknie. Nazaw ta jest umieszczana w buforze stringowym NazwaBuffor.
KalkulatorIP_WM_USER.GetWindowText hwndChild, NazwaBuffor, DLCh + 1
' w zmiennej tej jest przechowywana tylko nazwa pobrana za pomoc¹ funkcji GetWindowText.
Zawartosc = Left(NazwaBuffor, DLCh)

'Funkcja ta zwraca do zmiennej "DlNClass1" d³ugoœæ nazwy klasy kontrolki o podanym handlerze.
DlNClass1 = KalkulatorIP_WM_USER.GetClassName(hwndChild, NazwaClassy, 255)
'Zmienna NazwaClassy1 - przechowuje ca³¹ nazwê kontrolki o podanym handlerze.
NazwaClassy1 = Left(NazwaClassy, DlNClass1)

'
If (NazwaClassy1 = "TTabPage") Then
    
    If (Wejscie = False And Zawartosc = "Odsetki ustawowe") Then
        '
        Is_Zakladka = True
    End If
    
    '
    Wejscie = True
    
End If

'
my_EnumChildWindows_S = True


End Function

Private Function my_EnumChildWindows(ByVal hwndChild As Long, ByVal lParam As Long) As Boolean

' Zmienne do programu pobierania i wstawiania danych do programu.
Dim DataRoz As String
Dim DataZak As String
Dim KwotaZadl As String
Dim KwotaOdsetek As String

'
Wpisz = Wpisz + 1

'
Select Case Wpisz
    Case 5
        Hwnd_Przelicz = hwndChild
    Case 12
        Hwnd_Odsetki = hwndChild
    Case 13
        Hwnd_Kwota = hwndChild
        KwotaZadl = Range("C2").Value
        '
        Call Wstawianie(Hwnd_Kwota, KwotaZadl)
        
    Case 14
        Hwnd_DataZak = hwndChild
        DataZak = Range("B2").Value
        '
        Call Wstawianie(Hwnd_DataZak, DataZak)

    Case 15
        Hwnd_DataRoz = hwndChild
        DataRoz = Range("A2").Value
        '
        If (SprawdzenieDaty(DataRoz) = True) Then
            '
            Call Wstawianie(Hwnd_DataRoz, DataRoz)
        Else
            '
            MsgBox "Data powstania zob. nie mo¿e byæ mniejsza od 15-08-1992.", vbCritical + vbOKOnly + vbDefaultButton1, tytul
            End
        End If
        
End Select


' Zmienna ta przechowuje wartoœæ handlera do kontrolki, która posiada³a ostatni focusa.
OldHwndChild = hwndChild


' wywo³ywanie funkcji dopuki jest jeszcze jakaœ nie wyenumerowanka kontrolka.
my_EnumChildWindows = True

End Function

Private Function SprawdzenieDaty(ByVal Data As String) As Boolean

'
Dim Dzien As String, Miesiac As String, Rok As String
Dim DL As Integer, i As Integer
Dim Znak As String, Liczba As String

'
DL = Len(Data)

'
For i = 1 To DL + 1
    '
    Znak = Mid(Data, i, 1)
    '
    If IsNumeric(Znak) Then
        '
        Liczba = Liczba & Znak
    
    Else
        '
        If Dzien = "" Then
            Dzien = Liczba
        ElseIf Miesiac = "" Then
            Miesiac = Liczba
        ElseIf Rok = "" Then
            Rok = Liczba
        End If
        
        '
        Liczba = ""
        
    End If

Next i

'
If CInt(Rok) < 1992 Then
    '
    SprawdzenieDaty = False

ElseIf CInt(Rok) = 1992 Then
    '
    If CInt(Miesiac) < 8 Then
        '
        SprawdzenieDaty = False
        
    ElseIf CInt(Miesiac) = 8 Then
        '
        If CInt(Dzien) < 15 Then
            '
            SprawdzenieDaty = False
        Else
            '
            SprawdzenieDaty = True
            
        End If
    
    End If
    
Else
    '
    SprawdzenieDaty = True

End If


End Function

Private Sub Wstawianie(ByVal hwnd As Long, ByVal wartosc As String)

'
If wartosc <> "" Then

    ' przekazanie fokusa do kontrolki o podanym handlerze.
    KalkulatorIP_WM_USER.SendMessage hwnd, WM_SETFOCUS, 0&, 0&
    ' odebranie fokusa kontrolce, która go posiada³a poprzednio.
    KalkulatorIP_WM_USER.SendMessage OldHwndChild, WM_KILLFOCUS, 0&, 0&

    ' wysy³aj¹c ten komunikat do kontrolki wstawiamy do niej wartoœæ,
    ' która znajduje siê w zmiennej "wartosc".
    KalkulatorIP_WM_USER.SendMessage hwnd, WM_SETTEXT, 0&, wartosc
    
    'odœwierzenie zawartoœci kontrolki.
    KalkulatorIP_WM_USER.UpdateWindow hwnd
    
    'odmalowywanie kontrolki lub okna, w krórym nast¹pi³a zmiana zawartoœci.
    KalkulatorIP_WM_USER.RedrawWindow hwnd, ByVal 0&, ByVal 0&, RDW_INVALIDATE

End If

End Sub

Private Sub Przelicz_Odsetki()

'-----------------------------------------------------------------------------------
' Jest pierwszy sposób w jaki mozna przekazaæ programowi polecenie wykonania
' przeliczenia przes³anych danych. Polega on na tym, ¿e najpierw przekazujemy
' kontrolce "Button" o nazwie "Przelicz" ognisko "Focusa" a nastênie wysy³amy
' wiadomoœæ do tej kontrolki sygnalizuj¹c¹ systemowi wciœniêcie tego przycisku
' co spowoduje wykonanie procedur wywo³ywanych przez jego naciœniêcie.

' przekazanie fokusa do kontrolki o podanym handlerze.
'KalkulatorIP_WM_USER.SendMessage Hwnd_Przelicz, WM_SETFOCUS, 0&, 0&

' odebranie fokusa kontrolce, która go posiada³a poprzednio.
'KalkulatorIP_WM_USER.SendMessage OldHwndChild, WM_KILLFOCUS, 0&, 0&

'
'OldHwndChild = Hwnd_Przelicz

' Wysy³aj¹c komunikat BN_CLICKED do okna nadrzêdnego za pomoc¹ WM_COMMAND
' sygnalizujemy, ¿e zosta³ wciœniêty przycisk "Przelicz".
'KalkulatorIP_WM_USER.SendMessage HwndWin, WM_COMMAND, BN_CLICKED, Hwnd_Przelicz
'-----------------------------------------------------------------------------------


'-----------------------------------------------------------------------------------
' Drugi sposób polega na przekazaniu kontrolce "Focusa", do której wrowadziliœmy
' dane, a nastêpnie wys³anie do niej komunikatu, ¿e zosta³ wciœniêty przycisk "Enter".
' Zrobi³em to w tym przypadku za pomoc¹ flagi WM_USER, mo¿na to zrobiæ za pomoc¹
' flagi WM_KEYDOWN i wartoœci przycisku "Enter" VK_RETURN ale to nie dzia³a w naszym
' przypadku.

Dim k1 As Integer

' Powoduje wizualny efekt wciœniêcia przycisku "Button" bez ¿adnej reakcji systemowej.
KalkulatorIP_WM_USER.SendMessage Hwnd_Przelicz, BM_SETSTATE, 1&, 0&
' Powoduje wizualny efekt puszczenia przycisku "Button" bez ¿adnej reakcji systemowej.
KalkulatorIP_WM_USER.SendMessage Hwnd_Przelicz, BM_SETSTATE, 0&, 0&

'
KalkulatorIP_WM_USER.SendMessage Hwnd_Kwota, WM_SETFOCUS, 0&, 0&
' odebranie fokusa kontrolce, która go posiada³a poprzednio.
KalkulatorIP_WM_USER.SendMessage OldHwndChild, WM_KILLFOCUS, 0&, 0&


'kl = SendMessage(Hwnd_Kwota, WM_KEYDOWN, VK_RETURN, ByVal 1835009)
'
k1 = SendMessage(Hwnd_Kwota, WM_USER + 47360, &HD, ByVal &H1C0001) '&H1C0001 to samo co  1835009)
'
'kl = SendMessage(Hwnd_Kwota, WM_KEYUP, VK_RETURN, ByVal 1835009)
'
OldHwndChild = Hwnd_Kwota
'-----------------------------------------------------------------------------------



'odmalowywanie kontrolki lub okna, w krórym nast¹pi³a zmiana zawartoœci.
KalkulatorIP_WM_USER.RedrawWindow HwndWin, ByVal 0&, ByVal 0&, RDW_INVALIDATE


End Sub

Private Sub Wstaw_Odsetki()

'
Dim Zawartosc As String * 255
Dim Zawartosc1 As String
Dim DLCh As Long

' przekazanie fokusa do kontrolki o podanym handlerze.
KalkulatorIP_WM_USER.SendMessage Hwnd_Odsetki, WM_SETFOCUS, 0&, 0&
' odebranie fokusa kontrolce, która go posiada³a poprzednio.
KalkulatorIP_WM_USER.SendMessage OldHwndChild, WM_KILLFOCUS, 0&, 0&
'
OldHwndChild = Hwnd_Odsetki

'
DLCh = KalkulatorIP_WM_USER.SendMessage(Hwnd_Odsetki, WM_GETTEXTLENGTH, 0&, 0&) + 1
'
KalkulatorIP_WM_USER.SendMessage Hwnd_Odsetki, WM_GETTEXT, DLCh&, Zawartosc
'
Zawartosc1 = Left(Zawartosc, DLCh - 1)

' tutaj nastepuje zwrócenie zawartoœci do komórki o podanym adresie.
Range("D2").Value = Zawartosc1


End Sub

'*********************************************************************************************



