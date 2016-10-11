<?php
// Business tier class for reading product catalog information
class Catalog
{
  public static $mProductDisplayOptions = array ('Default',       // 0
                                                 'On Catalog',    // 1
                                                 'On Department', // 2
                                                 'On Both');      // 3

  // Retrieves all departments
  public static function GetDepartments()
  {
    // Build SQL query
    $sql = 'SELECT * FROM catalog_get_departments_list();';

    // Prepare the statement with PDO-specific functionality
    $result = DatabaseHandler::Prepare($sql);

    // Execute the query and return the results
    return DatabaseHandler::GetAll($result);
  }

  // Retrieves complete details for the specified department
  public static function GetDepartmentDetails($departmentId)
  {
    // Build SQL query
    $sql = 'SELECT *
            FROM catalog_get_department_details(:department_id);';
    // Build the parameters array
    $params = array (':department_id' => $departmentId);
    // Prepare the statement with PDO-specific functionality
    $result = DatabaseHandler::Prepare($sql);

    // Execute the query and return the results
    return DatabaseHandler::GetRow($result, $params);
  }

  // Retrieves list of categories that belong to a department
  public static function GetCategoriesInDepartment($departmentId)
  {
    // Build SQL query
    $sql = 'SELECT *
            FROM catalog_get_categories_list(:department_id);';
    // Build the parameters array
    $params = array (':department_id' => $departmentId);
    // Prepare the statement with PDO-specific functionality
    $result = DatabaseHandler::Prepare($sql);

    // Execute the query and return the results
    return DatabaseHandler::GetAll($result, $params);
  }

  // Retrieves complete details for the specified category
  public static function GetCategoryDetails($categoryId)
  {
    // Build SQL query
    $sql = 'SELECT *
            FROM catalog_get_category_details(:category_id);';
    // Build the parameters array
    $params = array (':category_id' => $categoryId);
    // Prepare the statement with PDO-specific functionality
    $result = DatabaseHandler::Prepare($sql);

    // Execute the query and return the results
    return DatabaseHandler::GetRow($result, $params);
  }

  /* Calculates how many pages of products could be filled by the
     number of products returned by the $countSql query */
  private static function HowManyPages($countSql, $countSqlParams)
  {
    // Create a hash for the sql query 
    $queryHashCode = md5($countSql . var_export($countSqlParams, true));

    // Verify if we have the query results in cache
    if (isset ($_SESSION['last_count_hash']) &&
        isset ($_SESSION['how_many_pages']) &&
        $_SESSION['last_count_hash'] === $queryHashCode)
    {
      // Retrieve the the cached value
      $how_many_pages = $_SESSION['how_many_pages'];
    }
    else
    {
      // Execute the query
      $prepared = DatabaseHandler::Prepare($countSql);
      $items_count = DatabaseHandler::GetOne($prepared, $countSqlParams);

      // Calculate the number of pages
      $how_many_pages = ceil($items_count / PRODUCTS_PER_PAGE);

      // Save the query and its count result in the session
      $_SESSION['last_count_hash'] = $queryHashCode;
      $_SESSION['how_many_pages'] = $how_many_pages;
    }

    // Return the number of pages    
    return $how_many_pages;
  }

  // Retrieves list of products that belong to a category
  public static function GetProductsInCategory(
                           $categoryId, $pageNo, &$rHowManyPages)
  {
    // Query that returns the number of products in the category
    $sql = 'SELECT catalog_count_products_in_category(:category_id);';
    $params = array (':category_id' => $categoryId);
    // Calculate the number of pages required to display the products
    $rHowManyPages = Catalog::HowManyPages($sql, $params);
    // Calculate the start item
    $start_item = ($pageNo - 1) * PRODUCTS_PER_PAGE;

    // Retrieve the list of products
    $sql = 'SELECT *
            FROM   catalog_get_products_in_category(
                     :category_id, :short_product_description_length,
                     :products_per_page, :start_item);';
    $params = array (
      ':category_id' => $categoryId,
      ':short_product_description_length' => SHORT_PRODUCT_DESCRIPTION_LENGTH,
      ':products_per_page' => PRODUCTS_PER_PAGE,
      ':start_item' => $start_item);
    $result = DatabaseHandler::Prepare($sql);

    // Execute the query and return the results
    return DatabaseHandler::GetAll($result, $params);
  }

