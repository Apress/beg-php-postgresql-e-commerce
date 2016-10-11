{* cart_details.tpl *}
{load_checkout_info assign="checkout_info"}
<span class="description">
  Your order consists of the following items:
</span>
<br /><br />
<form method="post"
 action="{$checkout_info->mCheckoutInfoLink|prepare_link:"https"}">
  <table>
    <tr>
      <th>Product Name</th>
      <th>Price</th>
      <th>Quantity</th>
      <th>Subtotal</th>
    </tr>
  {section name=cCartItems loop=$checkout_info->mCartItems}
    <tr>
      <td>{$checkout_info->mCartItems[cCartItems].name}</td>
      <td>{$checkout_info->mCartItems[cCartItems].price}</td>
      <td>{$checkout_info->mCartItems[cCartItems].quantity}</td>
      <td>{$checkout_info->mCartItems[cCartItems].subtotal}</td>
    </tr>
  {/section}
  </table>
  <br />
  <span>Total amount:</span>
  <span class="price">${$checkout_info->mTotalAmountLabel}</span>
  <br /><br />
  {if $checkout_info->mNoCreditCard == 'yes'}
  <span class="error_text">No credit card details stored.</span>
  {else}
  <span>{$checkout_info->mCreditCardNote}</span>
  {/if}
  <br /><br />
  {if $checkout_info->mNoShippingAddress == 'yes'}
  <span class="error_text">Shipping address required to place order.</span>
  {else}
  <span>
    Shipping address: <br />
    &nbsp;{$checkout_info->mCustomerData.address_1}<br />
    {if $checkout_info->mCustomerData.address_2}
      &nbsp;{$checkout_info->mCustomerData.address_2}<br />
    {/if}
    &nbsp;{$checkout_info->mCustomerData.city}<br />
    &nbsp;{$checkout_info->mCustomerData.region}<br />
    &nbsp;{$checkout_info->mCustomerData.postal_code}<br />
    &nbsp;{$checkout_info->mCustomerData.country}<br /><br />
    Shipping region: {$checkout_info->mShippingRegion}
  </span>
  {/if}
  <br /><br />
  <input type="submit" name="sended" value="Place Order"
   {$checkout_info->mOrderButtonVisible} />
  <input type="button" value="Edit Shopping Cart"
   onclick="window.location='{
     $checkout_info->mEditCart|prepare_link:"http"}';" />
  <input type="button" value="Continue Shopping" 
   onclick="window.location='{
     $checkout_info->mContinueShopping|prepare_link:"http"}';" />
</form>
