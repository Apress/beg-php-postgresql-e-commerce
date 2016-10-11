{* categories_list.tpl *}
{load_categories_list assign="categories_list"}
{* Start categories list *}
<div class="left_box" id="categories_box">
  <p>Choose a Category</p>
  <ol>
  {section name=i loop=$categories_list->mCategories}
    {assign var=selected_c value=""}
    {if ($categories_list->mCategorySelected ==
         $categories_list->mCategories[i].category_id)}
      {assign var=selected_c value="class=\"selected\""}
    {/if}
    <li>
      <a {$selected_c}
       href="{$categories_list->mCategories[i].link|prepare_link:"http"}">
        &raquo; {$categories_list->mCategories[i].name}
      </a>
    </li>
  {/section}
  </ol>
</div>
{* End categories list *}
