{* admin_product.tpl *}
{load_admin_product assign="admin_product"}
<span class="admin_page_text">
  Editing product: ID #{$admin_product->mProductId} &mdash;
  {$admin_product->mProductName} [
  {strip}
  <a href="{$admin_product->mAdminProductsLink|prepare_link:"https"}">
    back to products ...
  </a>
  {/strip}
  ]
</span>
<form enctype="multipart/form-data" method="post"
 action="{$admin_product->mAdminProductTarget|prepare_link:"https"}">
  <br />
  <span class="admin_page_text">Product belongs to these categories:</span>
  <span><strong>{$admin_product->mProductCategoriesString}</strong></span>
  <br /><br />
  <span class="admin_page_text">Remove this product from:</span>
  {html_options name="TargetCategoryIdRemove"
   options=$admin_product->mRemoveFromCategories}
  <input type="submit" name="RemoveFromCategory" value="Remove"
  {if $admin_product->mRemoveFromCategoryButtonDisabled}
   disabled="disabled" {/if}/>
  <br /><br />
  <span class="admin_page_text">Set display option for this product:</span>
  {html_options name="ProductDisplay"
   options=$admin_product->mProductDisplayOptions
   selected=$admin_product->mProductDisplay}
  <input type="submit" name="SetProductDisplayOption" value="Set" />
  <br /><br />
  <span class="admin_page_text">Assign product to this category:</span>
  {html_options name="TargetCategoryIdAssign"
   options=$admin_product->mAssignOrMoveTo}
  <input type="submit" name="Assign" value="Assign" />
  <br /><br />
  <span class="admin_page_text">Move product to this category:</span>
  {html_options name="TargetCategoryIdMove"
   options=$admin_product->mAssignOrMoveTo}
  <input type="submit" name="Move" value="Move" />
  <br /><br />
  <input type="submit" name="RemoveFromCatalog"
   value="Remove product from catalog"
  {if !$admin_product->mRemoveFromCategoryButtonDisabled}
   disabled="disabled" {/if} />
  <br /><br />
  <span class="admin_page_text">
    Image name: {$admin_product->mProductImage}
    <input name="ImageUpload" type="file" value="Upload" />
    <input type="submit" name="Upload" value="Upload" /><br />
    <img src="product_images/{$admin_product->mProductImage}"
     border="0" alt="Product image" />
    <br />
    Thumbnail name: {$admin_product->mProductThumbnail}
    <input name="ThumbnailUpload" type="file" value="Upload" />
    <input type="submit" name="Upload" value="Upload" /><br />
    <img src="product_images/{$admin_product->mProductThumbnail}"
     border="0" alt="Product thumbnail" />
  </span>
</form>
