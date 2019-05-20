(function($) {
  $('.general-materials').on('change', '.general-material-fields:last-child select', function() {
    var fields = $(this).parent();
    if ($(this).val() && $(this).find('option').length > 2) {
      var newField = fields.clone();
      var option = newField.find('select option[value="' + $(this).val() + '"]');
      option.remove();
      newField.insertAfter(fields);
    }
  });
  
  $('.general-materials').on('click', 'a', function() {
    $(this).parent().remove();
    return false;
  });
})(jQuery);
