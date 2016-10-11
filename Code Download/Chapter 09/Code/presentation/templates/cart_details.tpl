{* cart_details.tpl *}
{load_cart_details assign="cart_details"}
{if ($cart_details->mIsCartNowEmpty == 1)}
<span class="description">Your shopping cart is empty!</span>
<br /><br />
{else}
<span class="description">These are the products in your shopping cart:</span>
<br /><br />
<form method="post"
 action="{$cart_details->mCartDetailsTarget|prepare_link:"http"}">
  <table>
    <tr>
      <th>Product Name</th>
      <th>Price</th>
      <th>Quantity</th>
      <th>Subtotal</th>
      <th>&nbsp;</th>
    </tr>
  {section name=cCart loop=$cart_details->mCartProducts}
    <tr>
      <td>
        <input name="productID[]" type="hidden"
         value="{$cart_details->mCartProducts[cCart].product_id}" />
        {$cart_details->mCartProducts[cCart].name}
      </td>
      <td>${$cart_details->mCartProducts[cCart].price}</td>
      <td>
        <input type="text" name="quantity[]" size="10"
         value="{$cart_details->mCartProducts[cCart].quantity}" />
      </td>
      <td>${$cart_details->mCartProducts[cCart].subtotal}</td>
      <td align="right">
        <input type="button" name="saveForLater" value="Save for later"
         onclick="window.location=
           '{$cart_details->mCartProducts[cCart].save|prepare_link}';" />
        <input type="button" name="remove" value="Remove"
         onclick="window.location=
           '{$cart_details->mCartProducts[cCart].remove|prepare_link}';" />
      </td>
    </tr>
  {/section}
  </table>
  <table>
    <tr>
      <td class="cart_total">
        <span>Total amount:</span>&nbsp;
        <span class="price">${$cart_details->mTotalAmount}</span>
      </td>
      <td class="cart_total" align="right">
        <input type="submit" name="update" value="Update" />
        <input type="submit" name="place_order" value="Place Order" />
      </td>
    </tr>
  </table>
</form>
{/if}
{if ($cart_details->mIsCartLaterEmpty == 0)}
<br />
<span class="description">Saved products to buy later:</span>
<br /><br />
<table>
  <tr>
    <th>Product Name</th>
    <th>Price</th>
    <th>&nbsp;</th>
  </tr>
  {section name=cSavedCart loop=$cart_details->mSavedCartProducts}
  <tr>
    <td>{$cart_details->mSavedCartProducts[cSavedCart].name}</td>
    <td>
      ${$cart_details->mSavedCartProducts[cSavedCart].price}
    </td>
    <td align="right">
      <input type="button" name="moveToCart" value="Move to cart"
       onclick="window.location=
         '{$cart_details->mSavedCartProducts[cSavedCart].move|prepare_link}';"
       />
      <input type="button" name="remove" value="Remove"
       onclick="window.location=
         '{$cart_details->mSavedCartProducts[cSavedCart].remove|prepare_link}';"
       />
    </td>
  </tr>
  {/section}
</table>
{/if}
<br />
<input type="button" name="continueShopping" value="Continue Shopping"
 onclick="window.location='{$cart_details->mCartReferrer}';" />
