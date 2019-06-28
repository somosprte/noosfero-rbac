(function($) {
  $('#map_form').on('change', "input[type='checkbox']", function() {
    $('#map_form').submit();
  });
})(jQuery);