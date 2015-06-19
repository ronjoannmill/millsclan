<!--- <cfinclude template="check_session.cfm"> --->

<cftry>
	<cfquery name="payees" datasource="#application.database#">
		select A.*,B.payment_method AS Method from payees A join payment_methods B on A.payment_method = B.id AND a.active = 1 order by a.name
	</cfquery>
<cfcatch type="any">
	<cfmail 
		to="ron@millsclan.com" 
		from="ron@millsclan.com" 
		server="mail.millsclan.com" 
		username="ron@millsclan.com" 
		password="Wed1994!" 
		type="html" 
		subject="MillsClan Error - payee">
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
<title>MillsClan Payees</title>
<link rel="stylesheet" type="text/css" href="css/millsclan.css" />
</head>

<body style="text-align:center">
<cfinclude template="header.cfm">
<div class="address"><br /><br />
<cfoutput>
<table align="center">
<tr><td colspan="9">
<cfif StructKeyExists(URL,"msg") AND Len(Trim(#URL.msg#)) gt 0>#URL.msg#<cfelse>&nbsp;</cfif>
</td></tr>
<tr><td class="title">ID</td><td class="title">Name</td><td class="title">URL</td><td class="title">User Name</td><td class="title">Password</td><td class="title">Description</td><td class="title">Pmt Method</td><td style="width:15px">&nbsp;</td><td style="width:15px">&nbsp;</td></tr>
<cfloop query="payees">
<tr><td class="left">#id#</td><td class="left">#name#</td><td class="left">#url#</td><td class="left">#user_name#</td><td class="left">#password#</td><td class="left">#description#</td><td class="left">#method#</td><td style="width:15px"><a href="https://www.millsclan.com/editpayee.cfm?id=#id#"><img border="none" width="15" height="15" src="images/b_edit.png" /></a></td><td style="width:15px"><a href="https://www.millsclan.com/deletepayee.cfm?id=#id#"><img border="none" width="15" height="15" src="images/X.gif" /></a></td></tr>
</cfloop>
<tr><td colspan="9" style="text-align:center"><input type="button" name="Add" onClick="javascript:window.location='https://www.millsclan.com/addpayee.cfm'" value="Add" /></td></tr>
</table>
</cfoutput>
</div>
<cfinclude template="footer.cfm">
</body>
</html>
