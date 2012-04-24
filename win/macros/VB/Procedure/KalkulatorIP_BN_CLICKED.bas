Attribute VB_Name = "KalkulatorIP_BN_CLICKED"
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
Declare Function SetWindowLong Lib "user32" Alias "SetWindowLongA" (ByVal hwnd As Long, ByVal nIndex As Long, ByVal dwNewLong As Long) As Long
Declare Function GetWindowLong Lib "user32" Alias "GetWindowLongA" (ByVal hwnd As Long, ByVal nIndex As Long) As Long
Declare Function EnumWindows Lib "user32" (ByVal lpEnumFunc As Long, ByVal lParam As Long) As Boolean
Declare Function GetWindowText Lib "user32" Alias "GetWindowTextA" (ByVal hwnd As Long, ByVal lpString As String, ByVal cch As Long) As Long
Declare Function GetWindowTextLength Lib "user32" Alias "GetWindowTextLengthA" (ByVal hwnd As Long) As Long
Declare Function EnumChildWindows Lib "user32" (ByVal hWndParent As Long, ByVal lpEnumFunc As Long, ByVal lParam As Long) As Long
Declare Function SetWindowText Lib "user32" Alias "SetWindowTextA" (ByVal hwnd As Long, ByVal lpString As String) As Long
'Funkcja UpdateWindow(hwnd) - odœwierza zawartoœæ kontrolki lub okna o podanym handlerze.
Declare Function UpdateWindow Lib "user32" (ByVal hwnd As Long) As Long
Declare Function RedrawWindow Lib "user32" (ByVal hwnd As Long, lprcUpdate As Any, ByVal hrgnUpdate As Long, ByVal fuRedraw As Long) As Long
Declare Function GetClassName Lib "user32" Alias "GetClassNameA" (ByVal hwnd As Long, ByVal lpClassName As String, ByVal nMaxCount As Long) As Long
Declare Function SendMessage Lib "user32" Alias "SendMessageA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Integer, ByVal lParam As Any) As Long


'komunikaty wysy³ane do okna lub kontrolek.
Const WM_CLEAR = &H303
Const WM_COMMAND = &H111
Const WM_COPY = &H301
Const WM_CUT = &H300
Const WM_KEYDOWN = &H100
Const WM_KEYUP = &H101
Const WM_KILLFOCUS = &H8
Const WM_PASTE = &H302
Const WM_SETFOCUS = &H7
Const WM_UNDO = &H304
Const WM_USER = &H400
Const WM_SETTEXT = &HC
Const WM_GETTEXT = &HD
Const WM_GETTEXTLENGTH = &HE

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


' Zmienna "OldHwndChild"- przechowuje za ka¿dym razem handler kontrolki,
' która posiada³a fokusa ostatnim razem.
Dim OldHwndChild As Long
Dim Is_Window As Boolean
Dim Is_Zakladka As Boolean
Dim Wejscie As Boolean
Dim HwndWin As Long
Dim tytul As String
Dim Wpisz As Integer
'
Dim Hwnd_Przelicz  As Long, Hwnd_Odsetki As Long, Hwnd_Kwota As Long
Dim Hwnd_DataZak As Long, Hwnd_DataRoz As Long



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
KalkulatorIP_BN_CLICKED.EnumWindows AddressOf my_EnumWindows, ByVal 0&


'Sprawdzanie warunku, czy uruchomiony jest odpowiedni program
'i czy jest aktywna odpowiednia zak³adka w tym programie.
If (Is_Window = True And Is_Zakladka = True) Then
    
        '
        KalkulatorIP_BN_CLICKED.EnumChildWindows HwndWin, AddressOf my_EnumChildWindows, ByVal 0&
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
DL = KalkulatorIP_BN_CLICKED.GetWindowTextLength(hwnd)
'GetWindowText hwnd, NazwaBuffor, DL + 1 - funk. ta zwraca pe³n¹ nazwê wyœwietlanom
'   w danym oknie. Nazaw ta jest umieszczana w buforze stringowym NazwaBuffor.
KalkulatorIP_BN_CLICKED.GetWindowText hwnd, NazwaBuffor, DL + 1

'
If DL <> 0 Then
    Nazwa = Left(NazwaBuffor, DL)
    '
    If Nazwa = "Kalkulator IP - Odsetki" Then
        '
        Is_Window = True
        HwndWin = hwnd
        '
        KalkulatorIP_BN_CLICKED.EnumChildWindows hwnd, AddressOf my_EnumChildWindows_S, ByVal 0&
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
DLCh = KalkulatorIP_BN_CLICKED.GetWindowTextLength(hwndChild)
'GetWindowText hwnd, NazwaBuffor, DLCh + 1 - funk. ta zwraca pe³n¹ nazwê wyœwietlanom
'   w danym oknie. Nazaw ta jest umieszczana w buforze stringowym NazwaBuffor.
KalkulatorIP_BN_CLICKED.GetWindowText hwndChild, NazwaBuffor, DLCh + 1
' w zmiennej tej jest przechowywana tylko nazwa pobrana za pomoc¹ funkcji GetWindowText.
Zawartosc = Left(NazwaBuffor, DLCh)

