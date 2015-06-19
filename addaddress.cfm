<cfset aryAddress = StructNew()>
<cfset aryAddress.name =""> 
<cfset aryAddress.addr =""> 
<cfset aryAddress.csz =""> 
<cfset aryAddress.phone =""> 
<cfset aryAddress.email =""> 
<cfset aryAddress.cell1 =""> 
<cfset aryAddress.cell2 =""> 

<cfif cgi.REQUEST_METHOD IS "POST">
		<cfset aryAddress = StructNew()>
		<cfset aryAddress.name ="#form["aname"]#"> 
		<cfset aryAddress.addr ="#form["addr"]#"> 
		<cfset aryAddress.csz ="#form["csz"]#"> 
		<cfset aryAddress.phone ="#form["phone"]#"> 
		<cfset aryAddress.email ="#form["email"]#"> 
		<cfset aryAddress.cell1 ="#form["cell1"]#"> 
		<cfset aryAddress.cell2 ="#form["cell2"]#"> 
	<!---insert rows--->
	<cfquery name="insertAddress" datasource="#application.database#">
		Insert into address (name,address,csz,phone,email,cell1,cell2)
		VALUES
		('#aryAddress.name#','#aryAddress.addr#','#aryAddress.csz#','#aryAddress.phone#','#aryAddress.email#','#aryAddress.cell1#','#aryAddress.cell2#')		
	</cfquery>
	<cflocation url="address.cfm" addtoken="no">	
</cfif>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>MillsClan Addresses</title>
<link rel="stylesheet" type="text/css" href="css/millsclan.css" />
<script language="javascript">
	function go(){
		window.location="index.cfm";
		return;
	}
</script>
</head>

<body style="text-align:center">
<cfinclude template="header.cfm">
<div class="address">
<cfoutput>
	<form name="addresses" action="addAddress.cfm" method="post">
		<table style="width:300px; text-align:center; border:none" align="center">
				<tr><td style="text-align:right">
				Name:</td><td style="text-align:left"><input name="aname" value="#aryAddress.name#" /></td></tr>
					<tr><td style="text-align:right">Address:</td><td style="text-align:left"><input type="text" name="addr" value="#aryAddress.addr#" /></td></tr>
					<tr><td style="text-align:right">City, St Zip:</td><td style="text-align:left"><input type="text" name="csz" value="#aryAddress.csz#" /></td></tr>
					<tr><td style="text-align:right">Phone:</td><td style="text-align:left"><input type="text" name="phone" value="#aryAddress.phone#" /></td></tr>
					<tr><td style="text-align:right">Email:</td><td style="text-align:left"><input type="text" name="email" value="#aryAddress.email#" /></td></tr>
					<tr><td style="text-align:right">Cell 1:</td><td style="text-align:left"><input type="text" name="cell1" value="#aryAddress.cell1#" /></td></tr>
					<tr><td style="text-align:right">Cell 2:</td><td style="text-align:left"><input type="text" name="cell2" value="#aryAddress.cell2#" /></td></tr>
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
