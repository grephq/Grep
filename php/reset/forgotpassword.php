<?php
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;
use PHPMailer\PHPMailer\SMTP;

require 'src/Exception.php';
require 'src/PHPMailer.php';
require 'src/SMTP.php';

if(isset($_POST['email'])){
    $token = md5(uniqid());
    $email = $_POST['email'];
        
    $hostname = "localhost";
    $user = "tomiwaco_root";
    $passkey = "nnIDkgu6tnV3";
    $db = "tomiwaco_grep";

    $con = mysqli_connect($hostname, $user, $passkey, $db) or die(mysqli_connect_error());
    
    $q = "select * from users where email='$email'";
    $r = mysqli_query($con, $q);
    if($r){
        $c = mysqli_num_rows($r);
        if($c > 0){
            $query = "update users set reset_token='$token' where email='$email'";
            $result = mysqli_query($con, $query);
            
            if($result){
                $mail = new PHPMailer(true);
                try {
                    
                    $mail->SMTPDebug  = 0;  
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
                    $mail->Body    = "<b>Hello</b>,<br/>If you did not request for password reset, ignore this mail.<br/><br/>Password reset link: https://tomiwa.com.ng/grepworks/reset.php?token=$token&email=$email";
                    $mail->AltBody = "<b>Hello</b>,<br/>If you did not request for password reset, ignore this mail.<br/><br/>Password reset link: https://tomiwa.com.ng/grepworks/reset.php?token=$token&email=$email";
                
                
                    $mail->send();
                    $json = array(
                        'Reset' => 'Success'
                    );
                    echo json_encode($json);
                    
                } catch (Exception $e) {
                    
                }
            }
        }
    }
}