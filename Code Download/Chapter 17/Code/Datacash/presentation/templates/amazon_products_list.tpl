{* amazon_products_list.tpl *}
{load_amazon_products_list assign="amazon_products_list"}
<p class="title">{$amazon_products_list->mDepartmentName}</p>
<br />
<p class="description">{$amazon_products_list->mDepartmentDescription}</p>
{section name=k loop=$amazon_products_list->mProducts}
  {assign var=direction_p value="left"}
  {if  $smarty.section.k.index != 0 &&
      ($smarty.section.k.index + 1) % 2 == 0}
    {assign var=direction_p value="right"}
  {else}
    <br />
  {/if}
  <p class="{$direction_p}">
    <br />
    <img src="{$amazon_products_list->mProducts[k].image}"
     border="0" height="70" alt="Product image" class="product_image" />
    <span class="small_title">
      {$amazon_products_list->mProducts[k].item_name}
    </span>
    <span>
      by {$amazon_products_list->mProducts[k].brand}
    </span>
    <br /><br />
    {if $amazon_products_list->mProducts[k].price}
    <span>Price:</span>
    <span class="price">
      {$amazon_products_list->mProducts[k].price}
    </span>
    {/if}
    <br /><br />
    <a class="small_link" target="_blank"
     href="{$amazon_products_list->mProducts[k].link}">
      Buy From Amazon
    </a>
  </p>
{/section}
