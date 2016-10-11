<?php
// Load Smarty library and config files
require_once 'include/app_top.php';

// Enforce page to be accessed through HTTPS
if (USE_SSL != 'no' and getenv('HTTPS') != 'on')
{
  header ('Location: https://' . getenv('SERVER_NAME') .
          getenv('REQUEST_URI'));

  exit();
}

// Load Smarty template file
$page = new Page();

// Define the template file for the page menu
$pageMenuCell = 'blank.tpl';

// Define the template file for the page contents
$pageContentsCell = 'blank.tpl';

// If admin is not logged, assign admin_login template to $pageContentsCell
if (!(isset ($_SESSION['admin_logged'])) || $_SESSION['admin_logged'] != true)
  $pageContentsCell = 'admin_login.tpl';
else
{
  // If admin is logged, load the admin page menu
  $pageMenuCell = 'admin_menu.tpl';

  if (isset ($_GET['Page']))
    $admin_page = $_GET['Page'];
  // If Page is not explicitly set, assume the Departments page
  else
    $admin_page = 'Departments';

  // If loggin out ...
  if (isset ($_GET['Page']) && ($_GET['Page'] == 'Logout'))
  {
    unset($_SESSION['admin_logged']);
    header('Location: admin.php');

    exit;
  }

  // Choose what admin page to load ...
  if ($admin_page == 'Departments')
    $pageContentsCell = 'admin_departments.tpl';
  elseif ($admin_page == 'Categories')
    $pageContentsCell = 'admin_categories.tpl';
  elseif ($admin_page == 'Products')
    $pageContentsCell = 'admin_products.tpl';
  elseif ($admin_page == 'ProductDetails')
    $pageContentsCell = 'admin_product.tpl';
}

// Assign templates file to be loaded
$page->assign('pageMenuCell', $pageMenuCell);
$page->assign('pageContentsCell', $pageContentsCell);

// Display the page
$page->display('admin.tpl');

// Load app_bottom which closes the database connection
require_once 'include/app_bottom.php';
?>
