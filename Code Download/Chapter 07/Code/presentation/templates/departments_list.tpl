{* departments_list.tpl *}
{load_departments_list assign="departments_list"}
{* Start departments list *}
<div class="left_box" id="departments_box">
  <p>Choose a Department</p>
  <ol>
  {* Loop through the list of departments *}
  {section name=i loop=$departments_list->mDepartments}
    {assign var=selected_d value=""}
    {* Verify if the department is selected to decide what CSS style
       to use *}
    {if ($departments_list->mSelectedDepartment == 
         $departments_list->mDepartments[i].department_id)}
      {assign var=selected_d value="class=\"selected\""}
    {/if}
    <li>
      {* Generate a link for a new department in the list *}
      <a {$selected_d}
       href="{$departments_list->mDepartments[i].link|prepare_link:"http"}">
        &raquo; {$departments_list->mDepartments[i].name}
      </a>
    </li>
  {/section}
  </ol>
</div>
{* End departments list *}
