Attribute VB_Name = "KalkulatorIP_WM_CHAR"
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
Declare Function CallWindowProc Lib "user32" Alias "CallWindowProcA" (ByVal lpPrevWndFunc As Long, ByVal hwnd As Long, ByVal Msg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
Declare Function DefWindowProc Lib "user32" Alias "DefWindowProcA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
Declare Function SetClassLong Lib "user32" Alias "SetClassLongA" (ByVal hwnd As Long, ByVal nIndex As Long, ByVal dwNewLong As Long) As Long
Declare Function GetClassLong Lib "user32" Alias "GetClassLongA" (ByVal hwnd As Long, ByVal nIndex As Long) As Long
Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)
Declare Function GetMessage Lib "user32" Alias "GetMessageA" (lpMsg As Msg, ByVal hwnd As Long, ByVal wMsgFilterMin As Long, ByVal wMsgFilterMax As Long) As Long
Declare Function SetWindowLong Lib "user32" Alias "SetWindowLongA" (ByVal hwnd As Long, ByVal nIndex As Long, ByVal dwNewLong As Long) As Long
Declare Function TranslateMessage Lib "user32" (lpMsg As Msg) As Long
Declare Function DispatchMessage Lib "user32" Alias "DispatchMessageA" (lpMsg As Msg) As Long
Declare Function SetForegroundWindow Lib "user32" (ByVal hwnd As Long) As Long
Declare Function GetForegroundWindow Lib "user32" () As Long
Declare Function PeekMessage Lib "user32" Alias "PeekMessageA" (lpMsg As Msg, ByVal hwnd As Long, ByVal wMsgFilterMin As Long, ByVal wMsgFilterMax As Long, ByVal wRemoveMsg As Long) As Long
Declare Function GetClassInfo Lib "user32" Alias "GetClassInfoA" (ByVal hInstance As Long, ByVal lpClassName As String, lpWndClass As WNDCLASS) As Long
Declare Function GetWindowRect Lib "user32" (ByVal hwnd As Long, lpRect As RECT) As Long
Declare Function SetCursorPos Lib "user32" (ByVal x As Long, ByVal y As Long) As Long
Declare Function VkKeyScan Lib "user32" Alias "VkKeyScanA" (ByVal cChar As Byte) As Integer
Declare Function VkKeyScanEx Lib "user32" Alias "VkKeyScanExA" (ByVal ch As Byte, ByVal dwhkl As Long) As Integer


' do GetClassLong
Const GCL_WNDPROC = (-24)
Const GCL_STYLE = (-26)

' Do PeekMessage
Public Const PM_NOREMOVE = &H0


'komunikaty wysy³ane do okna lub kontrolek.
Const WM_CLEAR = &H303
Const WM_COMMAND = &H111
Const WM_COPY = &H301
Const WM_CUT = &H300
Const WM_KEYDOWN = &H100
Const WM_KEYUP = &H101
Const WM_SYSKEYDOWN = &H104
Const WM_SYSKEYUP = &H105
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
Const WM_LBUTTONUP = &H202
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
Const WM_MOUSEACTIVATE = &H21
Const WM_SETCURSOR = &H20
Const WM_MOUSEMOVE = &H200
Const WM_NCHITTEST = &H84
Const WM_CHAR = &H102
'
Const HTCLIENT = 1

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

' definiowanie typów.
Public Type POINT
        x As Long
        y As Long
End Type
'struktura wiadomoœci
Public Type Msg
    hwnd As Long
    message As Long
    wParam As Long
    lParam As Long
    time As Long
    pt As POINT
End Type
' struktura klasy okna
Public Type WNDCLASS
    style As Long
    lpfnwndproc As Long
    cbClsextra As Long
    cbWndExtra2 As Long
    hInstance As Long
    hIcon As Long
    hCursor As Long
    hbrBackground As Long
    lpszMenuName As String
    lpszClassName As String
End Type
'
Public Type RECT
        Left As Long
        Top As Long
        Right As Long
        Bottom As Long
End Type


' Zmienna "OldHwndChild"- przechowuje za ka¿dym razem handler kontrolki,
' która posiada³a fokusa ostatnim razem.
Dim OldHwndChild As Long
Dim Is_Window As Boolean
Dim Is_Zakladka As Boolean
Dim Wejscie As Boolean
Dim tytul As String
Dim Wpisz As Integer
Dim byl As Boolean
'
Dim Hwnd_Przelicz  As Long, Hwnd_Odsetki As Long, Hwnd_Kwota As Long
Dim Hwnd_DataZak As Long, Hwnd_DataRoz As Long
Dim HwndWin As Long ' handler okna g³ównego programu "Kalkulator"
Dim OldHwndProc  As Long ' handler procedury okna programu "Kalkulator"
Dim MyHwndProc As Long ' handler proceduru mojego okna programu.
Dim Hwnd_KontCalkow As Long


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
byl = False
Wpisz = 0
' zerowanie zmiennych przechowuj¹cych handlery do kontrolek i procedur okna.
Hwnd_Przelicz = 0
Hwnd_KontCalkow = 0
Hwnd_Odsetki = 0
Hwnd_Kwota = 0
Hwnd_DataZak = 0
Hwnd_DataRoz = 0
HwndWin = 0
OldHwndProc = 0
MyHwndProc = 0


