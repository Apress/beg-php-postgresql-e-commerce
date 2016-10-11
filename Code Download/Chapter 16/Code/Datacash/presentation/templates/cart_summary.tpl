{* cart_summary.tpl *}
{load_cart_summary assign="cart_summary"}
{* Start cart summary *}
<div class="left_box" id="cart_summary_box">
  <p>Cart Summary</p>
{if $cart_summary->mEmptyCart}
  <span class="cart_empty">Your shopping cart is empty!</span>
{else}
  <ol class="cart_items_list">
  {section name=cCartSummary loop=$cart_summary->mItems}
    <li>
    {$cart_summary->mItems[cCartSummary].quantity} x
    {$cart_summary->mItems[cCartSummary].name}
    </li>
  {/section}
  </ol>
  <span class="cart_items_total">
    ${$cart_summary->mTotalAmount}
    ( <a href="{"index.php?CartAction"|prepare_link:"http"}">View details</a> )
  </span>
{/if}
</div>
{* End cart summary *}
