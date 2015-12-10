(function() {

if (window.TravelApp === undefined){
  window.TravelApp = {};
}

'use strict';
var ajax;

TravelApp.Travel = function (id) {
  this.id = id;
  ajax = new TravelApp.Ajax();
}; 

TravelApp.Travel.prototype.show = function() {
  var current_user = TravelApp.Helpers.getCurrentUser();
  ajax.get('/users/' + current_user.id + '/travels/' + this.id, TravelApp.Travel.printInfo);
}

TravelApp.Travel.printInfo = function(travel) {
  var current_travel = JSON.stringify(travel);
  window.localStorage.setItem("current_travel", current_travel);

  travel.initial_date = travel.initial_date.slice(0,10);
  travel.final_date = travel.final_date.slice(0,10);
  $('#content').empty();
  $('#content').html(HandlebarsTemplates['travels/show'](travel));
  TravelApp.Comment.getComments(travel);
  $('.comments-public').after('<div><button id="btn-form-public-comment">Write a comment</button></div>'); 
  $('.comments-private').after('<div><button id="btn-form-private-comment">Write a comment</button></div>')
}

TravelApp.Travel.getNewFormData = function() {
  var title = $('.input.name').val();
  var initial_date = $('.input.initial-date').val();
  var final_date = $('.input.final-date').val();
  var description = $('.input.description').val();
  var budget = $('.select.budget').val();
  var maximum_people = $('.input.maximum').val();
  var countries = $('.input.countries').val();
  var places = $('.input.places').val();
  var tags = [];
  $('input:checked.tags').each(function(tag) {
    tags.push($(this).val());
  })
  var requirements = [];
  $('input:checked.requirements').each(function(tag) {
    requirements.push($(this).val());
  })
  return {title: title, initial_date: initial_date, final_date:final_date, description: description, budget: budget, maximum_people: maximum_people, countries: countries, places: places, tags: tags, requirements: requirements}
}

TravelApp.Travel.printNewError = function(response) {
  $('.errors').remove();
  var errorHtml = '<div class="errors">'
  response.responseJSON.forEach(function(error) {
    errorHtml += '<dd>' + error + '</dd>'
  })
  errorHtml += '</div>'
  $('.form-travel').before(errorHtml);
}

TravelApp.Travel.showIndex = function(response) {
  $('#content').empty();
  var current_user = TravelApp.Helpers.getCurrentUser();
  TravelApp.User.showProfile(current_user);
  $('.user-travels').prepend('<h4 class="errors">Travel deleted</h4>');
}

TravelApp.Travel.prototype.getUpdateForm = function() {
  var current_user = TravelApp.Helpers.getCurrentUser();
  ajax.get('/users/' + current_user.id + '/travels/' + this.id, TravelApp.Travel.showUpdateForm);
}

TravelApp.Travel.showUpdateForm = function(travel) {
  travel.initial_date = travel.initial_date.slice(0,10);
  travel.final_date = travel.final_date.slice(0,10);
  $('#content').empty();
  $('#content').html(HandlebarsTemplates['travels/update'](travel));
  travel.taglist.forEach(function(tag) {
    var string = '.tags[value="'+ tag + '"]'
    $(string).attr('checked', 'checked')
  })
  travel.requirementlist.forEach(function(requirement) {
    var string = '.requirements[value="'+ requirement + '"]'
    $(string).attr('checked', 'checked')
  })
}

TravelApp.Travel.index = function(user) {
  ajax = new TravelApp.Ajax();
  ajax.get('/users/' + user.id + '/travels', TravelApp.Travel.showTravels);
}

TravelApp.Travel.showTravels = function(travels) {
  var travels = travels.travels;
  travels.forEach(function(travel) {
    $('.user-travels').append(HandlebarsTemplates['travels/miniature'](travel));
  })
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

  $(document).on('click','#link-form-new', function(event) {
    event.preventDefault();
    $('#content').empty();
    $('#content').html(HandlebarsTemplates['travels/new']);
  })

  $(document).on('click', '#btn-create',function(event) {
    event.preventDefault();
    ajax = new TravelApp.Ajax();

    var data = TravelApp.Travel.getNewFormData();
    var current_user = TravelApp.Helpers.getCurrentUser();

    ajax.post('/users/' + current_user.id + '/travels', data, TravelApp.Travel.printInfo, TravelApp.Travel.printNewError);
  })

  $(document).on('click', '#btn-delete', function(event) {
    event.preventDefault();
    var $button = $(event.currentTarget);
    var id = $button.data('id');

    ajax = new TravelApp.Ajax();
    var current_user = TravelApp.Helpers.getCurrentUser();

    ajax.delet('/users/' + current_user.id + '/travels/' + id, TravelApp.Travel.showIndex);
  })

  $(document).on('click', '#link-form-update', function(event) {
    event.preventDefault();
    var $link = $(event.currentTarget);
    var id = $link.data('id');

    var travel = new TravelApp.Travel(id);
    travel.getUpdateForm();
  })

  $(document).on('click', '#btn-update', function(event) {
    event.preventDefault();
    var $button = $(event.currentTarget);
    var id = $button.data('id');

    ajax = new TravelApp.Ajax();
    var data = TravelApp.Travel.getNewFormData();
    var current_user = TravelApp.Helpers.getCurrentUser();

    ajax.patch('/users/' + current_user.id + '/travels/' + id, data, TravelApp.Travel.printInfo);
  })

})
