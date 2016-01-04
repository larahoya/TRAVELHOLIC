(function() {

if (window.TravelApp === undefined){
  window.TravelApp = {};
}

'use strict';
  
TravelApp.Search = TravelApp.Search || {};

TravelApp.Search.getSearchForm= function() {
  var initial_date = $('.input.initial-date').val();
  var final_date = $('.input.final-date').val();
  var budget = $('.select.budget').val();
  var country = $('.input.country').val();
  var place = $('.input.place').val();
  var tags = [];
  $('input:checked.tags').each(function(tag) {
    tags.push($(this).val());
  })
  return {initial_date: initial_date, final_date:final_date, budget: budget, country: country, place: place, tags: tags}
}

TravelApp.Search.showResult = function(travels) {
  var travels = travels.travels;
  $('#content').empty();
  travels.forEach(function(travel) {
    $('#content').append(HandlebarsTemplates['travels/miniature'](travel));
  })
}

TravelApp.Search.showNoResult = function(response) {
  $('#content').empty();
  $('#content').append('<div class="errors">No results!</div>');
}

})()

$(document).on('ready', function() {

  $(document).on('click', '#btn-search', function(event) {
    event.preventDefault();
    var data = TravelApp.Search.getSearchForm();

    TravelApp.Ajax.post('/travels/search', data, TravelApp.Search.showResult, TravelApp.Search.showNoResult)
  })

})