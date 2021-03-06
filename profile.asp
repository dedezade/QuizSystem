<!-- #include file="inc/inc_settings.asp" -->
<!DOCTYPE html>
<html lang="en">
  <head>
    <!-- #include file="inc/-head.asp" -->
  </head>
  <body>
<%
LoginGate()
%>
    <div class="container">
    <!-- #include file="inc/-modal.asp" -->
    <!-- Static navbar -->
    <!-- #include file="inc/-navigation.asp" -->
    <!-- #include file="inc/-err_messages.asp" -->
    <div class="content-area">
      <div class="full">
<%
strID = Session("UserID")
strSQL = "Select * From Members Where ID = "&strID&""
Set objRs = Conn.Execute(StrSQL)
%>
        <div class="row">
          <div class="col-sm-10">
            <h3 class=""><%=objRs("Name") & " " & objRs("Surname")%></h3>
            <% if Session("Admin") = True then %>
            <a href="admin/" class="btn btn-success" role="button"> Administration </a>
            <% end if %>
			<a href="#" class="btn btn-info" role="button"> Create a New Quiz </a>
			<a href="#" class="btn btn-info" role="button"> My Results </a>
            <br />
          </div>
          <div class="col-sm-2"><a href="#" class="pull-right"><img title="profile image" class="img-circle img-responsive" src="images/profile.jpg"></a>
          </div>
        </div>
        <br />
        <div class="row">
          <div class="col-sm-3">
            <!--left col-->
            <ul class="list-group">
              <li class="list-group-item text-muted" contenteditable="false">Profile Overview</li>
              <li class="list-group-item text-right"><span class="pull-left"><strong class="">Joined</strong></span> <%=objRs("RegistrationDate")%></li>
              <li class="list-group-item text-right"><span class="pull-left"><strong class="">Last seen</strong></span> <%=objRs("LastLogin")%></li>
              <li class="list-group-item text-right"><span class="pull-left"><strong class="">E-Mail</strong></span> <%=objRs("EMail")%>              </li>
              <li class="list-group-item text-right"><span class="pull-left"><strong class="">Activation: </strong></span> <% IF objRs("Active") = True Then Response.Write("Actived") Else Response.Write("Pasive") End IF %>
              </li>
            </ul>
            <ul class="list-group">
              <li class="list-group-item text-muted">Activity Overview <i class="fa fa-dashboard fa-1x"></i>
              </li>
              <li class="list-group-item text-right"><span class="pull-left"><strong class="">Published Quizzes</strong></span> 12</li>
              <li class="list-group-item text-right"><span class="pull-left"><strong class="">Taken Quizzes</strong></span> 125</li>
              <li class="list-group-item text-right"><span class="pull-left"><strong class="">High Score</strong></span> 13</li>
              <li class="list-group-item text-right"><span class="pull-left"><strong class="">Completed Quizzes</strong></span> 17</li>
              <li class="list-group-item text-right"><span class="pull-left"><strong class="">Uncompleted Quizzes</strong></span> 18</li>
            </ul>
          </div>
          <!--/col-3-->
<%
objRs.Close
Set objRs = Nothing
%>
          <div class="col-sm-9" style="" contenteditable="false">
            <div class="panel panel-default">
              <div class="panel-heading"> <i class="fa fa-newspaper-o"></i> Whats new on quiz system?</div>
              <div class="panel-body"> 
			  <p> Here is an area that contains new features of quiz system. So members will know when we update the system.</p>
              </div>
            </div>
            <div class="panel panel-default target">
			

              <div class="panel-heading" contenteditable="false">Last 3 quizzes from you</div>
              <div class="panel-body">
                <div class="row">
<% set rs = conn.execute("select top 15 * from Quizzes Where MemberID = "&strID&" and Active = 1 Order by ID desc")
do while not rs.eof 
Minutes = rs("Time")/60
%>
<div class="col-xs-12 col-sm-6 col-md-4">	
<div class="well">
<div class="media">
<div class="media-body">
<h4 class="media-heading"><%=rs("Title")%></h4>
<p>Short description</p>
<ul class="list-inline list-unstyled">
<li><span><i class="glyphicon glyphicon-play-circle"></i> <a href="doquiz.asp?ID=<%=rs("ID")%>">Select &amp; Begin</a></span></li>
<li>|</li>
<li>
<span><i class="fa fa-clock-o"></i> <%=formatnumber(Minutes,2)%> mins</span>
</li>
</ul>
</div>
</div>
</div>
</div>
<% rs.movenext : loop : rs.close : set rs = nothing %>

                </div>
              </div>
            </div>
           
          </div>
        </div>
      </div>
      </div>

      <!-- #include file="inc/-footer.asp" -->
    </div>
    <!-- /container -->
  </body>
</html>