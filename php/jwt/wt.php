<?php
require_once 'JWT.php';
require_once 'JWK.php';
require_once 'ExpiredException.php';
require_once 'BeforeValidException.php';
require_once 'SignatureInvalidException.php';

use \Firebase\JWT\JWT;

$key = "tomiwa";
$payload = array(
    "First" => "First Data",
    "Second" => "Second Data"
);

$jwt = JWT::encode($payload, $key);
echo $jwt;
echo '</br></br></br>';

$decoded = JWT::decode($jwt, $key, array('HS256'));
print_r($decoded);
echo '</br></br></br>';
print_r((array)$decoded);




?>