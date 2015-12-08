(function() {

'use strict';
var ajax;

TravelApp.Travel = function (id) {
  this.id = id;
  ajax = new TravelApp.Ajax();
}; 

TravelApp.Travel.prototype.show = function() {
  ajax.get('/travels/' + this.id, TravelApp.Travel.printInfo);
}

TravelApp.Travel.printInfo = function(travel) {
  $('#content').empty();
  $('#content').html(HandlebarsTemplates['travels/show'](travel));
}

TravelApp.Travel.getNewFormData = function() {
  var title = $('.input.name').val();
  var initial_date = $('.input.initial-date').val();
  var final_date = $('.input.final-date').val();
  var description = $('.input.description').val();
  var budget = $('.input.budget').val();
  var maximum_people = $('.input.maximum').val();
  var countries = $('.input.countries').val();
  var places = $('.input.places').val();
  var tags = [];
  $('input:checked.tags').each(function(tag) {
    tags.push($(this).val());
  })
  var requirements = [];
  $('input:checked.requirements').each(function(tag) {
    requirements.push(tag.val());
  })
  return {title: title, initial_date: initial_date, final_date:final_date, description: description, budget: budget, maximum_people: maximum_people, countries: countries, places: places, tags: tags, requirements: requirements}
}

TravelApp.Travel.printNewError = function(response) {
  var errorHtml = '<div class="errors">'
  response.responseJSON.forEach(function(error) {
    errorHtml += '<dd>' + error + '</dd>'
  })
  errorHtml += '</div>'
  $('.form-travel-new').before(errorHtml);
}

TravelApp.Travel.showIndex = function(response) {
  $('#content').empty();
  $('#content').append('<h4 class="errors">Travel deleted</h4>');
}

})()

$(document).on('ready', function() {

  $(document).on('click','.link-travel', function(event) {
    event.preventDefault();
    var $link = $(event.currentTarget);
    var id = $link.data('id');

    var travel = new TravelApp.Travel(id);
    travel.show();
  })

  $(document).on('click','#link-travel-new', function(event) {
    event.preventDefault();
    $('#content').empty();
    $('#content').html(HandlebarsTemplates['travels/new']);
  })

  $(document).on('click', '#btn-create',function(event) {
    event.preventDefault();
    ajax = new TravelApp.Ajax();
    var data = TravelApp.Travel.getNewFormData();
    ajax.post('/travels', data, TravelApp.Travel.printInfo, TravelApp.Travel.printNewError);
  })

  $(document).on('click', '#btn-delete', function(event) {
    event.preventDefault();
    var $link = $(event.currentTarget);
    var id = $link.data('id');

    ajax = new TravelApp.Ajax();
    var data = TravelApp.Travel.getNewFormData();
    ajax.delet('/travels/'+ id, TravelApp.Travel.showIndex);
  })

})
