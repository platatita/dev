VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ThisOutlookSession"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

Const SubjectFieldSeparator As String = ";"
Const GetIPAddressSubjectName As String = "Get IPAddress"
Const ReplyKeyName As String = "Reply:"
Const DefaultUrlToReadIPAddress As String = "http://www.whatismyip.com/automation/n09230945.asp"
Const UrlKeyName As String = "Url:"
Const IPAddressSubjectName As String = "IPAddress"
Const RequestedIPFolder As String = "Requested IP"
Const BodyMessage As String = "This message is automatically generated. Please do not reply to it."


Private Sub Application_NewMail()
    Dim currentMailItem As MailItem
    Dim inboxFolder As MAPIFolder
    Dim responseText As String
    
    
    Set inboxFolder = Application.Session.GetDefaultFolder(olFolderInbox)
    If Not (inboxFolder Is Nothing) Then
    
        Dim i As Integer
        For i = 1 To inboxFolder.Items.Count
            If TypeOf inboxFolder.Items.Item(i) Is MailItem Then
                Set currentMailItem = inboxFolder.Items.Item(i)
                
                Debug.Print currentMailItem.subject
                
                If InStr(1, currentMailItem.subject, GetIPAddressSubjectName, 1) <> 0 And currentMailItem.UnRead = True Then
                    Dim newMailItem As MailItem
                    Dim movingResult As Boolean
                    
                    Set newMailItem = Application.CreateItem(olMailItem)
                    
                    newMailItem.To = ReadMailAddressFromSubject(currentMailItem)
                    newMailItem.Body = BodyMessage
                    
                    
                    On Error GoTo ErrorGettingIpAddress
                    responseText = GetCurrentIPAddress(currentMailItem)
                    Call AddIPAddressToNewMail(newMailItem, responseText)
                    
                    
                    On Error GoTo ErrorSendingMail
                    Call newMailItem.Send
                    
                    movingResult = MoveReadMailItem(inboxFolder, currentMailItem)
                    If movingResult = True Then
                        currentMailItem.UnRead = True
                    Else
                        currentMailItem.UnRead = False
                    End If
                    Debug.Print "Moving mail: '" & currentMailItem.subject & "' to folder: '" & RequestedIPFolder & "' " & movingResult
                    
                End If
            End If
        Next i
    End If
    
    Exit Sub
    
ErrorGettingIpAddress:
    Call BuildErrorMessageOfGettingIPAddress(newMailItem)
    Resume Next

ErrorSendingMail:
    If Err.Number <> 0 Then
        Debug.Print CStr(Err.Number) + " " + Err.Description
    End If
    Resume Next

End Sub


'This function reads the mail address from the subject of the 'currentMailItem' parameter in order to respond to it.
Private Function ReadMailAddressFromSubject(ByVal currentMailItem As MailItem) As String

    Dim result As String
    
    If GetKeyValueFromSubject(currentMailItem.subject, ReplyKeyName, result) = True Then
        ReadMailAddressFromSubject = result
    Else
        ReadMailAddressFromSubject = currentMailItem.SenderEmailAddress
    End If
    
End Function


'This function gets the current address ip of this computer and returns it.
'Address IP is got by sending the http request to the appropriate web site which returns the sender's ip address.
Private Function GetCurrentIPAddress(ByVal currentMailItem As MailItem) As String
    Dim url As String
    Dim httpRequest As WinHttpRequest
    
    url = ReadUrlFromSubject(currentMailItem)
    Set httpRequest = New WinHttpRequest
    
    Call httpRequest.Open("GET", url, False)
    Call httpRequest.Send
    
    Debug.Print ("Received IP: '" & httpRequest.responseText & "' from url: '" & url & "'")

    GetCurrentIPAddress = httpRequest.responseText

End Function

'This function reads the url from the subject of the 'currentMailItem' parameter if it exists,
'otherwise returns standard defined url e.g. "http://www.whatismyip.com/automation/n09230945.asp".
Private Function ReadUrlFromSubject(ByVal currentMailItem As MailItem) As String

    Dim result As String
    
    If GetKeyValueFromSubject(currentMailItem.subject, UrlKeyName, result) = True Then
        ReadUrlFromSubject = result
    Else
        ReadUrlFromSubject = DefaultUrlToReadIPAddress
    End If
        
End Function

'This procedure adds the provided 'receivedResponse' parameter to the subject of the 'newMailItem' parameter.
'If the length of the 'receivedResponse' is grather than 32 characters then it is added to the body, otherwise to the subject.
Private Sub AddIPAddressToNewMail(ByVal newMailItem As MailItem, ByVal receivedResponse As String)
    Dim newLine As String
    
    newLine = Chr(13) & Chr(10)
    
    newMailItem.subject = IPAddressSubjectName
    
    If Len(receivedResponse) <= 32 Then
        newMailItem.subject = newMailItem.subject & ":" & receivedResponse
    Else
        newMailItem.Body = newMailItem.Body & newLine & receivedResponse
    End If
    
End Sub


'This function moves the read mail from the inbox to the "Requested IP" folder.
Private Function MoveReadMailItem(ByVal currentFolder As MAPIFolder, ByVal currentMailItem As MailItem) As Boolean
    Dim j As Integer
                
    For j = 1 To currentFolder.Folders.Count
        Dim currentMAPIFolder As MAPIFolder
        Set currentMAPIFolder = currentFolder.Folders.Item(j)
        Debug.Print currentMAPIFolder.Name

        If currentMAPIFolder.Name = RequestedIPFolder Then
            Call currentMailItem.Move(currentMAPIFolder)
            MoveReadMailItem = True
            Exit For
        ElseIf currentMAPIFolder.Folders.Count > 1 Then
            If MoveReadMailItem(currentMAPIFolder, currentMailItem) = True Then
                MoveReadMailItem = True
                Exit For
            End If
        End If
        
    Next j

End Function


'This function parses provided 'subject' parameter in order to find the 'keyName'.
'If it find this 'keyName' then returns 'true' and in the 'outPutData' value of the keyName,
'otherwise 'false' and leave the 'outPutData' parameter in the unchanged state.
Private Function GetKeyValueFromSubject(ByVal subject As String, ByVal keyName As String, _
                                        ByRef outPutData As String) As Boolean

    Dim index As Integer
    Dim keyValuePair As Variant
    Dim subStringArray() As String
    
    subStringArray = Split(subject, SubjectFieldSeparator, -1, vbTextCompare)
    For Each keyValuePair In subStringArray
    
        index = InStr(LCase(keyValuePair), LCase(keyName))
        
        If index <> 0 Then
            outPutData = Mid(keyValuePair, index + Len(keyName))
            GetKeyValueFromSubject = True
            Exit Function
        End If
    Next
    
    GetKeyValueFromSubject = False
    
End Function


'This procedure builds the whole error message placed in the body message.
Private Sub BuildErrorMessageOfGettingIPAddress(ByVal newMailItem As MailItem)
    Dim newLine As String
    
    newLine = Chr(13) & Chr(10)

    If Err.Number <> 0 Then
        Dim errorMessage As String
        errorMessage = "Error occured" & newLine
        errorMessage = errorMessage & "Error number: " & CStr(Err.Number) & newLine
        errorMessage = errorMessage & "Error description: " & Err.Description & newLine
        
        newMailItem.Body = errorMessage & newLine & newMailItem.Body
        
        Debug.Print errorMessage
    End If
End Sub


