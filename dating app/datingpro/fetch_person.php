<?php
header("Content-Type: application/json");
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

include 'db_connection.php';  

if (!$conn) {
    // Log and return a connection error
    error_log("Error: Database connection failed");
    echo json_encode(['status' => 'error', 'message' => 'Database connection failed']);
    exit;
} else {
    error_log("MySQL connection established.");
}

$user_id = isset($_GET['user_id']) ? (int)$_GET['user_id'] : null;

if ($user_id === null) {
    echo json_encode(['status' => 'error', 'message' => 'User ID is required']);
    exit;
}

$sql = "SELECT * FROM user WHERE id = ?"; 
$stmt = $conn->prepare($sql);

if ($stmt === false) {
    error_log("Error: SQL prepare failed");
    echo json_encode(['status' => 'error', 'message' => 'SQL prepare failed']);
    exit;
}

$stmt->bind_param("i", $user_id);

if (!$stmt->execute()) {
    error_log("Error: SQL execute failed");
    echo json_encode(['status' => 'error', 'message' => 'SQL execute failed']);
    exit;
}

$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    // Return JSON response
    echo json_encode($row);
} else {
    echo json_encode(["error" => "No record found"]);
}

$stmt->close();
$conn->close();
?>
