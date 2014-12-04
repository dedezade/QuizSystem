<%
Function GeneratePassword(strData)
If IsNull(strData) Then Exit Function
Dim Password,KarakterBoyu,KacinciKarakter
Const Karakterler = "0123456789"
Randomize
KarakterBoyu = Len(Karakterler)
For x = 1 To strData
KacinciKarakter = Int((KarakterBoyu * Rnd) + 1)
Password = Password & Mid(Karakterler,KacinciKarakter,1)
Next
GeneratePassword = Password
End Function

' FORM INPUT FILTERS 
'SQL Injection Prevent Function
Function QueryFilter(Str)
Str = Replace(Str, "*", "[INJ]",1,-1,1)
Str = Replace(Str, "=", "[INJ]",1,-1,1)
Str = Replace(Str, "<", "[INJ]",1,-1,1)
Str = Replace(Str, ">", "[INJ]",1,-1,1)
Str = Replace(Str, ";", "[INJ]",1,-1,1)
Str = Replace(Str, "(", "[INJ]",1,-1,1)
Str = Replace(Str, ")", "[INJ]",1,-1,1)
Str = Replace(Str, "+", "[INJ]",1,-1,1)
Str = Replace(Str, "#", "[INJ]",1,-1,1)
Str = Replace(Str, "'", "[INJ]", 1, -1, 1)
Str = Replace(Str, "&", "[INJ]", 1, -1, 1)
Str = Replace(Str, "%", "[INJ]", 1, -1, 1)
Str = Replace(Str, "?", "[INJ]", 1, -1, 1)
Str = Replace(Str, "´", "[INJ]", 1, -1, 1)
Str = Replace(Str, ",", "[INJ]",1,-1,1)
Str = Replace(Str, "UNION", "[INJ]",1,-1,1)
Str = Replace(Str, "SELECT", "[INJ]",1,-1,1)
Str = Replace(Str, "WHERE", "[INJ]",1,-1,1)
Str = Replace(Str, "LIKE", "[INJ]",1,-1,1)
Str = Replace(Str, "FROM", "[INJ]",1,-1,1)
Str = Replace(Str, "UPDATE", "[INJ]",1,-1,1)
Str = Replace(Str, "INSERT", "[INJ]",1,-1,1)
Str = Replace(Str, "ORDER", "[INJ]",1,-1,1)
Str = Replace(Str, "GROUP", "[INJ]",1,-1,1)
Str = Replace(Str, "ALTER", "[INJ]",1,-1,1)
Str = Replace(Str, "ADD", "[INJ]",1,-1,1)
Str = Replace(Str, "MODIFY", "[INJ]",1,-1,1)
Str = Replace(Str, "RENAME", "[INJ]",1,-1,1)
Str = Replace(Str, Chr(39), "[INJ]", 1, -1, 1)
If InStr(1,Str,"[INJ]",1) then
Response.Redirect ""&strSiteURL&""
end if
QueryFilter = Str
End Function


'// clean non ascii characters
Function CleanChars(ByVal strVariable)

	Dim objRegExp
	Dim strTempValue

	Set objRegExp = New RegExp
	With objRegExp
		.Pattern = "([^a-zA-Z0-9\-])"
		.IgnoreCase = False
		.Global = True
		strTempValue = .Replace(strVariable, "")
	End With

	CleanChars = strTempValue

End Function

