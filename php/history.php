<?php




require_once 'jwt/JWT.php';
require_once 'jwt/JWK.php';
require_once 'jwt/ExpiredException.php';
require_once 'jwt/BeforeValidException.php';
require_once 'jwt/SignatureInvalidException.php';

use \Firebase\JWT\JWT;

$key = "OBbyzm1zv7m9oJ5wI5rNhuFHX37gPA";



header("Context-Type:application/json");
require "db_connect.php";
if(isset($_POST['history'])){

$details = (array) JWT::decode($_POST['history'], $key, array('HS256'));


    $email = $details['email'];
    
    $query = "select * from errands where email='$email' order by id desc";
    $result = mysqli_query($con, $query);
    if($result){
        $count = mysqli_num_rows($result);
        $i = 0;
        if($count > 0){
            $json = array();
            while($i < $count){
                $rows = mysqli_fetch_array($result);
                $json[$i] = array(
                    "ID" => $rows['errandid'],
                    "Date" => $rows['date'],
                    "Status" => $rows['status'],
                    "Description" => $rows['description'],
                    "PickUp" => $rows['pickup'],
                    "DropOff" => $rows['dropoff'],
                    "Responder" => $rows['AcceptedBy'],
                    "Number" => $rows['ResNum']
                );
                $i++;
                $result++;
            }
            echo json_encode($json);
                
        }
    }
}



?>