<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

include 'db_connection.php';

// Get POST data
$username = $_POST['username'];
$password = $_POST['password'];

$sql = "SELECT id, email, password FROM user WHERE email='$username'";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $user = $result->fetch_assoc();
    if (password_verify($password, $user['password'])) {
        echo json_encode([
            "status" => "success", 
            "message" => "Login successful", 
            "userId" => $user['id']
        ]);
    } else {
        // Incorrect password
        echo json_encode([
            "status" => "error", 
            "message" => "Invalid password"
        ]);
    }
} else {
    // User not found
    echo json_encode([
        "status" => "error", 
        "message" => "User not found"
    ]);
}

$conn->close();
?>
