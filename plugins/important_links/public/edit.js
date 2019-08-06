(function($) {
  $('form').on('click', '#new-link', function() {
    var template = $('.edit-important-link.template');
    var nextLinkID = ($('.edit-important-link').length - 1).toString();
    var newLink = template.clone();
    newLink.html(newLink.html().replace(/LINK/g, nextLinkID));
    newLink.removeClass('template');
    newLink.insertBefore('#new-link');
    return false;
  });

  $('form').on('click', '#remove-link', function() {
    var field = $(this).closest('.edit-important-link');
    var hidden = field.find('input[type=hidden]');
    hidden.val(true);
    field.hide();
    return false;
  });
})(jQuery);
