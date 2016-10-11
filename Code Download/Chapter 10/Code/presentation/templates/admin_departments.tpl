{* admin_departments.tpl *}
{load_admin_departments assign="admin_departments"}
<span class="admin_page_text">Edit the departments of HatShop:</span>
<br /><br />
{if $admin_departments->mErrorMessage neq ""}
<span class="admin_error_text">
  {$admin_departments->mErrorMessage}<br /><br />
</span>
{/if}
<form method="post"
 action="{$admin_departments->mAdminDepartmentsTarget|prepare_link:"https"}">
{if $admin_departments->mDepartmentsCount eq 0}
  <strong>There are no departments in your database!</strong><br />
{else}
  <table>
    <tr>
      <th>Department Name</th>
      <th>Department Description</th>
      <th>&nbsp;</th>
    </tr>
  {section name=cDepartments loop=$admin_departments->mDepartments}
    {if $admin_departments->mEditItem ==
        $admin_departments->mDepartments[cDepartments].department_id}
    <tr>
      <td width="122">
        <input type="text" name="name"
         value="{$admin_departments->mDepartments[cDepartments].name}" />
      </td>
      <td>
      {strip}
        <textarea name="description" rows="3" cols="42">
          {$admin_departments->mDepartments[cDepartments].description}
        </textarea>
      {/strip}
      </td>
      <td align="right" width="280">
        <input type="submit"
         name="submit_edit_categ_{
               $admin_departments->mDepartments[cDepartments].department_id}"
         value="Edit Categories" />
        <input type="submit"
         name="submit_update_dep_{
               $admin_departments->mDepartments[cDepartments].department_id}"
         value="Update" />
        <input type="submit" name="cancel" value="Cancel" />
        <input type="submit"
         name="submit_delete_dep_{
               $admin_departments->mDepartments[cDepartments].department_id}"
         value="Delete" />
      </td>
    </tr>
    {else}
    <tr>
      <td width="122">
        {$admin_departments->mDepartments[cDepartments].name}
      </td>
      <td>{$admin_departments->mDepartments[cDepartments].description}</td>
      <td align="right" width="280">
        <input type="submit"
         name="submit_edit_categ_{
               $admin_departments->mDepartments[cDepartments].department_id}"
         value="Edit Categories" />
        <input type="submit"
         name="submit_edit_dep_{
               $admin_departments->mDepartments[cDepartments].department_id}"
         value="Edit" />
        <input type="submit"
         name="submit_delete_dep_{
               $admin_departments->mDepartments[cDepartments].department_id}"
         value="Delete" />
      </td>
    </tr>
    {/if}
  {/section}
  </table>
{/if}
  <br />
  <span class="admin_page_text">Add new department:</span>
  <br /><br />
  <input type="text" name="department_name" value="[name]" size="30" />
  <input type="text" name="department_description" value="[description]"
   size="60" />
  <input type="submit" name="submit_add_dep_0" value="Add" />
</form>
