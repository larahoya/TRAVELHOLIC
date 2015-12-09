(function() {

if (window.TravelApp === undefined){
  window.TravelApp = {};
}

'use strict';
var ajax;
  
TravelApp.User = function(){
};

TravelApp.User.showHome = function(response) {
  console.log(response);
}

TravelApp.User.getNewFormData = function() {
  var email = $('#user_email').val();
  var password = $('#user_password').val();
  var password_confirmation = $('#user_password_confirmation').val();
  var auth = $('#authenticity_token').val();
  return {"utf8": "✓", "authenticity_token": auth, "user": {"email": email, "password": password, "password_confirmation": password_confirmation},  "commit": "Sign up"};
}

TravelApp.User.showProfile = function(user) {
  $('#content').empty();
  $('#content').html(HandlebarsTemplates['users/profile'](user));
}

TravelApp.User.printNewError = function(response) {
  var errors = response.responseJSON.errors;
  var errorHtml = '<div class="errors">';
  Object.keys(errors).forEach(function(key) {
    errorHtml += '<dd>' + key + ':' + errors[key] + '</dd>';
  })
  $('.form-signup').before(errorHtml + '</div>');
}

})()

$(document).on('ready', function() {

  $(document).on('click', '#link-form-signup', function(event) {
    event.preventDefault();
    $('#content').empty();
    $('#content').html(HandlebarsTemplates['users/signup']);
  })

  $(document).on('click', '#link-logout', function(event) {
    event.preventDefault();
    ajax = new TravelApp.Ajax();
    ajax.delet('/sign_out', TravelApp.User.showHome);
  })

  $(document).on('click', '#btn-register', function(event) {
    event.preventDefault();
    ajax = new TravelApp.Ajax();
    var data = TravelApp.User.getNewFormData();
    ajax.post('/', data, TravelApp.User.showProfile, TravelApp.User.printNewError);
  })

})