Function ClearText(strData)
If IsNull(strData) Then Exit Function
	strData = Trim(strData)
	strData = Replace(strData, "'OR'", "")
	strData = Replace(strData, "'OR' '='", "")
	strData = Replace(strData, ";--", "")
	strData = Replace(strData, "1=1", "")
	strData = Replace(strData, "'or'", "")
	strData = Replace(strData, "'='", "")
	strData = Replace(strData, "--;", "")
	strData = Replace(strData, "<", "&lt;")
	strData = Replace(strData, ">", "&gt;")
	strData = Replace(strData, "[", "&#091;")
	strData = Replace(strData, "]", "&#093;")
	strData = Replace(strData, """", "&quot;", 1, -1, 1)
	strData = Replace(strData, "'", "&#39;", 1, -1, 1)
ClearText = strData
End Function

Function HTMLRead(strData)
If IsNull(strData) Then Exit Function
	strData = Trim(strData)
	strData = Replace(strData, "&#39;", "'", 1, -1, 1)
	strData = Replace(strData,"&lt;", "<" )
	strData = Replace(strData,"&gt;", ">")
	strData = Replace(strData,"&nbsp;", " ")
	strData = Replace(strData, "&rsquo;", "'", 1, -1, 1)
HTMLRead = strData
End Function

Function NumberControl(byVal strData)
	If IsNull(strData) Then Exit Function
	strData= Trim(strData)
	If NOT IsNumeric(strData) Then NumberControl = 0 Else NumberControl = strData
End Function

'// Email Validation
Function MailControl(strData)
	Dim objRegExp
	If IsNull(strData) Then Exit Function
	Set objRegExp = New Regexp
	With objRegExp
		.Pattern = "^([\w\-\.]+)@((\[([0-9]{1,3}\.){3}[0-9]{1,3}\])|(([\w\-]+\.)+)([a-zA-Z]{2,4}))$"
		.IgnoreCase = False
		.Global = True
	End With

	If objRegExp.Test(strData) = True Then
		MailControl = True
	Else
		MailControl = False
	End If
End Function


Function dbBoolControl(byVal strData)
	'If IsNull(strData) Then Exit Function
	strData = CStr(strData)
	If strData <> "True" AND strData <> "1" AND strData <> "-1" AND strData <> True Then
		dbBoolControl = 0
	Else
		dbBoolControl = 1
	End If
End Function


Function GTVDuz(strData)
	if strData < 10 then
		GTVDuz = "0" & strData
	Else
		GTVDuz = strData
	End if
End Function

Function GlobalTarih(strData,sSaat)
	If Not strData = "" then
		Tgun = Day(strData)
		Tay = Month(strData)
		Tyil = Year(strData)
		
		GlobalTarih = Tyil & "-" & GTVDuz(Tay) & "-" & GTVDuz(Tgun) 
		
		If sSaat = "yes" Then
			TSaat = Hour(strData)
			TDakika = Minute(strData)
			TSaniye = Second(strData)
			GlobalTarih = GlobalTarih &" " & GTVDuz(TSaat) & ":" & GTVDuz(TDakika) & ":" & GTVDuz(TSaniye)
		End IF 
	Else
		GlobalTarih = strData
	End if
End function

Function GlobalSaat(strData)
	If Not strData = "" then
		TSaat = Hour(strData)
		TDakika = Minute(strData)
		TSaniye = Second(strData)
		GlobalSaat = GTVDuz(TSaat) & ":" & GTVDuz(TDakika) & ":" & GTVDuz(TSaniye)
	End if
End function

'ERROR HANDLING 
Function ErrorMessage(ErrID)
If ErrID = "1" Then
ErrorMessage = "<div class=""alert alert-success alert-dismissable""> <button type=""button"" class=""close"" data-dismiss=""alert"" aria-hidden=""true"">&times;</button> <strong>Success!</strong> Your account has been successfully created. An email has been sent to you with detailed instructions on how to activate it.</div>"
ElseIF ErrID = "2" Then 
ErrorMessage = "<div class=""alert alert-danger alert-dismissable""> <button type=""button"" class=""close"" data-dismiss=""alert"" aria-hidden=""true"">&times;</button> <strong>Oopss!</strong> The email address or password you entered is not valid. Please try again. </div>"
ElseIF ErrID = "3" Then 
ErrorMessage = "<div class=""alert alert-danger alert-dismissable""> <button type=""button"" class=""close"" data-dismiss=""alert"" aria-hidden=""true"">&times;</button> <strong>Oopss!</strong> Please enter your email address and password.</div>"
ElseIF ErrID = "4" Then 
ErrorMessage = "<div class=""alert alert-warning alert-dismissable""> <button type=""button"" class=""close"" data-dismiss=""alert"" aria-hidden=""true"">&times;</button> <strong>Attention!</strong> Please fill in <strong>all</strong> fields correctly to register.</div>"
ElseIF ErrID = "5" Then
ErrorMessage = "<div class=""alert alert-danger alert-dismissable""> <button type=""button"" class=""close"" data-dismiss=""alert"" aria-hidden=""true"">&times;</button> <strong>Error!</strong> Password does not match the confirm password.</div>"
Else
ErrorMessage = "Contact with webmaster team."
End IF

End Function
%>
