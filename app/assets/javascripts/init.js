if (window.TravelApp === undefined){
  window.TravelApp = {};
}

TravelApp.init = function() {

  var current_user = JSON.parse(window.localStorage.getItem("current_user")) || null;

  if (current_user) {
    $('#user-header').html(HandlebarsTemplates['users/header-logout'])
  } else {
    $('#user-header').html(HandlebarsTemplates['users/header-login'])
  }
  
  $('#content').html(HandlebarsTemplates['site/home']);
};

$(document).on("ready",function(){
  TravelApp.init();

});