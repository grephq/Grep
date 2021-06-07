<?php



require_once 'jwt/JWT.php';
require_once 'jwt/JWK.php';
require_once 'jwt/ExpiredException.php';
require_once 'jwt/BeforeValidException.php';
require_once 'jwt/SignatureInvalidException.php';

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;
use PHPMailer\PHPMailer\SMTP;

use \Firebase\JWT\JWT;
require 'src/Exception.php';
require 'src/PHPMailer.php';
require 'src/SMTP.php';

$key = "nckedJjcUENcokdnx04939dk";


if(isset($_POST['email'])){
    $t = md5(uniqid());
    $email = filter_var($_POST['email'], FILTER_SANITIZE_EMAIL);
    $token = JWT::encode($t, $key);
    $hostname = "localhost";
    $user = "tomiwaco_root";
    $passkey = "nnIDkgu6tnV3";
    $db = "tomiwaco_grep";

    $con = mysqli_connect($hostname, $user, $passkey, $db) or die(mysqli_connect_error());
    
    $query = "update users set reset_token='$token' where email='$email'";
    $result = mysqli_query($con, $query);
    if($result){
        
        $mail = new PHPMailer(true);
        try {
           
        
        $mail->SMTPDebug  = 1;  
        $mail->SMTPAuth   = TRUE;
        $mail->SMTPSecure = "tls";
        $mail->Port       = 587;
        $mail->Host       = "smtp.gmail.com";
        $mail->Username   = "abcqwerty924@gmail.com";
        $mail->Password   = "crazydog09!";
        
        
            //Recipients
            $mail->setFrom('noreply@grep.com', 'Admin');
            $mail->addAddress($email);     //Add a recipient
        
            //Content
            $mail->isHTML(true);                                  //Set email format to HTML
            $mail->Subject = 'Grep: Password Reset';
            $mail->Body    = "<b>Hello</b>, if you did not request for password reset, ignore this mail.\n\nPassword reset link: https://tomiwa.com.ng/grepworks/reset.php?token='$token'&email='$email'";
            $mail->AltBody = "<b>Hello</b>, if you did not request for password reset, ignore this mail.\n\nPassword reset link: https://tomiwa.com.ng/grepworks/reset.php?token='$token'&email='$email'";
        
            $mail->send();
            $json = array(
                    'Reset' => 'Success'
                );
                echo json_encode($json);
        } catch (Exception $e) {
            
        }
        
    }
}



?>