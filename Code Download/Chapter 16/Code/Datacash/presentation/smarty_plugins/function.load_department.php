<?php
// Plugin functions inside plugin files must be named: smarty_type_name
function smarty_function_load_department($params, $smarty)
{
  // Create Department object
  $department = new Department();
  $department->init();

  // Assign template variable
  $smarty->assign($params['assign'], $department);
}

// Deals with retrieving department details
class Department
{
  // Public variables for the smarty template
  public $mDescriptionLabel;
  public $mNameLabel;

  // Private members
  private $_mDepartmentId;
  private $_mCategoryId;

  // Class constructor
  public function __construct()
  {
    // We need to have DepartmentID in the query string
    if (isset ($_GET['DepartmentID']))
      $this->_mDepartmentId = (int)$_GET['DepartmentID'];
    else
      trigger_error('DepartmentID not set');

    /* If CategoryID is in the query string we save it 
       (casting it to integer to protect against invalid values) */
    if (isset ($_GET['CategoryID']))
      $this->_mCategoryId = (int)$_GET['CategoryID'];
  }

  public function init()
  {
    // If visiting a department ...
    $details = Catalog::GetDepartmentDetails($this->_mDepartmentId);
    $this->mNameLabel = $details['name'];
    $this->mDescriptionLabel = $details['description'];

    // If visiting a category ...
    if (isset ($this->_mCategoryId))
    {
      $details = Catalog::GetCategoryDetails($this->_mCategoryId);
      $this->mNameLabel =
        $this->mNameLabel . ' &raquo; ' . $details['name'];
      $this->mDescriptionLabel = $details['description'];
    }
  }
}
?>
