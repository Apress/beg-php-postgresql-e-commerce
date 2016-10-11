<?php
/* Smarty plugin function that gets called when the
   load_admin_login function plugin is loaded from a template */
function smarty_function_load_admin_login($params, $smarty)
{
  // Create AdminLogin object
  $admin_login = new AdminLogin();

  // Assign template variable
  $smarty->assign($params['assign'], $admin_login);
}

// Class that deals with authenticating administrators
class AdminLogin
{
  // Public variables available in smarty templates
  public $mUsername;
  public $mLoginMessage = '';

  // Class constructor
  public function __construct()
  {
    // Verify if the correct username and password have been supplied
    if (isset ($_POST['submit']))
    {
      if ($_POST['username'] == ADMIN_USERNAME
          && $_POST['password'] == ADMIN_PASSWORD)
      {
        $_SESSION['admin_logged'] = true;
        header('Location: admin.php');
        exit;
      }
      else
        $this->mLoginMessage = 'Login failed. Please try again:';
    }
  }
}
?>
