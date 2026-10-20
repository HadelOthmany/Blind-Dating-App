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

if (isset($_POST['user_id']) && is_numeric($_POST['user_id'])) {
    $user_id = (int)$_POST['user_id'];
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid user ID']);
    exit;
}

// Favorites Received (profiles who have liked the user)
$sql_received = "SELECT u.id, u.gender, u.name, u.email, u.phone_no, u.city, u.country, u.profile_heading, u.looking_for_partner,
                    u.height, u.weight, u.body_type, u.profession, u.living_situation, u.willing_to_relocate, 
                    u.relationship_looking_for, u.nationality, u.education, u.languages_spoken, u.religion, 
                    u.ethnicity, u.birthdate, u.drinks, u.smokes, u.have_children, u.no_of_children, 
                    u.employment_status, u.income
                     FROM user u
                 JOIN likes l ON u.id = l.user_id
                 WHERE l.like_user_id = ?";
$stmt_received = $conn->prepare($sql_received);

if (!$stmt_received) {
    error_log("Error preparing the SQL query: " . $conn->error);
    echo json_encode(['status' => 'error', 'message' => 'Failed to prepare the query']);
    exit;
}

$stmt_received->bind_param("i", $user_id);

if (!$stmt_received->execute()) {
    error_log("Error executing query: " . $stmt_received->error);
    echo json_encode(['status' => 'error', 'message' => 'Failed to retrieve received likes']);
    exit;
}

$result_received = $stmt_received->get_result();
$received_likes = $result_received->fetch_all(MYSQLI_ASSOC);

if (empty($received_likes)) {
    echo json_encode(['status' => 'success', 'message' => 'No likes received', 'data' => []]);
} else {
    echo json_encode(['status' => 'success', 'data' => $received_likes]);
}

if (isset($stmt_received)) {
    $stmt_received->close();
}
if (isset($conn)) {
    $conn->close();
}
?>
