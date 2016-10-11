<?php
/* Smarty plugin function that gets called when the
   load_admin_products function plugin is loaded from a template */
function smarty_function_load_admin_products($params, $smarty)
{
  // Create AdminProducts object
  $admin_products = new AdminProducts();
  $admin_products->init();

  // Assign template variable
  $smarty->assign($params['assign'], $admin_products);
}

// Class that deals with products administration from a specific category
class AdminProducts
{
  // Public variables available in smarty template
  public $mProducts;
  public $mProductsCount;
  public $mEditItem;
  public $mErrorMessage = '';
  public $mDepartmentId;
  public $mCategoryId;
  public $mProductId;
  public $mCategoryName;
  public $mAdminCategoriesLink = 'admin.php?Page=Categories';
  public $mAdminProductsTarget = 'admin.php?Page=Products';

  // Private attributes
  private $mCatalog;
  private $mAction = '';
  private $mActionedProductId;
  // Class constructor
  public function __construct()
  {
    if (isset ($_GET['DepartmentID']))
      $this->mDepartmentId = (int)$_GET['DepartmentID'];
    else
      trigger_error('DepartmentID not set');

    if (isset ($_GET['CategoryID']))
      $this->mCategoryId = (int)$_GET['CategoryID'];
    else
      trigger_error('CategoryID not set');

    $category_details = Catalog::GetCategoryDetails($this->mCategoryId);
    $this->mCategoryName = $category_details['name'];

    foreach ($_POST as $key => $value)
      // If a submit button was clicked ...
      if (substr($key, 0, 6) == 'submit')
      {
        /* Get the position of the last '_' underscore from submit button name
           e.g strtpos('submit_edit_prod_1', '_') is 17 */
        $last_underscore = strrpos($key, '_');

        /* Get the scope of submit button
           (e.g  'edit_dep' from 'submit_edit_prod_1') */
        $this->mAction = substr($key, strlen('submit_'),
                                $last_underscore - strlen('submit_'));

        /* Get the product id targeted by submit button
           (the number at the end of submit button name)
           e.g '1' from 'submit_edit_prod_1' */
        $this->mActionedProductId = (int)substr($key, $last_underscore + 1);

        break; 
      }
  }

  public function init()
  {
    // If adding a new product
    if ($this->mAction == 'add_prod')
    {
      $product_name = $_POST['product_name'];
      $product_description = $_POST['product_description'];
      $product_price = $_POST['product_price'];

      if ($product_name == null)
        $this->mErrorMessage = 'Product name is empty';

      if ($product_description == null)
        $this->mErrorMessage = 'Product description is empty';

      if ($product_price == null || !is_numeric($product_price))
        $this->mErrorMessage = 'Product price must be a number!';

      if ($this->mErrorMessage == null)
        Catalog::AddProductToCategory($this->mCategoryId, $product_name,
          $product_description, $product_price, 'generic_image.jpg',
          'generic_thumbnail.jpg');
    }

    // If editing a product
    if ($this->mAction == 'edit_prod')
    {
      $this->mEditItem = $this->mActionedProductId;
    }

    // If we want to see a product details
    if ($this->mAction == 'select_prod')
    {
      header('Location: admin.php?Page=ProductDetails&DepartmentID=' .
             $this->mDepartmentId . '&CategoryID=' . $this->mCategoryId .
             '&ProductID=' . $this->mActionedProductId);

      exit;
    }

    // If updating a product
    if ($this->mAction == 'update_prod')
    {
      $product_name = $_POST['name'];
      $product_description = $_POST['description'];
      $product_price = $_POST['price'];
      $product_discounted_price = $_POST['discounted_price'];

      if ($product_name == null)
        $this->mErrorMessage = 'Product name is empty';

      if ($product_description == null)
        $this->mErrorMessage = 'Product description is empty';

      if ($product_price == null || !is_numeric($product_price))
        $this->mErrorMessage = 'Product price must be a number!';

      if ($product_discounted_price == null ||
          !is_numeric($product_discounted_price))
        $this->mErrorMessage = 'Product discounted price must be a number!';

      if ($this->mErrorMessage == null)
        Catalog::UpdateProduct($this->mActionedProductId, $product_name,
          $product_description, $product_price, $product_discounted_price);
    }

    $this->mAdminCategoriesLink .= '&DepartmentID=' . $this->mDepartmentId;
    $this->mAdminProductsTarget .= '&DepartmentID=' . $this->mDepartmentId .
                                   '&CategoryID=' . $this->mCategoryId;

    $this->mProducts = Catalog::GetCategoryProducts($this->mCategoryId);
    $this->mProductsCount = count($this->mProducts);
  }
}
?>
