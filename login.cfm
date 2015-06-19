<cfset mdate = DateFormat(now(),"MMMM dd, yyyy")>
<cfset dow = day(mdate)>
<cfset murl = "index.cfm">
<cfif StructKeyExists(URL,"id")>
	<cfset mid = #URL.id#>
<cfelse>
	<cfset mid = 0>
</cfif>

<cfif CGI.REQUEST_METHOD IS "POST">
	<cftry>
		<cfset user = Trim(#form.username#)>
		<cfset pw = Trim(#form.dob#)><!---<cfdump var="#user# - #CreateODBCDate(pw)#"><cfabort>--->
		<cfquery name="getLogin" datasource="#application.database#">
			select count(*) as CNT from members where fname = '#user#' and dob = #CreateODBCDate(pw)#
		</cfquery>
		<cfif getLogin.CNT gt 0><!---edit addresses--->
			<cfif #form.mid# eq 1>
				<cfset murl = "editaddress.cfm">
			<cfelseif #form.mid# eq 2>
				<cfset murl = "admin.cfm">
			<cfelseif #form.mid# eq 3>
				<cfset murl = "addaddress.cfm">
			</cfif>
		<cfelse>
			<cfset murl = "login.cfm?msg=Login Failed">
		</cfif>
	<cfcatch type="any">
		<cfmail 
			to="ron@millsclan.com" 
			from="ron@millsclan.com" 
			server="mail.millsclan.com" 
			username="ron@millsclan.com" 
			password="wed1994" 
			type="html" 
			subject="MillsClan Error - Login">
			Error Message - #cfcatch.Message#<br />
			Error Detail - #cfcatch.Detail#<br />
			<cfdump var="#cfcatch#">
		</cfmail>
	</cfcatch>
	</cftry>
	<cflocation url="#murl#" addtoken="no">
</cfif>

<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>The Mills Family</title>
<link rel="stylesheet" type="text/css" href="css/millsclan.css" />
<script language="javascript">
	function go(){
		window.location="index.cfm";
		return;
	}
</script>
</head>
<body style="text-align:center">
<cfinclude template="header.cfm">
<br />
<div class="login">
	<table style="text-align:center; border:none; width:100%">
	<cfif StructKeyExists(URL,"msg")>
		<tr><td colspan="3"><div class="msg">#URL.msg#</div></td></tr>
	</cfif>
	<tr><td style="text-align:right">
	<form name="login" action="login.cfm" method="post">
		Enter user name:</td><td style="width:180px; text-align:center"><input type="text" name="username" value="" /></td><td>&nbsp;</td></tr><br />
		<tr><td style="text-align:right">Enter DOB:</td><td style="width:180px; text-align:center"><input type="text" name="dob" value="" /></td>
		<td style="text-align:left">[YYYY-MM-DD]</td></tr><br />
	<tr><td colspan="3" style="text-align:center"><button type="submit">Submit</button></td></tr>
	<input type="hidden" name="mid" value="#mid#" />
	</form>
	<td colspan="3" style="text-align:center"><button type="button" onclick="go();">Cancel</button></td></tr>
	</table>
</div>
<cfinclude template="footer.cfm">
</body>
</html></cfoutput>
