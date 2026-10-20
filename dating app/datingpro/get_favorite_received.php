<?php
header("Content-Type: application/json");
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

include 'db_connection.php';  

if (!$conn) {
    // Log and return a connection error
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

$sql_received = "SELECT u.id, u.gender, u.name, u.email, u.phone_no, u.city, u.country, u.profile_heading, u.looking_for_partner,
                    u.height, u.weight, u.body_type, u.profession, u.living_situation, u.willing_to_relocate, 
                    u.relationship_looking_for, u.nationality, u.education, u.languages_spoken, u.religion, 
                    u.ethnicity, u.birthdate, u.drinks, u.smokes, u.have_children, u.no_of_children, 
                    u.employment_status, u.income
                     FROM user u
                 JOIN favorites f ON u.id = f.user_id
                 WHERE f.favorite_user_id = ?";
$stmt_received = $conn->prepare($sql_received);
$stmt_received->bind_param("i", $user_id);
$stmt_received->execute();
$result_received = $stmt_received->get_result();

$received_favorites = $result_received->fetch_all(MYSQLI_ASSOC);

echo json_encode([
    'status' => 'success',
    'data' => $received_favorites,
]);


$stmt_received->close();
$conn->close();
?>