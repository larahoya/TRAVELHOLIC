(function() {

if (window.TravelApp === undefined){
  window.TravelApp = {};
}

'use strict';
var ajax;
  
TravelApp.Search = function(){
};

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




})()

$(document).on('ready', function() {

  $(document).on('click', '#btn-search', function() {
    var data = TravelApp.Search.getSearchForm();
    ajax = new TravelApp.Ajax();
  })

})