<?php

require_once 'jwt/JWT.php';
require_once 'jwt/JWK.php';
require_once 'jwt/ExpiredException.php';
require_once 'jwt/BeforeValidException.php';
require_once 'jwt/SignatureInvalidException.php';

use \Firebase\JWT\JWT;

$key = "OBbyzm1zv7m9oJ5wI5rNhuFHX37gPA";


header("Context-Type:application/json");

$hostname = "localhost";
$user = "tomiwaco_root";
$passkey = "nnIDkgu6tnV3";
$db = "tomiwaco_grep";

$con = mysqli_connect($hostname, $user, $passkey, $db) or die(mysqli_connect_error());

if(isset($_POST['email'])){
    $details = (array) JWT::decode($_POST['email'], $key, array('HS256'));
    $email = filter_var($details['email_'], FILTER_SANITIZE_EMAIL);
    $newemail = filter_var($details['newemail'], FILTER_SANITIZE_EMAIL);
    $query = "update users set email='$newemail' where email='$email'";
    $result = mysqli_query($con, $query);
    if($result){
        $q1 = "update errands set email='$newemail' where email='$email'";
        $r1 = mysqli_query($con, $q1);
        if($r1){
          $json = array(
            "Update" => "Success"
        );
        echo json_encode($json);
        }
    }
}

if(isset($_POST['phone'])){
    $details = (array) JWT::decode($_POST['phone'], $key, array('HS256'));
    $email = filter_var($details['email'], FILTER_SANITIZE_EMAIL);
    $phone = filter_var($details['phone_'], FILTER_SANITIZE_EMAIL);
    $query = "update users set phone='$phone' where email='$email'";
    $result = mysqli_query($con, $query);
    if($result){
        $q1 = "update errands set phone='$phone' where email='$email'";
        $r1 = mysqli_query($con, $q1);
        if($r1){
          $json = array(
            "Update" => "Success"
        );
        echo json_encode($json);
        }
    }
}

if(isset($_POST['address'])){
    $details = (array) JWT::decode($_POST['address'], $key, array('HS256'));
    $email = filter_var($details['email'], FILTER_SANITIZE_EMAIL);
    $address = filter_var($details['address_'], FILTER_SANITIZE_EMAIL);
    $query = "update users set address='$address' where email='$email'";
    $result = mysqli_query($con, $query);
    if($result){
        $json = array(
            "Update" => "Success"
        );
        echo json_encode($json);
    }
}








?>