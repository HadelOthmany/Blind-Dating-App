<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

include 'db_connection.php';

$currentUserId = $_POST['currentUserId'];
$otherUserId = $_POST['otherUserId'];
$message = $_POST['message'];

$sql = "INSERT INTO messages (sender_id, receiver_id, message, created_at) VALUES ('$currentUserId', '$otherUserId', '$message', NOW())";

if ($conn->query($sql) === TRUE) {
    echo "Meddelande skickat!";
} else {
    echo "Error: " . $sql . "<br>" . $conn->error;
}

$conn->close();
?>
