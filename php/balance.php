<?php
header("Context-Type:application/json");
require "db_connect.php";
if(isset($_POST['email'])){
    $email = $_POST['email'];
    
    $query = "select * from users where email='$email'";
    $result = mysqli_query($con, $query);
    if($result){
        $count = mysqli_num_rows($result);
        if($count > 0){
            
            $rows = mysqli_fetch_array($result);
                $json = array(
                    "Balance" => $rows['balance']
                );
            echo json_encode($json);
        }
    }
}



?>