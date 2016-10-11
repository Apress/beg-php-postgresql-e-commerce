<?php
// Plugin functions inside plugin files must be named: smarty_type_name
function smarty_function_load_departments_list($params, $smarty)
{
  // Create DepartmentsList object
  $departments_list = new DepartmentsList();
  $departments_list->init();

  // Assign template variable
  $smarty->assign($params['assign'], $departments_list);
}

// Manages the departments list
class DepartmentsList
{
  /* Public variables available in departments_list.tpl Smarty template */
  public $mDepartments;
  public $mSelectedDepartment;
  public $mAmazonSelected = false;
  public $mAmazonDepartmentName;
  public $mAmazonDepartmentLink;

  // Constructor reads query string parameter
  public function __construct()
  {
    /* If DepartmentID exists in the query string, we're visiting a
       department */
    if (isset ($_GET['DepartmentID']))
      $this->mSelectedDepartment = (int)$_GET['DepartmentID'];
    else
      $this->mSelectedDepartment = -1;

    // Set Amazon department name and build the link for department
    $this->mAmazonDepartmentName = AMAZON_DEPARTMENT_TITLE;
    $this->mAmazonDepartmentLink = 'index.php?DepartmentID=' .
                                   AMAZON_DEPARTMENT_TITLE;

    // Check if the Amazon department is selected
    if ((isset ($_GET['DepartmentID'])) &&
        ((string) $_GET['DepartmentID'] == AMAZON_DEPARTMENT_TITLE))
      $this->mAmazonSelected = true;
  }

  /* Calls business tier method to read departments list and create
     their links */
  public function init()
  {
    // Get the list of departments from the business tier
    $this->mDepartments = Catalog::GetDepartments();

    // Create the department links
    for ($i = 0; $i < count($this->mDepartments); $i++)
      $this->mDepartments[$i]['link'] =
        'index.php?DepartmentID=' .
        $this->mDepartments[$i]['department_id'];
  }
}
?>
