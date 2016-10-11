<?php
/* Smarty plugin function that gets called when the
   load_customer_logged function plugin is loaded from a template */
function smarty_function_load_customer_logged($params, $smarty)
{
  // Create CustomerLogged object
  $customer_logged = new CustomerLogged();
  $customer_logged->init();

  // Assign template variable
  $smarty->assign($params['assign'], $customer_logged);
}

class CustomerLogged
{
  // Public attributes
  public $mCustomerName;
  public $mCreditCardAction = 'Add';
  public $mAddressAction = 'Add';
  public $mUpdateAccount;
  public $mUpdateCreditCard;
  public $mUpdateAddress;
  public $mLogout;

  // Class constructor
  public function __construct()
  {
  }

  public function init()
  {
    $url_base = substr(getenv('REQUEST_URI'),
                       strrpos(getenv('REQUEST_URI'), '/') + 1,
                       strlen(getenv('REQUEST_URI')) - 1);

    $url_parameter_prefix = (count($_GET) == 1 ? '?' : '&');

    if (isset($_GET['Logout']))
      $url_base = str_replace($url_parameter_prefix . 'Logout', '',
                              $url_base);
    elseif (isset($_GET['UpdateAccountDetails']))
      $url_base = str_replace($url_parameter_prefix .
                    'UpdateAccountDetails', '', $url_base);
    elseif (isset($_GET['UpdateCreditCardDetails']))
      $url_base = str_replace($url_parameter_prefix .
                    'UpdateCreditCardDetails', '', $url_base);
    elseif (isset($_GET['UpdateAddressDetails']))
      $url_base = str_replace($url_parameter_prefix .
                    'UpdateAddressDetails', '', $url_base);

    if (strpos($url_base, '?', 0) === false)
      $url_parameter_prefix = '?';
    else
      $url_parameter_prefix = '&';

    if (isset($_GET['Logout']))
    {
      Customer::Logout();

      // Redirect
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

      $redirect_link .= VIRTUAL_LOCATION . $url_base;

      header('Location:' . $redirect_link);

      exit;
    }

    $url_base .= $url_parameter_prefix;
    $this->mUpdateAccount = $url_base . 'UpdateAccountDetails';
    $this->mUpdateCreditCard = $url_base . 'UpdateCreditCardDetails';
    $this->mUpdateAddress = $url_base . 'UpdateAddressDetails';
    $this->mLogout = $url_base . 'Logout';

    $customer_data = Customer::Get();
    $this->mCustomerName = $customer_data['name'];

    if (!(empty($customer_data['credit_card'])))
      $this->mCreditCardAction = 'Change';

    if (!(empty($customer_data['address_1'])))
      $this->mAddressAction = 'Change';
  }
}
?>
