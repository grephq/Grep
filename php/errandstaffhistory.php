<?php
    require 'db_connect.php';

    if($_SESSION['fname'] == ""){
       header("Location: login.php");
    }
   
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <!-- Required meta tags-->
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="au theme template">
    <meta name="author" content="Hau Nguyen">
    <meta name="keywords" content="au theme template">

    <!-- Title Page-->
    <title>History</title>

    <!-- Fontfaces CSS-->
    <link href="css/font-face.css" rel="stylesheet" media="all">
    <link href="vendor/font-awesome-4.7/css/font-awesome.min.css" rel="stylesheet" media="all">
    <link href="vendor/font-awesome-5/css/fontawesome-all.min.css" rel="stylesheet" media="all">
    <link href="vendor/mdi-font/css/material-design-iconic-font.min.css" rel="stylesheet" media="all">

    <!-- Bootstrap CSS-->
    <link href="vendor/bootstrap-4.1/bootstrap.min.css" rel="stylesheet" media="all">

    <!-- Vendor CSS-->
    <link href="vendor/animsition/animsition.min.css" rel="stylesheet" media="all">
    <link href="vendor/bootstrap-progressbar/bootstrap-progressbar-3.3.4.min.css" rel="stylesheet" media="all">
    <link href="vendor/wow/animate.css" rel="stylesheet" media="all">
    <link href="vendor/css-hamburgers/hamburgers.min.css" rel="stylesheet" media="all">
    <link href="vendor/slick/slick.css" rel="stylesheet" media="all">
    <link href="vendor/select2/select2.min.css" rel="stylesheet" media="all">
    <link href="vendor/perfect-scrollbar/perfect-scrollbar.css" rel="stylesheet" media="all">

    <!-- Main CSS-->
    <link href="css/theme.css" rel="stylesheet" media="all">

</head>

