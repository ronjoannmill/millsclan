<cfif structKeyExists(request, "loggedin")>
	<cfif not request.loggedin>
		<cfset returnURL = "#cgi.script_name#?#cgi.query_string#">
		<cflocation url="payeelogin.cfm?msg=Login Failed" addtoken="false">
	</cfif>
</cfif>
	