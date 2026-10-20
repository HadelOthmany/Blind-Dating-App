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

// Likes Sent (profiles that the user has liked)
$sql_sent = "SELECT u.id, u.name, u.gender, u.email, u.phone_no, u.city, u.country, u.profile_heading, u.looking_for_partner,
                    u.height, u.weight, u.body_type, u.profession, u.living_situation, u.willing_to_relocate, 
                    u.relationship_looking_for, u.nationality, u.education, u.languages_spoken, u.religion, 
                    u.ethnicity, u.birthdate, u.drinks, u.smokes, u.have_children, u.no_of_children, 
                    u.employment_status, u.income
             FROM user u 
             JOIN likes l ON u.id = l.like_user_id
             WHERE l.user_id = ?";  
             
$stmt_sent = $conn->prepare($sql_sent);

if (!$stmt_sent) {
    error_log("Error preparing SQL query: " . $conn->error);
    echo json_encode(['status' => 'error', 'message' => 'Failed to prepare the query']);
    exit;
}

$stmt_sent->bind_param("i", $user_id);

if (!$stmt_sent->execute()) {
    error_log("Error executing query: " . $stmt_sent->error);
    echo json_encode(['status' => 'error', 'message' => 'Failed to retrieve sent likes']);
    exit;
}

$result_sent = $stmt_sent->get_result();
$sent_likes = $result_sent->fetch_all(MYSQLI_ASSOC);

if (empty($sent_likes)) {
    echo json_encode(['status' => 'success', 'message' => 'No likes sent', 'data' => []]);
} else {
    echo json_encode(['status' => 'success', 'data' => $sent_likes]);
}

if (isset($stmt_sent)) {
    $stmt_sent->close();
}
if (isset($conn)) {
    $conn->close();
}
?>
