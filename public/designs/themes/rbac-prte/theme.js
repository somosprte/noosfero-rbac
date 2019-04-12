$(document).ready(function() {
  $('.action-account-signup #signup-form-profile .oauth-login')
    .detach()
    .prependTo('#signup-form');
  $('.profile-country').val('BR');
});