<?php
header("Context-Type:application/json");
require "db_connect.php";
if(isset($_POST['email'])){
    $email = $_POST['email'];
    
    $query = "select * from errands where email='$email' order by id desc";
    $result = mysqli_query($con, $query);
    if($result){
        $count = mysqli_num_rows($result);
        $i = 0;
        if($count > 0){
            
            $rows = mysqli_fetch_array($result);
            $i = 0;
            $json = array();
            while($i < 2){
                $json[$i] = array(
                    "ID" => $rows['errandid'],
                    "Date" => $rows['date'],
                    "Status" => $rows['status'],
                    "Description" => $rows['description'],
                    "Location" => $rows['location'],
                    "Responder" => $rows['AcceptedBy'],
                    "Number" => $rows['ResNum']
                );
                $rows++;
                $i++;
            }
            echo json_encode($json);
        }
    }
}



?>