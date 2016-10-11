{* customer_credit_card.tpl *}
{load_customer_credit_card assign="customer_credit_card"}
<form method="post"
 action="{$customer_credit_card->mCustomerCreditCardTarget|prepare_link:"https"}">
  <span class="description">
    Please enter your credit card details:
  </span>
  <br /><br />
  <table class="form_table">
    <tr>
      <td>Card Holder:</td>
      <td>
        <input type="text" name="cardHolder"
         value="{$customer_credit_card->mPlainCreditCard.card_holder}" />
      </td>
      <td>
        {if $customer_credit_card->mCardHolderError}
        <span class="error_text">You must enter a card holder.</span>
        {/if}
      </td>
    </tr>
    <tr>
      <td>Card Number (digits only):</td>
      <td>
        <input type="text" name="cardNumber"
         value="{$customer_credit_card->mPlainCreditCard.card_number}" />
      </td>
      <td>
        {if $customer_credit_card->mCardNumberError}
        <span class="error_text">You must enter a card number.</span>
        {/if}
      </td>
    </tr>
    <tr>
      <td>Expiry Date (MM/YY):</td>
      <td>
        <input type="text" name="expDate"
         value="{$customer_credit_card->mPlainCreditCard.expiry_date}" />
      </td>
      <td>
        {if $customer_credit_card->mExpDateError}
        <span class="error_text">You must enter an expiry date</span>
        {/if}
      </td>
    </tr>
    <tr>
      <td>Issue Date (MM/YY if applicable):</td>
      <td>
        <input type="text" name="issueDate"
         value="{$customer_credit_card->mPlainCreditCard.issue_date}" />
      </td>
    </tr>
    <tr>
      <td>Issue Number (if applicable):</td>
      <td>
        <input type="text" name="issueNumber"
         value="{$customer_credit_card->mPlainCreditCard.issue_number}" />
      </td>
    </tr>
    <tr>
      <td>Card Type:</td>
      <td>
        <select name="cardType">
          {html_options options=$customer_credit_card->mCardTypes
           selected=$customer_credit_card->mPlainCreditCard.card_type}
        </select>
      </td>
      <td>
        {if $customer_credit_card->mCardTypesError}
        <span  class="error_text">You must enter a card type.</span>
        {/if}
      </td>
    </tr>
  </table>
  <br />
  <input type="submit" name="sended" value="Confirm" />
  <input type="button" value="Cancel"
   onclick="window.location='{
     $customer_credit_card->mReturnLink|prepare_link:$customer_credit_card->mReturnLinkProtocol}';" />
</form>
