{* smarty *}
{config_load file="site.conf"}
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
 "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html>
  <head>
    <title>{#site_title#}</title>
    <link href="hatshop.css" type="text/css" rel="stylesheet" />
    {literal}
    <script language="JavaScript" type="text/javascript">
    <!--
      var PayPalWindow = null;
      function OpenPayPalWindow(url)
      {
        if ((!PayPalWindow) || PayPalWindow.closed)
          // If the PayPal window doesn't exist, we open it
          PayPalWindow = window.open(url, "cart", "height=300, width=500");
        else
        {
          // If the PayPal window exists, we make it show
          PayPalWindow.location.href = url;
          PayPalWindow.focus();
        }
      }
    // -->
    </script>
    {/literal}
  </head>
  <body>
    <div>
      {include file="departments_list.tpl"}
      {include file="$categoriesCell"}
      {include file="search_box.tpl"}
      {include file="$cartSummaryCell"}
      {include file="header.tpl"}
      <div id="content">
        {include file="$pageContentsCell"}
      </div>
    </div>
  </body>
</html>
