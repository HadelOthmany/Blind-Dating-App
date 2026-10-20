<?php
header("Content-Type: application/json");
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

include 'db_connection.php';

$currentUserId = isset($_GET['currentUserId']) ? (int)$_GET['currentUserId'] : 0;

$sql = "
    SELECT DISTINCT 
        CASE 
            WHEN m.sender_id = $currentUserId THEN m.receiver_id 
            ELSE m.sender_id 
        END AS chat_partner_id,
        u.name AS chat_partner_name,
        u.email AS chat_partner_email,
        MAX(m.created_at) AS last_message_time,
        (SELECT m2.message 
         FROM messages m2 
         WHERE (m2.sender_id = m.sender_id AND m2.receiver_id = m.receiver_id) 
         OR (m2.sender_id = m.receiver_id AND m2.receiver_id = m.sender_id)
         ORDER BY m2.created_at DESC LIMIT 1) AS last_message
    FROM messages m
    JOIN user u ON u.id = CASE 
            WHEN m.sender_id = $currentUserId THEN m.receiver_id 
            ELSE m.sender_id 
        END
    WHERE m.sender_id = $currentUserId OR m.receiver_id = $currentUserId
    GROUP BY chat_partner_id
    ORDER BY last_message_time DESC;
";

$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $chats = [];
    
    while ($row = $result->fetch_assoc()) {
        $chats[] = [
            'chat_partner_id' => (string)$row['chat_partner_id'],
            'chat_partner_name' => $row['chat_partner_name'],
            'chat_partner_email' => $row['chat_partner_email'],
            'last_message_time' => $row['last_message_time'],
            'last_message' => $row['last_message']
        ];
    }

    echo json_encode([
        'status' => 'success',
        'chats' => $chats
    ]);
} else {
    echo json_encode([
        'status' => 'error',
        'message' => 'No chats found'
    ]);
}
?>
