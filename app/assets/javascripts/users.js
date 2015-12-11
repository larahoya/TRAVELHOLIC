(function() {

if (window.TravelApp === undefined){
  window.TravelApp = {};
}

'use strict';
var ajax;
  
TravelApp.User = function(){
};


//CREATE

TravelApp.User.getNewFormData = function() {
  var first_name = $('#user_first_name').val();
  var last_name = $('#user_last_name').val();
  var address = $('#user_address').val();
  var city = $('#user_city').val();
  var country = $('#user_country').val();
  var date_of_birth = $('#user_date_of_birth').val();
  var telephone = $('#user_telephone').val();
  var email = $('#user_email').val();
  var password = $('#user_password').val();
  var password_confirmation = $('#user_password_confirmation').val();
  var auth = $('#authenticity_token').val();
  return {"utf8": "✓", "authenticity_token": auth, "user": {"first_name": first_name, "last_name":last_name, "address": address, "city": city, "country": country, "date_of_birth": date_of_birth, "telephone": telephone, "email": email, "password": password, "password_confirmation": password_confirmation},  "commit": "Sign up"};
}

TravelApp.User.showNewProfile = function(user) {

  var current_user = JSON.stringify(user);
  window.localStorage.setItem("current_user", current_user);

  $('#user-header').html(HandlebarsTemplates['users/header-logout'](user))
  $('#content').empty();
  $('#aside').html(HandlebarsTemplates['users/user-info'](user));
  $('#content').html(HandlebarsTemplates['users/user-profile']);
  TravelApp.Travel.index(user);
  TravelApp.Traveler.userIndex(user);
}

TravelApp.User.printNewError = function(response) {
  $('.errors').remove();
  var errors = response.responseJSON.errors;
  var errorHtml = '<div class="errors">';
  Object.keys(errors).forEach(function(key) {
    errorHtml += '<dd>' + key + ':' + errors[key] + '</dd>';
  })
  $('.form-signup').before(errorHtml + '</div>');
}

//LOG IN

TravelApp.User.getLoginData = function() {
  var email = $('#user_email').val();
  var password = $('#user_password').val();
  var auth = $('#authenticity_token').val();
  return {"utf8": "✓", "authenticity_token": auth, "user": {"email": email, "password": password, "remember_me": "0"}, "commit": "Log in"}
}

TravelApp.User.printLoginError = function(response) {
  var error = response.responseText;
  $('#user-reg').append('<span class="errors">' + error + '</span>');
}

//LOG OUT

TravelApp.User.showHome = function(response) {
  console.log('Log out');
}

//SHOW

TravelApp.User.showProfile = function(user) {
  $('#user-header').html(HandlebarsTemplates['users/header-logout'](user))
  $('#content').empty();
  $('#aside').html(HandlebarsTemplates['users/user-info'](user));
  $('#content').html(HandlebarsTemplates['users/user-profile']);
  TravelApp.Travel.index(user);
  TravelApp.Traveler.userIndex(user);
}

//UPDATE

TravelApp.User.getUpdateFormData = function() {
  var first_name = $('#user_first_name').val();
  var last_name = $('#user_last_name').val();
  var address = $('#user_address').val();
  var city = $('#user_city').val();
  var country = $('#user_country').val();
  var date_of_birth = $('#user_date_of_birth').val();
  var telephone = $('#user_telephone').val();
  var email = $('#user_email').val();
  var password = $('#user_password').val();
  var password_confirmation = $('#user_password_confirmation').val();
  var auth = $('#authenticity_token').val();
  var current_password = $('#user_current_password').val()
  return {"utf8": "✓", "authenticity_token": auth, "user": {"first_name": first_name, "last_name":last_name, "address": address, "city": city, "country": country, "date_of_birth": date_of_birth, "telephone": telephone, "email": email, "password": password, "password_confirmation": password_confirmation, "current_password": current_password},  "commit": "Update"};
}

TravelApp.User.showUpdatedProfile = function(response) {
  ajax = new TravelApp.Ajax();
  var current_user = TravelApp.Helpers.getCurrentUser();
  ajax.get('/users/' + current_user.id, TravelApp.User.showNewProfile)
}

})()

$(document).on('ready', function() {

//SIGN UP

  $(document).on('click', '#link-form-signup', function(event) {
    event.preventDefault();
    $('#content').empty();
    var template = HandlebarsTemplates['users/signup'];
    $('#content').html(template);
  })

  $(document).on('click', '#btn-register', function(event) {
    event.preventDefault();
    ajax = new TravelApp.Ajax();
    var data = TravelApp.User.getNewFormData();
    ajax.post('/', data, TravelApp.User.showFirstProfile, TravelApp.User.printNewError);
  })

//LOG IN

  $(document).on('click', '#btn-login', function(event) {
    event.preventDefault();
    ajax = new TravelApp.Ajax();
    var data = TravelApp.User.getLoginData();
    ajax.post('/login', data, TravelApp.User.showNewProfile, TravelApp.User.printLoginError);
  })

//LOG OUT

  $(document).on('click', '#link-logout', function(event) {
    event.preventDefault();
    ajax = new TravelApp.Ajax();
    ajax.delet('/sign_out', TravelApp.User.showHome);
    window.localStorage.clear();
    $('#aside').empty();
    $('#user-header').html(HandlebarsTemplates['users/header-login'])
    $('#content').html(HandlebarsTemplates['site/home'])
  })

//UPDATE

  $(document).on('click', '#link-form-user-update', function(event) {
    event.preventDefault();
    var current_user = TravelApp.Helpers.getCurrentUser();
    current_user.date_of_birth = current_user.date_of_birth.slice(0,10);
    $('#content').html(HandlebarsTemplates['users/user-update'](current_user));
  })

  $(document).on('click', '#btn-user-update', function(event) {
    event.preventDefault();
    var data = TravelApp.User.getUpdateFormData();
    
    ajax.patch('/', data, TravelApp.User.showUpdatedProfile);
  })

//SHOW PROFILE

  $(document).on('click', '#btn-profile', function(event) {
    event.preventDefault();
    var current_user = TravelApp.Helpers.getCurrentUser();
    TravelApp.User.showProfile(current_user);

  })


})