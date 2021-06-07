<?php
    $hostname = "localhost";
    $user = "tomiwaco_root";
    $passkey = "nnIDkgu6tnV3";
    $db = "tomiwaco_grep";

    $con = mysqli_connect($hostname, $user, $passkey, $db) or die(mysqli_connect_error());
        
    if(isset($_POST['token']) && isset($_POST['pwd']) && isset($_POST['cpwd']) && $_POST['pwd'] == $_POST['cpwd']){
        $pwd = password_hash($_POST['pwd'], PASSWORD_DEFAULT);
        $token = $_POST['token'];
        $q = "update users set password='$pwd', reset_token='' where reset_token='$token'";
        
        $r = mysqli_query($con, $q);
        if($r){
            echo '
            <!DOCTYPE html>
                        <html lang="en">
                        <head>
                            <!--Bootstrap css-->
                            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-eOJMYsd53ii+scO/bJGFsiCZc+5NDVN2yr8+0RDqr0Ql0h+rP48ckxlpbzKgwra6" crossorigin="anonymous">
                
                          
                            
                            <meta charset="UTF-8">
                            <meta name="viewport" content="width=device-width, initial-scale=1.0">
                            <title> The Shop </title>
                        </head>
                        <body>
            <div class="alert alert-success" role="alert">
              Password Updated!
            </div>
            
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta3/dist/js/bootstrap.bundle.min.js" integrity="sha384-JEW9xMcG8R+pH31jmWH6WWP0WintQrMb4s7ZOdauHnUtxwoG2vI5DkLtS3qm9Ekf" crossorigin="anonymous"></script>
                
                
                        </body>
                        </html>';
        }else{
            echo '
                <!DOCTYPE html>
                        <html lang="en">
                        <head>
                            <!--Bootstrap css-->
                            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-eOJMYsd53ii+scO/bJGFsiCZc+5NDVN2yr8+0RDqr0Ql0h+rP48ckxlpbzKgwra6" crossorigin="anonymous">
                
                          
                            
                            <meta charset="UTF-8">
                            <meta name="viewport" content="width=device-width, initial-scale=1.0">
                            <title> The Shop </title>
                        </head>
                        <body>
            <div class="alert alert-danger" role="alert">
              Password Reset Failed!
            </div>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta3/dist/js/bootstrap.bundle.min.js" integrity="sha384-JEW9xMcG8R+pH31jmWH6WWP0WintQrMb4s7ZOdauHnUtxwoG2vI5DkLtS3qm9Ekf" crossorigin="anonymous"></script>
                
                
                        </body>
                        </html>
            ';
        }
    }

    if(isset($_GET['token']) && isset($_GET['email'])){
        $token = $_GET['token'];
        $email = $_GET['email'];
        
        
        
        $query = "select * from users where email='$email'";
        $result = mysqli_query($con, $query);
        if($result){
            $count = mysqli_num_rows($result);
            if($count > 0){
                $response = mysqli_fetch_array($result);
                if($token == $response['reset_token']){
                    echo '<!DOCTYPE html>
                        <html lang="en">
                        <head>
                            <!--Bootstrap css-->
                            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-eOJMYsd53ii+scO/bJGFsiCZc+5NDVN2yr8+0RDqr0Ql0h+rP48ckxlpbzKgwra6" crossorigin="anonymous">
                
                          
                            
                            <meta charset="UTF-8">
                            <meta name="viewport" content="width=device-width, initial-scale=1.0">
                            <title> The Shop </title>
                        </head>
                        <body>
                           
                            <br>
                            <br>
                            <form action="reset.php" method="post">
                                <div class="container">
                                    <div class="row">
                                        <div class="col-lg-5 mx-auto border border-bottom border-dark">
                                            <input type="password" name="pwd" id="pwd" placeholder="New Password" class="form-control"><br>
                                            <input type="password" name="cpwd" id="pwd" placeholder="Confirm Password" class="form-control"><br>
                                             <input type="hidden" id="token" name="token" value="' . $token .'">
                                            <input type="submit" name="reset" value="Change Password" class="btn btn-block bg-dark text-white">
                                            <br>
                                        </div>
                                    </div>  
                                </div>
                
                            </form>
                
                
                        <br>
                        <br>
                            
                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta3/dist/js/bootstrap.bundle.min.js" integrity="sha384-JEW9xMcG8R+pH31jmWH6WWP0WintQrMb4s7ZOdauHnUtxwoG2vI5DkLtS3qm9Ekf" crossorigin="anonymous"></script>
                
                
                        </body>
                        </html>';
                }
            }
        }
    }

?>

