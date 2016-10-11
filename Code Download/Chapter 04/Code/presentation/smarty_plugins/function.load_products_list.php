<?php
// Plugin functions inside plugin files must be named: smarty_type_name
function smarty_function_load_products_list($params, $smarty)
{
  // Create ProductsList object
  $products_list = new ProductsList();
  $products_list->init();

  // Assign template variable
  $smarty->assign($params['assign'], $products_list);
}

class ProductsList
{
  // Public variables to be read from Smarty template
  public $mProducts;
  public $mPageNo;
  public $mrHowManyPages;
  public $mNextLink;
  public $mPreviousLink;

  // Private members
  private $_mDepartmentId;
  private $_mCategoryId;

  // Class constructor
  public function __construct()
  {
    // Get DepartmentID from query string casting it to int
    if (isset ($_GET['DepartmentID']))
      $this->_mDepartmentId = (int)$_GET['DepartmentID'];

    // Get CategoryID from query string casting it to int
    if (isset ($_GET['CategoryID']))
      $this->_mCategoryId = (int)$_GET['CategoryID'];

    // Get PageNo from query string casting it to int
    if (isset ($_GET['PageNo']))
      $this->mPageNo = (int)$_GET['PageNo'];
    else
      $this->mPageNo = 1;
  }

  public function init()
  {
    /* If browsing a category, get the list of products by calling
       the GetProductsInCategory business tier method */
    if (isset ($this->_mCategoryId))
      $this->mProducts = Catalog::GetProductsInCategory(
        $this->_mCategoryId, $this->mPageNo, $this->mrHowManyPages);
    /* If browsing a department, get the list of products by calling
       the GetProductsOnDepartmentDisplay business tier method */
    elseif (isset ($this->_mDepartmentId))
      $this->mProducts = Catalog::GetProductsOnDepartmentDisplay(
        $this->_mDepartmentId, $this->mPageNo, $this->mrHowManyPages);
    /* If browsing the first page, get the list of products by
       calling the GetProductsOnCatalogDisplay business
       tier method */
    else
      $this->mProducts = Catalog::GetProductsOnCatalogDisplay(
                           $this->mPageNo, $this->mrHowManyPages);

    /* If there are subpages of products, display navigation
       controls */
    if ($this->mrHowManyPages > 1)
    {
      // Read the query string
      $query_string = getenv('QUERY_STRING');

      // Find if we have PageNo in the query string
      $pos = stripos($query_string, 'PageNo=');

      /* If there is no PageNo in the query string
         then we're on the first page */
      if ($pos == false)
      {
        $query_string .= '&PageNo=1';
        $pos = stripos($query_string, 'PageNo=');
      }

      // Read the current page number from the query string
      $temp = substr($query_string, $pos);
      sscanf($temp, 'PageNo=%d', $this->mPageNo);

      // Build the Next link
      if ($this->mPageNo >= $this->mrHowManyPages)
        $this->mNextLink = '';
      else
      {
        $new_query_string = str_replace('PageNo=' . $this->mPageNo,
                                        'PageNo=' . ($this->mPageNo + 1),
                                        $query_string);
        $this->mNextLink = 'index.php?' . $new_query_string;
      }

      // Build the Previous link
      if ($this->mPageNo == 1)
        $this->mPreviousLink = '';
      else
      {
        $new_query_string = str_replace('PageNo=' . $this->mPageNo,
                                        'PageNo=' . ($this->mPageNo - 1),
                                        $query_string);
        $this->mPreviousLink = 'index.php?' . $new_query_string;
      }
    }

    // Build links for product details pages
    $url = $_SESSION['page_link'];

    if (count($_GET) > 0)
      $url = $url . '&ProductID=';
    else
      $url = $url . '?ProductID=';

    for ($i = 0; $i < count($this->mProducts); $i++)
    {
      $this->mProducts[$i]['link'] =
        $url . $this->mProducts[$i]['product_id'];
    }
  }
}
?>
