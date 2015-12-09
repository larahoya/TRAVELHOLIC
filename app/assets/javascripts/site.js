(function() {

if (window.TravelApp === undefined){
  window.TravelApp = {};
}

'use strict';
var ajax;

TravelApp.render = function() {

  var current_user = TravelApp.Helpers.getCurrentUser();

  if (current_user) {
    $('#user-header').html(HandlebarsTemplates['users/header-logout'](current_user))
  } else {
    $('#user-header').html(HandlebarsTemplates['users/header-login'])
  }
  
  $('#content').html(HandlebarsTemplates['site/home']);
}

})()

$(document).on('ready', function() {

  TravelApp.render();

  $(document).on('click', '#load-home', function() {
    $('.main').html(HandlebarsTemplates['site/home']);
  })

})