<?php
header("Content-Type: application/json");
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

include 'db_connection.php'; 

if (!$conn) {
    error_log("Error: Database connection failed");
    echo json_encode(['message' => 'Database connection failed']);
    exit;
} else {
    error_log("MySQL connection established.");
}

$sql_fetch = "SELECT 
        b.id, 
        u1.name AS reported_user, 
        u1.email AS reported_user_email, 
        b.report_reason
    FROM blocked_users b
    JOIN user u1 ON b.user_id = u1.id 
    ORDER BY b.block_date DESC"; 



$result = $conn->query($sql_fetch);

if ($result) {
    $blocked_users = [];
    while ($row = $result->fetch_assoc()) {
        $blocked_users[] = $row;
    }

    echo json_encode($blocked_users);
} else {
    error_log("Error fetching blocked users: " . $conn->error);
    echo json_encode(['message' => 'Failed to fetch blocked users']);
}
?>
