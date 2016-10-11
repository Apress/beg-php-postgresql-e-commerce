<?php
// Plugin functions inside plugin files must be named: smarty_type_name
function smarty_function_load_reviews($params, $smarty)
{
  // Create Reviews object
  $reviews = new Reviews();
  $reviews->init();

  // Assign template variable
  $smarty->assign($params['assign'], $reviews);
}

// Class that handles product reviews
class Reviews
{
  public $mProductId;
  public $mReviews;
  public $mTotalReviews;
  public $mReviewerName;
  public $mEnableAddProductReviewForm = false;
  public $mAddProductReviewTarget = 'index.php';

  public function __construct()
  {
    if (isset ($_GET['ProductID']))
      $this->mProductId = (int)$_GET['ProductID'];
    else
      trigger_error('ProductID not set', E_USER_ERROR);

    $this->mAddProductReviewTarget .= '?ProductID=' . $this->mProductId;
  }

  public function init()
  {
    // If visitor is logged in ...
    if (Customer::IsAuthenticated())
    {
      // Check if visitor is adding a review
      if (isset($_POST['AddProductReview']))
        Catalog::CreateProductReview(Customer::GetCurrentCustomerId(),
                                     $this->mProductId, $_POST['review'],
                                     $_POST['rating']);

      // Display "add review" form because visitor is registered
      $this->mEnableAddProductReviewForm = true;

      // Get visitor's (reviewer's) name
      $customer_data = Customer::Get();
      $this->mReviewerName = $customer_data['name'];
    }

    // Get reviews for this product
    $this->mReviews = Catalog::GetProductReviews($this->mProductId);

    // Get the number of the reviews
    $this->mTotalReviews = count($this->mReviews);
  }
}
?>
