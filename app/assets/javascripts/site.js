(function() {

if (window.TravelApp === undefined){
  window.TravelApp = {};
}

'use strict';
var ajax;

})()

$(document).on('ready', function() {

  $(document).on('click', '#load-home', function() {
    $('.main').html(HandlebarsTemplates['site/home']);
  })

})