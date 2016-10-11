{* products_list.tpl *}
{load_products_list assign="products_list"}
{if $products_list->mrHowManyPages > 1}
<br />
<span class="paging_text">
  Page {$products_list->mPageNo} of {$products_list->mrHowManyPages}
  {if $products_list->mPreviousLink}
    <a href="{$products_list->mPreviousLink|prepare_link:"http"}">Previous</a>
  {else}
    Previous
  {/if}
  {if $products_list->mNextLink}
    <a href="{$products_list->mNextLink|prepare_link:"http"}">Next</a>
  {else}
    Next
  {/if}
</span>
{/if}
<br />
{section name=k loop=$products_list->mProducts}
  {assign var=direction_p value="left"}
  {if  $smarty.section.k.index != 0 &&
      ($smarty.section.k.index + 1) % 2 == 0}
    {assign var=direction_p value="right"}
  {else}
    <br />
  {/if}
  <p class="{$direction_p}">
    <a class="product_name"
     href="{$products_list->mProducts[k].link|prepare_link:"http"}">
      {$products_list->mProducts[k].name}
    </a>
    <br />
    <a href="{$products_list->mProducts[k].link|prepare_link:"http"}">
      <img src="product_images/{$products_list->mProducts[k].thumbnail}"
       border="0" width="120" alt="Product image" class="product_image" />
    </a>
    <span class="product_description">
      {$products_list->mProducts[k].description}
    </span>
    <br /><br />
    <span>Price:</span>
    {if $products_list->mProducts[k].discounted_price == 0}
    <span class="price">
    {else}
    <span class="old_price">
    {/if}
      ${$products_list->mProducts[k].price}
    </span>
    {if $products_list->mProducts[k].discounted_price != 0}
    <span class="price">
      &nbsp;${$products_list->mProducts[k].discounted_price}
    </span>
    {/if}
  </p>
{/section}
