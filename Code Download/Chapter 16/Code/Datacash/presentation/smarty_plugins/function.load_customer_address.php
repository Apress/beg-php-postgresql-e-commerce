<?php
/* Smarty plugin function that gets called when the
   load_customer_address function plugin is loaded from a template */
function smarty_function_load_customer_address($params, $smarty)
{
  // Create CustomerAddress object
  $customer_address = new CustomerAddress();
  $customer_address->init();

  // Assign template variable
  $smarty->assign($params['assign'], $customer_address);
}

class CustomerAddress
{
  // Public attributes
  public $mCustomerAddressTarget;
  public $mReturnLink;
  public $mReturnLinkProtocol = 'http';
  public $mAddress1 = '';
  public $mAddress2 = '';
  public $mCity = '';
  public $mRegion = '';
  public $mPostalCode = '';
  public $mCountry = '';
  public $mShippingRegion = '';
  public $mShippingRegions = array ();
  public $mAddress1Error = 0;
  public $mCityError = 0;
  public $mRegionError = 0;
  public $mPostalCodeError = 0;
  public $mCountryError = 0;
  public $mShippingRegionError = 0;

  // Private attributes
  private $_mErrors = 0;
  private $_mHaveData = 0;

  // Class constructor
  public function __construct()
  {
    $url_base = substr(getenv('REQUEST_URI'),
                       strrpos(getenv('REQUEST_URI'), '/') + 1,
                       strlen(getenv('REQUEST_URI')) - 1);

    $url_parameter_prefix = (count($_GET) == 1 ? '?' : '&');

    // Set form action target
    $this->mCustomerAddressTarget = $url_base;

    // Set the return page
    $this->mReturnLink = str_replace($url_parameter_prefix .
                           'UpdateAddressDetails', '', $url_base);

    if (isset($_GET['Checkout']) && USE_SSL != 'no')
      $this->mReturnLinkProtocol = 'https';

    if (isset ($_POST['sended']))
      $this->_mHaveData = 1;

    if ($this->_mHaveData == 1)
    {
      // Address 1 cannot be empty
      if (empty ($_POST['address1']))
      {
        $this->mAddress1Error = 1;
        $this->_mErrors++;
      }
      else
        $this->mAddress1 = $_POST['address1'];

      if (isset ($_POST['address2']))
        $this->mAddress2 = $_POST['address2'];

      if (empty ($_POST['city']))
      {
        $this->mCityError = 1;
        $this->_mErrors++;
      }
      else
        $this->mCity = $_POST['city'];

      if (empty ($_POST['region']))
      {
        $this->mRegionError = 1;
        $this->_mErrors++;
      }
      else
        $this->mRegion = $_POST['region'];

      if (empty ($_POST['postalCode']))
      {
        $this->mPostalCodeError = 1;
        $this->_mErrors++;
      }
      else
        $this->mPostalCode = $_POST['postalCode'];

      if (empty ($_POST['country']))
      {
        $this->mCountryError = 1;
        $this->_mErrors++;
      }
      else
        $this->mCountry = $_POST['country'];

      if ($_POST['shippingRegion'] == 1)
      {
        $this->mShippingRegionError = 1;
        $this->_mErrors++;
      }
      else
        $this->mShippingRegion = $_POST['shippingRegion'];
    }
  }

  public function init()
  {
    $shipping_regions = Customer::GetShippingRegions();

    foreach ($shipping_regions as $item)
      $this->mShippingRegions[$item['shipping_region_id']] =
        $item['shipping_region'];

    if ($this->_mHaveData == 0)
    {
      $customer_data = Customer::Get();

      if (!(empty ($customer_data)))
      {
        $this->mAddress1 = $customer_data['address_1'];
        $this->mAddress2 = $customer_data['address_2'];
        $this->mCity = $customer_data['city'];
        $this->mRegion = $customer_data['region'];
        $this->mPostalCode = $customer_data['postal_code'];
        $this->mCountry = $customer_data['country'];
        $this->mShippingRegion = $customer_data['shipping_region_id'];
      }
    }
    elseif ($this->_mErrors == 0)
    {
      Customer::UpdateAddressDetails($this->mAddress1, $this->mAddress2,
        $this->mCity, $this->mRegion, $this->mPostalCode,
        $this->mCountry, $this->mShippingRegion);

      if (isset($_GET['Checkout']) && USE_SSL != 'no')
      {
        $redirect_link = 'https://' . getenv('SERVER_NAME');
      }
      else
      {
        $redirect_link = 'http://' . getenv('SERVER_NAME');

        // If HTTP_SERVER_PORT is defined and different than default
        if (defined('HTTP_SERVER_PORT') && HTTP_SERVER_PORT != '80')
        {
          // Append server port
          $redirect_link .= ':' . HTTP_SERVER_PORT;
        }
      }

      $redirect_link .= VIRTUAL_LOCATION . $this->mReturnLink;

      header('Location:' . $redirect_link);

      exit;
    }
  }
}
?>
