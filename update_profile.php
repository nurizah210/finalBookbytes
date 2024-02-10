<?php
include_once("dbconnect.php");

// Check if the request is not empty
if (empty($_POST)) {
    $response = array('status' => 'failed', 'message' => 'Empty request');
    sendJsonResponse($response);
    die();
}

// Check for image update
if (isset($_POST['image'])) {
    $encoded_string = $_POST['image'];
    $userid = $_POST['userid'];
    $decoded_string = base64_decode($encoded_string);
    $path = '../assets/profileimages/' . $userid . '.png';
    $is_written = file_put_contents($path, $decoded_string);
    if ($is_written) {
        $response = array('status' => 'success', 'message' => 'Image updated successfully');
    } else {
        $response = array('status' => 'failed', 'message' => 'Failed to update image');
    }
    sendJsonResponse($response);
    die();
}

// Check for other updates
if (isset($_POST['newphone'])) {
    $phone = $_POST['newphone'];
    $userid = $_POST['userid'];
    $sqlupdate = "UPDATE tbl_users SET user_phone ='$phone' WHERE user_id = '$userid'";
    databaseUpdate($sqlupdate, 'Phone updated successfully', 'Failed to update phone');
    die();
}

if (isset($_POST['oldpass'])) {
    $oldpass = $_POST['oldpass'];
    $newpass = $_POST['newpass'];
    $userid = $_POST['userid'];
    updatePassword($userid, $oldpass, $newpass);
    die();
}

if (isset($_POST['newname'])) {
    $name = $_POST['newname'];
    $userid = $_POST['userid'];
    $sqlupdate = "UPDATE tbl_users SET user_name ='$name' WHERE user_id = '$userid'";
    databaseUpdate($sqlupdate, 'Name updated successfully', 'Failed to update name');
    die();
}

// Function to update the database
function databaseUpdate($sql, $successMessage, $failureMessage)
{
    global $conn;
    if ($conn->query($sql) === TRUE) {
        $response = array('status' => 'success', 'message' => $successMessage);
    } else {
        $response = array('status' => 'failed', 'message' => $failureMessage, 'error' => $conn->error);
    }
    sendJsonResponse($response);
}

// Function to update the password
function updatePassword($userid, $oldpass, $newpass)
{
    global $conn;
    $sqllogin = "SELECT * FROM tbl_users WHERE user_id = '$userid'";
    $result = $conn->query($sqllogin);
    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        $currentPassword = $row['user_password'];

        // Verify old password
        if (password_verify($oldpass, $currentPassword)) {
            // Update password
            $hashedNewPass = password_hash($newpass, PASSWORD_BCRYPT);
            $sqlupdate = "UPDATE tbl_users SET user_password ='$hashedNewPass' WHERE user_id = '$userid'";
            databaseUpdate($sqlupdate, 'Password updated successfully', 'Failed to update password');
        } else {
            $response = array('status' => 'failed', 'message' => 'Incorrect old password');
            sendJsonResponse($response);
        }
    } else {
        $response = array('status' => 'failed', 'message' => 'User not found');
        sendJsonResponse($response);
    }
}

// Function to send JSON response
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}


$conn->close();
?>
