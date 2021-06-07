<?php
header("Context-Type:application/json");
require "db_connect.php";
if(isset($_POST['email'])){
    $email = $_POST['email'];
    
    $query = "select * from transactions where email='$email' order by id desc";
    $result = mysqli_query($con, $query);
    if($result){
        $count = mysqli_num_rows($result);
        $i = 0;
        if($count > 0){
            $json = array();
            while($i < $count){
                $rows = mysqli_fetch_array($result);
                $json[$i] = array(
                    "TrxnID" => $rows['trxnid'],
                    "Date" => $rows['date'],
                    "Transaction" => $rows['transaction']
                    
                );
                $i++;
                $result++;
            }
            echo json_encode($json);
        }
    }
}



?>