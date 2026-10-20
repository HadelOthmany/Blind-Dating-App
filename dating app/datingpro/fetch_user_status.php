<?php
header("Content-Type: application/json");
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');
include 'db_connection.php';

$userId = $_POST['user_id'];
$profileId = $_POST['profile_id']; 

$response = [
    'is_favorited' => false,
    'is_liked' => false,
];

$favQuery = "SELECT * FROM favorites WHERE user_id = '$userId' AND favorite_user_id = '$profileId'";
$favResult = mysqli_query($conn, $favQuery);
if (mysqli_num_rows($favResult) > 0) {
    $response['is_favorited'] = true;
}

$likeQuery = "SELECT * FROM likes WHERE user_id = '$userId' AND like_user_id = '$profileId'";
$likeResult = mysqli_query($conn, $likeQuery);
if (mysqli_num_rows($likeResult) > 0) {
    $response['is_liked'] = true;
}

echo json_encode($response);
?>
