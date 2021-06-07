<?php




header("Context-Type:application/json");


if(isset($_POST['referrer'])){




    $referrer = filter_var($_POST['referrer'], FILTER_SANITIZE_EMAIL);
    
    $hostname = "localhost";
    $user = "tomiwaco_root";
    $passkey = "nnIDkgu6tnV3";
    $db = "tomiwaco_grep";
    
    $con = mysqli_connect($hostname, $user, $passkey, $db) or die(mysqli_connect_error());
    $query = "update users set freeerrands = freeerrands + 1 where email='$referrer'";
    $result = mysqli_query($con, $query);
    if($result){
        $json = array(
            'Free Errand Update' => 'Success'
        );
        echo json_encode($json);
    }
}

?>