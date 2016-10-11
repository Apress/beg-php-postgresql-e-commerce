{* admin_products.tpl *}
{load_admin_products assign="admin_products"}
<span class="admin_page_text">
  Editing products for category: {$admin_products->mCategoryName} [
  {strip}
  <a href="{$admin_products->mAdminCategoriesLink|prepare_link:"https"}">
    back to categories ...
  </a>
  {/strip}
  ]
</span>
<br /><br />
{if $admin_products->mErrorMessage neq ""}
<span class="admin_error_text">
  {$admin_products->mErrorMessage}<br /><br />
</span>
{/if}
<form  method="post"
 action="{$admin_products->mAdminProductsTarget|prepare_link:"https"}">
{if $admin_products->mProductsCount eq 0}
  <strong>There are no products in this category!</strong><br />
{else}
  <table>
    <tr>
      <th>Name</th>
      <th>Description</th>
      <th>Price</th>
      <th>Discounted Price</th>
      <th>&nbsp;</th>
    </tr>
  {section name=cProducts loop=$admin_products->mProducts}
    {if $admin_products->mEditItem ==
        $admin_products->mProducts[cProducts].product_id}
    <tr>
      <td>
        <input type="text" size="15" name="name"
         value="{$admin_products->mProducts[cProducts].name}" />
      </td>
      <td>
      {strip}
        <textarea name="description" rows="3" cols="39">
          {$admin_products->mProducts[cProducts].description}
        </textarea>
      {/strip}
      </td>
      <td>
        <input type="text" name="price"
         value="{$admin_products->mProducts[cProducts].price}" size="5" />
      </td>
      <td>
        <input type="text" name="discounted_price"
         value="{$admin_products->mProducts[cProducts].discounted_price}"
         size="5" />
      </td>
      <td align="right" width="180">
        <input type="submit"
         name="submit_update_prod_{
               $admin_products->mProducts[cProducts].product_id}"
         value="Update" />
        <input type="submit" name="cancel" value="Cancel" />
        <input type="submit"
         name="submit_select_prod_{
               $admin_products->mProducts[cProducts].product_id}"
         value="Select" />
      </td>
    </tr>
    {else}
    <tr>
      <td>{$admin_products->mProducts[cProducts].name}</td>
      <td>{$admin_products->mProducts[cProducts].description}</td>
      <td>{$admin_products->mProducts[cProducts].price}</td>
      <td>{$admin_products->mProducts[cProducts].discounted_price}</td>
      <td align="right" width="180">
        <input type="submit"
         name="submit_edit_prod_{
               $admin_products->mProducts[cProducts].product_id}"
         value="Edit" />
        <input type="submit"
         name="submit_select_prod_{
               $admin_products->mProducts[cProducts].product_id}"
         value="Select" />
      </td>
    </tr>
    {/if}
  {/section}
  </table>
{/if}
  <br />
  <span class="admin_page_text">Add new product:</span>
  <br /><br />
  <input type="text" name="product_name" value="[name]" size="30" />
  <input type="text" name="product_description" value="[description]"
   size="75" />
  <input type="text" name="product_price" value="[price]" size="10" />
  <input type="submit" name="submit_add_prod_0" value="Add" />
</form>
