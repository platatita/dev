VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ArrayList"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
'
Private m_added As Long
Private m_list() As Variant


Private Sub Class_Initialize()
    '
    m_added = -1
    '
    ReDim m_list(2)
    
End Sub

Public Property Let Add(ByVal element As Variant)
           
    '
    If m_added = UBound(m_list, 1) Then
        ReDim Preserve m_list(UBound(m_list, 1) * 2)
    End If
    
    '
    m_added = m_added + 1
     '
    m_list(m_added) = element


End Property

Public Function Remove(ByVal index As Long) As Boolean
    '
    If Not TestIndex(index) Then
        '
        Remove = False
        '
        Exit Function
    End If
    
    
    '
    Dim i As Long
        
    '
    For i = index + 1 To m_added
        m_list(i - 1) = m_list(i)
    Next i
    
    '
    m_list(m_added) = Null
    '
    m_added = m_added - 1
    
    
    '
    Remove = True
    
End Function

Public Property Get Get_Data(ByVal index As Long) As Variant
    '
    If Not TestIndex(index) Then
        '
        Get_List = "index outside range"
        '
        Exit Sub
    End If
    
    '
    Get_Data = m_list(index)
    
End Property

Public Property Get Get_Count() As Long
    '
    Get_Count = m_added
    
End Property

Public Sub Clear()
    '
    Call Class_Initialize
    
End Sub

Public Sub Sort()
    '
    Call QSort(0, m_added, m_list)
    
End Sub

Public Sub Sort1(ByVal from_index As Integer, ByVal to_index As Integer)
    '
    Call QSort(from_index, to_index, m_list)
    
End Sub

Private Sub QSort(ByVal l As Integer, ByVal r As Integer, ar() As Variant)
    '
    Dim val As Long, val1 As Variant
    Dim i As Integer, j As Integer
    
    '
    i = l
    j = r
    val = ar((l + r) / 2)
    
    '
    Do
        '
        While (CLng(ar(i)) < val)
            i = i + 1
        Wend
        '
        While (CLng(ar(j)) > val)
            j = j - 1
        Wend
        
        
        '
        If (i <= j) Then
            '
            val1 = ar(i)
            ar(i) = ar(j)
            ar(j) = val1
            '
            i = i + 1
            j = j - 1
        End If
        
        
    Loop Until Not (i <= j)
    
    
    '
    If l < j Then
        Call QSort(l, j, ar)
    End If
    '
    If i < r Then
        Call QSort(i, r, ar)
    End If
    

End Sub

Private Function TestIndex(ByVal index As Long) As Boolean
    '
    If index > m_added Then
        TestIndex = False
    ElseIf index < 0 Then
        TestIndex = False
    Else
        TestIndex = True
    End If

End Function
