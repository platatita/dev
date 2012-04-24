Attribute VB_Name = "Sub_ClearRanges"
Option Explicit


'
Public Sub ClearRanges()

'
Dim i As Integer
Dim s As Worksheet


    For i = 1 To ActiveWorkbook.Worksheets.Count
    
        '
        Set s = ActiveWorkbook.Worksheets.Item(i)
        '
        s.Activate
        
        '
        Union(Range( _
            "S17,S19,U11,U15,U19,M28:Q28,M29:Q29,A4:B4,D4:E4,F4,G11,G13,G15,G17,G19,I19,I17,I15,I13,I11,M11,M13,M15,M17,M19,O19,O17,O15,O13,O11,Q11,Q13" _
            ), Range("Q15,Q17,Q19,S11,S13,S15")).Select
        Selection.FormulaR1C1 = "0"
        '
        Range("B11,B13,B15,B17,B19,B11:B25,B29:H44,I31:X44,W28:X30").Select
        Selection.FormulaR1C1 = " "
        
        '
        s.Range("A1").Select
        
        '
        Set s = Nothing
        
    Next i
    
    '
    Set s = ActiveWorkbook.Worksheets.Item(1)
    '
    s.Activate
    '
    Set s = Nothing

End Sub
