$(window).off('beforeunload.page');
$(window).off('beforeunload.blog_post');

function unsavedChangesToBlogPost() {
  return 'You have unsaved changes to the current blog post. Are you sure?';
}

function unsavedChangesToPage(condition) {
  return 'You have unsaved changes to the current page. Are you sure?';
}
var seriously;

$(function() {
  if ($('#active-warning').length) {
    $('#active-warning').hide();

    var alreadyActive = $('#active-warning').data('already-active');

    if (!alreadyActive) {
      $('#story_active').click(function() {
        if (this.checked) {
          $('#active-warning').show();
        } else {
          $('#active-warning').hide();
        }
      });
    }
  }

  $('.story-link.dropdown').mouseover(function() {
    $(this).dropdown('toggle');
  });
});
