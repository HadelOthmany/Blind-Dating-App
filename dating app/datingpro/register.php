<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

include 'db_connection.php';

$username = isset($_POST['username']) ? trim($_POST['username']) : null;
$email = isset($_POST['email']) ? trim($_POST['email']) : null;
$password = isset($_POST['password']) ? trim($_POST['password']) : null;

if (!$username || !$email || !$password) {
    echo json_encode(["status" => "error", "message" => "All fields are required"]);
    exit;
}

$email_check_stmt = $conn->prepare("SELECT id FROM user WHERE email = ?");
if (!$email_check_stmt) {
    echo json_encode(["status" => "error", "message" => "Database error: " . $conn->error]);
    exit;
}
$email_check_stmt->bind_param("s", $email);
$email_check_stmt->execute();
$email_check_result = $email_check_stmt->get_result();

if ($email_check_result->num_rows > 0) {
    echo json_encode(["status" => "error", "message" => "Email already registered"]);
    $email_check_stmt->close();
    $conn->close();
    exit;
}
$email_check_stmt->close();

$password_hashed = password_hash($password, PASSWORD_DEFAULT);

$stmt = $conn->prepare("INSERT INTO user (name, email, password) VALUES (?, ?, ?)");
if (!$stmt) {
    echo json_encode(["status" => "error", "message" => "Database error: " . $conn->error]);
    exit;
}
$stmt->bind_param("sss", $username, $email, $password_hashed);

if ($stmt->execute()) {
    echo json_encode(["status" => "success", "message" => "User registered successfully"]);
} else {
    echo json_encode(["status" => "error", "message" => "Error: " . $stmt->error]);
}

$stmt->close();
$conn->close();
?>
