<cfset session.loggedin = FALSE>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>MillsClan Addresses</title>
<link rel="stylesheet" type="text/css" href="css/millsclan.css" />

<style TYPE="text/css">
<!--  A:hover	{color:red} -->
</style>

<SCRIPT LANGUAGE="JavaScript">

function heatdIndex(form) {
	var tmpf = parseFloat(stripBad(form.temp.value));
	var dwpf = parseFloat(stripBad(form.dew.value));
	if ((isNaN(tmpf)) || (isNaN(dwpf))) {
	form.heatindex.value = " ???";
	form.humidity.value = " ???"}
	else {
	dwpc=5/9*(dwpf-32)
	tmpc=5/9*(tmpf-32)
	e=6.112*(Math.exp((17.67*dwpc)/(dwpc+243.5)));
	es=6.112*(Math.exp((17.67*tmpc)/(tmpc+243.5)));
	rhcalc=(e/es)*100
	var relh = gesult(rhcalc);
	heatb=61+(tmpf-68)*1.2+relh*.094
	var t2 = Math.pow(tmpf,2)
	var t3 = Math.pow(tmpf,3)
	var r2 = Math.pow(relh,2)
	var r3 = Math.pow(relh,3)
	heata=17.423+0.185212*tmpf+5.37941*relh-0.100254*tmpf*relh+
		0.941695*(Math.pow(10,-2))*t2+0.728898*(Math.pow(10,-2))*r2+
		0.345372*(Math.pow(10,-3))*t2*relh-0.814971*(Math.pow(10,-3))*tmpf*r2+
		0.102102*(Math.pow(10,-4))*t2*r2-0.38646*(Math.pow(10,-4))*t3+
		0.291583*(Math.pow(10,-4))*r3+0.142721*(Math.pow(10,-5))*t3*relh+
		0.197483*(Math.pow(10,-6))*tmpf*r3-0.218429*(Math.pow(10,-7))*t3*r2+
		0.843296*(Math.pow(10,-9))*t2*r3-0.481975*(Math.pow(10,-10))*t3*r3
	var heat = gesult(heata);
	heat=(tmpf < 70) ? tmpf : heat;
	relh=(tmpf < 70) ? " " : relh;
	form.heatindex.value = " " + heat + " °";
	form.humidity.value = " " + relh + " %";}
}

function heatdcIndex(form) {
	var tmpf = parseFloat(stripBad(form.temp.value));
	var ctmpf = tmpf
	var dwpf = parseFloat(stripBad(form.dew.value));
	if ((isNaN(tmpf)) || (isNaN(dwpf))) {
	form.heatindex.value = " ???";
	form.humidity.value = " ???"}
	else {
	tmpf= (tmpf*(9/5))+32
	dwpf= (dwpf*(9/5))+32
	dwpc=5/9*(dwpf-32)
	tmpc=5/9*(tmpf-32)
	e=6.112*(Math.exp((17.67*dwpc)/(dwpc+243.5)));
	es=6.112*(Math.exp((17.67*tmpc)/(tmpc+243.5)));
	rhcalc=(e/es)*100
	var relh = gesult(rhcalc);
	heatb=61+(tmpf-68)*1.2+relh*.094
	var t2 = Math.pow(tmpf,2)
	var t3 = Math.pow(tmpf,3)
	var r2 = Math.pow(relh,2)
	var r3 = Math.pow(relh,3)
	heata=17.423+0.185212*tmpf+5.37941*relh-0.100254*tmpf*relh+
		0.941695*(Math.pow(10,-2))*t2+0.728898*(Math.pow(10,-2))*r2+
		0.345372*(Math.pow(10,-3))*t2*relh-0.814971*(Math.pow(10,-3))*tmpf*r2+
		0.102102*(Math.pow(10,-4))*t2*r2-0.38646*(Math.pow(10,-4))*t3+
		0.291583*(Math.pow(10,-4))*r3+0.142721*(Math.pow(10,-5))*t3*relh+
		0.197483*(Math.pow(10,-6))*tmpf*r3-0.218429*(Math.pow(10,-7))*t3*r2+
		0.843296*(Math.pow(10,-9))*t2*r3-0.481975*(Math.pow(10,-10))*t3*r3
	heata = (heata-32)*(5/9)
	var heat = gesult(heata);
	heat=(ctmpf < 21.11) ? ctmpf : heat;
	relh=(ctmpf < 21.11) ? " " : relh;
	form.heatindex.value = " " + heat + " °";
	form.humidity.value = " " + relh + " %";}
}

