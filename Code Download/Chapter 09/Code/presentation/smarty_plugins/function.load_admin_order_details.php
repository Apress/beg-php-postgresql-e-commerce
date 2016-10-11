<?php
// Plugin functions inside plugin files must be named: smarty_type_name
function smarty_function_load_admin_order_details($params, $smarty)
{
  // Create AdminOrderDetils object
  $admin_order_details = new AdminOrderDetails();
  $admin_order_details->init();

  // Assign the template variable
  $smarty->assign($params['assign'], $admin_order_details);
}

// Presentation tier class that deals with administering order details
class AdminOrderDetails
{
  // Public variables available in smarty template
  public $mOrderId;
  public $mOrderInfo;
  public $mOrderDetails;
  public $mEditEnabled;
  public $mOrderStatusOptions;
  public $mAdminOrdersPageLink;

  // Class constructor
  public function __construct()
  {
    // Get the back link from session
    $this->mAdminOrdersPageLink = $_SESSION['admin_orders_page_link'];

    // We receive the order ID in the query string
    if (isset ($_GET['OrderId']))
      $this->mOrderId = (int) $_GET['OrderId'];
    else
      trigger_error('OrderId paramater is required');

    $this->mOrderStatusOptions = Orders::$mOrderStatusOptions;
  }

  // Initializes class members
  public function init()
  {
    if (isset ($_GET['submitUpdate']))
    {
      Orders::UpdateOrder($this->mOrderId, $_GET['status'],
        $_GET['comments'], $_GET['customerName'], $_GET['shippingAddress'],
        $_GET['customerEmail']);
    }

    $this->mOrderInfo = Orders::GetOrderInfo($this->mOrderId);
    $this->mOrderDetails = Orders::GetOrderDetails($this->mOrderId);

    // Value which specifies whether to enable or disable edit mode
    if (isset ($_GET['submitEdit']))
      $this->mEditEnabled = true;
    else
      $this->mEditEnabled = false;
  }
}
?>
