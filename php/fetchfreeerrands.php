<?php
require 'db_connect.php';
header("Context-Type:application/json");

if(isset($_POST['refcode'])){
    $refcode = filter_var($_POST['refcode'], FILTER_SANITIZE_STRING);
    $query = "select * from users where refcode='$refcode'";
    $result = mysqli_query($con, $query);
    if($result){
        if(mysqli_num_rows($result) > 0){
            $response = mysqli_fetch_array($result);
            $jsonarray = array(
                "FreeErrands" => $response['freeerrands']    
            );
            $json = json_encode($jsonarray);
            echo $json;
        }
    }
}


?>