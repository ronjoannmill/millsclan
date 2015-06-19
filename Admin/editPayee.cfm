<cfif StructKeyExists(URL,"id")>
	<cfset pid = #URL.id#>
<cfelse>
	<cfset pid = 0>
</cfif>

<cfset aryPayee = StructNew()>
<cfset aryPayee.name =""> 
<cfset aryPayee.URL =""> 
<cfset aryPayee.user_name =""> 
<cfset aryPayee.password =""> 
<cfset aryPayee.description =""> 
<cfset aryPayee.payment_method =""> 
<cfset aryPayee.date_created =""> 

<cfquery name="getPayee" datasource="#application.database#">
	select * from payees where id = #pid#
</cfquery>

<cfquery name="getMethods" datasource="#application.database#">
	select id,payment_method from payment_methods order by payment_method
</cfquery>

<cfset aryPayee.name ="#getPayee.name#"> 
<cfset aryPayee.URL ="#getPayee.URL#"> 
<cfset aryPayee.user_name ="#getPayee.user_name#"> 
<cfset aryPayee.password ="#getPayee.password#"> 
<cfset aryPayee.description ="#getPayee.description#"> 
<cfset aryPayee.payment_method ="#getPayee.payment_method#"> 

<cfif cgi.REQUEST_METHOD IS "POST">
		<cfset aryPayee = StructNew()>
		<cfset aryPayee.name ="#form["name"]#"> 
		<cfset aryPayee.URL ="#form["URL"]#"> 
		<cfset aryPayee.user_name ="#form["user_name"]#"> 
		<cfset aryPayee.password ="#form["password"]#"> 
		<cfset aryPayee.description ="#form["description"]#"> 
		<cfset aryPayee.payment_method ="#form["payment_method"]#"> 
	<!---insert rows--->
	<cftry>
		<cfquery name="updatePayee" datasource="#application.database#">
			UPDATE payees 
				SET
					name = <cfqueryparam value="#aryPayee.name#" CFSQLType="cf_sql_varchar" />,
					URL = <cfqueryparam value="#aryPayee.URL#" CFSQLType="cf_sql_varchar" />,
					user_name = <cfqueryparam value="#aryPayee.user_name#" CFSQLType="cf_sql_varchar" />,
					password = <cfqueryparam value="#aryPayee.password#" CFSQLType="cf_sql_varchar" />,
					description = <cfqueryparam value="#aryPayee.description#" CFSQLType="cf_sql_varchar" />,
					payment_method = <cfqueryparam value="#aryPayee.payment_method#" CFSQLType="cf_sql_integer" />
				WHERE id = <cfqueryparam value="#pid#" CFSQLType="cf_sql_integer" />
		</cfquery>
	<cfcatch type="database">
		<cfmail 
			to="ron@millsclan.com" 
			from="ron@millsclan.com" 
			server="mail.millsclan.com" 
			username="ron@millsclan.com" 
			password="wed1994" 
			type="html" 
			subject="MillsClan Error - Edit payee">
			Error Message - #cfcatch.Message#<br />
			Error Detail - #cfcatch.Detail#<br />
			<cfdump var="#cfcatch#">
		</cfmail>
	</cfcatch>
	</cftry>
	<cflocation url="payee.cfm" addtoken="no">	
</cfif>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>MillsClan Edit Payees</title>
<link rel="stylesheet" type="text/css" href="css/millsclan.css" />
<script language="javascript">
	function go(){
		window.location="payee.cfm";
		return;
	}
</script>
</head>

<body style="text-align:center">
<cfinclude template="header.cfm">
<div class="address">
<cfoutput>
	<form name="payees" action="https://www.millsclan.com/editpayee.cfm?id=#pid#" method="post">
		<table style="width:300px; text-align:center; border:none" align="center">
				<tr><td style="text-align:right">
					<tr><td style="text-align:right">Name:</td><td style="text-align:left"><input type="text" name="name" value="#aryPayee.name#" /></td></tr>
					<tr><td style="text-align:right">URL:</td><td style="text-align:left"><input type="text" name="url" value="#aryPayee.url#" /></td></tr>
					<tr><td style="text-align:right">User Name:</td><td style="text-align:left"><input type="text" name="user_name" value="#aryPayee.user_name#" /></td></tr>
					<tr><td style="text-align:right">Password:</td><td style="text-align:left"><input type="text" name="password" value="#aryPayee.password#" /></td></tr>
					<tr><td style="text-align:right">Description:</td><td style="text-align:left"><input type="text" name="description" value="#aryPayee.description#" /></td></tr>
					<tr><td style="text-align:right">Payment Method:</td><td style="text-align:left">
					<select name="payment_method">
						<cfloop query="getMethods">
							<cfif aryPayee.payment_method eq id>
								<option value="#id#" selected="selected">#payment_method#</option>
							<cfelse>
								<option value="#id#">#payment_method#</option>
							</cfif>
						</cfloop>
					</select>
					</td></tr>
				<tr><td colspan="2"><hr style="width:300px" /></td></tr>
			<tr><td colspan="2" style="text-align:center"><button type="submit">Save</button></td></tr>
			<tr><td colspan="2" style="text-align:center"><button type="button" onclick="go();">Cancel</button></td></tr>
		</table>
	</form>
</cfoutput>
</div>
<cfinclude template="footer.cfm">
</body>
</html>
