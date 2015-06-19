<cftry>
	<cfquery name="address" datasource="#application.database#">
		select * from address
	</cfquery>
<cfcatch type="any">
	<cfmail 
		to="ron@millsclan.com" 
		from="ron@millsclan.com" 
		server="mail.millsclan.com" 
		username="ron@millsclan.com" 
		password="wed1994" 
		type="html" 
		subject="MillsClan Error - address">
		Error Message - #cfcatch.Message#<br />
		Error Detail - #cfcatch.Detail#<br />
		<cfdump var="#cfcatch#">
	</cfmail>
</cfcatch>
</cftry>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>MillsClan Addresses</title>
<link rel="stylesheet" type="text/css" href="css/millsclan.css" />
</head>

<body style="text-align:center">
<cfinclude template="header.cfm">
<div class="address"><br /><br />
<cfoutput>
<cfloop query="address">
	#name#<br />
	<cfif Len(trim(#address#)) gt 0>
		#address#<br />
	<cfelse>
		No Address<br />
	</cfif>
	<cfif Len(trim(#csz#)) gt 0>
		#csz#<br />
	<cfelse>
		No City<br />
	</cfif>
	<cfif Len(trim(#phone#)) gt 0>
		#phone#<br />
	<cfelse>
		No Phone<br />
	</cfif>
	<cfif Len(trim(#email#)) gt 0>
		#email#<br />
	<cfelse>
		No Email address<br />
	</cfif>
	Cell 1: #cell1#  Cell 2: #cell2#<br />
	<p style="text-align:center"><a href="login.cfm?id=3">Add</a>&nbsp;or
	<a href="login.cfm?id=1">Edit</a> Addresses</p>
	<hr style="width:300px" />
</cfloop>
</cfoutput>
</div>
<cfinclude template="footer.cfm">
</body>
</html>
