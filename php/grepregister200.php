<?php


require_once 'jwt/JWT.php';
require_once 'jwt/JWK.php';
require_once 'jwt/ExpiredException.php';
require_once 'jwt/BeforeValidException.php';
require_once 'jwt/SignatureInvalidException.php';

use \Firebase\JWT\JWT;

$key = "OBbyzm1zv7m9oJ5wI5rNhuFHX37gPA";




header("Context-Type:application/json");

if(isset($_POST['register'])){


$details = (array) JWT::decode($_POST['register'], $key, array('HS256'));

    $hostname = "localhost";
    $user = "tomiwaco_root";
    $passkey = "nnIDkgu6tnV3";
    $db = "tomiwaco_grep";

    $con = mysqli_connect($hostname, $user, $passkey, $db) or die(mysqli_connect_error());

    $fullname = filter_var($details['fullname'], FILTER_SANITIZE_STRING);
    $email = filter_var($details['email'], FILTER_SANITIZE_EMAIL);
    $phone = filter_var($details['phone'], FILTER_SANITIZE_EMAIL);
    $pwd = $details['pwd'];
    $ref = $details['refcode'];
    $pwd = password_hash($pwd, PASSWORD_DEFAULT);

    $query = "insert into users(fullname, email, phone, password, referralcode) values('$fullname', '$email', '$phone', '$pwd', '$ref')";

    $result = mysqli_query($con, $query);

    if($result){
        $json = array(
            'Registration' => 'Success',    
        );
        echo json_encode($json);
    }   

}

?>