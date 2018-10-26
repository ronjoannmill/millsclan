<cfset session.loggedin = false>
<cfset m = structClear(session)>
<cflocation url="millsclan.cfm" addtoken="false">
