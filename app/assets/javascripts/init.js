if (window.TravelApp === undefined){
  window.TravelApp = {};
}

TravelApp.init = function() {
  $('#user-header').html(HandlebarsTemplates['users/header-login'])
  $('#content').html(HandlebarsTemplates['site/home'])
};

$(document).on("ready",function(){
  TravelApp.init();

});