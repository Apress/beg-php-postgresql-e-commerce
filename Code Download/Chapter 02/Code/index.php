<?php
// Load Smarty library and config files
require_once 'include/app_top.php';

// Load Smarty template file
$page = new Page();

// Display the page
$page->display('index.tpl');
?>
