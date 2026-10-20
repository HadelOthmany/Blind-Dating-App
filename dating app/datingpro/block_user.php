<?php
header("Content-Type: application/json");
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

include 'db_connection.php'; 


if (isset($_POST['user_id'], $_POST['email'], $_POST['report_reason'], $_POST['report_id'])) {
    $user_id = (int) $_POST['user_id'];  
    $reported_user_email = $conn->real_escape_string($_POST['email']);
    $report_reason = $conn->real_escape_string($_POST['report_reason']);
    $report_id = (int) $_POST['report_id']; 

    if ($user_id <= 0 || $report_id <= 0) {
        echo json_encode(['status' => 'error', 'message' => 'Invalid user ID or report ID']);
        exit;
    }

    $conn->begin_transaction();

    try {
        $insert_query = "INSERT INTO blocked_users (user_id, email, report_reason)
                         VALUES ('$user_id', '$reported_user_email', '$report_reason')";

        if (!$conn->query($insert_query)) {
            throw new Exception("Error inserting into blocked_users table: " . $conn->error);
        }

        $delete_query = "DELETE FROM reported_users WHERE report_id = '$report_id'";

        if (!$conn->query($delete_query)) {
            throw new Exception("Error deleting from reported_users table: " . $conn->error);
        }

        $conn->commit();

        echo json_encode(['status' => 'success', 'message' => 'User successfully blocked and report removed']);
    } catch (Exception $e) {
        $conn->rollback();

        echo json_encode(['status' => 'error', 'message' => $e->getMessage()]);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Missing required parameters']);
}
?>
