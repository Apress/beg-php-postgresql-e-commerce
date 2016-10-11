{* customer_address.tpl *}
{load_customer_address assign="customer_address"}
<form method="post"
 action="{$customer_address->mCustomerAddressTarget|prepare_link:"https"}">
  <span class="description">Please enter your address details:</span>
  <br /><br />
  <table class="form_table">
    <tr>
      <td>Address 1:</td>
      <td>
        <input type="text" name="address1"
         value="{$customer_address->mAddress1}" />
      </td>
      <td>
        {if $customer_address->mAddress1Error}
        <span class="error_text">You must enter an address.</span>
        {/if}
      </td>
    </tr>
    <tr>
      <td>Address 2:</td>
      <td>
        <input type="text" name="address2"
         value="{$customer_address->mAddress2}" />
      </td>
    </tr>
    <tr>
      <td>Town/City:</td>
      <td>
        <input type="text" name="city"
         value="{$customer_address->mCity}" />
      </td>
      <td>
        {if $customer_address->mCityError}
        <span class="error_text">You must enter a city.</span>
        {/if}
      </td>
    </tr>
    <tr>
      <td>Region/State:</td>
      <td>
        <input type="text" name="region"
         value="{$customer_address->mRegion}" />
      </td>
      <td>
        {if $customer_address->mRegionError}
        <span class="error_text">You must enter a region/state.</span>
        {/if}
      </td>
    </tr>
    <tr>
      <td>Postal Code/ZIP:</td>
      <td>
        <input type="text" name="postalCode"
         value="{$customer_address->mPostalCode}" />
      </td>
      <td>
        {if $customer_address->mPostalCodeError}
        <span class="error_text">You must enter a postal code/ZIP.</span>
        {/if}
      </td>
    </tr>
    <tr>
      <td>Country:</td>
      <td>
        <input type="text" name="country"
         value="{$customer_address->mCountry}" />
      </td>
      <td>
        {if $customer_address->mCountryError}
        <span class="error_text">You must enter a country.</span>
        {/if}
      </td>
    </tr>
    <tr>
      <td>Shipping region:</td>
      <td>
        <select name="shippingRegion">
          {html_options options=$customer_address->mShippingRegions
           selected=$customer_address->mShippingRegion}
        </select>
      </td>
      <td>
        {if $customer_address->mShippingRegionError}
        <span class="error_text">You must select a shipping region.</span>
        {/if}
      </td>
    </tr>
  </table>
  <br />
  <input type="submit" name="sended" value="Confirm" />
  <input type="button" value="Cancel"
   onclick="window.location='{
     $customer_address->mReturnLink|prepare_link:$customer_address->mReturnLinkProtocol}';" />
</form>
