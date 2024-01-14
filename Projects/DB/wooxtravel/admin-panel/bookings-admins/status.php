<?php require "../layouts/header.php"; ?>      
<?php require "../../config/config.php"; ?> 

<?php 

    if(!isset($_SESSION["adminname"])) {
        header("location: ".ADMINURL."");
    }

    try {
        // Start the transaction
        $conn->beginTransaction();

        if(isset($_GET['id']) AND isset($_GET['status'])) {

            $id = $_GET['id'];
            $status = $_GET['status'];

            if($status == "Pending") {
                $update = $conn->prepare("UPDATE bookings SET status='Booked Successfully' WHERE id=:id");
                $update->bindParam(':id', $id, PDO::PARAM_INT);

            } else {
                $update = $conn->prepare("UPDATE bookings SET status='Pending' WHERE id=:id");
                $update->bindParam(':id', $id, PDO::PARAM_INT);
            }

            $update->execute();

            // Commit the transaction
            $conn->commit();

            header("location: show-bookings.php");
        }

    } catch (Exception $e) {
        // Rollback the transaction if an error occurs
        $conn->rollBack();

        // Handle the error, e.g., log it, display a message, etc.
        // Redirect to an error page or display an error message
        header("location: 404.php"); // Redirect to an error page
    }
?>
