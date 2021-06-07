<?php
    if(isset($_POST['email'])){
        require '../db_connect.php';
        
        $email = $_POST['email'];
        $pwd = $_POST['password'];
        
        $query = "select * from admin where email='$email'";
        $result = mysqli_query($con, $query);
        if($result){
            if(mysqli_num_rows($result) > 0){
                $response = mysqli_fetch_array($result);
                if(password_verify($pwd, $response['password'])){
                    $_SESSION['email'] = $response['email'];
                    header("Location: uploadad.php");
                }else{
                    echo "
                    
                       <div class='alert alert-danger' role='alert'>
                          Invalid username/password
                        </div>
                        
                        ";
                }
            }
        }
    }



?>

<!DOCTYPE html>
<html>
    
<head>
    <link href="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
<script src="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.min.js"></script>
<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<!------ Include the above in your HEAD tag ---------->
<link rel=stylesheet href="styles.css">
</head>

<body>
    <div id="login">
        <h3 class="text-center text-white pt-5">Login form</h3>
        <div class="container">
            <div id="login-row" class="row justify-content-center align-items-center">
                <div id="login-column" class="col-md-6">
                    <div id="login-box" class="col-md-12">
                        <form id="login-form" class="form" action="" method="post">
                            <h3 class="text-center text-info">Login</h3>
                            <div class="form-group">
                                <label for="username" class="text-info">Email:</label><br>
                                <input type="text" name="email" id="username" class="form-control">
                            </div>
                            <div class="form-group">
                                <label for="password" class="text-info">Password:</label><br>
                                <input type="password" name="password" id="password" class="form-control">
                            </div>
                            <div class="form-group">
                                <input type="submit" name="submit" class="btn btn-info btn-md btn-block" value="Submit">
                            </div>
                            
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
