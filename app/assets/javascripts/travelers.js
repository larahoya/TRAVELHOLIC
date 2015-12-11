(function() {

if (window.TravelApp === undefined){
  window.TravelApp = {};
}

'use strict';
var ajax;
  
TravelApp.Traveler = function(){
};

//UPDATE 

TravelApp.Traveler.showUpdateForm = function(traveler) {
  traveler.date_of_birth = traveler.date_of_birth.slice(0,10);
  $('#content').empty();
  $('#content').html(HandlebarsTemplates['travelers/update'](traveler));
  var string = '.avatar[value="' + traveler.avatar + '"]';
  $(string).attr('checked', 'checked');
}

//CREATE

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

//USER INDEX

TravelApp.Traveler.userIndex = function(user) {
  ajax = new TravelApp.Ajax();
  ajax.get('/users/' + user.id + '/travelers', TravelApp.Traveler.showUserIndex);
}

TravelApp.Traveler.showUserIndex = function(travelers) {
  var travelers = travelers.travelers;
  travelers.forEach(function(traveler) {
    $('.user-travelers').append(HandlebarsTemplates['travelers/miniature'](traveler));
  })
}

//TRAVEL INDEX

TravelApp.Traveler.travelIndex = function(travel) {
  ajax = new TravelApp.Ajax();
  ajax.get('/travels/' + travel.id + '/travelers', TravelApp.Traveler.showTravelIndex);
}

TravelApp.Traveler.showTravelIndex = function(travelers) {
  TravelApp.Traveler.showSelectForm(travelers);
  var travelers = travelers.travelers;
  travelers.forEach(function(traveler) {
    $('.travel-travelers').append(HandlebarsTemplates['travelers/miniature'](traveler));
  })
}

TravelApp.Traveler.showSelectForm = function(travelers) {
  var travelers = travelers.travelers;
  var select_html = '<div class="travelers-select"><label class="travelers-select">Join the travel!</label><select name="travel-travelers" class="select travelers">'
  travelers.forEach(function(traveler) {
    select_html += '<option value="' + traveler.id + '">' + traveler.first_name + '</option>';
    console.log(select_html);
  })
  $('.travel-travelers').append(select_html + '</select></div>');
}

})()

$(document).on('ready', function() {

  //CREATE

  $(document).on('click', '#link-new-form-traveler', function(event) {
    event.preventDefault();
    $('#content').empty();
    $('#content').html(HandlebarsTemplates['travelers/new']);
  })

  $(document).on('click', '#btn-traveler-create', function(event) {
    event.preventDefault();

    var current_user = TravelApp.Helpers.getCurrentUser();
    var data = TravelApp.Traveler.getTravelerFormInfo();

    ajax = new TravelApp.Ajax();
    ajax.post('/users/' + current_user.id + '/travelers', data, TravelApp.Traveler.correctInfo, TravelApp.Traveler.incorrectInfo)

  })

  //UPDATE

  $(document).on('click', '#link-update-form-traveler', function(event) {
    event.preventDefault();
    var $link = $(event.currentTarget);
    var id = $link.data('id');

    ajax = new TravelApp.Ajax();
    var current_user = TravelApp.Helpers.getCurrentUser();

    ajax.get('/users/' + current_user.id + '/travelers/' + id, TravelApp.Traveler.showUpdateForm);
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

  //DELETE

  $(document).on('click', '#btn-traveler-delete', function(event) {
    event.preventDefault();
    var $button = $(event.currentTarget);
    var id = $button.data('id');
    var current_user = TravelApp.Helpers.getCurrentUser();

    ajax = new TravelApp.Ajax();

    ajax.delet('/users/' + current_user.id + '/travelers/' + id, TravelApp.Traveler.correctInfo)

  })

})