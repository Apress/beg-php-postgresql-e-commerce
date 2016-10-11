{* customer_login.tpl *}
{load_customer_login assign="customer_login"}
<div class="left_box" id="login_box">
  <p>Login</p>
    <form method="post"
     action="{$customer_login->mCustomerLoginTarget|prepare_link:"https"}">
    {if $customer_login->mLoginMessage}
    <span class="error_text">
      {$customer_login->mLoginMessage}
    </span>
    <br />
    {/if}
    <span>E-mail address:</span><br />
    <input type="text" maxlength="50" name="email"
     size="25" value="{$customer_login->mEmail}" /><br />
    <span>Password:</span><br />
    <input type="password" maxlength="50"
     name="password" size="25" />
    <br />
    <input type="submit" name="Login" value="Login" />
    <strong>(
      {strip}
      <a href="{$customer_login->mRegisterUser|prepare_link:"https"}">
        Register user
      </a>
      {/strip} )
    </strong>
  </form>
</div>
