(function() {

if (window.TravelApp === undefined){
  window.TravelApp = {};
}

'use strict';
var ajax;

TravelApp.Travel = function () {
}; 

//SHOW

TravelApp.Travel.printTravelInfo = function(travel) {
  TravelApp.Helpers.setCurrentTravel(travel);

  travel.initial_date = travel.initial_date.slice(0,10);
  travel.final_date = travel.final_date.slice(0,10);

  $('#content').empty();
  $('#content').html(HandlebarsTemplates['travels/show'](travel));
  
  async.parallel([
    function(callback) {
      TravelApp.Traveler.travelIndex(travel, callback);
    },
    function(callback) {
      TravelApp.Comment.getComments(travel, callback);
    }],
    function(err) {
      if(err) {
        console.log(err)
      }
      var current_user = TravelApp.Helpers.getCurrentUser();
      TravelApp.Travel.setPrivacy();
    }
  )
}

TravelApp.Travel.setPrivacy = function() {
  var current_user = TravelApp.Helpers.getCurrentUser();
  var current_travel = TravelApp.Helpers.getCurrentTravel();

  if(current_user == null) { //not logged
    $('.comments-public').prepend('<h5>Log in to comment!</h5><br>')
    $('.comments-private').remove()
    $('#btn-form-public-comment').remove();
    $('#btn-delete').remove();
    $('#link-form-update').remove();
  } else if(current_user.id != current_travel.id && $('.' + current_user.id).length === 0) {//logged && not the travel user && not in the travel
    $('.comments-private').remove();
    $('#btn-delete').remove();
    $('#link-form-update').remove();
  } else if(current_user.id != current_travel.user_id) { //logged && not the travel user
    $('#btn-delete').remove();
    $('#link-form-update').remove();
  }

}

//CREATE

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
  return {travel: {title: title, initial_date: initial_date, final_date:final_date, description: description, budget: budget, maximum_people: maximum_people, countries: countries, places: places, tags: tags, requirements: requirements}}
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

//DELETE

TravelApp.Travel.showIndex = function(response) {
  $('#content').empty();
  var current_user = TravelApp.Helpers.getCurrentUser();
  TravelApp.User.showProfile(current_user);
  $('.user-travels').prepend('<h4 class="errors">Travel deleted</h4>');
}

//UPDATE

TravelApp.Travel.getUpdateForm = function() {
  var current_user = TravelApp.Helpers.getCurrentUser();
  var current_travel = TravelApp.Helpers.getCurrentTravel();
  ajax = new TravelApp.Ajax();
  ajax.get('/users/' + current_user.id + '/travels/' + current_travel.id, TravelApp.Travel.showUpdateForm);
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

//INDEX USER

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

//JOIN

TravelApp.Travel.travelerJoin = function(response) {
  var current_travel = TravelApp.Helpers.getCurrentTravel();
  var travel = new TravelApp.Travel(current_travel.id);
  TravelApp.Travel.printTravelInfo(current_travel);
}

TravelApp.Travel.joinError = function(response) {
  $('.errors').remove();
  $('.travel-travelers').prepend('<div class="errors">You can´t join the travel</div>');
}

//LEFT

TravelApp.Travel.travelerLeft = function(response) {
  var current_travel = TravelApp.Helpers.getCurrentTravel();
  var travel = new TravelApp.Travel(current_travel.id);
  TravelApp.Travel.printTravelInfo(current_travel);
}

TravelApp.Travel.leftError = function(response) {
  $('.errors').remove();
  $('.travel-travelers').prepend('<div class="errors">You can´t left the travel</div>');
}

})()

$(document).on('ready', function() {

//SHOW

  $(document).on('click','.link-travel', function(event) {
    event.preventDefault();
    ajax = new TravelApp.Ajax();

    var $link = $(event.currentTarget);
    var user_id = $link.data('user');
    var travel_id = $link.data('travel');

    ajax.get('/users/' + user_id + '/travels/' + travel_id, TravelApp.Travel.printTravelInfo);
  })


//CREATE

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

    ajax.post('/users/' + current_user.id + '/travels', data, TravelApp.Travel.printTravelInfo, TravelApp.Travel.printNewError);
  })

//DELETE

  $(document).on('click', '#btn-delete', function(event) {
    event.preventDefault();
    var $button = $(event.currentTarget);
    var id = $button.data('id');

    ajax = new TravelApp.Ajax();
    var current_user = TravelApp.Helpers.getCurrentUser();

    ajax.delet('/users/' + current_user.id + '/travels/' + id, TravelApp.Travel.showIndex);
  })

//UPDATE

  $(document).on('click', '#link-form-update', function(event) {
    event.preventDefault();
    TravelApp.Travel.getUpdateForm();
  })

  $(document).on('click', '#btn-update', function(event) {
    event.preventDefault();
    var $button = $(event.currentTarget);
    var id = $button.data('id');

    ajax = new TravelApp.Ajax();
    var data = TravelApp.Travel.getNewFormData();
    var current_user = TravelApp.Helpers.getCurrentUser();

    ajax.patch('/users/' + current_user.id + '/travels/' + id, data, TravelApp.Travel.printTravelInfo);
  })

  //JOIN

  $(document).on('click', '#btn-travel-join', function(event) {
    event.preventDefault();

    var id = $('.select.travelers').val();
    var current_travel = TravelApp.Helpers.getCurrentTravel();
    var data = {"id": id};

    ajax = new TravelApp.Ajax();
    ajax.post('/travels/' + current_travel.id + '/join', data, TravelApp.Travel.travelerJoin, TravelApp.Travel.joinError);
  })

  //LEFT

  $(document).on('click', '#btn-travel-left', function(event) {
    event.preventDefault();
    
    var $button = $(event.currentTarget);
    var id = $button.data('id');
    var current_travel = TravelApp.Helpers.getCurrentTravel();

    var data = {"id": id};

    ajax = new TravelApp.Ajax();
    ajax.post('/travels/' + current_travel.id + '/left', data, TravelApp.Travel.travelerLeft, TravelApp.Travel.leftError); 
  })

})
