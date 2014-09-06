$(window).off('beforeunload.page');
$(window).off('beforeunload.blog_post');

function unsavedChangesToBlogPost() {
  return 'You have unsaved changes to the current blog post. Are you sure?';
}

function unsavedChangesToPage() {
  return 'You have unsaved changes to the current page. Are you sure?';
}
