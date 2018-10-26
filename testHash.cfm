<cfscript>
	mname = "ronm";
	mpassword = "wed1994";
	mhash = "";
	mfullstring = mpassword & mname;
	mhash = hash(mfullstring, SHA512, 1);

</cfscript>
<cfdump var="#mname#">
<cfdump var="#mpassword#">
<cfdump var="#mhash#">
<cfdump var="#mfullstring#">
<cfdump var="#mhash#">
<cfabort>


