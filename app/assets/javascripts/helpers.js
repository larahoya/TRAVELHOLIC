(function() {

if (window.TravelApp === undefined){
  window.TravelApp = {};
}

TravelApp.Helpers = TravelApp.Helpers || {};

//current_user

TravelApp.Helpers.setCurrentUser = function(user) {
  var current_user = JSON.stringify(user);
  window.localStorage.setItem("current_user", current_user);
} 

TravelApp.Helpers.getCurrentUser = function() {
  current_user = JSON.parse(window.localStorage.getItem("current_user")) || null
  return current_user
} 

//current_travel

TravelApp.Helpers.setCurrentTravel = function(travel) {
  var current_travel = JSON.stringify(travel);
  window.localStorage.setItem("current_travel", current_travel);
}

TravelApp.Helpers.getCurrentTravel = function() {
  current_travel = JSON.parse(window.localStorage.getItem("current_travel")) || null
  return current_travel
}

TravelApp.Helpers.getId = function(event) {
  $selection = $(event.currentTarget);
  return $selection.data('id');
}

})()