'
tytul = "Sterowanie programem - 'Kalkulator IP - Odsetki'."


' wywo³ywanie funkcji enumeruj¹cej, wszystkie otwarte w tym momêcie wywo³ania, okna.
KalkulatorIP_New.EnumWindows AddressOf my_EnumWindows, ByVal 0&


'Sprawdzanie warunku, czy uruchomiony jest odpowiedni program
'i czy jest aktywna odpowiednia zak³adka w tym programie.
If (Is_Window = True And Is_Zakladka = True) Then
    
        '
        KalkulatorIP_New.EnumChildWindows HwndWin, AddressOf my_EnumChildWindows, ByVal 0&
        '
        'Call HackWinProc
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

Private Function WNDPROC(ByVal hwnd As Long, ByVal Msg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long

'
Stop

    WNDPROC = DefWindowProc(hwnd, Msg, wParam, lParam)
    
Stop
    
End Function

Function GetMyWndProc(ByVal lWndProc As Long) As Long

'
Stop

 GetMyWndProc = lWndProc

End Function

Private Sub HackWinProc()

' Procedura ta pobiera handlery procedur okna danego programu.

Dim k As Long

Stop

'
k = SendMessage(OldHwndChild, WM_KILLFOCUS, 0&, 0&)
k = SendMessage(Hwnd_KontCalkow, WM_SETFOCUS, 0&, 0&)
'
OldHwndChild = Hwnd_KontCalkow

'
k = SendMessage(Hwnd_KontCalkow, WM_KEYDOWN, &H50, &H190001)
k = SendMessage(Hwnd_KontCalkow, WM_USER + 47360, &H50, &H190001)
k = SendMessage(Hwnd_KontCalkow, WM_CHAR, 112, &H190001)
k = SendMessage(Hwnd_KontCalkow, WM_USER + 47362, &H70, &H190001)
k = SendMessage(Hwnd_KontCalkow, WM_KEYUP, &H50, &HC0190001)


'odmalowywanie kontrolki lub okna, w krórym nast¹pi³a zmiana zawartoœci.
KalkulatorIP_New.RedrawWindow HwndWin, ByVal 0&, ByVal 0&, RDW_INVALIDATE



End Sub

Private Function my_EnumWindows(ByVal hwnd As Long, ByVal iParam As Long) As Boolean

' Funkcja ta enumeruje wszystkie aktualnie otwarte okna w systemie.
Dim NazwaBuffor As String * 255
Dim Nazwa As String
Dim DL As Long


'GetWindowTextLength(hwnd) - funkcja ta zwraca d³ugoœæ nazwy w wyswietlanym oknie
DL = KalkulatorIP_New.GetWindowTextLength(hwnd)
'GetWindowText hwnd, NazwaBuffor, DL + 1 - funk. ta zwraca pe³n¹ nazwê wyœwietlanom
'   w danym oknie. Nazaw ta jest umieszczana w buforze stringowym NazwaBuffor.
KalkulatorIP_New.GetWindowText hwnd, NazwaBuffor, DL + 1

'
If DL <> 0 Then
    Nazwa = Left(NazwaBuffor, DL)
    '
    If Nazwa = "Kalkulator IP - Odsetki" Then
        '
        Is_Window = True
        HwndWin = hwnd
        '
        KalkulatorIP_New.EnumChildWindows hwnd, AddressOf my_EnumChildWindows_S, ByVal 0&
        
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
DLCh = KalkulatorIP_New.GetWindowTextLength(hwndChild)
'GetWindowText hwnd, NazwaBuffor, DLCh + 1 - funk. ta zwraca pe³n¹ nazwê wyœwietlanom
'   w danym oknie. Nazaw ta jest umieszczana w buforze stringowym NazwaBuffor.
KalkulatorIP_New.GetWindowText hwndChild, NazwaBuffor, DLCh + 1
' w zmiennej tej jest przechowywana tylko nazwa pobrana za pomoc¹ funkcji GetWindowText.
Zawartosc = Left(NazwaBuffor, DLCh)

'Funkcja ta zwraca do zmiennej "DlNClass1" d³ugoœæ nazwy klasy kontrolki o podanym handlerze.
DlNClass1 = KalkulatorIP_New.GetClassName(hwndChild, NazwaClassy, 255)
'Zmienna NazwaClassy1 - przechowuje ca³¹ nazwê kontrolki o podanym handlerze.
NazwaClassy1 = Left(NazwaClassy, DlNClass1)

'
If (NazwaClassy1 = "TPage") Then
    
    If (Wejscie = False And Zawartosc = "Odsetki ustawowe") Then
        '
        Is_Zakladka = True
    End If
    
    '
    Wejscie = True
    
ElseIf (NazwaClassy1 = "TMWSFlatRadioButton" And Zawartosc = "ca³kowita" And byl = False) Then
    '
    Hwnd_KontCalkow = hwndChild
    '
    byl = True
    
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
        '
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
    Case 7
        '
        Hwnd_Kwota = hwndChild
        KwotaZadl = Range("C2").Value
        '
        Call Wstawianie(Hwnd_Kwota, KwotaZadl)
        
    Case 9
        '
        Hwnd_DataZak = hwndChild
        DataZak = Range("B2").Value
        '
        Call Wstawianie(Hwnd_DataZak, DataZak)
    Case 15
        '
        Hwnd_Odsetki = hwndChild
    Case 46
        '
        Hwnd_Przelicz = hwndChild
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
    KalkulatorIP_New.SendMessage hwnd, WM_SETFOCUS, 0&, 0&
    ' odebranie fokusa kontrolce, która go posiada³a poprzednio.
    KalkulatorIP_New.SendMessage OldHwndChild, WM_KILLFOCUS, 0&, 0&

    ' wysy³aj¹c ten komunikat do kontrolki wstawiamy do niej wartoœæ,
    ' która znajduje siê w zmiennej "wartosc".
    KalkulatorIP_New.SendMessage hwnd, WM_SETTEXT, 0&, wartosc
    
    'odœwierzenie zawartoœci kontrolki.
    KalkulatorIP_New.UpdateWindow hwnd
    
    'odmalowywanie kontrolki lub okna, w krórym nast¹pi³a zmiana zawartoœci.
    KalkulatorIP_New.RedrawWindow hwnd, ByVal 0&, ByVal 0&, RDW_INVALIDATE

End If

End Sub

Private Sub Przelicz_Odsetki()

' Procedura ta powoduje wys³anie komunikatów do programu w celu wykonanie przeliczenia.

Dim k As Long

'
k = SendMessage(OldHwndChild, WM_KILLFOCUS, 0&, 0&)
k = SendMessage(Hwnd_KontCalkow, WM_SETFOCUS, 0&, 0&)
'
OldHwndChild = Hwnd_KontCalkow

'
k = SendMessage(Hwnd_KontCalkow, WM_KEYDOWN, &H50, &H190001)
k = SendMessage(Hwnd_KontCalkow, WM_USER + 47360, &H50, &H190001)
k = SendMessage(Hwnd_KontCalkow, WM_CHAR, 112, &H190001)
k = SendMessage(Hwnd_KontCalkow, WM_USER + 47362, &H70, &H190001)
k = SendMessage(Hwnd_KontCalkow, WM_KEYUP, &H50, &HC0190001)


'odmalowywanie kontrolki lub okna, w krórym nast¹pi³a zmiana zawartoœci.
KalkulatorIP_New.RedrawWindow HwndWin, ByVal 0&, ByVal 0&, RDW_INVALIDATE


End Sub

Private Sub Wstaw_Odsetki()

'
Dim Zawartosc As String * 255
Dim Zawartosc1 As String
Dim DLCh As Long

' przekazanie fokusa do kontrolki o podanym handlerze.
KalkulatorIP_New.SendMessage Hwnd_Odsetki, WM_SETFOCUS, 0&, 0&
' odebranie fokusa kontrolce, która go posiada³a poprzednio.
KalkulatorIP_New.SendMessage OldHwndChild, WM_KILLFOCUS, 0&, 0&
'
OldHwndChild = Hwnd_Odsetki

'
DLCh = KalkulatorIP_New.SendMessage(Hwnd_Odsetki, WM_GETTEXTLENGTH, 0&, 0&) + 1
'
KalkulatorIP_New.SendMessage Hwnd_Odsetki, WM_GETTEXT, DLCh&, Zawartosc
'
Zawartosc1 = Left(Zawartosc, DLCh - 1)

' tutaj nastepuje zwrócenie zawartoœci do komórki o podanym adresie.
Range("D2").Value = Zawartosc1


End Sub

'*********************************************************************************************



