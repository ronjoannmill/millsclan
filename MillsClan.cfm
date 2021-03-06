<cfquery name="getAddresses" datasource="#application.database#">
    select * from address
</cfquery>
<cfset mbgNumber = "">
<cfset mday = day(now())>
<cfif (mday mod 2) eq 1>
    <cfset mbgNumber = 1>
</cfif>
<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Mills Family</title>

    <!-- Bootstrap Core CSS -->
    <link href="assets/css/bootstrap/bootstrap.min.css" rel="stylesheet" type="text/css">

    <!-- Retina.js - Load first for faster HQ mobile images. -->
    <script src="assets/js/plugins/retina/retina.min.js"></script>

    <!-- Font Awesome -->
    <link href="assets/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">

    <!-- Default Fonts -->
    <link href='http://fonts.googleapis.com/css?family=Roboto:400,100,100italic,300,300italic,400italic,500,500italic,700,700italic,900,900italic' rel='stylesheet' type='text/css'>
    <link href='http://fonts.googleapis.com/css?family=Raleway:400,100,200,300,600,500,700,800,900' rel='stylesheet' type='text/css'>

    <!-- Modern Style Fonts (Include these is you are using body.modern!) -->
    <link href='http://fonts.googleapis.com/css?family=Montserrat:400,700' rel='stylesheet' type='text/css'>
    <link href='http://fonts.googleapis.com/css?family=Cardo:400,400italic,700' rel='stylesheet' type='text/css'>

    <!-- Vintage Style Fonts (Include these if you are using body.vintage!) -->
    <link href='http://fonts.googleapis.com/css?family=Sanchez:400italic,400' rel='stylesheet' type='text/css'>
    <link href='http://fonts.googleapis.com/css?family=Cardo:400,400italic,700' rel='stylesheet' type='text/css'>

    <!-- Plugin CSS -->
    <link href="assets/css/plugins/owl-carousel/owl.carousel.css" rel="stylesheet" type="text/css">
    <link href="assets/css/plugins/owl-carousel/owl.theme.css" rel="stylesheet" type="text/css">
    <link href="assets/css/plugins/owl-carousel/owl.transitions.css" rel="stylesheet" type="text/css">
    <link href="assets/css/plugins/magnific-popup.css" rel="stylesheet" type="text/css">
    <link href="assets/css/plugins/jquery.fs.wallpaper.css" rel="stylesheet" type="text/css">
    <link href="assets/css/plugins/animate.css" rel="stylesheet" type="text/css">

    <!-- Vitality Theme CSS -->
    <!-- Uncomment the color scheme you want to use. -->
    <!-- <link href="assets/css/vitality-red.css" rel="stylesheet" type="text/css"> -->
    <!-- <link href="assets/css/vitality-aqua.css" rel="stylesheet" type="text/css"> -->
    <!-- <link href="assets/css/vitality-blue.css" rel="stylesheet" type="text/css"> -->
    <!-- <link href="assets/css/vitality-green.css" rel="stylesheet" type="text/css"> -->
    <!-- <link href="assets/css/vitality-orange.css" rel="stylesheet" type="text/css"> -->
    <!-- <link href="assets/css/vitality-pink.css" rel="stylesheet" type="text/css"> -->
    <!-- <link href="assets/css/vitality-purple.css" rel="stylesheet" type="text/css"> -->
    <!-- <link href="assets/css/vitality-tan.css" rel="stylesheet" type="text/css"> -->
    <link href="assets/css/vitality-turquoise.css" rel="stylesheet" type="text/css">
    <!-- <link href="assets/css/vitality-yellow.css" rel="stylesheet" type="text/css"> -->

    <!-- IE8 support for HTML5 elements and media queries -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
      <script src="https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
    <![endif]-->

</head>

<!-- Alternate Body Classes: .modern and .vintage -->

