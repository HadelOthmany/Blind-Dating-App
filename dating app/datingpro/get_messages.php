<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

include 'db_connection.php';


$userId = $_POST['user_id'];
$otherUserId = $_POST['other_user_id'];

$sql = "SELECT sender_id, message 
        FROM messages 
        WHERE (sender_id = ? AND receiver_id = ?) 
        OR (sender_id = ? AND receiver_id = ?) 
        ORDER BY created_at ASC";

$stmt = $conn->prepare($sql);
$stmt->bind_param("iiii", $userId, $otherUserId, $otherUserId, $userId);

if (!$stmt->execute()) {
    echo json_encode(["error" => "SQL query execution failed: " . $stmt->error]);
    exit;
}

$result = $stmt->get_result();

$messages = [];
while ($row = $result->fetch_assoc()) {
    $messages[] = $row;
}

echo json_encode($messages);

$stmt->close();
$conn->close();

?>
