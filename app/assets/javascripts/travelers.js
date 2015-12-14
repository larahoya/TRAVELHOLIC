(function() {

if (window.TravelApp === undefined){
  window.TravelApp = {};
}

'use strict';

var ajax;

var user_travelers;
var travel_travelers;
  
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

  //get user_travelers && travel_travelers

TravelApp.Traveler.travelIndex = function(travel) {
  async.parallel([
    function(callback) {
      ajax = new TravelApp.Ajax();
      ajax.get('/travels/' + travel.id + '/travelers', function(data){
          TravelApp.Traveler.setTravelTravelers(data);
          callback(); 
        }); 
    },
    function(callback) {
      var current_user = TravelApp.Helpers.getCurrentUser();
      if (current_user) {
        ajax = new TravelApp.Ajax();
        ajax.get('/users/' + current_user.id + '/travelers', function(data){
          TravelApp.Traveler.setUserTravelers(data);
          callback();
        });
      }else{
        callback();
      }
      
    }],
    function(err, results) {
      if(err) {
        console.log(err);
      }
      TravelApp.Traveler.setTravelIndex(results);
    }
  )
}

TravelApp.Traveler.setTravelTravelers = function(travelers) {
  travel_travelers = travelers.travelers;
}

TravelApp.Traveler.setUserTravelers = function(travelers) {
  user_travelers = travelers.travelers;
}

  //set travel index

TravelApp.Traveler.setTravelIndex = function() {
  TravelApp.Traveler.setIndex();
  
  //show join form only if maximum_people < people
  var current_travel = TravelApp.Helpers.getCurrentTravel();
  var current_user = TravelApp.Helpers.getCurrentUser();  
  if(current_user && current_travel.maximum_people > current_travel.people) {
    TravelApp.Traveler.setSelectForm();
  }
  //add delete links only if there is a current user
  if(current_user) {
    TravelApp.Traveler.setDeleteLinks();
  }
}

TravelApp.Traveler.setIndex = function() {
  travel_travelers.forEach(function(traveler) {
    $('.travel-travelers').append(HandlebarsTemplates['travelers/travel-miniature'](traveler));
  })
}

TravelApp.Traveler.setSelectForm = function() {
  var user_travelers_not_in_travel = user_travelers.filter(function(a){return !~this.indexOf(a);},travel_travelers);

  var select_html  = '<div class="travelers-select"><label class="travelers-select">Join the travel!</label><select name="travel-travelers" class="select travelers">'
  user_travelers_not_in_travel.forEach(function(traveler) {
    select_html += '<option value="' + traveler.id + '">' + traveler.first_name + '</option>';
  })
  $('.travel-travelers').append(select_html + '</select><button id="btn-travel-join">JOIN</button></div>');
}

TravelApp.Traveler.setDeleteLinks = function() {
  user_travelers.forEach(function(traveler) {
    var string = '#' + traveler.id;
    $(string).append('<a href="/" id="btn-travel-left" data-id="' + traveler.id + '">Left</a>');
  })
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

// TravelApp.Traveler.setUserTravelers = function(travelers) {
//   user_travelers = travelers.travelers;
//   TravelApp.Traveler.setTravelIndex();
// }

// TravelApp.Traveler.travelIndex = function(travel) {
//   ajax = new TravelApp.Ajax();
//   ajax.get('/travels/' + travel.id + '/travelers', TravelApp.Traveler.setTravelTravelers); 
// }

// TravelApp.Traveler.setTravelTravelers = function(travelers) {
//   travel_travelers = travelers.travelers;

//   var current_user = TravelApp.Helpers.getCurrentUser();
//   if (current_user) {
//     ajax = new TravelApp.Ajax();
//     ajax.get('/users/' + current_user.id + '/travelers', TravelApp.Traveler.setUserTravelers);
//   } else {
//     TravelApp.Traveler.setTravelIndex();
//   }
// }

// TravelApp.Traveler.setUserTravelers = function(travelers) {
//   user_travelers = travelers.travelers;
//   TravelApp.Traveler.setTravelIndex();
// }