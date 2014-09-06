@initializeSummernote = (element) ->
  $element = $(element)
  $element.summernote
    height: 300

  $element.code $element.val()

  $element.closest('form').submit ->
    $element.val $element.code()
    true
