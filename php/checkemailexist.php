<?php





header("Context-Type:application/json");


if(isset($_POST['email'])){


    $hostname = "localhost";
    $user = "tomiwaco_root";
    $passkey = "nnIDkgu6tnV3";
    $db = "tomiwaco_grep";

    $email = filter_var($_POST['email'], FILTER_SANITIZE_EMAIL);

    $con = mysqli_connect($hostname, $user, $passkey, $db) or die(mysqli_connect_error());
    $query = "select * from users where email='$email'";
    $result = mysqli_query($con, $query);
    if($result){
        if(mysqli_num_rows($result) == 0){
            $json = array(
                'Email Exist' => 'No'
            );
            echo json_encode($json);
        }
    }
}


?>