function GetNumber2h(form) {
	var wchill = 0
	var F = parseFloat(stripBad(form.txtNumber.value));
	var rh = parseFloat(stripBad(form.txtNumbe2.value));
	if ((isNaN(F)) || (isNaN(rh))) {
	form.txtResult.value=" ???"}
	else {
	wchill = heatIndex(F, rh)
	wchill=gesult(wchill);

	wchill=(F < 70) ? F : wchill;
	form.txtResult.value = wchill + " °"}
}

function GetNumber3h(form) {
	var wchill = 0
	var C = parseFloat(stripBad(form.txtNumber.value));
	var rh = parseFloat(stripBad(form.txtNumbe2.value));
	if ((isNaN(C)) || (isNaN(rh))) {
	form.txtResult.value=" ???"}
	else {
	var F = (C*(9/5))+32
	wchill = heatIndex(F, rh)
	var C2 = (wchill-32)*(5/9)
	wchill=gesult(C2);

	wchill=(F < 70) ? C : wchill;
	form.txtResult.value = wchill + " °"}
}

function heatIndex(F, rh)
	{
	var Hindex;
				
	Hindex = -42.379 + 2.04901523*F + 10.14333127*rh 
	- 0.22475541*F*rh - 6.83783*Math.pow(10,-3)*Math.pow(F, 2)
	- 5.481717*Math.pow(10,-2)*Math.pow(rh, 2)
	+ 1.22874*Math.pow(10,-3)*Math.pow(F, 2)*rh 
	+ 8.5282*Math.pow(10,-4)*F*Math.pow(rh, 2) 
	- 1.99*Math.pow(10,-6)*Math.pow(F, 2)*Math.pow(rh, 2);
		return Hindex;
	}

function GetNumber2(form) {
	var wchill = 0
	var temp = parseFloat(stripBad(form.txtNumber.value));
	var wind = parseFloat(stripBad(form.txtNumbe2.value));
	if ((isNaN(temp)) || (isNaN(wind))) {
	form.txtResult.value=" ???"}
	else {
	wchill=(35.74+0.6215*temp-35.75*Math.pow(wind,0.16)+0.4275*temp*Math.pow(wind,0.16));
	wchill=gesult(wchill);
	wchill=(wind <= 3) ? temp : wchill;
	wchill=(temp > 50) ? temp : wchill;
	form.txtResult.value = wchill + " °"}
}

function GetNumber3(form) {
	var wchill = 0
	var temp = parseFloat(stripBad(form.txtNumber.value));
	var wind = parseFloat(stripBad(form.txtNumbe2.value));
	if ((isNaN(temp)) || (isNaN(wind))) {
	form.txtResult.value=" ???"}
	else {
	wchill=(13.12+0.6215*temp-11.37*Math.pow(wind,0.16)+0.3965*temp*Math.pow(wind,0.16));
	wchill=gesult(wchill);
	wchill=(wind <=4.8) ? temp : wchill;
	wchill=(temp > 10) ? temp : wchill;
	form.txtResult.value = wchill + " °"}
}

function GetNumber4(form) {
	var wchill = 0
	var temp = parseFloat(stripBad(form.txtNumber.value));
	var wind = parseFloat(stripBad(form.txtNumbe2.value));
	if ((isNaN(temp)) || (isNaN(wind))) {
	form.txtResult.value=" ???"}
	else {
	wind = 0.6213711922373341 * wind;
	wchill=(35.74+0.6215*temp-35.75*Math.pow(wind,0.16)+0.4275*temp*Math.pow(wind,0.16));
	wchill=gesult(wchill);
	wchill=(wind <= 4.8) ? temp : wchill;
	wchill=(temp > 50) ? temp : wchill;
	form.txtResult.value = wchill + " °"}
}

function GetNumber5(form) {
	var wchill = 0
	var temp = parseFloat(stripBad(form.txtNumber.value));
	var wind = parseFloat(stripBad(form.txtNumbe2.value));
	if ((isNaN(temp)) || (isNaN(wind))) {
	form.txtResult.value=" ???"}
	else {
	wind = 1.609344 * wind;
	wchill=(13.12+0.6215*temp-11.37*Math.pow(wind,0.16)+0.3965*temp*Math.pow(wind,0.16));
	wchill=gesult(wchill);
	wchill=(wind <=3) ? temp : wchill;
	wchill=(temp > 10) ? temp : wchill;
	form.txtResult.value = wchill + " °"}
}

