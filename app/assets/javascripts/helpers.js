(function() {

if (window.TravelApp === undefined){
  window.TravelApp = {};
}

TravelApp.Helpers = function () {
};

var current_user;
var current_travel;

//current_user

TravelApp.Helpers.setCurrentUser = function(user) {
  current_user = JSON.stringify(user);
  window.localStorage.setItem("current_user", current_user);
} 

TravelApp.Helpers.getCurrentUser = function() {
  current_user = JSON.parse(window.localStorage.getItem("current_user")) || null
  return current_user
} 

//current_travel

TravelApp.Helpers.setCurrentTravel = function(travel) {
  current_travel = JSON.stringify(travel);
  window.localStorage.setItem("current_travel", current_travel);
}

TravelApp.Helpers.getCurrentTravel = function() {
  current_travel = JSON.parse(window.localStorage.getItem("current_travel")) || null
  return current_travel
}

})()