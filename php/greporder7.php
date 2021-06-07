<?php



require_once 'jwt/JWT.php';
require_once 'jwt/JWK.php';
require_once 'jwt/ExpiredException.php';
require_once 'jwt/BeforeValidException.php';
require_once 'jwt/SignatureInvalidException.php';

use \Firebase\JWT\JWT;

$key = "OBbyzm1zv7m9oJ5wI5rNhuFHX37gPA";



function inform(){

$user1 = 'https://api.telegram.org/bot1846733035:AAFMe-736ft8UyXBgMWbcgvlD3kJcPZiBYs/sendMessage?chat_id=1536173777&text=There is a new order';


$user2 = 'https://api.telegram.org/bot1846733035:AAFMe-736ft8UyXBgMWbcgvlD3kJcPZiBYs/sendMessage?chat_id=919833146&text=There is a new order';


$cURLConnection = curl_init();

curl_setopt($cURLConnection, CURLOPT_URL, $user1);
curl_setopt($cURLConnection, CURLOPT_RETURNTRANSFER, true);

$ist = curl_exec($cURLConnection);
curl_close($cURLConnection);



$cURLConnection = curl_init();

curl_setopt($cURLConnection, CURLOPT_URL, $user2);
curl_setopt($cURLConnection, CURLOPT_RETURNTRANSFER, true);

$ist = curl_exec($cURLConnection);
curl_close($cURLConnection);

}


header("Context-Type:application/json");

if(isset($_POST['order'])){

$details = (array) JWT::decode($_POST['order'], $key, array('HS256'));


    $hostname = "localhost";
    $user = "tomiwaco_root";
    $pwd= "nnIDkgu6tnV3";
    $db = "tomiwaco_grep";

    $fullname = filter_var($details['fullname'], FILTER_SANITIZE_STRING);
    $phone= filter_var($details['phone'], FILTER_SANITIZE_STRING);
    $email = filter_var($details['email'], FILTER_SANITIZE_EMAIL);
    $pickup = filter_var($details['pickup'], FILTER_SANITIZE_STRING);
    
    $dropoff = filter_var($details['dropoff'], FILTER_SANITIZE_STRING);
    $description = filter_var($details['description'], FILTER_SANITIZE_STRING);
    $date = $details['date'];
    $status = $details['status'];
    $errandid = $details['errandid'];

    $con = mysqli_connect($hostname, $user, $pwd, $db) or die(mysqli_error());
    $query = "insert into errands(fullname, email, phone, pickup, dropoff, description, status, date, errandid, AcceptedBy, ResNum) values('$fullname', '$email', '$phone', '$pickup', '$dropoff', '$description', '$status', '$date', '$errandid','-', '-')";
    $result = mysqli_query($con, $query);
    if($result){
        $q = "update users set num_errands = num_errands + 1 where email='$email'";
        $r = mysqli_query($con, $q);
        if($r){
            $q1 = "select * from users where email='$email'";
            $r1 = mysqli_query($con, $q1);
            if($r1){
                if(mysqli_num_rows($r1) > 0){
                    $response = mysqli_fetch_array($r1);
                    $no = $response['freeerrands'];
                    if($no >= 5){
                        $q2 = "update users set freeerrands = freeerrands - 5 where email='$email'";
                        $r2 = mysqli_query($con, $q2);
                        if($r2){
                            $qs = "update errands set free = 1 where errandid='$errandid'";
                            $rs = mysqli_query($con, $qs);
                            if($rs){
                                $json = array(
                                    'Errand' => 'Free',
                                    'Order' => 'Success'
                                );
                                
                                inform();
                                echo json_encode($json);
                                
                            }
                        }
                    }else{
                        $json = array(
                            'Errand' => 'Not Free',
                            'Order' => 'Success'
                        );
                        inform();
                                echo json_encode($json);
                    }
                }
            }
        }
        
    }

}



?>