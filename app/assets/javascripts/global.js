$(window).off('beforeunload.page');
$(window).off('beforeunload.blog_post');

function unsavedChangesToBlogPost() {
  return 'You have unsaved changes to the current blog post. Are you sure?';
}

function unsavedChangesToPage(condition) {
  return 'You have unsaved changes to the current page. Are you sure?';
}

function setLogoWidth() {
  if ($('#page-box').length == 0) {
    var pageWidth = $(window).width();
    var logoWidth = $('img.logo').data('width');

    var newWidth  = Math.min(pageWidth * 0.8, logoWidth);
    var newHeight = newWidth * (859 / 3108);

    $('.logo').width(newWidth);
    $('.logo').height(newHeight);
  } else {
    var newWidth  = $('#page-box').width() * (3108 / 2600);
    var newHeight = newWidth * (859 / 3108);
    $('.logo').width(newWidth);
    $('.logo').height(newHeight);

    var pos   = $('.logo').offset();
    var pageX = $('#page-box').offset().left;

    var offsetToBox = newWidth * (175 / 3108);

    pos.left = pageX - offsetToBox;

    $('.logo').offset(pos);
  }
}

function setTextareaHeight(){
  this.style.height = this.scrollHeight+'px'; 
}

var markdownEditors = {};
function previewMarkdown() {
  if (markdownEditors[this.id] === undefined) {
    var newEditor = {
      input:   this,
      preview: $(this).closest('.markdown-container').find('.markdown-preview')[0],
      timeout: null
    };
    markdownEditors[this.id] = newEditor;
  }

  var editor = markdownEditors[this.id];

  editor.timeout = setTimeout(function() {
    editor.preview.innerHTML = markdown.toHTML(editor.input.value);
  }, 10);
}

function inspirationChevronUp() {
  var chev = $("#inspiration-hide");

  chev.removeClass('fa-chevron-down');
  chev.addClass('fa-chevron-up');
}

function inspirationChevronDown() {
  var chev = $("#inspiration-hide");

  chev.removeClass('fa-chevron-up');
  chev.addClass('fa-chevron-down');
}

$(function() {
  $(window).resize(setLogoWidth);
  setLogoWidth();

  $('#homepage-link').click(function() {
    window.location = $('#homepage-link > a').href();
    return false;
  });

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
});
