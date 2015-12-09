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

})