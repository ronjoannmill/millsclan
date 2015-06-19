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
<cfif IsDefined("Form.myString")>
   <cfscript>
		userObj = createObject("component", "#request.componentRoot#.user").init();
   </cfscript>
	<cfquery name="getID" datasource="#request.dsn#">
		SELECT id FROM user WHERE username = <cfqueryparam value="#form.username#" cfsqltype="cf_sql_varchar" />
	</cfquery>
	
	<cfif getID.recordcount gt 0>
		<cfset mid = getID.id>
		<cfset result = userObj.updateUserPassword(userID=#mid#,password=#form.myString#,resetLoginDate=TRUE)>   
	<cfelse>
		<cfset result = FALSE>
	</cfif>

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
