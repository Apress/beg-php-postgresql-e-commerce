<?php
// Plugin functions inside plugin files must be named: smarty_type_name
function smarty_function_load_search_box($params, $smarty)
{
  // Create SearchBox object
  $search_box = new SearchBox();

  // Assign template variable
  $smarty->assign($params['assign'], $search_box);
}

// Manages the search box
class SearchBox
{
  // Public variables for the smarty template
  public $mSearchString = '';
  public $mAllWords = 'off';

  // Class constructor
  public function __construct()
  {
    if (isset ($_GET['Search']))
      $this->mSearchString = $_GET['Search'];

    if (isset ($_GET['AllWords']))
      $this->mAllWords = $_GET['AllWords'];
  }
}
?>
