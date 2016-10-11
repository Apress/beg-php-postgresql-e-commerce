<?php
/* Smarty plugin function that gets called when the
   load_checkout_info function plugin is loaded from a template */
function smarty_function_load_checkout_info($params, $smarty)
{
  // Create CheckoutInfo object
  $checkout_info = new CheckoutInfo();
  $checkout_info->init();

  // Assign template variable
  $smarty->assign($params['assign'], $checkout_info);
}

// Class that supports the checkout page
class CheckoutInfo
{
  // Public attributes
  public $mCartItems;
  public $mTotalAmountLabel;
  public $mCreditCardNote;
  public $mEditCart = 'index.php?CartAction';
  public $mOrderButtonVisible;
  public $mNoShippingAddress = 'no';
  public $mNoCreditCard = 'no';
  public $mContinueShopping;
  public $mCheckoutInfoLink;
  public $mPlainCreditCard;
  public $mShippingRegion;

  // Private attributes
  private $_mPlaceOrder = 0;

  // Class constructor
  public function __construct()
  {
    if (isset ($_POST['sended']))
      $this->_mPlaceOrder = 1;
  }

  public function init()
  {
    // If the Place Order button was clicked, save the order to database
    if ($this->_mPlaceOrder == 1)
    {
      $order_id = ShoppingCart::CreateOrder();

      // Redirect to index.php
      $redirect_link = 'http://' . getenv('SERVER_NAME');

      // If HTTP_SERVER_PORT is defined and different than default
      if (defined('HTTP_SERVER_PORT') && HTTP_SERVER_PORT != '80')
      {
        // Append server port
        $redirect_link .= ':' . HTTP_SERVER_PORT;
      }

      $redirect_link .= VIRTUAL_LOCATION . 'index.php';

      header('Location:' . $redirect_link);

      exit;
    }

    $this->mCheckoutInfoLink = substr(getenv('REQUEST_URI'),
                                 strrpos(getenv('REQUEST_URI'), '/') + 1,
                                 strlen(getenv('REQUEST_URI')) - 1);

    // Set members for use in the Smarty template
    $this->mCartItems = ShoppingCart::GetCartProducts(GET_CART_PRODUCTS);
    $this->mTotalAmountLabel = ShoppingCart::GetTotalAmount();
    $this->mContinueShopping = $_SESSION['page_link'];
    $this->mCustomerData = Customer::Get();

    // We allow placing orders only if we have complete customer details
    if (empty ($this->mCustomerData['credit_card']))
    {
      $this->mOrderButtonVisible = 'disabled="disabled"';
      $this->mNoCreditCard = 'yes';
    }
    else
    {
      $this->mPlainCreditCard = Customer::DecryptCreditCard(
                                  $this->mCustomerData['credit_card']);

      $this->mCreditCardNote = 'Credit card to use: ' .
                               $this->mPlainCreditCard['card_type'] .
                               '<br />Card number: ' .
                               $this->mPlainCreditCard['card_number_x'];
    }

    if (empty ($this->mCustomerData['address_1']))
    {
      $this->mOrderButtonVisible = 'disabled="disabled"';
      $this->mNoShippingAddress = 'yes';
    }
    else
    {
      $shipping_regions = Customer::GetShippingRegions();

      foreach ($shipping_regions as $item)
        if ($item['shipping_region_id'] ==
            $this->mCustomerData['shipping_region_id'])
        $this->mShippingRegion = $item['shipping_region'];
    }
  }
}
?>
