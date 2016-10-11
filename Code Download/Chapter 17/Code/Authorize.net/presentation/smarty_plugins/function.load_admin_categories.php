<?php
/* Smarty plugin function that gets called when the
   load_admin_categories function plugin is loaded from a template */
function smarty_function_load_admin_categories($params, $smarty)
{
  // Create AdminLogin object
  $admin_categories = new AdminCategories();
  $admin_categories->init();

  // Assign template variable
  $smarty->assign($params['assign'], $admin_categories);
}

// Class that deals with departments admin
class AdminCategories
{
  // Public variables available in smarty template
  public $mCategoriesCount;
  public $mCategories;
  public $mEditItem =  - 1;
  public $mErrorMessage = '';
  public $mDepartmentId;
  public $mDepartmentName;
  public $mAdminDepartmentsLink = 'admin.php?Page=Departments';
  public $mAdminCategoriesTarget = 'admin.php?Page=Categories';

  // Private members
  private $mAction = '';
  private $mActionedCategoryId;

  // Class constructor
  public function __construct()
  {
    if (isset ($_GET['DepartmentID']))
      $this->mDepartmentId = (int)$_GET['DepartmentID'];
    else
      trigger_error('DepartmentID not set');

    $department_details = Catalog::GetDepartmentDetails($this->mDepartmentId);
    $this->mDepartmentName = $department_details['name'];

    foreach ($_POST as $key => $value)
      // If a submit button was clicked ...
      if (substr($key, 0, 6) == 'submit')
      {
        /* Get the position of the last '_' underscore from submit
           button name e.g strtpos('submit_edit_categ_1', '_') is 18 */
        $last_underscore = strrpos($key, '_');

        /* Get the scope of submit button
           (e.g  'edit_categ' from 'submit_edit_categ_1') */
        $this->mAction = substr($key, strlen('submit_'),
                                $last_underscore - strlen('submit_'));

        /* Get the category id targeted by submit button
           (the number at the end of submit button name)
           e.g '1' from 'submit_edit_categ_1' */
        $this->mActionedCategoryId = (int)substr($key, $last_underscore + 1);

        break;
      }
  }

  public function init()
  {
    // If adding a new category ...
    if ($this->mAction == 'add_categ')
    {
      $category_name = $_POST['category_name'];
      $category_description = $_POST['category_description'];

      if ($category_name == null)
        $this->mErrorMessage = 'Category name is empty';

      if ($this->mErrorMessage == null)
        Catalog::AddCategory($this->mDepartmentId, $category_name,
                             $category_description);
    }

    // If editing an existing category ...
    if ($this->mAction == 'edit_categ')
    {
      $this->mEditItem = $this->mActionedCategoryId;
    }

    // If updating a category ...
    if ($this->mAction == 'update_categ')
    {
      $category_name = $_POST['name'];
      $category_description = $_POST['description'];

      if ($category_name == null)
        $this->mErrorMessage = 'Category name is empty';

      if ($this->mErrorMessage == null)
        Catalog::UpdateCategory($this->mActionedCategoryId, $category_name,
                                $category_description);
    }

    // If deleting a category ...
    if ($this->mAction == 'delete_categ')
    {
      $status = Catalog::DeleteCategory($this->mActionedCategoryId);

      if ($status < 0)
        $this->mErrorMessage = 'Category not empty';
    }

    // If editing category's products ...
    if ($this->mAction == 'edit_products')
    {
      header('Location: admin.php?Page=Products&DepartmentID=' .
             $this->mDepartmentId . '&CategoryID=' .
             $this->mActionedCategoryId);

      exit;
    }

    $this->mAdminCategoriesTarget .= '&DepartmentID=' . $this->mDepartmentId;

    // Load the list of categories
    $this->mCategories =
      Catalog::GetDepartmentCategories($this->mDepartmentId);
    $this->mCategoriesCount = count($this->mCategories);
  }
}
?>
