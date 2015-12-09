(function() {

if (window.TravelApp === undefined){
  window.TravelApp = {};
}

TravelApp.Helpers = function () {
};

TravelApp.Helpers.getCurrentUser = function() {
  var current_user = JSON.parse(window.localStorage.getItem("current_user")) || null
  return current_user
} 

})()