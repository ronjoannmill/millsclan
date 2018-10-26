<cfset result = TRUE>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Regenerate Password</title>
</head>

<body>
<h3>Generate Password</h3>
<!--- Do the following if the form has been submitted. --->
<cfif StructKeyExists(FORM,"myString")>
	<cftry>
		<cfset user = Trim(#form.username#)>
		<cfset pw = Trim(#form.myString#)><!---<cfdump var="#user# - #pw#"><cfabort>--->
		<cfset combo = #pw# & #user#>
		<cfset mhash = hash(#combo#, "SHA-512")>
		<cfset pwupdate = "">
		<cfset updateLogin = "">
		<cfquery name="updateLogin" datasource="#application.database#" result="pwupdate">
			update user set user_hash = <cfqueryparam value="#mhash#" cfsqltype="cf_sql_varchar" />
			where username = <cfqueryparam value="#user#" cfsqltype="cf_sql_varchar" /> 
		</cfquery>

	<cfcatch type="any">
		<cfmail 
			to="ron@millsclan.com" 
			from="ron@millsclan.com" 
			server="mail.millsclan.com" 
			username="ron@millsclan.com" 
			password="Wed1994!" 
			type="html" 
			subject="MillsClan Error - Login">
			Error Message - #cfcatch.Message#<br />
			Error Detail - #cfcatch.Detail#<br />
			<cfdump var="#cfcatch#">
		</cfmail>
		<cfdump var="#cfcatch#">
		<cfset result = FALSE>
	</cfcatch>
	</cftry>
   <!--- Display the values used for encryption and decryption, 
         and the results. --->
	<cfif result>
	   <cfoutput>
		  <b>Password Update Succeeded<br>
	   </cfoutput>
	<cfelse>
	   <cfoutput>
		  <b>Password Update Failed<br>
	   </cfoutput>
	</cfif>

</cfif>


<!--- The input form.  --->
<form action="regenpw.cfm" method="post">
<br />
<b>Enter user name:</b><br />
<input type="text" name="username" value="" />
<br>
   <b>Enter password to encrypt</b><br>
   <input type="text" name = "myString" value="" /><br>
   <input type = "Submit" value = "Generate Password">
</form>
</body>
</html>
