<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header('Content-Type: application/json');
require_once 'db_connection.php';

$input_data = json_decode(file_get_contents('php://input'), true);

$user_id = isset($input_data['user_id']) ? intval($input_data['user_id']) : 0;
$filters = isset($input_data['filters']) ? $input_data['filters'] : [];

if (empty($filters)) {
    echo json_encode(['error' => 'No valid filters provided']);
    exit;
}

$where_clauses = [];
$params = [];

foreach ($filters as $key => $value) {
    if ($value !== null && $value !== '') {
        $where_clauses[] = "$key = ?";
        $params[] = $value;
    }
}

if (empty($where_clauses)) {
    echo json_encode(['error' => 'No valid filters provided']);
    exit;
}

$sql = "SELECT * FROM user WHERE id != ?"; 
if (!empty($where_clauses)) {
    $sql .= " AND " . implode(" AND ", $where_clauses);
}

$stmt = $conn->prepare($sql);
if ($stmt === false) {
    echo json_encode(['error' => 'Error preparing SQL query']);
    exit;
}

$types = str_repeat('s', count($params) + 1); 
$stmt->bind_param($types, $user_id, ...$params);

$stmt->execute();
$result = $stmt->get_result();

$users = [];
while ($user = $result->fetch_assoc()) {
    $users[] = $user;  
}

echo json_encode($users);

$stmt->close();
$conn->close();
?>
