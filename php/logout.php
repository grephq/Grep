<?php
session_start();
unset($_SESSION["fname"]);
unset($_SESSION["lname"]);
unset($_SESSION["email"]);
unset($_SESSION["phone"]);
unset($_SESSION["password"]);
session_destroy();
header("Location:login.php");


?>