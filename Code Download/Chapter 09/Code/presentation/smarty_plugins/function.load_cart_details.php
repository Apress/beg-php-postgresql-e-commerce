<?php
// Plugin functions inside plugin files must be named: smarty_type_name
function smarty_function_load_cart_details($params, $smarty)
{

  $cart_details = new CartDetails();
  $cart_details->init();

  // Assign template variable
  $smarty->assign($params['assign'], $cart_details);
}

// Class that deals with managing the shopping cart
class CartDetails
{
  // Public variables available in smarty template
  public $mCartProducts;
  public $mSavedCartProducts;
  public $mTotalAmount;
  public $mIsCartNowEmpty = 0; // Is the shopping cart empty?
  public $mIsCartLaterEmpty = 0; // Is the 'saved for later' list empty?
  public $mCartReferrer = 'index.php';
  public $mCartDetailsTarget;

  // Private attributes
  private $_mProductId;
  private $_mCartAction;

  // Class constructor
  public function __construct()
  {
    // Setting the "Continue shopping" button target
    if (isset ($_SESSION['page_link']))
      $this->mCartReferrer = $_SESSION['page_link'];

    if (isset ($_GET['CartAction']))
      $this->mCartAction = $_GET['CartAction'];
    else
      trigger_error('CartAction not set', E_USER_ERROR);

    // These cart operations require a valid product id
    if ($this->mCartAction == ADD_PRODUCT ||
        $this->mCartAction == REMOVE_PRODUCT ||
        $this->mCartAction == SAVE_PRODUCT_FOR_LATER ||
        $this->mCartAction == MOVE_PRODUCT_TO_CART)

    if (isset ($_GET['ProductID']))
      $this->mProductId = $_GET['ProductID'];
    else
      trigger_error('ProductID must be set for this type of request',
                    E_USER_ERROR);

    $this->mCartDetailsTarget = 'index.php?CartAction=' .
                                UPDATE_PRODUCTS_QUANTITIES;
  }

  public function init()
  {
    switch ($this->mCartAction)
    {
      case ADD_PRODUCT:
        ShoppingCart::AddProduct($this->mProductId);
        header('Location: ' . $this->mCartReferrer);

        break;
      case REMOVE_PRODUCT:
        ShoppingCart::RemoveProduct($this->mProductId);

        break;
      case UPDATE_PRODUCTS_QUANTITIES:
        ShoppingCart::Update($_POST['productID'], $_POST['quantity']);

        break;
      case SAVE_PRODUCT_FOR_LATER:
        ShoppingCart::SaveProductForLater($this->mProductId);

        break;
      case MOVE_PRODUCT_TO_CART:
        ShoppingCart::MoveProductToCart($this->mProductId);

        break;
      default:
        // Do nothing
        break;
    }

    // Calculate the total amount for the shopping cart
    $this->mTotalAmount = ShoppingCart::GetTotalAmount();

    // If the Place Order button was clicked ...
    if(isset ($_POST['place_order']))
    {
      // Create the order and get the order ID
      $order_id = ShoppingCart::CreateOrder();

      // This will contain the PayPal link
      $redirect =
        'https://www.paypal.com/xclick/business=youremail@example.com' .
        '&item_name=HatShop Order ' . $order_id .
        '&item_number=' . $order_id .
        '&amount=' . $this->mTotalAmount .
        '&currency=USD&return=www.example.com' .
        '&cancel_return=www.example.com';

      // Redirection to the payment page
      header('Location: ' . $redirect);

      exit;
    }

    // Get shopping cart products
    $this->mCartProducts =
      ShoppingCart::GetCartProducts(GET_CART_PRODUCTS);

    // Gets the Saved for Later products
    $this->mSavedCartProducts =
      ShoppingCart::GetCartProducts(GET_CART_SAVED_PRODUCTS);

    // Check whether we have an empty shopping cart
    if (count($this->mCartProducts) == 0)
      $this->mIsCartNowEmpty = 1;

    // Check whether we have an empty Saved for Later list
    if (count($this->mSavedCartProducts) == 0)
      $this->mIsCartLaterEmpty = 1;

    // Build the links for cart actions
    for ($i = 0; $i < count($this->mCartProducts); $i++)
    {
      $this->mCartProducts[$i]['save'] = 'index.php?ProductID=' .
        $this->mCartProducts[$i]['product_id'] .
        '&CartAction=' . SAVE_PRODUCT_FOR_LATER;

      $this->mCartProducts[$i]['remove'] = 'index.php?ProductID=' .
        $this->mCartProducts[$i]['product_id'] .
        '&CartAction=' . REMOVE_PRODUCT;
    }

    for ($i = 0; $i < count($this->mSavedCartProducts); $i++)
    {
      $this->mSavedCartProducts[$i]['move'] = 'index.php?ProductID=' .
        $this->mSavedCartProducts[$i]['product_id'] .
        '&CartAction=' . MOVE_PRODUCT_TO_CART;

      $this->mSavedCartProducts[$i]['remove'] = 'index.php?ProductID=' .
        $this->mSavedCartProducts[$i]['product_id'] .
        '&CartAction=' . REMOVE_PRODUCT;
    }
  }
}
?>
