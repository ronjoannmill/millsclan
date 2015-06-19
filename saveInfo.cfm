<cftry>
<cfset murl = "admin.cfms">
<cfif structKeyExists(FORM,"selectInfo") AND Len(Trim(#form.selectInfo#)) gt 0>
	<cfset cid = #FORM.selectInfo#>
	<cfquery name="SaveInfo" datasource="#application.database#">
		update tblinfo set info = '#FORM.information#' where id = #cid#
	</cfquery>
	<cfset murl="admin.cfm?selectInfo=#cid#&msg='Save was successful'">
<cfelse>
	<cfset murl="admin.cfm">
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
<cflocation url="#murl#" addtoken="no">
