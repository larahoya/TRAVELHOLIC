(function(){
  window.TravelApp = window.TravelApp || {};
  
  TravelApp.Ajax = function(){

  };

  TravelApp.Ajax.prototype.get = function(uri, callback_function){
    $.ajax({
      url: uri,
      success: function(response){
        console.log(response);
        callback_function(response);
      },
      fail: function(error){
        console.error("Error: " + error);
      }
    });
  };

  TravelApp.Ajax.prototype.post = function(uri, data_hash, success_function, error_function){
    var request = $.post(uri, data_hash);
    request.done(function(response) {
      success_function(response);
    });
    request.fail(function(response) {
      error_function(response);
    });
  };

})();