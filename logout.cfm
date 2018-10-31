<cfset session.loggedin = false>
<cfcookie name="CFID" value="1" domain="www.millsclan.com" />
<cfcookie name="CFID" value="1" domain="www.millsclan.com" />
<cfcookie name="cftoken" value="" domain="www.millsclan.com" expires="now" /> 
<cfcookie name="cftoken" value="" domain="www.millsclan.com" expires="now" /> 
<cfset m = structClear(session)>
<cflocation url="millsclan.cfm" addtoken="false">
