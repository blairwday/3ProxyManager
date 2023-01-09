<?php

	$interface = "ens18";
	$networkSize = "64";
	$maxCount = 400;
	$startingPort = 50000;
	
	/*
	
		timezone="America/Chicago"
echo "${timezone}" | sudo tee /etc/timezone
sudo ln -fs "/usr/share/zoneinfo/${timezone}" /etc/localtime
sudo dpkg-reconfigure -f noninteractive tzdata

trap cleanup EXIT SIGHUP SIGINT SIGTERM

*/
	

	// Get v6 Address
	exec("ifconfig ".$interface." | grep -i 'inet6 '", $v6config);
	for($i = 0; $i < sizeof($v6config); $i++){
		if(strpos($v6config[$i], "::1") !== false){
			$v6network = $v6config[$i];
			break;
		}
	}
	$v6network = explode('inet6 ', $v6network);
	$v6network = explode('::1  prefixlen 44', $v6network[1]);
	$v6network = $v6network[0];

	// Get v4 Address
	exec("ifconfig ".$interface." | grep -i 'inet '", $v4network);
	$v4network = explode('inet ', $v4network[0]);
	$v4network = explode('  netmask', $v4network[1]);
	$v4network = $v4network[0];
	
	// Run Network Setup
	$proxyList = generateIPv6List($maxCount, $v6network);
	$result = generateIfConfig($interface, $networkSize, $proxyList);
	
	
	
	//$result = createValidUsers();
	//$result = configureThreeProxy($startingPort, $v4network, $proxyList);
	//var_dump($proxyList);
  
	
  
	function generateIPv6List($maxCount, $prefix){
		// Clear Old File
		file_put_contents('ipv6.txt', "");
		
		// Create Random Proxies
		$proxyArray = array();
		for($i = 1; $i <= $maxCount; $i++){
			$currentProxy = $prefix.":".createCouple().":".createCouple().":".createCouple().":".createCouple();
			
			array_push($proxyArray, $currentProxy);
			file_put_contents('ipv6.txt', $currentProxy."\r\n", FILE_APPEND);
		}
		return $proxyArray;
	}
	
	function createCouple(){
		$characterArray = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'];
		$string = "";
		for ($i = 0; $i < 4; $i++) {
			$index = rand(0, sizeof($characterArray) - 1);
			$string .= $characterArray[$index];
		}
		return $string;
	}
	
	function generateIfConfig($interface, $networkSize, $proxyArray){
		
		if(file_exists('ifconfig.txt')){
			// Delete Existing Records
			$oldIPs = file_get_contents('ifconfig.txt');
			$oldIPs = str_replace(" add ", " del ", $oldIPs);
			$oldArray = explode("\r\n", $oldIPs);
			for($i = 0; $i < sizeof($oldArray)-1; $i++){
				exec($oldArray[$i]);	
			}
		
			// Clear Old File
			file_put_contents('ifconfig.txt', "");
		}

		// Loop Through Proxies
		for($i = 0; $i < sizeof($proxyArray); $i++){
			$configLine = "ifconfig ".$interface." inet6 add ".$proxyArray[$i]."/".$networkSize;
			file_put_contents('ifconfig.txt', $configLine."\r\n", FILE_APPEND);
			exec($configLine);
		}
		
		return true;
		
	}
	
	function createValidUsers(){
		// Clear Old File
		file_put_contents('/etc/3proxy/users.conf', "");
		
		// Add Users
		$userLine = "users wings:NT:43F7D44889BDAE557E8A4B39DB58A38F\r\n";
		file_put_contents('/etc/3proxy/users.conf', $userLine, FILE_APPEND);
	}
	
	function configureThreeProxy($startingPort, $serverIP, $proxyArray){
		// Clear Old File
		file_put_contents('/etc/3proxy/3proxy.cfg', "");
		
		// Add Config Variables
		$threeProxy = array();
		//array_push($threeProxy, "include /conf/3proxy.cfg");
		//array_push($threeProxy, "daemon");
		array_push($threeProxy, "maxconn 800");
		array_push($threeProxy, "nserver 1.1.1.1");
		array_push($threeProxy, "nserver [2606:4700:4700::1111]");
		array_push($threeProxy, "nserver [2606:4700:4700::1001]");
		array_push($threeProxy, "nserver [2001:4860:4860::8888]");
		array_push($threeProxy, "nscache 65536");
		array_push($threeProxy, "timeouts 1 5 30 60 180 1800 15 60");
		array_push($threeProxy, "setgid 65535");
		array_push($threeProxy, "setuid 65535");
		array_push($threeProxy, "stacksize 6291456");
		array_push($threeProxy, "flush");
		array_push($threeProxy, "auth strong cache");
		array_push($threeProxy, "users proxy:CL:789789");
		array_push($threeProxy, "allow proxy");
		for($i = 0; $i < sizeof($threeProxy); $i++){
			file_put_contents('/etc/3proxy/3proxy.cfg', $threeProxy[$i]."\r\n", FILE_APPEND);
		}
		
		// Add Config Proxies
		for($i = 0; $i < sizeof($proxyArray); $i++){
			$proxyLine = "proxy -6 -n -a -p".($startingPort+$i)." -i".$serverIP." -e".$proxyArray[$i]; 
			file_put_contents('/etc/3proxy/3proxy.cfg', $proxyLine, FILE_APPEND);
		}
	}