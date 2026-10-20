<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

include 'db_connection.php';

// Check if the 'user_id' is set in the POST request
if (isset($_POST['user_id'])) {
    // Get the user_id from the POST request
    $user_id = $_POST['user_id'];

    // Create a SQL query to fetch the user profile
    $query = "SELECT * FROM user WHERE id = ?";

    // Prepare the statement to avoid SQL injection
    if ($stmt = $conn->prepare($query)) {
        // Bind the 'user_id' parameter to the prepared statement
        $stmt->bind_param("s", $user_id);

        // Execute the query
        $stmt->execute();

        // Get the result
        $result = $stmt->get_result();

        // Check if the user exists
        if ($result->num_rows > 0) {
            // Fetch the user profile
            $user_profile = $result->fetch_assoc();

            // Return the profile data as JSON
            echo json_encode([
                'status' => 'success',
                'data' => $user_profile
            ]);
        } else {
            // If no user is found
            echo json_encode([
                'status' => 'error',
                'message' => 'No user found with the given ID.'
            ]);
        }

        // Close the statement
        $stmt->close();
    } else {
        // If SQL query preparation fails
        echo json_encode([
            'status' => 'error',
            'message' => 'Failed to prepare SQL query.'
        ]);
    }
} else {
    // If 'user_id' is not provided in the POST request
    echo json_encode([
        'status' => 'error',
        'message' => 'User ID is required.'
    ]);
}

// Close the database connection
$conn->close();
?>
