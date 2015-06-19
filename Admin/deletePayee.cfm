<cfif StructKeyExists(URL,"id")>
	<cfset pid = #URL.id#>
<cfelse>
	<cfset pid = 0>
</cfif>

<cfif #pid# neq 0>
	<cfquery name="DeletePayee" datasource="#application.database#">
		update payees set active = 0 where id = #pid#
	</cfquery>
	<cfset mmsg = "Record succesfully deleted.">
<cfelse>
	<cfset mmsg = "">
</cfif>
<cflocation url="https://www.millsclan.com/payee.cfm?msg=#mmsg#" addtoken="no">	

