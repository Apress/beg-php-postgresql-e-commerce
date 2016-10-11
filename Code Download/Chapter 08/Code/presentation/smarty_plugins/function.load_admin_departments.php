<?php
/* Smarty plugin function that gets called when the 
   load_admin_departments function plugin is loaded from a template */
function smarty_function_load_admin_departments($params, $smarty)
{
  // Create AdminDepartments object
  $admin_departments = new AdminDepartments();
  $admin_departments->init(); 

  // Assign template variable
  $smarty->assign($params['assign'], $admin_departments);
}

// Class that supports departments admin functionality
class AdminDepartments
{
  // Public variables available in smarty template
  public $mDepartmentsCount;
  public $mDepartments;
  public $mErrorMessage = '';
  public $mEditItem;
  public $mAdminDepartmentsTarget = 'admin.php?Page=Departments';

 // Private members
  public $mAction = '';
  public $mActionedDepartmentId;

  // Class constructor
  public function __construct()
  {
    // Parse the list with posted variables
    foreach ($_POST as $key => $value)
      // If a submit button was clicked ...
      if (substr($key, 0, 6) == 'submit')
      {
        /* Get the position of the last '_' underscore from submit
           button name e.g strtpos('submit_edit_dep_1', '_') is 16 */
        $last_underscore = strrpos($key, '_');

        /* Get the scope of submit button
           (e.g  'edit_dep' from 'submit_edit_dep_1') */
        $this->mAction = substr($key, strlen('submit_'),
                                $last_underscore - strlen('submit_'));

        /* Get the department id targeted by submit button
           (the number at the end of submit button name)
           e.g '1' from 'submit_edit_dep_1' */
        $this->mActionedDepartmentId = substr($key, $last_underscore + 1);

        break;
      }
  }

  public function init()
  {
    // If adding a new department ...
    if ($this->mAction == 'add_dep')
    {
      $department_name = $_POST['department_name'];
      $department_description = $_POST['department_description'];

      if ($department_name == null)
        $this->mErrorMessage = 'Department name required';

      if ($this->mErrorMessage == null)
        Catalog::AddDepartment($department_name, $department_description);
    }

    // If editing an existing department ...
    if ($this->mAction == 'edit_dep')
      $this->mEditItem = $this->mActionedDepartmentId;

    // If updating a department ...
    if ($this->mAction == 'update_dep')
    {
      $department_name = $_POST['name'];
      $department_description = $_POST['description'];

      if ($department_name == null)
        $this->mErrorMessage = 'Department name required';

      if ($this->mErrorMessage == null)
        Catalog::UpdateDepartment($this->mActionedDepartmentId,
                                  $department_name, $department_description);
    }

    // If deleting a department ...
    if ($this->mAction == 'delete_dep')
    {
      $status = Catalog::DeleteDepartment($this->mActionedDepartmentId);

      if ($status < 0)
        $this->mErrorMessage = 'Department not empty';
    }

    // If editing department's categories ...
    if ($this->mAction == 'edit_categ')
    {
      header('Location: admin.php?Page=Categories&DepartmentID=' .
             $this->mActionedDepartmentId);

      exit;
    }

    // Load the list of departments
    $this->mDepartments = Catalog::GetDepartmentsWithDescriptions();
    $this->mDepartmentsCount = count($this->mDepartments);
  }
}
?>
