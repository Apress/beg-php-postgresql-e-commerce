<?php
// Plugin functions inside plugin files must be named: smarty_type_name
function smarty_function_load_cart_summary($params, $smarty)
{
  // Create CartSummary object
  $cart_summary = new CartSummary();

  // Assign template variable
  $smarty->assign($params['assign'], $cart_summary);
}

// Class that deals with managing the shopping cart summary
class CartSummary
{
  // Public variables to be used in Smarty template
  public $mTotalAmount;
  public $mItems;
  public $mEmptyCart;

  // Class constructor
  public function __construct()
  {
    // Calculate the total amount for the shopping cart
    $this->mTotalAmount = ShoppingCart::GetTotalAmount();

    // Get shopping cart products
    $this->mItems = ShoppingCart::GetCartProducts(GET_CART_PRODUCTS);

    if (empty($this->mItems))
      $this->mEmptyCart = true;
    else
      $this->mEmptyCart = false;
  }
}
?>
