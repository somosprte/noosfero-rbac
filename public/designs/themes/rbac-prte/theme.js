$(document).ready(function() {
  $('.action-account-signup #signup-form-profile .oauth-login')
    .detach()
    .prependTo('#signup-form');
    if (!$('.profile-country').val())
      $('.profile-country').val('BR');
});

$(document).ready(function() {
  $('.action-account-signup #signup-form-profile .oauth-login')
    .detach()
    .prependTo('#signup-form');
  $('.select-nationality').val('Brazilian');
});