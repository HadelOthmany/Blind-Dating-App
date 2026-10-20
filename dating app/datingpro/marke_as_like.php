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

$user_id = isset($_POST['user_id']) ? (int)$_POST['user_id'] : null;
$like_user_id = isset($_POST['like_user_id']) ? (int)$_POST['like_user_id'] : null;

if (is_null($user_id) || is_null($like_user_id) || $user_id <= 0 || $like_user_id <= 0) {
    echo json_encode(['status' => 'error', 'message' => 'Invalid input data']);
    exit;
}

$sql_check = "SELECT * FROM likes WHERE user_id = ? AND like_user_id = ?";
$stmt_check = $conn->prepare($sql_check);

if (!$stmt_check) {
    error_log("Error preparing check query: " . $conn->error);
    echo json_encode(['status' => 'error', 'message' => 'Failed to prepare the query']);
    exit;
}

$stmt_check->bind_param("ii", $user_id, $like_user_id);
$stmt_check->execute();
$result = $stmt_check->get_result();

if ($result === false) {
    error_log("Error executing check query: " . $stmt_check->error);
    echo json_encode(['status' => 'error', 'message' => 'Failed to check like status']);
    exit;
}

if ($result->num_rows > 0) {
    $sql_delete = "DELETE FROM likes WHERE user_id = ? AND like_user_id = ?";
    $stmt_delete = $conn->prepare($sql_delete);

    if (!$stmt_delete) {
        error_log("Error preparing delete query: " . $conn->error);
        echo json_encode(['status' => 'error', 'message' => 'Failed to prepare the delete query']);
        exit;
    }

    $stmt_delete->bind_param("ii", $user_id, $like_user_id);
    if ($stmt_delete->execute()) {
        echo json_encode(['status' => 'success', 'message' => 'like removed successfully.']);
    } else {
        error_log("Error executing delete query: " . $stmt_delete->error);
        echo json_encode(['status' => 'error', 'message' => 'Failed to remove like.']);
    }
} else {
    $sql_insert = "INSERT INTO likes (user_id, like_user_id) VALUES (?, ?)";
    $stmt_insert = $conn->prepare($sql_insert);

    if (!$stmt_insert) {
        error_log("Error preparing insert query: " . $conn->error);
        echo json_encode(['status' => 'error', 'message' => 'Failed to prepare the insert query']);
        exit;
    }

    $stmt_insert->bind_param("ii", $user_id, $like_user_id);
    if ($stmt_insert->execute()) {
        echo json_encode(['status' => 'success', 'message' => 'Profile marked as liked.']);
    } else {
        error_log("Error executing insert query: " . $stmt_insert->error);
        echo json_encode(['status' => 'error', 'message' => 'Failed to mark as liked.']);
    }
}

if (isset($stmt_check)) $stmt_check->close();
if (isset($stmt_delete)) $stmt_delete->close();
if (isset($stmt_insert)) $stmt_insert->close();
if (isset($conn)) $conn->close();
?>
