<?php
    require 'db_connect.php';
    
    if(isset($_POST['id'])){
        $id = $_POST['id'];
        $phone = $_SESSION['phone'];
        $acceptor = $_POST['acceptedby'];
        $query = "update errands set status='Ongoing' where id='$id'";
        $result = mysqli_query($con, $query);
        if($result){
            $q1 = "update errands set AcceptedBy='$acceptor' where id='$id'";
            $r1 = mysqli_query($con, $q1);
            if($r1){
                $q2 = "update errands set ResNum='$phone' where id='$id'";
                $r2 = mysqli_query($con, $q2);
                if($r2){
                    header("Location: errandstaff.php");
                }
            }
        }
    }





?>