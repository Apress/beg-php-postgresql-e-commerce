<?php
/* Smarty plugin function that gets called when the
   load_customer_credit_card function plugin is loaded from a template */
function smarty_function_load_customer_credit_card($params, $smarty)
{
  // Create CustomerCreditCard object
  $customer_credit_card = new CustomerCreditCard();
  $customer_credit_card->init();

  // Assign template variable
  $smarty->assign($params['assign'], $customer_credit_card);
}

class CustomerCreditCard
{
  // Public attributes
  public $mCustomerCreditCardTarget;
  public $mReturnLink;
  public $mReturnLinkProtocol = 'http';
  public $mCardHolderError;
  public $mCardNumberError;
  public $mExpDateError;
  public $mCardTypesError;
  public $mPlainCreditCard;
  public $mCardTypes;

  // Private attributes
  private $_mErrors = 0;
  private $_mHaveData = 0;

  public function __construct()
  {
    $this->mPlainCreditCard = array('card_holder' => '',
      'card_number'  => '', 'issue_date' => '', 'expiry_date'   => '',
      'issue_number' => '', 'card_type'  => '', 'card_number_x' => '');

    $url_base = substr(getenv('REQUEST_URI'),
                       strrpos(getenv('REQUEST_URI'), '/') + 1,
                       strlen(getenv('REQUEST_URI')) - 1);

    $url_parameter_prefix = (count($_GET) == 1 ? '?' : '&');

    // Set form action target
    $this->mCustomerCreditCardTarget = $url_base;

    // Set the return page
    $this->mReturnLink = str_replace($url_parameter_prefix .
                           'UpdateCreditCardDetails', '', $url_base);

    if (isset($_GET['Checkout']) && USE_SSL != 'no')
      $this->mReturnLinkProtocol = 'https';

    if (!(empty ($_POST['sended'])))
      $this->_mHaveData = 1;

    $this->mCardTypes = array ('Mastercard' => 'Mastercard',
      'Visa' => 'Visa', 'Mastercard' => 'Mastercard',
      'Switch' => 'Switch', 'Solo' => 'Solo',
      'American Express' => 'American Express');

    if ($this->_mHaveData == 1)
    {
      // Initialization/validation stuff
      if (empty ($_POST['cardHolder']))
      {
        $this->mCardHolderError = 1;
        $this->_mErrors++;
      }
      else
        $this->mPlainCreditCard['card_holder'] = $_POST['cardHolder'];

      if (empty ($_POST['cardNumber']))
      {
        $this->mCardNumberError = 1;
        $this->_mErrors++;
      }
      else
        $this->mPlainCreditCard['card_number'] = $_POST['cardNumber'];

      if (empty ($_POST['expDate']))
      {
        $this->mExpDateError = 1;
        $this->_mErrors++;
      }
      else
        $this->mPlainCreditCard['expiry_date'] = $_POST['expDate'];

      if (isset ($_POST['issueDate']))
        $this->mPlainCreditCard['issue_date'] = $_POST['issueDate'];

      if (isset ($_POST['issueNumber']))
        $this->mPlainCreditCard['issue_number'] = $_POST['issueNumber'];

      $this->mPlainCreditCard['card_type'] = $_POST['cardType'];

      if (empty ($this->mPlainCreditCard['card_type']))
      {
        $this->mCardTypeError = 1;
        $this->_mErrors++;
      }
    }
  }

  public function init()
  {
    if ($this->_mHaveData == 0)
    {
      // Get credit card information
      $this->mPlainCreditCard = Customer::GetPlainCreditCard();
    }
    elseif ($this->_mErrors == 0)
    {
      // Update credit card information
      Customer::UpdateCreditCardDetails($this->mPlainCreditCard);

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