  // Retrieves the list of products for the department page
  public static function GetProductsOnDepartmentDisplay(
                           $departmentId, $pageNo, &$rHowManyPages)
  {
    // Query that returns the number of products in the department page
    $sql = 'SELECT catalog_count_products_on_department(:department_id);';
    $params = array (':department_id' => $departmentId);
    // Calculate the number of pages required to display the products
    $rHowManyPages = Catalog::HowManyPages($sql, $params);
    // Calculate the start item
    $start_item = ($pageNo - 1) * PRODUCTS_PER_PAGE;

    // Retrieve the list of products
    $sql = 'SELECT *
            FROM   catalog_get_products_on_department(
                     :department_id, :short_product_description_length,
                     :products_per_page, :start_item);';
    $params = array (
      ':department_id' => $departmentId,
      ':short_product_description_length' => SHORT_PRODUCT_DESCRIPTION_LENGTH,
      ':products_per_page' => PRODUCTS_PER_PAGE,
      ':start_item' => $start_item);
    $result = DatabaseHandler::Prepare($sql);

    // Execute the query and return the results
    return DatabaseHandler::GetAll($result, $params);
  }

  // Retrieves the list of products on catalog display
  public static function GetProductsOnCatalogDisplay($pageNo, &$rHowManyPages)
  {
    // Query that returns the number of products for the front catalog page
    $sql = 'SELECT catalog_count_products_on_catalog();';
    // Calculate the number of pages required to display the products
    $rHowManyPages = Catalog::HowManyPages($sql, null);
    // Calculate the start item
    $start_item = ($pageNo - 1) * PRODUCTS_PER_PAGE;

    // Retrieve the list of products
    $sql = 'SELECT *
            FROM   catalog_get_products_on_catalog(
                     :short_product_description_length,
                     :products_per_page, :start_item);';
    $params = array (
      ':short_product_description_length' => SHORT_PRODUCT_DESCRIPTION_LENGTH,
      ':products_per_page' => PRODUCTS_PER_PAGE,
      ':start_item' => $start_item);
    $result = DatabaseHandler::Prepare($sql);

    // Execute the query and return the results
    return DatabaseHandler::GetAll($result, $params);
  }

  // Retrieves complete product details
  public static function GetProductDetails($productId)
  {
    // Build SQL query
    $sql = 'SELECT *
            FROM catalog_get_product_details(:product_id);';
    // Build the parameters array
    $params = array (':product_id' => $productId);
    // Prepare the statement with PDO-specific functionality
    $result = DatabaseHandler::Prepare($sql);

    // Execute the query and return the results
    return DatabaseHandler::GetRow($result, $params);
  }

  // Flags stop words in search query
  public static function FlagStopWords($words)
  {
    // Build SQL query
    $sql = 'SELECT *
            FROM catalog_flag_stop_words(:words);';
    // Build the parameters array
    $params = array (':words' => '{' . implode(', ', $words) . '}');
    // Prepare the statement with PDO-specific functionality
    $result = DatabaseHandler::Prepare($sql);

    // Execute the query
    $flags = DatabaseHandler::GetAll($result, $params);

    $search_words = array ('accepted_words' => array (),
                           'ignored_words' => array ());

    for ($i = 0; $i < count($flags); $i++)
      if ($flags[$i]['catalog_flag_stop_words'])
        $search_words['ignored_words'][] = $words[$i];
      else
        $search_words['accepted_words'][] = $words[$i];

    return $search_words;
  }

