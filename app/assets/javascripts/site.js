(function() {

if (window.TravelApp === undefined){
  window.TravelApp = {};
}

'use strict';
var ajax;

TravelApp.renderHome = function() {

  var current_user = TravelApp.Helpers.getCurrentUser();

  if (current_user) {
    $('#user-header').html(HandlebarsTemplates['users/header-logout'](current_user))
  } else {
    $('#user-header').html(HandlebarsTemplates['users/header-login'])
  }
  
  $('#content').html(HandlebarsTemplates['site/home']);
  $('#aside').html(HandlebarsTemplates['site/search-form']);
}


})()

$(document).on('ready', function() {

  TravelApp.renderHome();

  $(document).on('click', '#load-home', function() {
    $('.main').html(HandlebarsTemplates['site/home']);
  })

})