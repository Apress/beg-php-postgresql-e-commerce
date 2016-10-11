{* admin_login.tpl *}
{load_admin_login assign="admin_login"}
<br /><br />
<div id="admin_login_box">
  <span class="admin_title">HatShop Login</span>
  <br /><br />
  <span class="admin_page_text">
    Enter login information or go back to
    <a href="{"index.php"|prepare_link:"http"}">storefront</a>
  </span>
  <br />
{if $admin_login->mLoginMessage neq ''}
  <br />
  <span class="admin_error_text">{$admin_login->mLoginMessage}</span>
  <br />
{/if}
  <br />
  <form method="post" action="{"admin.php"|prepare_link:"https"}">
    Username:
    <input type="text" name="username" value="{$admin_login->mUsername}" />
    &nbsp;&nbsp;
    Password:
    <input type="password" name="password" value="" />
    <br /><br />
    <input type="submit" name="submit" value="Login" />
  </form>
</div>
