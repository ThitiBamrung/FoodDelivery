<?php
	include 'connected.php';
	header("Access-Control-Allow-Origin: *");

if (!$link) {
    echo "Error: Unable to connect to MySQL." . PHP_EOL;
    echo "Debugging errno: " . mysqli_connect_errno() . PHP_EOL;
    echo "Debugging error: " . mysqli_connect_error() . PHP_EOL;
    
    exit;
}

if (!$link->set_charset("utf8")) {
    printf("Error loading character set utf8: %s\n", $link->error);
    exit();
	}

if (isset($_GET)) {
	if ($_GET['isAdd'] == 'true') {
				
		$name = $_GET['name'];
		$lastname = $_GET['lastname'];
		$phone = $_GET['phone'];
		$email = $_GET['email'];
		$password = $_GET['password'];
		$n_restaurant = $_GET['n_restaurant'];
		$address = $_GET['address'];
		$lat = $_GET['lat'];
		$lng = $_GET['lng'];
		
							
		$sql = "INSERT INTO `restaurant`(`id`, `name`, `lastname`, `phone`, `email`, `password`, `n_restaurant`, `address`, `lat`, `lng`) VALUES (Null,'$name','$lastname','$phone','$email','$password','$n_restaurant','$address','$lat','$lng')";

		$result = mysqli_query($link, $sql);

		if ($result) {
			echo "true";
		} else {
			echo "false";
		}

	} else echo "Welcome Master Top";
   
}
	mysqli_close($link);
?>