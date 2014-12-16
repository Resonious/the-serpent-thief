$(window).off('beforeunload.page');
$(window).off('beforeunload.blog_post');

function unsavedChangesToBlogPost() {
  return 'You have unsaved changes to the current blog post. Are you sure?';
}

function unsavedChangesToPage(condition) {
  return 'You have unsaved changes to the current page. Are you sure?';
}

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

  $('.tag-drop-hover').mouseover(function() {
    var storyTags = $(this).next('.story-tags');
    var dropdown = storyTags.find('.tags-dropdown');

    dropdown.dropdown('toggle');
  });
});
