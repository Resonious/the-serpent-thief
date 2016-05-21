function updatePathPreview() {
  var preview = $(this).closest('.path-container').find('.path-preview');
  var url = preview.data('root-url');
  if (url === undefined) {
    url = preview.text().trim();
    preview.data('root-url', url);
  }

  var path = this.value;
  if (path[0] === '/')
    path = path.substring(1, path.length);

  path = path
    .replace(/\/\/+/, '/')
    .replace(/\\+/, '/')
    .replace(/\s/, '-');

  preview.text(url + path);
}