  // Search the catalog
  public static function Search($searchString, $allWords,
                               $pageNo, &$rHowManyPages)
  {
    // The search results will be an array of this form
    $search_result = array ('accepted_words' => array (),
                            'ignored_words' => array (),
                            'products' => array ());

    // Return void result if the search string is void
    if (empty ($searchString))
      return $search_result;

    // Search string delimiters
    $delimiters = ',.; ';
    // Use strtok to get the first word of the search string 
    $word = strtok($searchString, $delimiters);
    $words = array ();

    // Build words array
    while ($word)
    {
      $words[] = $word;
      // Get the next word of the search string
      $word = strtok($delimiters);
    }

    // Split the search words in two categories: accepted and ignored 
    $search_words = Catalog::FlagStopWords($words);
    $search_result['accepted_words'] = $search_words['accepted_words'];
    $search_result['ignored_words'] = $search_words['ignored_words'];

    // Return void result if all words are stop words
    if (count($search_result['accepted_words']) == 0)
      return $search_result;

    // Count the number of search results
    $sql = 'SELECT catalog_count_search_result(:words, :all_words);';
    $params = array (
      ':words' => '{' . implode(', ', $search_result['accepted_words']) . '}',
      ':all_words' => $allWords);
    // Calculate the number of pages required to display the products
    $rHowManyPages = Catalog::HowManyPages($sql, $params);
    // Calculate the start item
    $start_item = ($pageNo - 1) * PRODUCTS_PER_PAGE;

    // Retrieve the list of matching products
    $sql = 'SELECT *
            FROM   catalog_search(:words,
                                  :all_words,
                                  :short_product_description_length,
                                  :products_per_page,
                                  :start_page);';
    $params = array (
      ':words' => '{' . implode(', ', $search_result['accepted_words']) . '}',
      ':all_words' => $allWords, 
      ':short_product_description_length' => SHORT_PRODUCT_DESCRIPTION_LENGTH,
      ':products_per_page' => PRODUCTS_PER_PAGE,
      ':start_page' => $start_item);

    // Prepare and execute the query, and return the results
    $result = DatabaseHandler::Prepare($sql);
    $search_result['products'] = DatabaseHandler::GetAll($result, $params);
    return $search_result;
  }

  // Retrieves all departments with their descriptions
  public static function GetDepartmentsWithDescriptions()
  {
    // Build SQL query
    $sql = 'SELECT * FROM catalog_get_departments();';
    // Prepare the statement with PDO-specific functionality
    $result = DatabaseHandler::Prepare($sql);

    return DatabaseHandler::GetAll($result);
  }

  // Updates department details
  public static function UpdateDepartment($departmentId, $departmentName,
                                          $departmentDescription)
  {
    // Build SQL query
    $sql = 'SELECT catalog_update_department(:department_id, :department_name,
                                             :department_description);';
    // Build the parameters array
    $params = array (':department_id' => $departmentId,
                     ':department_name' => $departmentName,
                     ':department_description' => $departmentDescription);
    // Prepare the statement with PDO-specific functionality
    $result = DatabaseHandler::Prepare($sql);

