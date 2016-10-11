<?php
// Plugin functions inside plugin files must be named: smarty_type_name
function smarty_function_load_categories_list($params, $smarty)
{
  // Create CategoriesList object
  $categories_list = new CategoriesList();
  $categories_list->init();

  // Assign template variable
  $smarty->assign($params['assign'], $categories_list);
}

// Manages the categories list
class CategoriesList
{
  // Public variables for the smarty template
  public $mCategorySelected   = 0;
  public $mDepartmentSelected = 0;
  public $mCategories;

  // Constructor reads query string parameter
  public function __construct()
  {
    if (isset ($_GET['DepartmentID']))
      $this->mDepartmentSelected = (int)$_GET['DepartmentID'];
    else
      trigger_error('DepartmentID not set');

    if (isset ($_GET['CategoryID']))
      $this->mCategorySelected = (int)$_GET['CategoryID'];
  }

  public function init()
  {
    $this->mCategories =
      Catalog::GetCategoriesInDepartment($this->mDepartmentSelected);

    // Building links for the category pages
    for ($i = 0; $i < count($this->mCategories); $i++)
      $this->mCategories[$i]['link'] =
        'index.php?DepartmentID=' . $this->mDepartmentSelected .
        '&CategoryID=' . $this->mCategories[$i]['category_id'];
  }
}
?>
