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

$reportId = isset($_POST['report_id']) ? (int)$_POST['report_id'] : null;

if (!$reportId) {
    echo json_encode(['status' => 'error', 'message' => 'Invalid report ID']);
    exit;
}

$sql_delete = "DELETE FROM reported_users WHERE report_id = ?";
$stmt_delete = $conn->prepare($sql_delete);

if (!$stmt_delete) {
    error_log("Error preparing delete query: " . $conn->error);
    echo json_encode(['status' => 'error', 'message' => 'Failed to prepare the delete query']);
    exit;
}

$stmt_delete->bind_param("i", $reportId);

if ($stmt_delete->execute()) {
    echo json_encode(['status' => 'success', 'message' => 'Report removed successfully.']);
} else {
    error_log("Error executing delete query: " . $stmt_delete->error);
    echo json_encode(['status' => 'error', 'message' => 'Failed to remove report.']);
}
?>
