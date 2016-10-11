<?php
// Business tier class for reading product catalog information
class Catalog
{
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
}
?>
