<?php
$servername = "infinitebe.com";
$username   = "infinmwk_izah";
$password   = "MH6yWvRS9KRsm5L";
$dbname     = "infinmwk_izah_bookbytes";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>