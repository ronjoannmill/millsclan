<cfif cgi.REQUEST_METHOD IS "GET">
	<cftry>
		<cfquery name="address" datasource="#application.database#">
			select * from address
		</cfquery>
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

<cfelseif cgi.REQUEST_METHOD IS "POST">
	<cfloop from="1" to="#form.count#" index="i">
		<cfset aryAddress[i] = StructNew()>
		<cfset aryAddress[i].name ="#form["aname_#i#"]#"> 
		<cfset aryAddress[i].addr ="#form["addr_#i#"]#"> 
		<cfset aryAddress[i].csz ="#form["csz_#i#"]#"> 
		<cfset aryAddress[i].phone ="#form["phone_#i#"]#"> 
		<cfset aryAddress[i].email ="#form["email_#i#"]#"> 
		<cfset aryAddress[i].cell1 ="#form["cell1_#i#"]#"> 
		<cfset aryAddress[i].cell2 ="#form["cell2_#i#"]#"> 
	</cfloop>
	<!---truncate table--->
	<cfquery name="killall" datasource="#application.database#">
		truncate table address
	</cfquery>
	<!---insert rows--->
	<cfloop from="1" to="#form.count#" index="k">
		<cfquery name="insertAddress" datasource="#application.database#">
			Insert into address (name,address,csz,phone,email,cell1,cell2)
			VALUES
			('#aryAddress[k].name#','#aryAddress[k].addr#','#aryAddress[k].csz#','#aryAddress[k].phone#','#aryAddress[k].email#','#aryAddress[k].cell1#','#aryAddress[k].cell2#')		
		</cfquery>
	</cfloop>
	<cflocation url="address.cfm" addtoken="no">	
</cfif>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>MillsClan Addresses</title>
<link rel="stylesheet" type="text/css" href="css/millsclan.css" />
</head>

<body style="text-align:center">
<cfinclude template="header.cfm">
<div class="address">
<cfoutput>
	<form name="addresses" action="editAddress.cfm" method="post">
		<table style="width:300px; text-align:center; border:none" align="center">
			<cfloop from="1" to="#address.recordcount#" index="j">
				<tr><td style="text-align:right"><input name="id_#j#" type="hidden" value="#address.id[j]#" />
				Name:</td><td style="text-align:left"><input name="aname_#j#" value="#address.name[j]#" /></td></tr>
				<cfif Len(trim(#address.address[j]#)) gt 0>
					<tr><td style="text-align:right">Address:</td><td style="text-align:left"><input type="text" name="addr_#j#" value="#address.address[j]#" /></td></tr>
				<cfelse>
					<tr><td style="text-align:right">Address:</td><td style="text-align:left"><input type="text" name="addr_#j#" value="No Address" /></td></tr>
				</cfif>
				<cfif Len(trim(#address.csz[j]#)) gt 0>
					<tr><td style="text-align:right">City, St Zip:</td><td style="text-align:left"><input type="text" name="csz_#j#" value="#address.csz[j]#" /></td></tr>
				<cfelse>
					<tr><td style="text-align:right">City, St Zip:</td><td style="text-align:left"><input type="text" name="csz_#j#" value="No City" /></td></tr>
				</cfif>
				<cfif Len(trim(#address.phone[j]#)) gt 0>
					<tr><td style="text-align:right">Phone:</td><td style="text-align:left"><input type="text" name="phone_#j#" value="#address.phone[j]#" /></td></tr>
				<cfelse>
					<tr><td style="text-align:right">Phone:</td><td style="text-align:left"><input type="text" name="phone_#j#" value="No Phone" /></td></tr>
				</cfif>
				<cfif Len(trim(#address.email[j]#)) gt 0>
					<tr><td style="text-align:right">Email:</td><td style="text-align:left"><input type="text" name="email_#j#" value="#address.email[j]#" /></td></tr>
				<cfelse>
					<tr><td style="text-align:right">Email:</td><td style="text-align:left"><input type="text" name="email_#j#" value="No Email" /></td></tr>
				</cfif>
				<cfif Len(trim(#address.cell1[j]#)) gt 0>
					<tr><td style="text-align:right">Cell 1:</td><td style="text-align:left"><input type="text" name="cell1_#j#" value="#address.cell1[j]#" /></td></tr>
				<cfelse>
					<tr><td style="text-align:right">Cell 1:</td><td style="text-align:left"><input type="text" name="cell1_#j#" value="No Cell" /></td></tr>
				</cfif>
				<cfif Len(trim(#address.cell2[j]#)) gt 0>
					<tr><td style="text-align:right">Cell 2:</td><td style="text-align:left"><input type="text" name="cell2_#j#" value="#address.cell2[j]#" /></td></tr>
				<cfelse>
					<tr><td style="text-align:right">Cell 2:</td><td style="text-align:left"><input type="text" name="cell2_#j#" value="No Cell" /></td></tr>
				</cfif>
				<tr><td colspan="2"><cfset count = #j#><hr style="width:300px" /></td></tr>
			</cfloop>
			<tr><td colspan="2" style="text-align:center"><button type="submit">Save</button></td></tr>
		</table><input type="hidden" name="count" value="#count#" />
	</form>
</cfoutput>
</div>
<cfinclude template="footer.cfm">
</body>
</html>
