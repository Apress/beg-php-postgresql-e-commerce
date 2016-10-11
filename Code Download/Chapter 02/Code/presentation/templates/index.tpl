{* smarty *}
{config_load file="site.conf"}
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
 "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html>
  <head>
    <title>{#site_title#}</title>
    <link href="hatshop.css" type="text/css" rel="stylesheet" />
  </head>
  <body>
    <div>
      <div class="left_box">
        Place list of departments here
      </div>
      {include file="header.tpl"}
      <div id="content">
        Place contents here
      </div>
    </div>
  </body>
</html>
