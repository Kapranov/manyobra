jQuery ->

  # Target all text areas
  $("textarea").markItUp mySettings

  # Target a specific ID
  $("#editor").markItUp mySettings

  # Target a specific class
  $("textarea.markitup").markItUp mySettings