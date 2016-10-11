{* admin_orders.tpl *}
{load_admin_orders assign="admin_orders"}
{if $admin_orders->mErrorMessage neq ""}
<span class="admin_error_text">{$admin_orders->mErrorMessage}</span>
<br /><br />
{/if}
<form action="{"admin.php"|prepare_link:"https"}" method="get">
  <input name="Page" type="hidden" value="Orders" />
  <span class="admin_page_text">Show the most recent</span>
  <input name="recordCount" type="text" value="{$admin_orders->mRecordCount}" />
  <span class="admin_page_text">orders</span>
  <input type="submit" name="submitMostRecent" value="Go!" />
  <br /><br />
  <span class="admin_page_text">Show all records created between</span>
  <input name="startDate" type="text" value="{$admin_orders->mStartDate}" />
  <span class="admin_page_text">and</span>
  <input name="endDate" type="text" value="{$admin_orders->mEndDate}" />
  <input type="submit" name="submitBetweenDates" value="Go!" />
  <br /><br />
  <span class="admin_page_text">Show orders by status</span>
  {html_options name="status" options=$admin_orders->mOrderStatusOptions
   selected=$admin_orders->mSelectedStatus}
  <input type="submit" name="submitOrdersByStatus" value="Go!" />
  <br /><br />
</form>
<br />
{if $admin_orders->mOrders}
<table>
  <tr>
   <th>Order ID</th>
   <th>Date Created</th>
   <th>Date Shipped</th>
   <th>Status</th>
   <th>Customer</th>
   <th>&nbsp;</th>
  </tr>
  {section name=cOrders loop=$admin_orders->mOrders}
    {assign var=status value=$admin_orders->mOrders[cOrders].status}
  <tr>
    <td>{$admin_orders->mOrders[cOrders].order_id}</td>
    <td>
      {$admin_orders->mOrders[cOrders].created_on|date_format:"%Y-%m-%d %T"}
    </td>
    <td>
      {$admin_orders->mOrders[cOrders].shipped_on|date_format:"%Y-%m-%d %T"}
    </td>
    <td>{$admin_orders->mOrderStatusOptions[$status]}</td>
    <td>{$admin_orders->mOrders[cOrders].customer_name}</td>
    <td align="right">
      <input type="button" value="View Details"
       onclick="window.location='{
         $admin_orders->mOrders[cOrders].onclick|prepare_link:"https"}';" />
    </td>
  </tr>
  {/section}
</table>
{/if}
