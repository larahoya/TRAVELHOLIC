(function(){

  TravelApp.Ajax = function(){

  };

  TravelApp.Ajax.prototype.get = function(uri, callback_function){
    $.ajax({
      url: uri,
      success: function(response){
        callback_function(response);
      },
      fail: function(error){
        console.error("Error: " + error);
      }
    });
  };

  TravelApp.Ajax.prototype.post = function(uri, data_hash, callback_function){
    $.ajax({
      url: uri,
      type: 'POST',
      data: data_hash,
      success: function(response){
        callback_function(response);
      },
      fail: function(error){
        console.error("Error: " + error);
      }
    });
  };

})();