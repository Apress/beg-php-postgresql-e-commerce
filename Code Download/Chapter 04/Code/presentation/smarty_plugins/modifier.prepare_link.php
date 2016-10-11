<?php
// Plugin functions inside plugin files must be named: smarty_type_name
function smarty_modifier_prepare_link($string, $link_type = 'http')
{
  // Use SSL?
  if ($link_type == 'https' && USE_SSL == 'no')
    $link_type = 'http';

  switch ($link_type)
  {
    case 'http':
      $link = 'http://' . getenv('SERVER_NAME');

      // If HTTP_SERVER_PORT is defined and diffrent than default
      if (defined('HTTP_SERVER_PORT') && HTTP_SERVER_PORT != '80')
      {
        // Append server port
        $link .= ':' . HTTP_SERVER_PORT;
      }

      $link .= VIRTUAL_LOCATION . $string;

      // Escape html
      return htmlspecialchars($link, ENT_QUOTES);
    case 'https':
      $link = 'https://' . getenv('SERVER_NAME') .
              VIRTUAL_LOCATION . $string;

      // Escape html
      return htmlspecialchars($link, ENT_QUOTES);
    default:
      return htmlspecialchars($string, ENT_QUOTES);
  }
}
?>
