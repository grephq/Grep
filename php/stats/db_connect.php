<?php

    session_start();

    $hostname = "localhost";
    $user = "tomiwaco_root";
    $pwd = "nnIDkgu6tnV3";
    $db = "tomiwaco_grep";

    $connect = mysqli_connect($hostname, $user, $pwd, $db) or die(mysqli_error());
    
    function disconnect($connect){
       mysqli_close($connect);
    }


?>