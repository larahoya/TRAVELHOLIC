(function() {

if (window.TravelApp === undefined){
  window.TravelApp = {};
}

'use strict';
var ajax;
  
TravelApp.Traveler = function(){
};

TravelApp.Traveler.showUpdateForm = function(traveler) {
  traveler.date_of_birth = traveler.date_of_birth.slice(0,10);
  $('#content').empty();
  $('#content').html(HandlebarsTemplates['travelers/update'](traveler));
  var string = '.avatar[value="' + traveler.avatar + '"]';
  $(string).attr('checked', 'checked');
}

TravelApp.Traveler.getTravelerFormInfo = function() {
  var first_name = $('.input.first-name').val();
  var last_name = $('.input.last-name').val();
  var country = $('.input.country').val();
  var date_of_birth = $('.input.date-of-birth').val();
  var gender = $('.select.gender').val();
  var avatar = $('input:checked.avatar').val();
  return {first_name: first_name, last_name: last_name, country: country, date_of_birth: date_of_birth, gender: gender, avatar: avatar}
}

TravelApp.Traveler.correctInfo = function(traveler) {
  var current_user = TravelApp.Helpers.getCurrentUser();
  TravelApp.User.showProfile(current_user);
}

TravelApp.Traveler.incorrectInfo = function(response) {
  $('.errors').remove();
  var errorHtml = '<div class="errors">'
  response.responseJSON.forEach(function(error) {
    errorHtml += '<dd>' + error + '</dd>'
  })
  errorHtml += '</div>'
  $('.form-traveler').before(errorHtml);
}

TravelApp.Traveler.index = function(user) {
  ajax = new TravelApp.Ajax();
  ajax.get('/users/' + user.id + '/travelers', TravelApp.Traveler.showIndex);
}

TravelApp.Traveler.showIndex = function(travelers) {
  var travelers = travelers.travelers;
  travelers.forEach(function(traveler) {
    $('.user-travelers').append(HandlebarsTemplates['travelers/miniature'](traveler));
  })
}


})()

$(document).on('ready', function() {

  $(document).on('click', '#btn-traveler-create', function(event) {
    event.preventDefault();

    var current_user = TravelApp.Helpers.getCurrentUser();
    var data = TravelApp.Traveler.getTravelerFormInfo();

    ajax = new TravelApp.Ajax();
    ajax.post('/users/' + current_user.id + '/travelers', data, TravelApp.Traveler.correctInfo, TravelApp.Traveler.incorrectInfo)

  })

  $(document).on('click', '#btn-traveler-update', function(event) {
    event.preventDefault();
    var $button = $(event.currentTarget);
    var id = $button.data('id');
    var current_user = TravelApp.Helpers.getCurrentUser();
    var data = TravelApp.Traveler.getTravelerFormInfo();

    ajax = new TravelApp.Ajax();
    ajax.patch('/users/' + current_user.id + '/travelers/' + id, data, TravelApp.Traveler.correctInfo, TravelApp.Traveler.incorrectInfo)


  })

  $(document).on('click', '#btn-traveler-delete', function(event) {
    event.preventDefault();
    var $button = $(event.currentTarget);
    var id = $button.data('id');
    var current_user = TravelApp.Helpers.getCurrentUser();

    ajax = new TravelApp.Ajax();

    ajax.delet('/users/' + current_user.id + '/travelers/' + id, TravelApp.Traveler.correctInfo)

  })

  $(document).on('click', '#link-new-form-traveler', function(event) {
    event.preventDefault();
    $('#content').empty();
    $('#content').html(HandlebarsTemplates['travelers/new']);
  })

  $(document).on('click', '#link-update-form-traveler', function(event) {
    event.preventDefault();
    var $link = $(event.currentTarget);
    var id = $link.data('id');

    ajax = new TravelApp.Ajax();
    var current_user = TravelApp.Helpers.getCurrentUser();

    ajax.get('/users/' + current_user.id + '/travelers/' + id, TravelApp.Traveler.showUpdateForm);
  })

})