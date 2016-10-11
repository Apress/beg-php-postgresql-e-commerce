{* admin_categories.tpl *}
{load_admin_categories assign="admin_categories"}
<span class="admin_page_text">
  Editing categories for department: {$admin_categories->mDepartmentName} [
  {strip}
  <a href="{$admin_categories->mAdminDepartmentsLink|prepare_link:"https"}">
    back to departments ...
  </a>
  {/strip}
  ]
</span>
<br /><br />
{if $admin_categories->mErrorMessage neq ""}
<span class="admin_error_text">
  {$admin_categories->mErrorMessage}<br /><br />
</span>
{/if}
<form method="post"
 action="{$admin_categories->mAdminCategoriesTarget|prepare_link:"https"}">
{if $admin_categories->mCategoriesCount eq 0}
  <strong>There are no categories in this department!</strong><br />
{else}
  <table>
    <tr>
      <th>Category Name</th>
      <th>Category Description</th>
      <th>&nbsp;</th>
    </tr>
  {section name=cCategories loop=$admin_categories->mCategories}
    {if $admin_categories->mEditItem ==
        $admin_categories->mCategories[cCategories].category_id}
    <tr>
      <td width="122">
        <input type="text" name="name"
         value="{$admin_categories->mCategories[cCategories].name}" />
      </td>
      <td>
        {strip}
        <textarea name="description"rows="3" cols="42">
          {$admin_categories->mCategories[cCategories].description}
        </textarea>
        {/strip}
      </td>
      <td align="right" width="280">
        <input type="submit"
         name="submit_edit_products_{
               $admin_categories->mCategories[cCategories].category_id}"
         value="Edit Products" />
        <input type="submit"
         name="submit_update_categ_{
               $admin_categories->mCategories[cCategories].category_id}"
         value="Update" />
        <input type="submit" name="cancel" value="Cancel" />
        <input type="submit"
         name="submit_delete_categ_{
               $admin_categories->mCategories[cCategories].category_id}"
         value="Delete" />
      </td>
    </tr>
    {else}
    <tr>
      <td width="122">
        {$admin_categories->mCategories[cCategories].name}
      </td>
      <td>{$admin_categories->mCategories[cCategories].description}</td>
      <td align="right" width="280">
        <input type="submit"
         name="submit_edit_products_{
               $admin_categories->mCategories[cCategories].category_id}"
         value="Edit Products" />
        <input type="submit"
         name="submit_edit_categ_{
               $admin_categories->mCategories[cCategories].category_id}"
         value="Edit" />
        <input type="submit"
         name="submit_delete_categ_{
               $admin_categories->mCategories[cCategories].category_id}"
         value="Delete" />
      </td>
    </tr>
    {/if}
  {/section}
  </table>
{/if}
  <br />
  <span class="admin_page_text">Add new category:</span>
  <br /><br />
  <input type="text" name="category_name" value="[name]" size="30" />
  <input type="text" name="category_description" value="[description]"
   size="60" />
  <input type="submit" name="submit_add_categ_0" value="Add" />
</form>
