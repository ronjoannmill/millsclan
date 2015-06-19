<cfif structKeyExists(FORM,"selectInfo") AND Len(Trim(#form.selectInfo#)) gt 0>
	<cfset cid = #FORM.selectInfo#>
	<cfset msql = "where a.id = " & #cid#>
<cfelseif structKeyExists(URL,"selectInfo")>
	<cfset cid = #URL.selectInfo#>
	<cfset msql = "where a.id = " & #cid#>
<cfelse>
	<cfset msql = "">
	<cfset cid = "">
</cfif>

<cftry>
		<cfset minfo = "">
	<cfquery name="getNames" datasource="#application.database#">
		select a.id,b.familyname from tblinfo A join families B on a.id = b.id 
	</cfquery>
	<cfquery name="getInfo" datasource="#application.database#">
		select a.*,b.familyname from tblinfo A join families B on a.id = b.id #PreserveSingleQuotes(msql)# 
	</cfquery>
	<cfif #msql# neq "">
		<cfset minfo = #getInfo.info#>
	<cfelse>
		<cfset minfo = "">
	</cfif>		
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
<title>MillsClan Admin Page</title>
<link rel="stylesheet" type="text/css" href="css/millsclan.css" />
</head>

<body style="text-align:center">
<cfinclude template="header.cfm">
<div class="address">
<cfoutput>
<cftry>
	<br />
	<cfif structKeyExists(URL,"msg")>
		<div class="msg">#URL.msg#</div>
	</cfif>
	<form name="admin" action="admin.cfm" method="post">
		Select your name to edit information:<br />
		<select name="selectinfo">
			<option value="">Select</option>
			<cfloop query="getNames">
				<cfif #id# eq #cid#>
					<option value="#id#" selected="selected">#familyname#</option>
				<cfelse>
					<option value="#id#">#familyname#</option>
				</cfif>
			</cfloop>
		</select>&nbsp;&nbsp;<button type="submit">Go</button><br />
		</form>
	<form name="getInformation" action="saveInfo.cfm" method="post">
		<div class="admin">
			<textarea name="information" style="width:1010px; height:250px; overflow:hidden">#minfo#</textarea>
		</div><br />
		<input name="selectInfo" type="hidden" value="#cid#" />
		<button type="submit">Save</button><br />
	</form>
<cfcatch type="any">
	<cfmail 
		to="ron@millsclan.com" 
		from="ron@millsclan.com" 
		server="mail.millsclan.com" 
		username="ron@millsclan.com" 
		password="wed1994" 
		type="html" 
		subject="MillsClan Error - Admin">
		Error Message - #cfcatch.Message#<br />
		Error Detail - #cfcatch.Detail#<br />
		<cfdump var="#cfcatch#">
	</cfmail>
</cfcatch>
</cftry>
</cfoutput>
</div>
<cfinclude template="footer.cfm">
</body>
</html>
