<?php
// Load Smarty library and config files
require_once 'include/app_top.php';

// Is the page being accessed through an HTTPS connection?
if (getenv('HTTPS') != 'on')
  $is_https = false;
else
  $is_https = true;

// Visiting a sensitive page?
if (isset($_GET['RegisterCustomer']) ||
    isset($_GET['UpdateAccountDetails']) ||
    isset($_GET['UpdateAddressDetails']) ||
    isset($_GET['UpdateCreditCardDetails']) ||
    isset($_GET['Checkout']) ||
    isset($_POST['Login']))
  $is_sensitive_page = true;
else
  $is_sensitive_page = false;

// Use HTTPS when accessing sensitive pages
if ($is_sensitive_page && $is_https == false && USE_SSL != 'no')
{
   header ('Location: https://' . getenv('SERVER_NAME') .
           getenv('REQUEST_URI'));

   exit;
}

// Don't use HTTPS for nonsensitive pages
if (!$is_sensitive_page && $is_https == true)
{

  $link = 'http://' . getenv('SERVER_NAME');

  // If HTTP_SERVER_PORT is defined and different than default
  if (defined('HTTP_SERVER_PORT') && HTTP_SERVER_PORT != '80')
  {
    // Append server port
    $link .= ':' . HTTP_SERVER_PORT;
  }

  $link .= getenv('REQUEST_URI');

   header ('Location: ' . $link);

   exit;
}

/* If not visiting a product page, save the link to the current page
   in the page_link session variable; it will be used to create the
   Continue Shopping link in the product details page and the links
   to product details pages */
if (!isset ($_GET['ProductID']) && !isset ($_GET['CartAction']))
  $_SESSION['page_link'] = substr(getenv('REQUEST_URI'),
                                  strrpos(getenv('REQUEST_URI'), '/') + 1,
                                  strlen(getenv('REQUEST_URI')) - 1);

// Load Smarty template file
$page = new Page();

// Define the template file for the page contents
$pageContentsCell = 'first_page_contents.tpl';

// Define the template file for the categories cell
$categoriesCell = 'blank.tpl';

// Define the template file for the cart summary cell
$cartSummaryCell = 'blank.tpl';

// Load department details if visiting a department
if (isset ($_GET['DepartmentID']))
{
  if ((string) $_GET['DepartmentID'] == AMAZON_DEPARTMENT_TITLE)
    $pageContentsCell = 'amazon_products_list.tpl';
  else
  {
    $pageContentsCell = 'department.tpl';
    $categoriesCell = 'categories_list.tpl';
  }
}

// Load search result page if we're searching the catalog
if (isset ($_GET['Search']))
  $pageContentsCell = 'search_results.tpl';

// Load product details page if visiting a product
if (isset ($_GET['ProductID']))
  $pageContentsCell = 'product.tpl';

if (isset ($_GET['CartAction']))
{
  $pageContentsCell = 'cart_details.tpl';
}
else
  $cartSummaryCell = 'cart_summary.tpl';

// Customer account functionality
$customerLoginOrLogged = 'customer_login.tpl';

if (Customer::IsAuthenticated())
  $customerLoginOrLogged = 'customer_logged.tpl';

$hide_boxes = false;

if (isset ($_GET['Checkout']))
{
  if (Customer::IsAuthenticated())
    $pageContentsCell = 'checkout_info.tpl';
  else
    $pageContentsCell = 'checkout_not_logged.tpl';

  $hide_boxes = true;
}

if (isset($_GET['RegisterCustomer']) || isset($_GET['UpdateAccountDetails']))
  $pageContentsCell = 'customer_details.tpl';
elseif (isset($_GET['UpdateAddressDetails'])) 
  $pageContentsCell = 'customer_address.tpl';
elseif (isset($_GET['UpdateCreditCardDetails']))
  $pageContentsCell = 'customer_credit_card.tpl';

if (isset($_GET['OrderDone']))
  $pageContentsCell = 'order_done.tpl';
elseif (isset($_GET['OrderError']))
  $pageContentsCell = 'order_error.tpl';

$page->assign('hide_boxes', $hide_boxes);
$page->assign('customerLoginOrLogged', $customerLoginOrLogged);

// Assign a template file to the cart summary cell
$page->assign('cartSummaryCell', $cartSummaryCell);

// Assign a template file to the page contents cell
$page->assign('pageContentsCell', $pageContentsCell);
$page->assign('categoriesCell', $categoriesCell);

// Display the page
$page->display('index.tpl');

// Load app_bottom which closes the database connection
require_once 'include/app_bottom.php';
?>
