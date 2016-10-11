{* reviews.tpl *}
{load_reviews assign="reviews"}
{if $reviews->mTotalReviews != 0}
<span class="description">Customer reviews:</span><br />
<ul>
  {section name=cReviews loop=$reviews->mReviews}
  <li>
    Review by
    <strong>{$reviews->mReviews[cReviews].customer_name}</strong> on
    {$reviews->mReviews[cReviews].created_on|date_format:"%A, %B %e, %Y"}
    <br /><br />
    <span>
    {$reviews->mReviews[cReviews].review}
    <br /><br />
    Rating: [{$reviews->mReviews[cReviews].rating} of 5]
    </span>
    <br />
  </li>
  {/section}
</ul>
{else}
<span class="description">
  Be the first person to voice your opinion!<br /><br />
</span>
{/if}
{if $reviews->mEnableAddProductReviewForm}
{* add review form *}
<span class="description"> Add a review:</span><br /><br />
<form method="post"
 action="{$reviews->mAddProductReviewTarget|prepare_link:"http"}">
  <table class="add_review">
    <tr>
      <td>
        From: <strong>{$reviews->mReviewerName}</strong>
      </td>
    </tr>
    <tr>
      <td>
        <textarea name="review"
         rows="3" cols="65">[Add your review here]</textarea>
      </td>
    </tr>
    <tr>
      <td>
        <table class="add_review">
          <tr>
            <td>
              Your Rating:
              <input type="radio" name="rating" value="1" /> 1
              <input type="radio" name="rating" value="2" /> 2
              <input type="radio" name="rating" value="3" checked="checked" /> 3
              <input type="radio" name="rating" value="4" /> 4
              <input type="radio" name="rating" value="5" /> 5
            </td>
            <td align="right">
              <input type="submit" name="AddProductReview" value="Add review" />
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</form>
{else}
<span>
  <strong>You must log in to add a review.<strong/>
</span>
{/if}
