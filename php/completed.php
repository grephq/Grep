<?php
    require 'db_connect.php';
    
    if(isset($_POST['id'])){
        $id = $_POST['id'];
        $acceptor = $_POST['acceptedby'];
        $query = "update errands set status='Completed' where id='$id'";
        $result = mysqli_query($con, $query);
        if($result){
            header("Location: errandstaffhistory.php");
        }
    }





?>