<body class="animsition">
    <div class="page-wrapper">
        <!-- HEADER DESKTOP-->
        <header class="header-desktop3 d-none d-lg-block">
            <div class="section__content section__content--p35">
                <div class="header3-wrap">
                    <div class="header__logo">
                        <a href="#">
                            <img src="images/icon/logo-white.png" alt="#" />
                        </a>
                    </div>
                    <div class="header__tool">
                        
                        
                        <div class="account-wrap">
                            <div class="account-item account-item--style2 clearfix js-item-menu">
                                <div class="content">
                                    <a class="js-acc-btn" href="#"><?php echo($_SESSION['lname'] . ' ' . $_SESSION['fname']); ?></a>
                                </div>
                                <div class="account-dropdown js-dropdown">
                                    <div class="info clearfix">
                                        <div class="content">
                                            <h5 class="name">
                                                <a href="#"><?php echo($_SESSION['lname'] . ' ' . $_SESSION['fname']); ?></a>
                                            </h5>
                                            <span class="email"><?php echo($_SESSION['email']); ?></span>
                                        </div>
                                    </div>
                                    <div class="account-dropdown__body">
                                        <div class="account-dropdown__item">
                                            <a href="#">
                                                <i class="zmdi zmdi-account"></i>Account</a>
                                        </div>
                                        <div class="account-dropdown__item">
                                            <a href="#">
                                                <i class="zmdi zmdi-settings"></i>Setting</a>
                                        </div>
                                        <div class="account-dropdown__item">
                                            <a href="#">
                                                <i class="zmdi zmdi-money-box"></i>Billing</a>
                                        </div>
                                    </div>
                                    <div class="account-dropdown__footer">
                                        <a href="logout.php">
                                            <i class="zmdi zmdi-power"></i>Logout</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </header>
        <!-- END HEADER DESKTOP-->

        <!-- HEADER MOBILE-->
        <header class="header-mobile header-mobile-2 d-block d-lg-none">
            <div class="header-mobile__bar">
                <div class="container-fluid">
                    <div class="header-mobile-inner">
                        <a class="logo" href="index.html">
                            <img src="images/icon/logo-white.png" alt="CoolAdmin" />
                        </a>
                        <button class="hamburger hamburger--slider" type="button">
                            <span class="hamburger-box">
                                <span class="hamburger-inner"></span>
                            </span>
                        </button>
                    </div>
                </div>
            </div>
        
        </header>
        <div class="sub-header-mobile-2 d-block d-lg-none">
            <div class="header__tool">
                <div class="account-wrap">
                    <div class="account-item account-item--style2 clearfix js-item-menu">
                        <div class="content">
                            <a class="js-acc-btn" href="#"><?php echo($_SESSION['lname'] . ' ' . $_SESSION['fname']); ?></a>
                        </div>
                        <div class="account-dropdown js-dropdown">
                            <div class="info clearfix">
                                <div class="content">
                                    <h5 class="name">
                                        <a href="#"><?php echo($_SESSION['lname'] . ' ' . $_SESSION['fname']); ?></a>
                                    </h5>
                                    <span class="email"><?php echo($_SESSION['email']); ?></span>
                                </div>
                            </div>
                            <div class="account-dropdown__body">
                                <div class="account-dropdown__item">
                                    <a href="#">
                                        <i class="zmdi zmdi-account"></i>Account</a>
                                </div>
                                <div class="account-dropdown__item">
                                    <a href="#">
                                        <i class="zmdi zmdi-settings"></i>Setting</a>
                                </div>
                                <div class="account-dropdown__item">
                                    <a href="#">
                                        <i class="zmdi zmdi-money-box"></i>Billing</a>
                                </div>
                            </div>
                            <div class="account-dropdown__footer">
                                <a href="logout.php">
                                    <i class="zmdi zmdi-power"></i>Logout</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- END HEADER MOBILE -->

        <!-- PAGE CONTENT-->
        <div class="page-content--bgf7">
            <!-- BREADCRUMB-->
            <section class="au-breadcrumb2">
                <div class="container">
                    <div class="row">
                        <div class="col-md-12">
                            <div class="au-breadcrumb-content">
                                <form class="au-form-icon--sm" action="" method="post">
                                    <input class="au-input--w300 au-input--style2" type="text" placeholder="Search for datas &amp; reports...">
                                    <button class="au-btn--submit2" type="submit">
                                        <i class="zmdi zmdi-search"></i>
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
            <!-- END BREADCRUMB-->

            <!-- DATA TABLE-->
            <section class="p-t-20">
                <div class="container">
                    <div class="row">
                        <div class="col-md-12">
                            <h3 class="title-5 m-b-35">Your history</h3>
                            <div class="table-data__tool">
                                <div class="table-data__tool-left">
                                    <div class="rs-select2--light rs-select2--md">
                                        <select class="js-select2" name="property">
                                            <option selected="selected">All Properties</option>
                                            <option value="">Option 1</option>
                                            <option value="">Option 2</option>
                                        </select>
                                        <div class="dropDownSelect2"></div>
                                    </div>
                                    <div class="rs-select2--light rs-select2--sm">
                                        <select class="js-select2" name="time">
                                            <option selected="selected">Today</option>
                                            <option value="">3 Days</option>
                                            <option value="">1 Week</option>
                                        </select>
                                        <div class="dropDownSelect2"></div>
                                    </div>
                                    <button class="btn btn-primary">
                                        <a class="text-white" href="errandstaff.php">Go Back</a></button>
                                </div>
                            </div>
                            <div class="table-responsive table-responsive-data2">
                                <table class="table table-data2">
                                    <thead>
                                        <tr>
                                            <th>Free</th>
                                            <th>details</th>
                                            <th>description</th>
                                            <th>date</th>
                                            <th>status</th>
                                            <th>Pickup</th>
                                            <th>DropOff</th>
                                            <th></th>
                                            <th>Accepted By</th>
                                            <th>Errand Id</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                            <?php
                                $name  = $_SESSION['lname'] . " " . $_SESSION['fname'];
                                 $query = "select * from errands where AcceptedBy='$name' order by id desc";
                                 $result = mysqli_query($con, $query);
                                 $btnStatus= "";
                                 if($result){
                                     $rows = mysqli_num_rows($result);
                                     if(mysqli_num_rows($result) > 0){
                                        $count = 0;
                                        while($count < $rows){
                                            $response = mysqli_fetch_array($result);
                                            $free = "False";
                                            if($response['free'] == 1){
                                                $free = "True";
                                            }
                                        if($response['status'] == "Ongoing"){
                                                $status = "text-warning";
                                                $btnStatus = "visible";
                                                $acceptor = $response['AcceptedBy'];
                                            }else{
                                                $status = "status--process";
                                                $btnStatus = "hidden";
                                                $acceptor = $response['AcceptedBy'];
                                            }
                                            echo ('
                                                    <tr class="tr-shadow">
                                                    <td>' . $free . '</td>
                                                        <td>' . $response['fullname'] . "\n" . $response['phone'] . '</td>
                                                        
                                                        <td class="desc">' . $response['description'] . '</td>
                                                        <td>' . $response['date'] . '</td>
                                                        <td>
                                                            <span class="' . $status .'">' . $response['status'] . '</span>
                                                        </td>
                                                        <td>' . $response['pickup'] . '</td><td>' . $response['dropoff'] . '</td>
                                                        <td>
                                                            <div class="table-data-feature">
                                                                <form method="POST" action="completed.php">
                                                                <input value="' . $response['id'] . '" name="id" hidden>
                                                                <input value="' . $_SESSION["lname"] . " " . $_SESSION['fname'] . '" name="acceptedby" hidden>
                                                                <input type="submit" id="accept" class="btn btn-primary" value="Completed" style="visibility:' . $btnStatus .';">
                                                                </form>
                                                              
                                                                
                                                            </div>
                                                        </td>
                                                        <td>' . $acceptor . '</td>
                                                                                                                <td>' . $response['errandid'] . '</td>
                                                    </tr>
                                                    <tr class="spacer"></tr>     
                                                ');
                                            $count++;
                                            $result++;
                                        }
                                     }
                                 }
                                
                                

                            ?>
                              </tbody>
                            </table>
                        </div>

                        
                        </div>
                    </div>
                </div>
            </section>
            <!-- END DATA TABLE-->

            
        </div>

    </div>


    <!-- Jquery JS-->
    <script src="vendor/jquery-3.2.1.min.js"></script>
    <!-- Bootstrap JS-->
    <script src="vendor/bootstrap-4.1/popper.min.js"></script>
    <script src="vendor/bootstrap-4.1/bootstrap.min.js"></script>
    <!-- Vendor JS       -->
    <script src="vendor/slick/slick.min.js">
    </script>
    <script src="vendor/wow/wow.min.js"></script>
    <script src="vendor/animsition/animsition.min.js"></script>
    <script src="vendor/bootstrap-progressbar/bootstrap-progressbar.min.js">
    </script>
    <script src="vendor/counter-up/jquery.waypoints.min.js"></script>
    <script src="vendor/counter-up/jquery.counterup.min.js">
    </script>
    <script src="vendor/circle-progress/circle-progress.min.js"></script>
    <script src="vendor/perfect-scrollbar/perfect-scrollbar.js"></script>
    <script src="vendor/chartjs/Chart.bundle.min.js"></script>
    <script src="vendor/select2/select2.min.js">
    </script>

    <!-- Main JS-->
    <script src="js/main.js"></script>

</body>

</html>
<!-- end document-->
