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

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request method']);
    exit;
}

$input_data = json_decode(file_get_contents('php://input'), true);



$reporting_user_id = isset($input_data['reportingUser']) ? (int)$input_data['reportingUser'] : null;
$reported_user_id = isset($input_data['reportedUser']) ? (int)$input_data['reportedUser'] : null;
$report_reason = isset($input_data['message']) ? $input_data['message'] : '';


if (is_null($reporting_user_id) || is_null($reported_user_id) || empty($report_reason)) {
    error_log("Missing required fields: reportingUser, reportedUser, or message");
    echo json_encode(['status' => 'error', 'message' => 'Missing required fields']);
    exit;
}

$sql_insert = "INSERT INTO reported_users (reporting_user_id, reported_user_id, report_reason) VALUES (?, ?, ?)";
$stmt_insert = $conn->prepare($sql_insert);

if (!$stmt_insert) {
    error_log("Error preparing insert query: " . $conn->error);
    echo json_encode(['status' => 'error', 'message' => 'Failed to prepare the insert query']);
    exit;
}

$stmt_insert->bind_param("iis", $reporting_user_id, $reported_user_id, $report_reason);

if ($stmt_insert->execute()) {
    echo json_encode(['status' => 'success', 'message' => 'User reported successfully.']);
} else {
    error_log("Error executing insert query: " . $stmt_insert->error);
    echo json_encode(['status' => 'error', 'message' => 'Failed to report user.']);
}
?>
