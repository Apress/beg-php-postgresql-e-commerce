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
  public $mCustomerInfo;
  public $mTotalCost;
  public $mTaxCost = 0.0;

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
        $_GET['comments'], $_GET['authCode'], $_GET['reference']);
    }

    $this->mOrderInfo = Orders::GetOrderInfo($this->mOrderId);
    $this->mOrderDetails = Orders::GetOrderDetails($this->mOrderId);
    $this->mCustomerInfo = Customer::Get($this->mOrderInfo['customer_id']);
    $this->mTotalCost = $this->mOrderInfo['total_amount'];

    if ($this->mOrderInfo['tax_percentage'] !== 0.0)
      $this->mTaxCost = round((float)$this->mTotalCost *
                              (float)$this->mOrderInfo['tax_percentage'], 2)
                             / 100.00;

    $this->mTotalCost += $this->mOrderInfo['shipping_cost'];
    $this->mTotalCost += $this->mTaxCost;

    // Format the values
    $this->mTotalCost = number_format($this->mTotalCost, 2, '.', '');
    $this->mTaxCost = number_format($this->mTaxCost, 2, '.', '');

    // Value which specifies whether to enable or disable edit mode
    if (isset ($_GET['submitEdit']))
      $this->mEditEnabled = true;
    else
      $this->mEditEnabled = false;
  }
}
?>
