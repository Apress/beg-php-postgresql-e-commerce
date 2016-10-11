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
<input type="button" name="add_to_cart" value="Add to Cart"
 onclick="window.location=
   '{$product->mAddToCartLink|prepare_link:"http"}';" />
<input type="button" value="Continue Shopping"
 onclick="window.location='{$product->mPageLink|prepare_link:"http"}';" />
{if $product->mRecommendations}
<br /><br />
<span class="description">Customers who bought this also bought:</span>
  {section name=m loop=$product->mRecommendations}
<br /><br />
    {strip}
<a class="product_recommendation"
   href="{$product->mRecommendations[m].link|prepare_link:"http"}">
  {$product->mRecommendations[m].name}
</a>
    {/strip}
 -
<span>{$product->mRecommendations[m].description}</span>
  {/section}
{/if}
<br /><br />
{include file="reviews.tpl"}
