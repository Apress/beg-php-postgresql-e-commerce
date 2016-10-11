{* search_box.tpl *}
{load_search_box assign="search_box"}
{* Start search box *}
<div  class="left_box" id="search_box">
  <p>Search the Catalog</p>
  <form action={"index.php"|prepare_link:"http"}>
    <input maxlength="100" id="Search" name="Search"
           value="{$search_box->mSearchString}" size="23" />
    <input type="submit" value="Go!" /><br />
    <input type="checkbox" id="AllWords" name="AllWords"
    {if $search_box->mAllWords == "on" } checked="checked" {/if}/>
      Search for all words
  </form>
</div>
{* End search box *}