function GetNumber6(form) {
	var wchill = 0
	var temp = parseFloat(stripBad(form.txtNumber.value));
	var wind = parseFloat(stripBad(form.txtNumbe2.value));
	if ((isNaN(temp)) || (isNaN(wind))) {
	form.txtResult.value=" ???"}
	else {
	wind = wind*1.852;
	wind = 0.6213711922373341 * wind;
	wchill=(35.74+0.6215*temp-35.75*Math.pow(wind,0.16)+0.4275*temp*Math.pow(wind,0.16));
	wchill=gesult(wchill);
	wchill=(wind <= 4.8) ? temp : wchill;
	wchill=(temp > 50) ? temp : wchill;
	form.txtResult.value = wchill + " °"}
}

function GetNumber7(form) {
	var wchill = 0
	var temp = parseFloat(stripBad(form.txtNumber.value));
	var wind = parseFloat(stripBad(form.txtNumbe2.value));
	if ((isNaN(temp)) || (isNaN(wind))) {
	form.txtResult.value=" ???"}
	else {
	wind = wind*1.852;
	wchill=(13.12+0.6215*temp-11.37*Math.pow(wind,0.16)+0.3965*temp*Math.pow(wind,0.16));
	wchill=gesult(wchill);
	wchill=(wind <=4.8) ? temp : wchill;
	wchill=(temp > 10) ? temp : wchill;
	form.txtResult.value = wchill + " °"}
}

function stripBad(string) {
    for (var i=0, output='', valid="eE-0123456789."; i<string.length; i++)
       if (valid.indexOf(string.charAt(i)) != -1)
          output += string.charAt(i)
    return output;
}

function gesult(ff){

 if (Number.prototype.toFixed) {
   ff = ff.toFixed(2);
   ff = parseFloat(ff);
 }
 else {
   var leftSide = Math.floor(ff);
   var rightSide = ff - leftSide;
   ff = leftSide + Math.round(rightSide *1e+14)/1e+14;
 }

 return ff;
}
</script>

</head>

<body style="text-align:center">
<cfinclude template="header.cfm">
<div class="address"><br /><br />

<a name = "top"><H2> </H2></a>
<CENTER><H1>Heat Index & Wind Chill Temperature Calculator</H1></CENTER>
<HR COLOR="navy" WIDTH="100%"></P>

<a name = "fkph"></a>
<FORM>
<FONT SIZE=5><B>Calculate Heat Index for Fahrenheit</B></FONT>
<BLOCKQUOTE>
Enter Air Temperature in number of degrees Fahrenheit: <INPUT TYPE="text" NAME="txtNumber" SIZE=6><BR>
Enter Relative Humidity: <INPUT TYPE="text" NAME="txtNumbe2" SIZE=4> <B>%</B><BR>

<INPUT TYPE="button" VALUE="Calculate Heat Index" class="b2t" onclick="GetNumber2h(this.form)">  <INPUT TYPE="text" NAME="txtResult"  SIZE=6><B><FONT SIZE=+1> Fahrenheit </FONT></B>
<input type="reset" class="b3t">
</BLOCKQUOTE>
</FORM>
<BR><BR>

<a name = "fmph"></a>
<FORM>
<FONT SIZE=5><B>Calculate Wind Chill given Fahrenheit & Miles Per Hour</B></FONT>
<BLOCKQUOTE>
Enter Air Temperature in number of degrees Fahrenheit: <INPUT TYPE="text" NAME="txtNumber" SIZE=6><BR>

EnterWind Speed in miles per hour (MPH): <INPUT TYPE="text" NAME="txtNumbe2" SIZE=4><BR>
<INPUT TYPE="button" VALUE="Calculate Wind Chill" class="b2t" onclick="GetNumber2(this.form)"> <INPUT TYPE="text" NAME="txtResult"  SIZE=6><B><FONT SIZE=+1> Fahrenheit </FONT></B>
<input type="reset" class="b3t">
</BLOCKQUOTE>
</FORM>
<BR><BR>


</div>
<cfinclude template="footer.cfm">
</BODY>
</HTML>

