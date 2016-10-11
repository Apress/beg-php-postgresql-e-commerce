{* admin_cart.tpl *}
{load_admin_cart assign='admin_cart'}
<span class="admin_page_text">Admin users&#039; shopping carts:</span>
<br /><br />
{if $admin_cart->mMessage neq ""}
<span  class="admin_page_text">{$admin_cart->mMessage}</span>
<br /><br />
{/if}
<form action="{"admin.php?Page=Cart"|prepare_link:"https"}" method="post">
  <span class="admin_page_text">Select carts</span>
  {html_options name="days" options=$admin_cart->mDaysOptions
                selected=$admin_cart->mSelectedDaysNumber}
  <input type="submit" name="submit_count" value="Count Old Shopping Carts" />
  <input type="submit" name="submit_delete" value="Delete Old Shopping Carts" />
</form>
