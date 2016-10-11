<?php
// Plugin function for the load_product function plugin
function smarty_function_load_product($params, $smarty)
{
  // Create Product object
  $product = new Product();
  $product->init();

  // Assign template variable
  $smarty->assign($params['assign'], $product);
}

// Handles product details
class Product
{
  // Public variables to be used in Smarty template
  public $mProduct;
  public $mPageLink = 'index.php';
  public $mAddToCartLink;

  // Private stuff
  private $_mProductId;

  // Class constructor
  public function __construct()
  {
    // Variable initialization
    if (isset ($_GET['ProductID']))
      $this->_mProductId = (int)$_GET['ProductID'];
    else
      trigger_error('ProductID required in product.php');
  }

  public function init()
  {
    // Get product details from business tier
    $this->mProduct = Catalog::GetProductDetails($this->_mProductId);

    if (isset ($_SESSION['page_link']))
      $this->mPageLink = $_SESSION['page_link'];

    $this->mAddToCartLink = 'index.php?ProductID=' . $this->_mProductId .
                            '&CartAction=' . ADD_PRODUCT;
  }
}
?>
