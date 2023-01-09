<?php
	$timezone= "America/Chicago";
	date_default_timezone_set($timezone);
	exec("sudo dpkg-reconfigure -f noninteractive tzdata");
	exec("trap cleanup EXIT SIGHUP SIGINT SIGTERM");