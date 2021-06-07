<?php
header("Context-Type:application/json");

if(isset($_POST['image'])){
    $hostname = "localhost";
    $user = "tomiwaco_root";
    $pwd= "nnIDkgu6tnV3";
    $db = "tomiwaco_grep";
    
    $image = $_POST['image'];

    $con = mysqli_connect($hostname, $user, $pwd, $db) or die(mysqli_error());
    $query = "select * from ads order by id desc";
    $result = mysqli_query($con, $query);
    if($result){
        $count = mysqli_num_rows($result);
        $i = 0;
        if($count > 0){
            $json = array();
            while($i < $count){
                $rows = mysqli_fetch_array($result);
                $json[$i] = array(
                    $rows['link']
                );
                $i++;
                $result++;
            }
            echo json_encode($json);
        }
    }
    
    
}



?>