(function() {

'use strict';
var ajax;

TravelApp.Travel = function (id) {
  this.id = id;
  ajax = new TravelApp.Ajax();
}; 

TravelApp.Travel.prototype.show = function() {
  ajax.get('/travels/' + this.id, this.printInfo);
}

TravelApp.Travel.prototype.printInfo = function(travel) {
  $('#content').html(HandlebarsTemplates['travels/show'](travel));
}

})()

$(document).on('ready', function() {

  $('.link-travel').on('click', function(event) {
    event.preventDefault();
    var $link = $(event.currentTarget);
    var id = $link.data('id');
    $('#content').empty();

    var travel = new TravelApp.Travel(id);
    travel.show();
  })

  $('.link-travel-new').on('click', function(event) {
    event.preventDefault();
    $('#content').empty();
    $('#content').html(HandlebarsTemplates['travels/new']);
  })
})