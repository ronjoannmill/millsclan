<!---page to allow update of information--->
<cftry>
	<cfquery name="getnames" datasource="#application.database#">
		select id,familyname from families order by familyname
	</cfquery>
	<cfquery name="getInfo" datasource="#application.database#">
		select * from info order by familyid
	</cfquery>
<cfcatch type="database">
</cfcatch>
</cftry>

<cfscript>
	familyid = "";
	
</cfscript>
<cfif StructKeyExists(URL,"id")>
	<cfset familyid = #URL.id#>
</cfif>

<cfif cgi.REQUEST_METHOD IS "GET">

</cfif>

<cfif cgi.REQUEST_METHOD IS "POST"><!---POST--->
	<cfif structkeyexists(FORM,"id")>
		<cfset familyid = #FORM.id#>
		<cfquery name="checkfordata" datasource="#application.database#">
			select count(*) as Count from info where familyid = #familyid#
		</cfquery>
		<cfif checkfordata.count gt 0>
			<cfquery name="updateinfo" datasource="#application.database#">
				update info set info = '#FORM.textinfo#'
				where familyid = #familyid#
			</cfquery>
		<cfelse>
			<cfquery name="updateinfo" datasource="#application.database#">
				insert into info (familyid,info) VALUE (#familyid#,'#FORM.textinfo#')
			</cfquery>
		</cfif>
	</cfif>

</cfif>

<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>The Mills Family</title>
</head>
<body>
<p style="text-align:center"><img src="./images/family_mix.jpg" width="640" /></p><br />
<cfform id="selectFamily" action="addinfo.cfm" method="get">
	<p style="text-align:center">
	<cfselect name="id" query="getnames" label="familyname" value="id" display="familyname" selected="#familyid#"  />
	</p><p style="text-align:center"><button type="submit">Select</button></p>
</cfform>

<cfform id="info" action="addinfo.cfm" method="post">
	<cfif len(trim(familyid)) gt 0>
		<input type="hidden" value="#familyid#"  name="id" />
		<cfquery dbtype="query" name="showinfo">
			select info from getinfo where familyid = #familyid#
		</cfquery>
		<cfset minfo = "">
		<cfif showinfo.recordcount gt 0>
			<cfset minfo = showinfo.info>
		</cfif>
		<p style="text-align:center">
		<textarea rows="20" cols="80" wrap="hard" name="textinfo">
			#minfo#
		</textarea></p><br />
		<p style="text-align:center"><button type="submit">Save</button></p>
	</cfif>

</cfform>
</body>
</html></cfoutput>
