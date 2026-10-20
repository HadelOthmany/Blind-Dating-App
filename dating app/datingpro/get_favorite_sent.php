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
// Favorites Sent (profiles that the user has liked)
$sql_sent = "SELECT u.id, u.name, u.gender, u.email, u.phone_no, u.city, u.country, u.profile_heading, u.looking_for_partner,
                    u.height, u.weight, u.body_type, u.profession, u.living_situation, u.willing_to_relocate, 
                    u.relationship_looking_for, u.nationality, u.education, u.languages_spoken, u.religion, 
                    u.ethnicity, u.birthdate, u.drinks, u.smokes, u.have_children, u.no_of_children, 
                    u.employment_status, u.income
             FROM user u 
             JOIN favorites f ON u.id = f.favorite_user_id
             WHERE f.user_id = ?";
$stmt_sent = $conn->prepare($sql_sent);
$stmt_sent->bind_param("i", $user_id);
$stmt_sent->execute();
$result_sent = $stmt_sent->get_result();
$sent_favorites = $result_sent->fetch_all(MYSQLI_ASSOC);

echo json_encode([
    'status' => 'success',
    'data' => $sent_favorites,
]);

$stmt_sent->close();
$conn->close();
?>