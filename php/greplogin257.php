<?php



require_once 'jwt/JWT.php';
require_once 'jwt/JWK.php';
require_once 'jwt/ExpiredException.php';
require_once 'jwt/BeforeValidException.php';
require_once 'jwt/SignatureInvalidException.php';

use \Firebase\JWT\JWT;

$key = "OBbyzm1zv7m9oJ5wI5rNhuFHX37gPA";




header("Context-Type:application/json");

if(isset($_POST['login'])){
$details = (array) JWT::decode($_POST['login'], $key, array('HS256'));

    $hostname = "localhost";
    $user = "tomiwaco_root";
    $passkey = "nnIDkgu6tnV3";
    $db = "tomiwaco_grep";

    $con = mysqli_connect($hostname, $user, $passkey, $db) or die(mysqli_connect_error());

    $email = filter_var($details['email'], FILTER_SANITIZE_EMAIL);
    $pwd = $details['pwd'];
    $query = "select * from users where email='$email'";
    $result = mysqli_query($con, $query);

    if($result){
        if(mysqli_num_rows($result) > 0){
            $response = mysqli_fetch_array($result);
            if($response['email'] == $email && password_verify($pwd, $response['password'])){
                $json = array(
                    'Login' => 'Success',
                    'FullName' => $response['fullname'],
                    'Email' => $response['email'],
                    'Phone' => $response['phone'],
                    'Birthday' => $response['birthday'],
                    'Address' => $response['address'],
                    'ReferralCode' => $response['referralcode'],
                    'NoErrands' => $response['num_errands'],
                    'FreeErrands' => $response['freeerrands']
                );
                $jsonstring = json_encode($json);
                echo $jsonstring;
            }   
        }
    }
}
?>
