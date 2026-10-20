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

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    header("Content-Type: application/json");

    try {
        $userId = isset($_POST['user_id']) ? (int)$_POST['user_id'] : null;
        if (!$userId) {
            error_log("Error: Missing or invalid user_id");
            echo json_encode(['status' => 'error', 'message' => 'Missing or invalid user_id']);
            exit;
        }

        $profileData = [
            'id' => $userId,
            'gender' => $_POST['gender'] ?? '',
            'name' => $_POST['name'] ?? '',
            'email' => $_POST['email'] ?? '',
            'phone_no' => $_POST['phone_no'] ?? '',
            'city' => $_POST['city'] ?? '',
            'country' => $_POST['country'] ?? '',
            'profile_heading' => $_POST['profile_heading'] ?? '',
            'looking_for_partner' => $_POST['looking_for_partner'] ?? '',
            'height' => $_POST['height'] ?? '',
            'weight' => $_POST['weight'] ?? '',
            'body_type' => $_POST['body_type'] ?? '',
            'profession' => $_POST['profession'] ?? '',
            'living_situation' => $_POST['living_situation'] ?? '',
            'willing_to_relocate' => ($_POST['willing_to_relocate'] === '1') ? 1 : 0,
            'relationship_looking_for' => $_POST['relationship_looking_for'] ?? '',
            'nationality' => $_POST['nationality'] ?? '',
            'education' => $_POST['education'] ?? '',
            'languages_spoken' => $_POST['languages_spoken'] ?? '',
            'religion' => $_POST['religion'] ?? '',
            'ethnicity' => $_POST['ethnicity'] ?? '',
            'birthdate' => $_POST['birthdate'] ?? null,
            'drinks' => ($_POST['drinks'] === '1') ? 1 : 0,
            'smokes' => ($_POST['smokes'] === '1') ? 1 : 0,
            'have_children' => ($_POST['have_children'] === '1') ? 1 : 0,
            'no_of_children' => $_POST['no_of_children'] ?? 0,
            'employment_status' => $_POST['employment_status'] ?? '',
            'income' => $_POST['income'] ?? ''
        ];

        error_log("Profile Data: " . json_encode($profileData));

        $query = "UPDATE user SET 
            gender=?,
            name = ?,
            email = ?,
            phone_no = ?,
            city = ?,
            country = ?,
            profile_heading = ?,
            looking_for_partner = ?,
            height = ?,
            weight = ?,
            body_type = ?,
            profession = ?,
            living_situation = ?,
            willing_to_relocate = ?,
            relationship_looking_for = ?,
            nationality = ?,
            education = ?,
            languages_spoken = ?,
            religion = ?,
            ethnicity = ?,
            birthdate = ?,
            drinks = ?,
            smokes = ?,
            have_children = ?,
            no_of_children = ?,
            employment_status = ?,
            income = ?
        WHERE id = ?";

        $stmt = $conn->prepare($query);

        if (!$stmt) {
            error_log("Error: Failed to prepare statement - " . $mysqli->error);
            echo json_encode(['status' => 'error', 'message' => 'Failed to prepare statement: ' . $mysqli->error]);
            exit;
        }

        error_log("SQL Query: " . $query);

        $stmt->bind_param(
            'sssssssssssssssssssssssssssi',
            $profileData['gender'],
            $profileData['name'],
            $profileData['email'],
            $profileData['phone_no'],
            $profileData['city'],
            $profileData['country'],
            $profileData['profile_heading'],
            $profileData['looking_for_partner'],
            $profileData['height'],
            $profileData['weight'],
            $profileData['body_type'],
            $profileData['profession'],
            $profileData['living_situation'],
            $profileData['willing_to_relocate'],
            $profileData['relationship_looking_for'],
            $profileData['nationality'],
            $profileData['education'],
            $profileData['languages_spoken'],
            $profileData['religion'],
            $profileData['ethnicity'],
            $profileData['birthdate'],
            $profileData['drinks'], 
            $profileData['smokes'], 
            $profileData['have_children'], 
            $profileData['no_of_children'],
            $profileData['employment_status'],
            $profileData['income'],
            $profileData['id'] 
        );

        if ($stmt->execute()) {
            echo json_encode(['status' => 'success', 'message' => 'Profile updated successfully']);
        } else {
            error_log("Error executing query: " . $stmt->error);
            echo json_encode(['status' => 'error', 'message' => 'Error updating profile: ' . $stmt->error]);
        }

        $stmt->close();
    } catch (Exception $e) {
        error_log("Exception: " . $e->getMessage());
        echo json_encode(['status' => 'error', 'message' => $e->getMessage()]);
    } finally {
        $conn->close();
    }
} else {
    error_log("Error: Invalid request method");
    echo json_encode(['status' => 'error', 'message' => 'Invalid request method']);
}
?>