'Funkcja ta zwraca do zmiennej "DlNClass1" d³ugoœæ nazwy klasy kontrolki o podanym handlerze.
DlNClass1 = KalkulatorIP_BN_CLICKED.GetClassName(hwndChild, NazwaClassy, 255)
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
        Call Wstawianie(Hwnd_DataRoz, DataRoz)
        
End Select


' Zmienna ta przechowuje wartoœæ handlera do kontrolki, która posiada³a ostatni focusa.
OldHwndChild = hwndChild


' wywo³ywanie funkcji dopuki jest jeszcze jakaœ nie wyenumerowanka kontrolka.
my_EnumChildWindows = True

End Function

Private Sub Wstawianie(ByVal hwnd As Long, ByVal wartosc As String)

'
If wartosc <> "" Then

    ' przekazanie fokusa do kontrolki o podanym handlerze.
    KalkulatorIP_BN_CLICKED.SendMessage hwnd, WM_SETFOCUS, 0&, 0&
    ' odebranie fokusa kontrolce, która go posiada³a poprzednio.
    KalkulatorIP_BN_CLICKED.SendMessage OldHwndChild, WM_KILLFOCUS, 0&, 0&

    ' wysy³aj¹c ten komunikat do kontrolki wstawiamy do niej wartoœæ,
    ' która znajduje siê w zmiennej "wartosc".
    KalkulatorIP_BN_CLICKED.SendMessage hwnd, WM_SETTEXT, 0&, wartosc
    
    'odœwierzenie zawartoœci kontrolki.
    UpdateWindow hwnd
    
    'odmalowywanie kontrolki lub okna, w krórym nast¹pi³a zmiana zawartoœci.
    KalkulatorIP_BN_CLICKED.RedrawWindow hwnd, ByVal 0&, ByVal 0&, RDW_INVALIDATE

End If

End Sub

Private Sub Przelicz_Odsetki()

'
' przekazanie fokusa do kontrolki o podanym handlerze.
KalkulatorIP_BN_CLICKED.SendMessage Hwnd_Przelicz, WM_SETFOCUS, 0&, 0&
' odebranie fokusa kontrolce, która go posiada³a poprzednio.
KalkulatorIP_BN_CLICKED.SendMessage OldHwndChild, WM_KILLFOCUS, 0&, 0&
'
OldHwndChild = Hwnd_Przelicz

' Wysy³aj¹c komunikat BN_CLICKED do okna nadrzêdnego za pomoc¹ WM_COMMAND
' sygnalizujemy, ¿e zosta³ wciœniêty przycisk przelicz.
KalkulatorIP_BN_CLICKED.SendMessage HwndWin, WM_COMMAND, BN_CLICKED, Hwnd_Przelicz


End Sub

Private Sub Wstaw_Odsetki()

'
Dim Zawartosc As String * 255
Dim Zawartosc1 As String
Dim DLCh As Long

' przekazanie fokusa do kontrolki o podanym handlerze.
KalkulatorIP_BN_CLICKED.SendMessage Hwnd_Odsetki, WM_SETFOCUS, 0&, 0&
' odebranie fokusa kontrolce, która go posiada³a poprzednio.
KalkulatorIP_BN_CLICKED.SendMessage OldHwndChild, WM_KILLFOCUS, 0&, 0&
'
OldHwndChild = Hwnd_Odsetki

'
DLCh = KalkulatorIP_BN_CLICKED.SendMessage(Hwnd_Odsetki, WM_GETTEXTLENGTH, 0&, 0&) + 1
'
KalkulatorIP_BN_CLICKED.SendMessage Hwnd_Odsetki, WM_GETTEXT, DLCh&, Zawartosc
'
Zawartosc1 = Left(Zawartosc, DLCh - 1)

' tutaj nastepuje zwrócenie zawartoœci do komórki o podanym adresie.
Range("D2").Value = Zawartosc1


End Sub

'*********************************************************************************************

' wysy³aj¹c ten komunikat do kontrolki "EDIT" wstawiamy do niej wartoœæ,
' która znajduje siê w zmiennej "wartosc".
'KalkulatorIP_BN_CLICKED.SendMessage Hwnd, EM_REPLACESEL, True, wartosc


