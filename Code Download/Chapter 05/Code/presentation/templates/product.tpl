{load_product assign="product"}
<span class="description">{$product->mProduct.name}</span>
<br /><br />
<img src="product_images/{$product->mProduct.image}"
     alt="Product image" width="190" border="0" />
<br /><br />
<span>
  {$product->mProduct.description}
  <br /><br />Price:
</span>
{if $product->mProduct.discounted_price == 0}
<span class="price">
{else}
<span class="old_price">
{/if}
  ${$product->mProduct.price}
</span>
{if $product->mProduct.discounted_price != 0}
<span class="price">
  &nbsp;${$product->mProduct.discounted_price}
</span>
{/if}
<br /><br />
<input type="button" value="Continue Shopping"
 onclick="window.location='{$product->mPageLink|prepare_link:"http"}';" />
