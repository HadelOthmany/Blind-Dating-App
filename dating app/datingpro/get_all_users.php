<?php
header("Content-Type: application/json");
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

include 'db_connection.php'; 

if (!$conn) {
    error_log("Error: Database connection failed");
    echo json_encode(['status' => 'error', 'message' => 'Database connection failed']);
    exit;
} else {
    error_log("MySQL connection established.");
}

$logged_in_user_id = isset($_GET['logged_in_user_id']) ? (int)$_GET['logged_in_user_id'] : 0;

$query = "SELECT * FROM user WHERE id != ?";
$stmt = $conn->prepare($query);
$stmt->bind_param("i", $logged_in_user_id);  
$stmt->execute();
$result = $stmt->get_result();

$profiles = array();

while ($data = $result->fetch_assoc()) {
    $profiles[] = $data;
}

echo json_encode($profiles);

$stmt->close();
$conn->close();
?>