    // Execute the query
    return DatabaseHandler::Execute($result, $params);
  }

  // Deletes a department
  public static function DeleteDepartment($departmentId)
  {
    // Build SQL query
    $sql = 'SELECT catalog_delete_department(:department_id);';
    // Build the parameters array
    $params = array (':department_id' => $departmentId);
    // Prepare the statement with PDO-specific functionality
    $result = DatabaseHandler::Prepare($sql);

    // Execute the query and return the results
    return DatabaseHandler::GetOne($result, $params);
  }

  // Add a department
  public static function AddDepartment($departmentName, $departmentDescription)
  {
    // Build SQL query
    $sql = 'SELECT catalog_add_department(
                     :department_name, :department_description);';
    // Build the parameters array
    $params = array (':department_name' => $departmentName,
                     ':department_description' => $departmentDescription);
    // Prepare the statement with PDO-specific functionality
    $result = DatabaseHandler::Prepare($sql);

    // Execute the query
    return DatabaseHandler::Execute($result, $params);
  }

  // Gets categories in a department
  public static function GetDepartmentCategories($departmentId)
  {
    // Build SQL query
    $sql = 'SELECT * FROM catalog_get_department_categories(:department_id);';
    // Build the parameters array
    $params = array (':department_id' => $departmentId);
    // Prepare the statement with PDO-specific functionality
    $result = DatabaseHandler::Prepare($sql);

    // Execute the query and return the results
    return DatabaseHandler::GetAll($result, $params);
  }

  // Adds a category
  public static function AddCategory($departmentId, $categoryName,
                                     $categoryDescription)
  {
    // Build SQL query
    $sql = 'SELECT catalog_add_category(:department_id, :category_name,
                                        :category_description);';
    // Build the parameters array
    $params = array (':department_id' => $departmentId,
                     ':category_name' => $categoryName,
                     ':category_description' => $categoryDescription);
    // Prepare the statement with PDO-specific functionality
    $result = DatabaseHandler::Prepare($sql);

    // Execute the query
    return DatabaseHandler::Execute($result, $params);
  }

  // Deletes a category
  public static function DeleteCategory($categoryId)
  {
    // Build SQL query
    $sql = 'SELECT catalog_delete_category(:category_id);';
    // Build the parameters array
    $params = array (':category_id' => $categoryId);
    // Prepare the statement with PDO-specific functionality
    $result = DatabaseHandler::Prepare($sql);

    // Execute the query and return the results
    return DatabaseHandler::GetOne($result, $params);
  }

  // Updates a category
  public static function UpdateCategory($categoryId, $categoryName,
                                        $categoryDescription)
  {
    // Build SQL query
    $sql = 'SELECT catalog_update_category(:category_id, :category_name,
                                           :category_description);';
    // Build the parameters array
    $params = array (':category_id' => $categoryId,
                     ':category_name' => $categoryName,
                     ':category_description' => $categoryDescription);
    // Prepare the statement with PDO-specific functionality
    $result = DatabaseHandler::Prepare($sql);

    // Execute the query
    return DatabaseHandler::Execute($result, $params);
  }

  // Gets products in a category
  public static function GetCategoryProducts($categoryId)
  {
    // Build SQL query
    $sql = 'SELECT * FROM catalog_get_category_products(:category_id);';
    // Build the parameters array
    $params = array (':category_id' => $categoryId);
    // Prepare the statement with PDO-specific functionality
    $result = DatabaseHandler::Prepare($sql);

    // Execute the query and return the results
    return DatabaseHandler::GetAll($result, $params);
  }

  // Creates a product and assigns it to a category
  public static function AddProductToCategory($categoryId, $productName,
                           $productDescription, $productPrice)
  {
    // Build SQL query
    $sql = 'SELECT catalog_add_product_to_category(:category_id, :product_name,
                     :product_description, :product_price);';
    // Build the parameters array
    $params = array (':category_id' => $categoryId,
                     ':product_name' => $productName,
                     ':product_description' => $productDescription,
                     ':product_price' => $productPrice);
    // Prepare the statement with PDO-specific functionality
    $result = DatabaseHandler::Prepare($sql);

    // Execute the query
    return DatabaseHandler::Execute($result, $params);
  }

  // Updates a product
  public static function UpdateProduct($productId, $productName,
                   $productDescription, $productPrice,
                   $productDiscountedPrice)
  {
    // Build SQL query
    $sql = 'SELECT catalog_update_product(:product_id, :product_name,
                     :product_description, :product_price,
                     :product_discounted_price);';
    // Build the parameters array
    $params = array (':product_id' => $productId,
                     ':product_name' => $productName,
                     ':product_description' => $productDescription,
                     ':product_price' => $productPrice,
                     ':product_discounted_price' => $productDiscountedPrice);
    // Prepare the statement with PDO-specific functionality
    $result = DatabaseHandler::Prepare($sql);

    // Execute the query
    return DatabaseHandler::Execute($result, $params);
  }

  // Removes a product from the product catalog
  public static function DeleteProduct($productId)
  {
    // Build SQL query
    $sql = 'SELECT catalog_delete_product(:product_id);';
    // Build the parameters array
    $params = array (':product_id' => $productId);
    // Prepare the statement with PDO-specific functionality
    $result = DatabaseHandler::Prepare($sql);

    // Execute the query
    return DatabaseHandler::Execute($result, $params);
  }

  // Unassigns a product from a category
  public static function RemoveProductFromCategory($productId, $categoryId)
  {
    // Build SQL query
    $sql = 'SELECT catalog_remove_product_from_category(
                     :product_id, :category_id);';
    // Build the parameters array
    $params = array (':product_id' => $productId,
                     ':category_id' => $categoryId);
    // Prepare the statement with PDO-specific functionality
    $result = DatabaseHandler::Prepare($sql);

    // Execute the query and return the results
    return DatabaseHandler::GetOne($result, $params);
  }

  // Retrieves the list of categories a product belongs to
  public static function GetCategories()
  {
    // Build SQL query
    $sql = 'SELECT * FROM catalog_get_categories();';
    // Prepare the statement with PDO-specific functionality
    $result = DatabaseHandler::Prepare($sql);

    // Execute the query and return the results
    return DatabaseHandler::GetAll($result);
  }

  // Retrieves product info
  public static function GetProductInfo($productId)
  {
    // Build SQL query
    $sql = 'SELECT * FROM catalog_get_product_info(:product_id);';
    // Build the parameters array
    $params = array (':product_id' => $productId);
    // Prepare the statement with PDO-specific functionality
    $result = DatabaseHandler::Prepare($sql);

    // Execute the query and return the results
    return DatabaseHandler::GetRow($result, $params);
  }

  // Retrieves the list of categories a product belongs to
  public static function GetCategoriesForProduct($productId)
  {
    // Build SQL query
    $sql = 'SELECT * FROM catalog_get_categories_for_product(:product_id);';
    // Build the parameters array
    $params = array (':product_id' => $productId);
    // Prepare the statement with PDO-specific functionality
    $result = DatabaseHandler::Prepare($sql);

    // Execute the query and return the results
    return DatabaseHandler::GetAll($result, $params);
  }

  // Assigns a product to a category
  public static function SetProductDisplayOption($productId, $display)
  {
    // Build SQL query
    $sql = 'SELECT catalog_set_product_display_option(
                     :product_id, :display);';
    // Build the parameters array
    $params = array (':product_id' => $productId,
                     ':display' => $display);
    // Prepare the statement with PDO-specific functionality
    $result = DatabaseHandler::Prepare($sql);

    // Execute the query
    return DatabaseHandler::Execute($result, $params);
  }

  // Assigns a product to a category
  public static function AssignProductToCategory($productId, $categoryId)
  {
    // Build SQL query
    $sql = 'SELECT catalog_assign_product_to_category(
                     :product_id, :category_id);';
    // Build the parameters array
    $params = array (':product_id' => $productId,
                     ':category_id' => $categoryId);
    // Prepare the statement with PDO-specific functionality
    $result = DatabaseHandler::Prepare($sql);

    // Execute the query
    return DatabaseHandler::Execute($result, $params);
  }

  // Moves a product from one category to another
  public static function MoveProductToCategory($productId, $sourceCategoryId,
                                               $targetCategoryId)
  {
    // Build SQL query
    $sql = 'SELECT catalog_move_product_to_category(:product_id,
                     :source_category_id, :target_category_id);';
    // Build the parameters array
    $params = array (':product_id' => $productId,
                     ':source_category_id' => $sourceCategoryId,
                     ':target_category_id' => $targetCategoryId);
    // Prepare the statement with PDO-specific functionality
    $result = DatabaseHandler::Prepare($sql);

    // Execute the query
    return DatabaseHandler::Execute($result, $params);
  }

  // Changes the name of the product image file in the database
  public static function SetImage($productId, $imageName)
  {
    // Build SQL query
    $sql = 'SELECT catalog_set_image(:product_id, :image_name);';
    // Build the parameters array
    $params = array (':product_id' => $productId, ':image_name' => $imageName);
    // Prepare the statement with PDO-specific functionality
    $result = DatabaseHandler::Prepare($sql);

    // Execute the query
    return DatabaseHandler::Execute($result, $params);
  }

  // Changes the name of the product thumbnail file in the database
  public static function SetThumbnail($productId, $thumbnailName)
  {
    // Build SQL query
    $sql = 'SELECT catalog_set_thumbnail(:product_id, :thumbnail_name);';
    // Build the parameters array
    $params = array (':product_id' => $productId,
                     ':thumbnail_name' => $thumbnailName);
    // Prepare the statement with PDO-specific functionality
    $result = DatabaseHandler::Prepare($sql);

    // Execute the query
    return DatabaseHandler::Execute($result, $params);
  }

  // Get product recommendations
  public static function GetRecommendations($productId)
  {
    // Build the SQL query
    $sql = 'SELECT * FROM catalog_get_recommendations(
                            :product_id, :short_product_description_length);';
    // Build the parameters array
    $params = array (':product_id' => $productId,
                     ':short_product_description_length' =>
                       SHORT_PRODUCT_DESCRIPTION_LENGTH);
    // Prepare the statement with PDO-specific functionality
    $result = DatabaseHandler::Prepare($sql);

    // Execute the query and return the results
    return DatabaseHandler::GetAll($result, $params);
  }
}
?>
