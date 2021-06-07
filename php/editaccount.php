<?php

header("Context-Type:application/json");

if(isset($_POST['email'])){

    $hostname = "localhost";
    $user = "tomiwaco_root";
    $passkey = "nnIDkgu6tnV3";
    $db = "tomiwaco_grep";

    $con = mysqli_connect($hostname, $user, $passkey, $db) or die(mysqli_connect_error());
    $email = filter_var($_POST['email'], FILTER_SANITIZE_EMAIL);
    $bday = $_POST['bday'];
    
    
    
    $q1 = "update users set birthday='$bday' where email='$email'";
                $r1 = mysqli_query($con, $q1);
                if($r1){
                    $json = array(
                        'Edit' => 'Success'
                    );
                    $jsonstring = json_encode($json);
                    echo $jsonstring;
                }
    

    
}
?>
