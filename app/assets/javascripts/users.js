(function() {

if (window.TravelApp === undefined){
  window.TravelApp = {};
}

'use strict';
var ajax;
  
TravelApp.User = TravelApp.User || {};


//CREATE

TravelApp.User.getNewFormData = function() {
  var first_name = $('#user_first_name').val();
  var last_name = $('#user_last_name').val();
  var address = $('#user_address').val();
  var city = $('#user_city').val();
  var country = $('#user_country').val();
  var date_of_birth = $('#user_date_of_birth').val();
  var gender = $('.select.gender').val();
  var avatar = $('input:checked.avatar').val();
  var telephone = $('#user_telephone').val();
  var email = $('#user_email').val();
  var password = $('#user_password').val();
  var password_confirmation = $('#user_password_confirmation').val();
  var auth = $('#authenticity_token').val();
  return {"utf8": "✓", "authenticity_token": auth, "user": {"first_name": first_name, "last_name":last_name, "address": address, "city": city, "country": country, "date_of_birth": date_of_birth, "telephone": telephone, "email": email, "password": password, "password_confirmation": password_confirmation, "gender": gender, "avatar": avatar},  "commit": "Sign up"};
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

//SHOW

TravelApp.User.showProfile = function(user) {
  TravelApp.Ajax.get('/users/' + user.id, function(user) {

    TravelApp.Helpers.setCurrentUser(user);
    user.date_of_birth = user.date_of_birth.slice(0,10);

    $('#user-header').html(HandlebarsTemplates['users/header-logout'](user))
    $('#content').empty();
    $('#aside').html(HandlebarsTemplates['users/user-info'](user));
    $('#content').html(HandlebarsTemplates['users/user-profile']);
    TravelApp.Travel.index(user);
    TravelApp.Traveler.userIndex(user);

    user.travels.forEach(function(travel) {
      TravelApp.Ajax.get('/travels/' + travel, function(travel) {
        var current_user = TravelApp.Helpers.getCurrentUser();
        if(travel.user_id != current_user.id) {
          $('.my-travels').append('<a href="/" class="link-travel" data-travel="' + travel.id + '" data-user="' + travel.user_id + '">' + travel.title + '</a><br>');
        }
      })
    })
    if (user.travels.length > 0) {
      $('.my-travels').prepend('<h6>My travels</h6>');
    }
  })
  
}

//LOG IN

TravelApp.User.getLoginData = function() {
  var email = $('#login_user_email').val();
  var password = $('#login_user_password').val();
  var auth = $('#login_authenticity_token').val();
  return {"utf8": "✓", "authenticity_token": auth, "user": {"email": email, "password": password, "remember_me": "0"}, "commit": "Log in"}
}

TravelApp.User.printLoginError = function(response) {
  var error = response.responseText;
  $('#user-reg').append('<span class="errors">' + error + '</span>');
}

//UPDATE

TravelApp.User.getUpdateFormData = function() {
  var first_name = $('#user_first_name').val();
  var last_name = $('#user_last_name').val();
  var address = $('#user_address').val();
  var city = $('#user_city').val();
  var country = $('#user_country').val();
  var date_of_birth = $('#user_date_of_birth').val();
  var gender = $('.select.gender').val();
  var avatar = $('input:checked.avatar').val();
  var telephone = $('#user_telephone').val();
  var email = $('#user_email').val();
  var password = $('#user_password').val();
  var password_confirmation = $('#user_password_confirmation').val();
  var auth = $('#authenticity_token').val();
  var current_password = $('#user_current_password').val()
  return {"utf8": "✓", "authenticity_token": auth, "user": {"first_name": first_name, "last_name":last_name, "address": address, "city": city, "country": country, "date_of_birth": date_of_birth, "telephone": telephone, "email": email, "password": password, "password_confirmation": password_confirmation, "current_password": current_password, "gender": gender, "avatar": avatar},  "commit": "Update"};
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
    var data = TravelApp.User.getNewFormData();
    TravelApp.Ajax.post('/', data, TravelApp.User.showProfile, TravelApp.User.printNewError);
  })

//LOG IN

  $(document).on('click', '#btn-login', function(event) {
    event.preventDefault();
    var data = TravelApp.User.getLoginData();
    TravelApp.Ajax.post('/login', data, TravelApp.User.showProfile, TravelApp.User.printLoginError);
  })

//LOG OUT

  $(document).on('click', '#link-logout', function(event) {
    event.preventDefault();
    TravelApp.Ajax.delet('/sign_out', TravelApp.User.showHome);
    window.localStorage.clear();
    TravelApp.renderHome();
  })

//UPDATE

  $(document).on('click', '#link-form-user-update', function(event) {
    event.preventDefault();
    var current_user = TravelApp.Helpers.getCurrentUser();
    current_user.date_of_birth = current_user.date_of_birth.slice(0,10);
    $('#content').html(HandlebarsTemplates['users/user-update'](current_user));
    var string = '.avatar[value="' + current_user.avatar + '"]';
    $(string).attr('checked', 'checked');
  })

  $(document).on('click', '#btn-user-update', function(event) {
    event.preventDefault();
    var data = TravelApp.User.getUpdateFormData();
    
    TravelApp.Ajax.patch('/', data, TravelApp.User.showProfile);
  })

//SHOW PROFILE

  $(document).on('click', '#btn-profile', function(event) {
    event.preventDefault();
    var current_user = TravelApp.Helpers.getCurrentUser();
    TravelApp.User.showProfile(current_user);

  })


})