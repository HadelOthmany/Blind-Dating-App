<?php
header("Content-Type: application/json");
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

include 'db_connection.php';

if (isset($_POST['id'])) {
    $block_id = (int) $_POST['id'];  

    if ($block_id <= 0) {
        echo json_encode(['status' => 'error', 'message' => 'Invalid block ID']);
        exit;
    }

    $delete_query = "DELETE FROM blocked_users WHERE id = '$block_id'";

    if ($conn->query($delete_query)) {
        echo json_encode(['status' => 'success', 'message' => 'User successfully unblocked']);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Failed to unblock user']);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Missing block ID']);
}
?>
