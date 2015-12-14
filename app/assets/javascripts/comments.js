(function() {

if (window.TravelApp === undefined){
  window.TravelApp = {};
}

'use strict';
var ajax;
  
TravelApp.Comment = function(){
};

//To show the comments in a travel view.

TravelApp.Comment.getComments = function(travel) {
  ajax = new TravelApp.Ajax();
  ajax.get('/travels/' + travel.id + '/comments', TravelApp.Comment.showComments);
}

TravelApp.Comment.showComments = function(comments) {
  var comments = comments.comments;
  comments.forEach(function(comment) {
    if(comment.category == true) {
      $('.comments-public').prepend(HandlebarsTemplates['comments/public-comment'](comment));
    } else {
      $('.comments-private').prepend(HandlebarsTemplates['comments/private-comment'](comment));
    } 
  })
}

//To create and show a new public comment.

TravelApp.Comment.addPublicComment = function(comment) {
  $('.comments-public').prepend(HandlebarsTemplates['comments/public-comment'](comment))
}

TravelApp.Comment.showPublicError = function(errors) {
  var errorHtml = '<div class="errors"><dl>';
  errors.forEach(function(error) {
    errorHtml += '<dd>' + error + '</dd>';
  })
  $('#public-comment-form').append(errorHtml + '</div>');
}

//To create and show a new private comment.

TravelApp.Comment.addPrivateComment = function(comment) {
  $('.comments-private').prepend(HandlebarsTemplates['comments/private-comment'](comment))
}

TravelApp.Comment.showPrivateError = function(errors) {
  var errorHtml = '<div class="errors"><dl>';
  errors.forEach(function(error) {
    errorHtml += '<dd>' + error + '</dd>';
  })
  $('#private-comment-form').append(errorHtml + '</div>');
}

})()

$(document).on('ready', function() {

  //Buttons to show the new comment forms

  $(document).on('click', '#btn-form-public-comment', function(event) {
    event.preventDefault();
    $('#public-comment-form').remove();
    $('#btn-form-public-comment').after(HandlebarsTemplates['comments/public-comment-form'])
  })

  $(document).on('click', '#btn-form-private-comment', function(event) {
    event.preventDefault();
    $('#private-comment-form').remove();
    $('#btn-form-private-comment').after(HandlebarsTemplates['comments/private-comment-form'])
  })

  //Buttons to create and show the new comment

  $(document).on('click', '#btn-create-public-comment', function(event) {
    event.preventDefault();
    var current_travel = TravelApp.Helpers.getCurrentTravel();
    var current_user = TravelApp.Helpers.getCurrentUser();
    var description = $('#public-description').val();

    var data = {name: current_user.first_name, user_id: current_user.id, description: description, category: true};

    ajax = new TravelApp.Ajax();
    ajax.post('/travels/' + current_travel.id + '/comments', data, TravelApp.Comment.addPublicComment, TravelApp.Comment.showPublicError);
  })

  $(document).on('click', '#btn-create-private-comment', function(event) {
    event.preventDefault();
    var current_user = TravelApp.Helpers.getCurrentUser();
    var current_travel = TravelApp.Helpers.getCurrentTravel();
    var description = $('#private-description').val();

    var data = {name: current_user.first_name, user_id: current_user.id, description: description, category: false};

    ajax = new TravelApp.Ajax();
    ajax.post('/travels/' + current_travel.id + '/comments', data, TravelApp.Comment.addPrivateComment, TravelApp.Comment.showPrivateError);
  })

  //Button to delete the comment

  $(document).on('click', '#btn-delete-comment', function() {
    
  })

})