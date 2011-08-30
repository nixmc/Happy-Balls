<?php

$db = new SQLite3("happy-balls.db");
$db->exec("INSERT INTO happiness(location, happiness, unhappiness) VALUES (99, 99, 99);");

?>