<body id="page-top">

    <!-- Navigation -->
    <!-- Note: navbar-default and navbar-inverse are both supported with this theme. -->
    <nav class="navbar navbar-inverse navbar-fixed-top navbar-expanded">
        <div class="container">
            <!-- Brand and toggle get grouped for better mobile display -->
            <div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand page-scroll" href="#page-top">
                    <img src="assets/img/MillsClanlogo.gif" class="img-responsive" alt="">
                </a>
            </div>

            <!-- Collect the nav links, forms, and other content for toggling -->
            <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                <ul class="nav navbar-nav navbar-right">
                    <li class="hidden">
                        <a class="page-scroll" href="#page-top"></a>
                    </li>
                    <li>
                        <a class="page-scroll" href="#ronjoann">Ron & Jo Ann</a>
                    </li>
                    <li>
                        <a class="page-scroll" href="#James">James & Robyn</a>
                    </li>
                    <li>
                        <a class="page-scroll" href="#Mindy">Leonel & Mindy</a>
                    </li>
                    <li>
                        <a class="page-scroll" href="#Jocelyn">Jocelyn</a>
                    </li>
                    <li>
                        <a class="page-scroll" href="#Andrew">Andrew</a>
                    </li>
                    <li>
                        <a class="page-scroll" href="#addresses">Addresses</a>
                    </li>
                </ul>
            </div>
            <!-- /.navbar-collapse -->
        </div>
        <!-- /.container -->
    </nav>

    <cfoutput>
    <header style="background-image: url('assets/img/MillsclanBackground#mbgNumber#.jpg');">
        <div class="intro-content">
            <!-- <img src="assets/img/creative/profile.png" class="img-responsive img-centered" alt=""> -->
            <div class="brand-name"></div>
            <hr class="colored">
            <div class="brand-name-subtext">An Online Look at our Family</div>
        </div>
    </cfoutput>
        <!--- <div class="scroll-down">
            <a class="btn page-scroll" href="#ronjoann"><i class="fa fa-angle-down fa-fw"></i></a>
        </div> --->
    </header>

    <section id="ronjoann">
        <div class="container wow fadeIn">
            <div class="row">
                <div class="col-md-6">
                    <img src="assets/img/ronjoann.jpeg" class="img-responsive" alt="">
                </div>
                <div class="col-md-6 text-center">
                    <h1>Ron <a href="payeelogin.cfm">&</a> Jo Ann</h1>
                    <hr class="colored">
                    <p>We are actual empty nesters now.  What a strange feeling! Andrew is enjoying his fist year of college at Doane University in Nebraska. Family is doing great and kids and grandkids are nice and close. Jo Ann is spending all the time she can with the twin grandbabies!</p>
                    <p>Please note that all of the pictures used as backgrounds on this site were taken by us in our area with the exception of Andrew's address background.  His is a picture from his college campus.  The time of year is obviously the fall season.</p>
                </div>
            </div>
        </div>
    </section>

    <section id="James">
        <div class="container wow fadeIn">
            <div class="row">
                <div class="col-md-6">
                    <img src="assets/img/JamesRobyn.jpg" class="img-responsive" alt="">
                </div>
                <div class="col-md-6 text-center">
                    <h1>James & Robyn</h1>
                    <hr class="colored">
                    <p>James and Robyn lead the typical life with three young children.  James is working from home and Robyn is the head cab driver for the three kids.</p>
                    <p>Their kids are doing great and are enjoying school! </p>
                </div>
            </div>
        </div>
    </section>

    <section id="Mindy">
        <div class="container wow fadeIn">
            <div class="row">
                <div class="col-md-6">
                    <img src="assets/img/AshlynnCheer.jpg" class="img-responsive" alt="">
                </div>
                <div class="col-md-6 text-center">
                    <h1>Leonel & Mindy</h1>
                    <hr class="colored">
                    <p>Leonel is working hard at a local Pest Control company and loving the change of pace from Wal Mart. Mindy is still nursing away at Presbyterian of PLano. LJ is a junior in high school and Ashlynn is in 7th grade.</p>
                    <p>LJ enjoys driving and spending time with his girlfriend. Ashlynn is now a cheerleader.</p>
                    <p>Ashlynn gets the most pictures since she is always in the spotlight.   This is one of her cheerleading pics.</p>
                </div>
            </div>
        </div>
    </section>

    <section id="Jocelyn">
        <div class="container wow fadeIn">
            <div class="row">
                <div class="col-md-6">
                    <img src="assets/img/TwinsFathersDay.jpg" class="img-responsive" alt="">
                </div>
                <div class="col-md-6 text-center">
                    <h1>Jocelyn</h1>
                    <hr class="colored">
                    <p>Jocelyn and Jeremy are still living in Lowry Crossing, just northwest of McKinney.  Her twins are 20 months old now and definitely rule their kingdom! They are beautiful and do not lack for spoiling from MawMaw. (I never spoil grandkids!)</p>
                    <p>She is an excellent mother! (No bull!) This picture was their Father's Day gift to Jeremy</p>
                </div>
            </div>
        </div>
    </section>

    <section id="Andrew">
        <div class="container wow fadeIn">
            <div class="row">
                <div class="col-md-6">
                    <img src="assets/img/AndrewDoane.jpg" class="img-responsive" alt="">
                </div>
                <div class="col-md-6 text-center">
                    <h1>Andrew</h1>
                    <hr class="colored">
                    <p>This is Andrew's freshmen football photo at Doane University.</p>
                    <p>He is having fun and doing well his Freshmen year. Mom still says he is too far away!</p>
                </div>
            </div>
        </div>
    </section>


    <section id="addresses" class="bg-gray">
        <div class="container text-center wow fadeIn">
            <h2>Family Addresses</h2>
            <hr class="colored">
            <p>Use the scroll arrows to view all.</p>
        </div>
    </section>

    <section class="portfolio-carousel wow fadeIn">
        <cfoutput query="getAddresses">
            <div class="item" style="background-image: url('assets/img/millsclanlogo#imageID#.jpg')">
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-md-4 col-md-push-8">
                            <div class="stars">
                                <i class="fa">#Name#</i><br />
                                <i class="fa">#address#</i><br />
                                <i class="fa">#csz#</i><br />
                                <i class="fa">#phone#</i><br />
                                <i class="fa">#email#</i><br />
                                <i class="fa">#cell1#</i><br />
                                <i class="fa">#cell2#</i><br />
                            </div>
                        </div>
                        <!--- <div class="col-md-8 col-md-pull-4 hidden-xs">
                            <img src="assets/img/portfolio/bg-4.png" class="img-responsive portfolio-image" alt="">
                        </div> --->
                    </div>
                </div>
            </div>
        </cfoutput>
    </section>


    <!-- Core Scripts -->
    <script src="assets/js/jquery.js"></script>
    <script src="assets/js/bootstrap/bootstrap.min.js"></script>

    <!-- Plugin Scripts -->
    <script src="assets/js/plugins/jquery.easing.min.js"></script>
    <script src="assets/js/plugins/classie.js"></script>
    <script src="assets/js/plugins/cbpAnimatedHeader.js"></script>
    <script src="assets/js/plugins/owl-carousel/owl.carousel.js"></script>
    <script src="assets/js/plugins/jquery.magnific-popup/jquery.magnific-popup.min.js"></script>
    <script src="assets/js/plugins/jquery.fs.wallpaper.js"></script>
    <script src="assets/js/plugins/jquery.mixitup.js"></script>
    <script src="assets/js/plugins/wow/wow.min.js"></script>
    <script src="assets/js/contact_me.js"></script>
    <script src="assets/js/plugins/jqBootstrapValidation.js"></script>

    <!-- Vitality Theme Scripts -->
    <script src="assets/js/vitality.js"></script>

</body>

</html>
