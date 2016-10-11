{* customer_details.tpl *}
{load_customer_details assign="customer_details"}
<form method="post"
 action="{$customer_details->mCustomerDetailsTarget|prepare_link:"https"}">
  <span class="description">Please enter your details:</span>
  {if $customer_details->mEmailAlreadyTaken}
  <br /><br />
  <span class="error_text">
    A user with that e-mail address already exists.
  </span>
  {/if}
  <br /><br />
  <table class="form_table">
    <tr>
      <td>E-mail Address:</td>
      <td>
        <input type="text" name="email"
         value="{$customer_details->mEmail}"
         {if $customer_details->mEditMode}readonly="readonly"{/if} />
      </td>
      <td>
      {if $customer_details->mEmailError}
        <span class="error_text">
          You must enter an e-mail address.
        </span>
      {/if}
      </td>
    </tr>
    <tr>
      <td>Name:</td>
      <td>
        <input type="text" name="name"
         value="{$customer_details->mName}" />
      </td>
      <td>
        {if $customer_details->mNameError}
        <span class="error_text">You must enter your name.</span>
        {/if}
      </td>
    </tr>
    <tr>
      <td>Password:</td>
      <td><input type="password" name="password" /></td>
      <td>
        {if $customer_details->mPasswordError}
        <span class="error_text">You must enter a password.</span>
        {/if}
      </td>
    </tr>
    <tr>
      <td>Re-enter Password:</td>
      <td><input type="password" name="passwordConfirm" /></td>
      <td>
        {if $customer_details->mPasswordConfirmError}
        <span class="error_text">
          You must re-enter your password.
        </span>
        {elseif $customer_details->mPasswordMatchError}
        <span class="error_text">
          You must re-enter the same password.
        </span>
        {/if}
      </td>
    </tr>
    {if $customer_details->mEditMode}
    <tr>
      <td>Day phone:</td>
      <td>
        <input type="text" name="dayPhone"
         value="{$customer_details->mDayPhone}" />
      </td>
    </tr>
    <tr>
      <td>Eve phone:</td>
      <td>
        <input type="text" name="evePhone"
         value="{$customer_details->mEvePhone}" />
      </td>
    </tr>
    <tr>
      <td>Mob phone:</td>
      <td>
        <input type="text" name="mobPhone"
         value="{$customer_details->mMobPhone}" />
      </td>
    </tr>
    {/if}
  </table>
  <br />
  <input type="submit" name="sended" value="Confirm" />
  <input type="button" value="Cancel"
   onclick="window.location='{
     $customer_details->mReturnLink|prepare_link:$customer_details->mReturnLinkProtocol}';" />
</form>
