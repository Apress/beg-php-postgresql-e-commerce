{* department.tpl *}
{load_department assign="department"}
<p class="title">{$department->mNameLabel}</p>
<br />
<p class="description">{$department->mDescriptionLabel}</p>
{include file="products_list.tpl"}
