<?php
// Business tier class for the orders
class Orders
{
  public static $mOrderStatusOptions = array ('placed',    // 0
                                              'verified',  // 1
                                              'completed', // 2
                                              'canceled'); // 3

  // Get the most recent $how_many orders
  public static function GetMostRecentOrders($how_many)
  {
    // Build the SQL query
    $sql = 'SELECT * FROM orders_get_most_recent_orders(:how_many);';
    // Build the parameters array
    $params = array (':how_many' => $how_many);
    // Prepare the statement with PDO-specific functionality
    $result = DatabaseHandler::Prepare($sql);

    // Execute the query and return the results
    return DatabaseHandler::GetAll($result, $params);
  }

  // Get orders between two dates
  public static function GetOrdersBetweenDates($startDate, $endDate)
  {
    // Build the SQL query
    $sql = 'SELECT * FROM orders_get_orders_between_dates(
                            :start_date, :end_date);';
    // Build the parameters array
    $params = array (':start_date' => $startDate, ':end_date' => $endDate);
    // Prepare the statement with PDO-specific functionality
    $result = DatabaseHandler::Prepare($sql);

    // Execute the query and return the results
    return DatabaseHandler::GetAll($result, $params);
  }

  // Gets orders by status
  public static function GetOrdersByStatus($status)
  {
    // Build the SQL query
    $sql = 'SELECT * FROM orders_get_orders_by_status(:status);';
    // Build the parameters array
    $params = array (':status' => $status);
    // Prepare the statement with PDO-specific functionality
    $result = DatabaseHandler::Prepare($sql);

    // Execute the query and return the results
    return DatabaseHandler::GetAll($result, $params);
  }

  // Gets the details of a specific order
  public static function GetOrderInfo($orderId)
  {
    // Build the SQL query
    $sql = 'SELECT * FROM orders_get_order_info(:order_id);';
    // Build the parameters array
    $params = array (':order_id' => $orderId);
    // Prepare the statement with PDO-specific functionality
    $result = DatabaseHandler::Prepare($sql);

    // Execute the query and return the results
    return DatabaseHandler::GetRow($result, $params);
  }

  // Gets the products that belong to a specific order
  public static function GetOrderDetails($orderId)
  {
    // Build the SQL query
    $sql = 'SELECT * FROM orders_get_order_details(:order_id);';
    // Build the parameters array
    $params = array (':order_id' => $orderId);
    // Prepare the statement with PDO-specific functionality
    $result = DatabaseHandler::Prepare($sql);

    // Execute the query and return the results
    return DatabaseHandler::GetAll($result, $params);
  }

  // Updates order details
  public static function UpdateOrder($orderId, $status, $comments,
                           $customerName, $shippingAddress, $customerEmail)
  {
    // Build the SQL query
    $sql = 'SELECT orders_update_order(:order_id, :status, :comments,
                     :customer_name, :shipping_address, :customer_email);';
    // Build the parameters array
    $params = array (':order_id' => $orderId,
                     ':status' => $status,
                     ':comments' => $comments,
                     ':customer_name' => $customerName,
                     ':shipping_address' => $shippingAddress,
                     ':customer_email' => $customerEmail);
    // Prepare the statement with PDO-specific functionality
    $result = DatabaseHandler::Prepare($sql);

    // Execute the query
    return DatabaseHandler::Execute($result, $params);
  }
}
?>
