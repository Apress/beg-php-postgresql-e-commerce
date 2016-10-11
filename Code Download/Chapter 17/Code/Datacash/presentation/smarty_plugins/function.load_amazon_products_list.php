<?php
// Plugin functions inside plugin files must be named: smarty_type_name
function smarty_function_load_amazon_products_list($params, $smarty)
{
  // Create AmazonProductsList object
  $amazon_products_list = new AmazonProductsList();
  $amazon_products_list->init();

  // Assign template variable
  $smarty->assign($params['assign'], $amazon_products_list);
}

// Class that handles receiving ECS data
class AmazonProductsList
{
  // Public variables available in smarty template
  public $mProducts;
  public $mDepartmentName;
  public $mDepartmentDescription;

  // Constructor
  public function __construct()
  {
    $this->mDepartmentName = AMAZON_DEPARTMENT_TITLE;
    $this->mDepartmentDescription = AMAZON_DEPARTMENT_DESCRIPTION;
  }

  public function init()
  {
    $amazon = new Amazon();
    $this->mProducts = $amazon->GetProducts();

    for ($i = 0;$i < count($this->mProducts); $i++)
      $this->mProducts[$i]['link'] =
        'http://www.amazon.com/exec/obidos/ASIN/' .
        $this->mProducts[$i]['asin'] .
        '/ref=nosim/' . AMAZON_ASSOCIATES_ID;
  }
}
?>
