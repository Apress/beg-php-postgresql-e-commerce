<?php
/* Smarty plugin function that gets called when the
   load_customer_login function plugin is loaded from a template */
function smarty_function_load_customer_login($params, $smarty)
{
  // Create CustomerLogin object
  $customer_login = new CustomerLogin();
  $customer_login->init();

  // Assign template variable
  $smarty->assign($params['assign'], $customer_login);
}

class CustomerLogin
{
  // Public stuff
  public $mLoginMessage;
  public $mCustomerLoginTarget;
  public $mRegisterUser;
  public $mEmail = '';

  // Private stuff
  private $_mHaveData = 0;

  // Class constructor
  public function __construct()
  {
    // Decide if we have submitted
    if (isset ($_POST['Login']))
      $this->_mHaveData = 1;
  }

  public function init()
  {
    $url_base = substr(getenv('REQUEST_URI'),
                       strrpos(getenv('REQUEST_URI'), '/') + 1,
                       strlen(getenv('REQUEST_URI')) - 1);

    $url_parameter_prefix = (count($_GET) == 0 ? '?' : '&');

    $this->mCustomerLoginTarget = $url_base;

    if (strpos($url_base, 'RegisterCustomer', 0) === false)
      $this->mRegisterUser = $url_base . $url_parameter_prefix .
                             'RegisterCustomer';
    else
      $this->mRegisterUser = $url_base;

    if ($this->_mHaveData)
    {
      // Get login status
      $login_status = Customer::IsValid($_POST['email'], $_POST['password']);

      switch ($login_status)
      {
        case 2:
          $this->mLoginMessage = 'Unrecognized Email.';
          $this->mEmail = $_POST['email'];

          break;
        case 1:
          $this->mLoginMessage = 'Unrecognized password.';
          $this->mEmail = $_POST['email'];

          break;
        case 0:
          // Valid login... build redirect link and redirect
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

          $redirect_link .= VIRTUAL_LOCATION . $this->mCustomerLoginTarget;

          header('Location:' . $redirect_link);

          exit;
      }
    }
  }
}
?>
