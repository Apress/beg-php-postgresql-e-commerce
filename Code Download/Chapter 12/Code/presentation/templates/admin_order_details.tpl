{* admin_order_details.tpl *}
{load_admin_order_details assign="admin_order_details"}
<span class="admin_page_text">
  Editing details for order ID:
  {$admin_order_details->mOrderInfo.order_id} [
  {strip}
  <a href="{$admin_order_details->mAdminOrdersPageLink|prepare_link:"https"}">
    back to admin orders...
  </a>
  {/strip}
  ]
</span>
<br /><br />
<form action="{"admin.php"|prepare_link:"https"}" method="get">
  <input type="hidden" name="Page" value="OrderDetails" />
  <input type="hidden" name="OrderId"
   value="{$admin_order_details->mOrderInfo.order_id}" />
  <table class="edit">
    <tr>
      <td class="admin_page_text">Total Amount: </td>
      <td class="price">
        ${$admin_order_details->mTotalCost}
      </td>
    </tr>
    <tr>
      <td class="admin_page_text">Tax: </td>
      <td class="price">
        {$admin_order_details->mOrderInfo.tax_type}
        ${$admin_order_details->mTaxCost}
      </td>
    </tr>
    <tr>
      <td class="admin_page_text">Shipping: </td>
      <td class="price">
        {$admin_order_details->mOrderInfo.shipping_type}
      </td>
    </tr>
    <tr>
      <td class="admin_page_text">Date Created: </td>
      <td>
        {$admin_order_details->mOrderInfo.created_on|date_format:"%Y-%m-%d %T"}
      </td>
    </tr>
    <tr>
      <td class="admin_page_text">Date Shipped: </td>
      <td>
        {$admin_order_details->mOrderInfo.shipped_on|date_format:"%Y-%m-%d %T"}
      </td>
    </tr>
    <tr>
      <td class="admin_page_text">Status: </td>
      <td>
        <select name="status"
         {if ! $admin_order_details->mEditEnabled}
         disabled="disabled"
         {/if} >
          {html_options options=$admin_order_details->mOrderStatusOptions
           selected=$admin_order_details->mOrderInfo.status}
        </select>
      </td>
    </tr>
    <tr>
      <td class="admin_page_text">Authorization Code: </td>
      <td>
        <input name="authCode" type="text" size="50"
         value="{$admin_order_details->mOrderInfo.auth_code}"
         {if ! $admin_order_details->mEditEnabled}
         disabled="disabled"
         {/if} />
      <td>
    </tr>
    <tr>
      <td class="admin_page_text">Reference Number: </td>
      <td>
        <input name="reference" type="text" size="50"
         value="{$admin_order_details->mOrderInfo.reference}"
         {if ! $admin_order_details->mEditEnabled}
         disabled="disabled"
         {/if} />
      <td>
    </tr>
    <tr>
      <td class="admin_page_text">Comments: </td>
      <td>
        <input name="comments" type="text" size="50"
         value="{$admin_order_details->mOrderInfo.comments}"
         {if ! $admin_order_details->mEditEnabled}
         disabled="disabled"
         {/if} />
      <td>
    </tr>
    <tr>
      <td class="admin_page_text">Customer Name: </td>
      <td>
        {$admin_order_details->mCustomerInfo.name}
      <td>
    </tr>
    <tr>
      <td class="admin_page_text" valign="top">Shipping Address: </td>
      <td>
        {$admin_order_details->mCustomerInfo.address_1}<br />
        {if $admin_order_details->mCustomerInfo.address_2}
          {$admin_order_details->mCustomerInfo.address_2}<br />
        {/if}
        {$admin_order_details->mCustomerInfo.city}<br />
        {$admin_order_details->mCustomerInfo.region}<br />
        {$admin_order_details->mCustomerInfo.postal_code}<br />
        {$admin_order_details->mCustomerInfo.country}<br />
      </td>
    </tr>
    <tr>
      <td class="admin_page_text">Customer Email: </td>
      <td>
        {$admin_order_details->mCustomerInfo.email}
      </td>
    </tr>
  </table>
  <br />
  <input type="submit" name="submitEdit" value="Edit"
   {if $admin_order_details->mEditEnabled}
   disabled="disabled"
   {/if} />
  <input type="submit" name="submitUpdate" value="Update"
   {if ! $admin_order_details->mEditEnabled}
   disabled="disabled"
   {/if} />
  <input type="submit" name="submitCancel" value="Cancel"
   {if ! $admin_order_details->mEditEnabled}
   disabled="disabled"
   {/if} />
  <br /><br />
  <span class="admin_page_text">Order contains these products:</span>
  <br /><br />
  <table>
    <tr>
      <th>Product ID</th>
      <th>Product Name</th>
      <th>Quantity</th>
      <th>Unit Cost</th>
      <th>Subtotal</th>
    </tr>
  {section name=cOrder loop=$admin_order_details->mOrderDetails}
    <tr>
      <td>{$admin_order_details->mOrderDetails[cOrder].product_id}</td>
      <td>{$admin_order_details->mOrderDetails[cOrder].product_name}</td>
      <td>{$admin_order_details->mOrderDetails[cOrder].quantity}</td>
      <td>${$admin_order_details->mOrderDetails[cOrder].unit_cost}</td>
      <td>${$admin_order_details->mOrderDetails[cOrder].subtotal}</td>
    </tr>
  {/section}
  </table>
</form>
