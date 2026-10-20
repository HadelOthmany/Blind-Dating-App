<?php
header("Content-Type: application/json");
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

include 'db_connection.php'; 

if (!$conn) {
    error_log("Error: Database connection failed");
    echo json_encode(['status' => 'error', 'message' => 'Database connection failed']);
    exit;
} else {
    error_log("MySQL connection established.");
}

$sql_fetch = "SELECT r.report_id, r.reporting_user_id, r.reported_user_id, r.report_reason, r.report_date, 
                     u1.name AS reporting_user, u2.name AS reported_user, u2.email AS reported_user_email
              FROM reported_users r
              JOIN user u1 ON r.reporting_user_id = u1.id
              JOIN user u2 ON r.reported_user_id = u2.id
              ORDER BY r.report_date DESC"; 

$result = $conn->query($sql_fetch);

if ($result) {
    $reported_users = [];
    while ($row = $result->fetch_assoc()) {
        $reported_users[] = $row;
    }

    echo json_encode(['status' => 'success', 'data' => $reported_users]);
} else {
    error_log("Error fetching reported users: " . $conn->error);
    echo json_encode(['status' => 'error', 'message' => 'Failed to fetch reported users']);
}
?>
