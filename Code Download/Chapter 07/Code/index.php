<?php
// Load Smarty library and config files
require_once 'include/app_top.php';

/* If not visiting a product page, save the link to the current page
   in the page_link session variable; it will be used to create the
   Continue Shopping link in the product details page and the links
   to product details pages */
if (!isset ($_GET['ProductID']))
  $_SESSION['page_link'] = substr(getenv('REQUEST_URI'),
                                  strrpos(getenv('REQUEST_URI'), '/') + 1,
                                  strlen(getenv('REQUEST_URI')) - 1);

// Load Smarty template file
$page = new Page();

// Define the template file for the page contents
$pageContentsCell = 'first_page_contents.tpl';

// Define the template file for the categories cell
$categoriesCell = 'blank.tpl';

// Load department details if visiting a department
if (isset ($_GET['DepartmentID']))
{
  $pageContentsCell = 'department.tpl';
  $categoriesCell = 'categories_list.tpl';
}

// Load search result page if we're searching the catalog
if (isset ($_GET['Search']))
  $pageContentsCell = 'search_results.tpl';

// Load product details page if visiting a product
if (isset ($_GET['ProductID']))
  $pageContentsCell = 'product.tpl';

// Assign a template file to the page contents cell
$page->assign('pageContentsCell', $pageContentsCell);
$page->assign('categoriesCell', $categoriesCell);

// Display the page
$page->display('index.tpl');

// Load app_bottom which closes the database connection
require_once 'include/app_bottom.php';
?>
