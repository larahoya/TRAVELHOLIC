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

  $('#aside').html(HandlebarsTemplates['site/search-form']);

  var data = {initial_date:'', final_date:'', budget:'', country:'', place:''}
  ajax = new TravelApp.Ajax();
  ajax.post('/travels/search', data, function(travels) {
    var n = travels.travels.length;
    travels.travels.slice(n - 4,n).forEach(function(travel) {
      $('#content').append(HandlebarsTemplates['travels/miniature'](travel));
    })
  }, function(err) {
    console.log(err)
  })
}


})()

$(document).on('ready', function() {

  TravelApp.renderHome();

})