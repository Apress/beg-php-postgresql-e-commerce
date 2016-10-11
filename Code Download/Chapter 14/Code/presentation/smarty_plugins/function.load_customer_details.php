<?php
/* Smarty plugin function that gets called when the
   load_customer_details function plugin is loaded from a template */
function smarty_function_load_customer_details($params, $smarty)
{
  // Create CustomerDetails object
  $customer_details = new CustomerDetails();
  $customer_details->init();

  // Assign template variable
  $smarty->assign($params['assign'], $customer_details);
}

class CustomerDetails
{
  // Public attributes
  public $mEditMode = 0;
  public $mCustomerDetailsTarget;
  public $mReturnLink;
  public $mReturnLinkProtocol = 'http';
  public $mEmail;
  public $mName;
  public $mPassword;
  public $mDayPhone = null;
  public $mEvePhone = null;
  public $mMobPhone = null;
  public $mNameError = 0;
  public $mEmailError = 0;
  public $mPasswordError = 0;
  public $mPasswordConfirmError = 0;
  public $mPasswordMatchError = 0;
  public $mEmailAlreadyTaken = 0;

  // Private attributes
  private $_mErrors = 0;
  private $_mHaveData = 0;

  // Class constructor
  public function __construct()
  {
    // Check if we have new user or editing existing customer details
    if (Customer::IsAuthenticated())
      $this->mEditMode = 1;

    $url_base = substr(getenv('REQUEST_URI'),
                       strrpos(getenv('REQUEST_URI'), '/') + 1,
                       strlen(getenv('REQUEST_URI')) - 1);

    $url_parameter_prefix = (count($_GET) == 1 ? '?' : '&');

    $this->mCustomerDetailsTarget = $url_base;

    if ($this->mEditMode == 0)
      $this->mReturnLink = str_replace($url_parameter_prefix .
                             'RegisterCustomer', '', $url_base);
    else
      $this->mReturnLink = str_replace($url_parameter_prefix .
                             'UpdateAccountDetails', '', $url_base);

    if (isset($_GET['Checkout']) && USE_SSL != 'no')
      $this->mReturnLinkProtocol = 'https';

    // Check if we have submitted data
    if (isset ($_POST['sended']))
      $this->_mHaveData = 1;

    if ($this->_mHaveData == 1)
    {
      // Name cannot be empty
      if (empty ($_POST['name']))
      {
        $this->mNameError = 1;
        $this->_mErrors++;
      }
      else
        $this->mName = $_POST['name'];

      if ($this->mEditMode == 0 && empty ($_POST['email']))
      {
        $this->mEmailError = 1;
        $this->_mErrors++;
      }
      else
        $this->mEmail = $_POST['email'];

      // Password cannot be empty
      if (empty ($_POST['password']))
      {
        $this->mPasswordError = 1;
        $this->_mErrors++;
      }
      else
        $this->mPassword = $_POST['password'];

      // Password confirm cannot be empty
      if (empty ($_POST['passwordConfirm']))
      {
        $this->mPasswordConfirmError = 1;
        $this->_mErrors++;
      }
      else
        $password_confirm = $_POST['passwordConfirm'];

      // Password and password confirm should be the same
      if (!isset ($password_confirm) ||
          $this->mPassword != $password_confirm)
      {
        $this->mPasswordMatchError = 1;
        $this->_mErrors++;
      }

      if ($this->mEditMode == 1)
      {
        if (!empty ($_POST['dayPhone']))
          $this->mDayPhone = $_POST['dayPhone'];

        if (!empty ($_POST['evePhone']))
          $this->mEvePhone = $_POST['evePhone'];

        if (!empty ($_POST['mobPhone']))
          $this->mMobPhone = $_POST['mobPhone'];
      }
    }
  }

  public function init()
  {
    // If we have submitted data and no errors in submitted data
    if (($this->_mHaveData == 1) && ($this->_mErrors == 0))
    {
      // Check if we have any customer with submitted email...
      $customer_read = Customer::GetLoginInfo($this->mEmail);

      /* ...if we have one and we are in 'new user' mode then
         email already taken error */
      if ((!(empty ($customer_read['customer_id']))) &&
          ($this->mEditMode == 0))
      {
        $this->mEmailAlreadyTaken = 1;

        return;
      }

      // We have a new user or we are updating an exisiting user details
      if ($this->mEditMode == 0)
        Customer::Add($this->mName, $this->mEmail, $this->mPassword);
      else
        Customer::UpdateAccountDetails($this->mName, $this->mEmail,
          $this->mPassword, $this->mDayPhone, $this->mEvePhone,
          $this->mMobPhone);

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

      $redirect_link .= VIRTUAL_LOCATION . $this->mReturnLink;

      header('Location:' . $redirect_link);

      exit;
    }

    if ($this->mEditMode == 1 && $this->_mHaveData == 0)
    {
      // We are editing an existing customer’s details
      $customer_data = Customer::Get();

      $this->mName = $customer_data['name'];
      $this->mEmail = $customer_data['email'];
      $this->mDayPhone = $customer_data['day_phone'];
      $this->mEvePhone = $customer_data['eve_phone'];
      $this->mMobPhone = $customer_data['mob_phone'];
    }
  }
}
?>
