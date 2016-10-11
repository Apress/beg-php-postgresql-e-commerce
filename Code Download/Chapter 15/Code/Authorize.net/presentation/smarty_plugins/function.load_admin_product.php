<?php
// Plugin function for the load_admin_product function plugin
function smarty_function_load_admin_product($params, $smarty)
{
  // Create AdminProduct object
  $admin_product = new AdminProduct();
  $admin_product->init();

  // Assign template variable
  $smarty->assign($params['assign'], $admin_product);
}

// Class that deals with product administration
class AdminProduct
{
  // Public attributes
  public $mProductName;
  public $mProductImage;
  public $mProductThumbnail;
  public $mProductDisplay;
  public $mProductCategoriesString;
  public $mRemoveFromCategories;
  public $mProductDisplayOptions;
  public $mProductId;
  public $mCategoryId;
  public $mDepartmentId;
  public $mRemoveFromCategoryButtonDisabled = false;
  public $mAdminProductsLink = 'admin.php?Page=Products';
  public $mAdminProductTarget = 'admin.php?Page=ProductDetails';

  // Private attributes
  private $mTargetCategoryId;

  // Class constructor
  public function __construct()
  {
    // Need to have DepartmentID in the query string
    if (!isset ($_GET['DepartmentID']))
      trigger_error('DepartmentID not set');
    else
      $this->mDepartmentId = (int)$_GET['DepartmentID'];

    // Need to have CategoryID in the query string
    if (!isset ($_GET['CategoryID']))
      trigger_error('CategoryID not set');
    else
      $this->mCategoryId = (int)$_GET['CategoryID'];

    // Need to have ProductID in the query string
    if (!isset ($_GET['ProductID']))
      trigger_error('ProductID not set');
    else
      $this->mProductId = (int)$_GET['ProductID'];

    $this->mProductDisplayOptions = Catalog::$mProductDisplayOptions;
  }

  public function init()
  {
    // If uploading a product picture ...
    if (isset ($_POST['Upload']))
    {
      /* Check whether we have write permission on the 
          product_images folder */
      if (!is_writeable(SITE_ROOT . '/product_images/'))
      {
        echo "Can't write to the product_images folder";

        exit;
      }

      // If the error code is 0, the first file was uploaded ok
      if ($_FILES['ImageUpload']['error'] == 0)
      {
        /* Use the move_uploaded_file PHP function to move the file
           from its temporary location to the product_images folder */
        move_uploaded_file($_FILES['ImageUpload']['tmp_name'],
                           SITE_ROOT . '/product_images/' .
                           $_FILES['ImageUpload']['name']);

        // Update the product's information in the database
        Catalog::SetImage($this->mProductId,
                          $_FILES['ImageUpload']['name']);
      }

      // If the error code is 0, the second file was uploaded ok
      if ($_FILES['ThumbnailUpload']['error'] == 0)
      {
        // Move the uploaded file to the product_images folder
        move_uploaded_file($_FILES['ThumbnailUpload']['tmp_name'],
                           SITE_ROOT . '/product_images/' .
                           $_FILES['ThumbnailUpload']['name']);

        // Update the product's information in the database
        Catalog::SetThumbnail($this->mProductId,
                              $_FILES['ThumbnailUpload']['name']);
      }
    }

    // If removing the product from a category ...
    if (isset ($_POST['RemoveFromCategory']))
    {
      $target_category_id = $_POST['TargetCategoryIdRemove'];
      $still_exists = Catalog::RemoveProductFromCategory(
                        $this->mProductId, $target_category_id);

      if ($still_exists == 0)
      {
        header('Location: admin.php?Page=Products&DepartmentID=' .
               $this->mDepartmentId . '&CategoryID=' . $this->mCategoryId);

        exit;
      }
    }

    // If setting product display option ...
    if (isset ($_POST['SetProductDisplayOption']))
    {
      $product_display = $_POST['ProductDisplay'];
      Catalog::SetProductDisplayOption($this->mProductId, $product_display);
    }

    // If removing the product from catalog ...
    if (isset ($_POST['RemoveFromCatalog']))
    {
      Catalog::DeleteProduct($this->mProductId);

      header('Location: admin.php?Page=Products&DepartmentID=' .
             $this->mDepartmentId . '&CategoryID=' . $this->mCategoryId);

      exit;
    }

    // If assigning the product to another category ...
    if (isset ($_POST['Assign']))
    {
      $target_category_id = $_POST['TargetCategoryIdAssign'];
      Catalog::AssignProductToCategory($this->mProductId,
                                       $target_category_id);
    }

    // If moving the product to another category ...
    if (isset ($_POST['Move']))
    {
      $target_category_id = $_POST['TargetCategoryIdMove'];
      Catalog::MoveProductToCategory($this->mProductId,
        $this->mCategoryId, $target_category_id);

      header('Location: admin.php?Page=ProductDetails&DepartmentID=' .
             $this->mDepartmentId . '&CategoryID=' .
             $target_category_id . '&ProductID=' . $this->mProductId);

      exit;
    }

    // Get product info and show it to user
    $product_info = Catalog::GetProductInfo($this->mProductId);
    $this->mProductName = $product_info['name'];
    $this->mProductImage = $product_info['image'];
    $this->mProductThumbnail = $product_info['thumbnail'];
    $this->mProductDisplay = $product_info['display'];
    $product_categories = Catalog::GetCategoriesForProduct($this->mProductId);

    if (count($product_categories) == 1)
      $this->mRemoveFromCategoryButtonDisabled = true;

    // Show the categories the product belongs to
    for ($i = 0; $i < count($product_categories); $i++)
      $temp1[$product_categories[$i]['category_id']] =
        $product_categories[$i]['name'];

    $this->mRemoveFromCategories = $temp1;
    $this->mProductCategoriesString = implode(', ', $temp1);
    $all_categories = Catalog::GetCategories();

    for ($i = 0; $i < count($all_categories); $i++)
      $temp2[$all_categories[$i]['category_id']] =
        $all_categories[$i]['name'];

    $this->mAssignOrMoveTo = array_diff($temp2, $temp1);

    $this->mAdminProductsLink .= '&DepartmentID=' . $this->mDepartmentId .
                                 '&CategoryID=' . $this->mCategoryId;
    $this->mAdminProductTarget .= '&DepartmentID=' . $this->mDepartmentId .
                                  '&CategoryID=' . $this->mCategoryId .
                                  '&ProductID=' . $this->mProductId;
  }
}
?>
