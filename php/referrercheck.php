<?php






header("Context-Type:application/json");


if(isset($_POST['referrer'])){




    $hostname = "localhost";
    $user = "tomiwaco_root";
    $passkey = "nnIDkgu6tnV3";
    $db = "tomiwaco_grep";

    $con = mysqli_connect($hostname, $user, $passkey, $db) or die(mysqli_connect_error());
    $ref = filter_var($_POST['referrer'], FILTER_SANITIZE_STRING);
    $query = "select * from users where referralcode='$ref'";
    $result = mysqli_query($con, $query);
    if($result){
        if(mysqli_num_rows($result) > 0){
            $response = mysqli_fetch_array($result);
            $json = array(
                'Referrer' => $response['email']
            );
            echo json_encode($json);
        }
    }
}


?>