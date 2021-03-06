<!-- #include file="inc/inc_settings.asp" -->
<%
req 			= QueryFilter(request.querystring("i"))
QID 			= QueryFilter(request.querystring("ID"))
'Register Form Parameters
firstname 		= ClearText(request.form("firstname"))
lastname 		= ClearText(request.form("lastname"))
email 			= ClearText(request.form("email"))
password 		= ClearText(request.form("password"))
password2 		= ClearText(request.form("password2"))


if req 	   = "Register" then
call Register

elseif req = "Login" then
call Login

elseif req = "UpdateProfile" then
LoginGate()
call UpdateProfile

elseif req = "Logout" then
call Logout

elseif req = "ActivateMember" then
call ActivateMember

elseif req = "ForgotPass" then
call ForgotPass

elseif req = "CalcQuiz" then
call CalcQuiz

else
response.redirect "default.asp"
end if
%>
<%
Sub CalcQuiz

dim i,correctanswers,wronganswers
correctanswers = 0
wronganswers = 0
emptyanswers = 0
totalpoints = 0
suredurum = dbBoolControl(Request.Form("suredurum"))
cevapsayisi = NumberControl(Request.Form("cevapsayisi"))

if suredurum = 1 then
suredurum = 0
else
suredurum = 1
end if

for i=1 to cevapsayisi step 1

	Cevap = request.form("Ans"&i)
	if Cevap = "" then
		emptyanswers = emptyanswers + 1
	else
		Set rs = Conn.Execute("Select * from Options Where ID = "&Cevap&" ")
			if rs("TrueAnswer") = True then
			
			Set checkpoint = conn.execute("Select Difficulty From Questions Where ID = "&rs("QuesionID")&" and Active = 1 ")
				totalpoints = totalpoints + checkpoint("Difficulty")
			checkpoint.close : set checkpoint = nothing
				
				correctanswers = correctanswers + 1
			else
				wronganswers = wronganswers + 1
			end if
		rs.close : Set rs = Nothing
	end if

next

StrSQL = "SELECT * FROM QuizResults"
objRS.Open StrSQL, Conn, 1, 2

objRS.AddNew
objRS("MemberID") 		= Session("UserID")
objRS("QuizID") 	= QID
objRS("QuizDate") 		= GlobalTarih(now(),"no")
objRS("Achievement") 	= totalpoints
objRS("NCorrectAnswers") = correctanswers
objRS("NWrongAnswers") = wronganswers
objRS("NEmptyAnswers") = emptyanswers
objRS("TimeOut") = suredurum

objRS.Update
objRS.close : set objRS = nothing

response.write "D : "&correctanswers &"</br>"
response.write "Y : "&wronganswers &"</br>"
response.write "B : "&emptyanswers &"</br>"
response.write "Points : "&totalpoints &"</br>"
response.write "Result has been successfully calculated."


End Sub

Sub Register
if firstname = "" or lastname = "" or email = "" or password = "" then
response.redirect "default.asp?H=4"
end if

if password <> password2 then
response.redirect "default.asp?H=5" ' works fine :) 
end if
Auth_Token = GeneratePassword(10)
ActivationCode = GeneratePassword(10)
Md5Password = Md5(password)

StrSQL = "SELECT * FROM Members"
objRS.Open StrSQL, Conn, 1, 2

objRS.AddNew
objRS("Name") 		= firstname
objRS("Surname") 	= lastname
objRS("EMail") 		= email
objRS("Password") 	= Md5Password
objRS("Active") = 0
objRS("RegistrationDate") = GlobalTarih(now(),"no")
objRS("LastLogin") = GlobalTarih(now(),"no")
objRS("Auth_Token") = Auth_Token
objRS("ActivationCode") = ActivationCode
objRS("Admin") = 0
objRS.Update

objRS.Close : set objRS = Nothing
response.redirect "default.asp?H=1"
' Successfuly Registered , will send activation mail ---------------
' Here we will implement sending activation mail to registered user.

end sub


Sub Login

IF email<>"" and password<>"" Then 
	strLogin = False 
	Md5Password = Md5(password)
		StrSQL = "Select ID, Name,SurName,Email FROM Members WHERE "
		StrSQL = StrSQL & "EMail = '"&email&"' AND Password = '"&Md5Password&"' AND Active = 1"

	set objRs = Conn.Execute(strSQL)
		IF objRs.EOF Then
			'USER NOT FOUND --------------------
			Response.Redirect "default.asp?H=2"
		Else
			'Login Success ----------------------
			strLogin = True 
			Auth_Token = GeneratePassword(10)
			UserID = objRS("ID")
			Session("Login") = True
			Session("UserID") = UserID
			Session("Auth_Token") = Auth_Token
			Session("Name") = objRS("Name")
			Session("SurName") = objRS("SurName")
			Session("EMail") = objRS("EMail")
			Session("Admin") = True
	
		If strLogin = True Then 
	
			StrSQL = "SELECT * FROM Members WHERE ID = "&UserID&""
			ObjRsYard.Open StrSQL, Conn, 1, 2
				ObjRsYard("Auth_Token") = Auth_Token
				ObjRsYard("LastLogin") = GlobalTarih(now(),"no")
			ObjRsYard.Update
			ObjRsYard.Close
			Set ObjRsYard = Nothing
			
			' REDIRECT TO ACCOUNT PAGE ---------------
			Response.Redirect "profile.asp?H=6"
	
		End IF 
	End IF
	ObjRs.Close
	Set ObjRs = Nothing
Else
	' EMail or Password values NULL -------------------
	Response.Redirect "default.asp?H=3"
End IF
End Sub


Sub Logout

			Session("Login") = False
			Session("UserID") = ""
			Session("Auth_Token") = ""
			Session("Name") = ""
			Session("SurName") = ""
			Session("EMail") = ""

Response.Redirect "default.asp?H=7"

End Sub
%>