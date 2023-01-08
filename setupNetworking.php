<?php
  $v6network = exec("ifconfig ens18 | grep -i 'inet6 '". $output);
  $v4network = "";
  
