// Action Cable provides the framework to deal with WebSockets in Rails.
// You can generate new channels where WebSocket features live using the `rails generate channel` command.
//
//= require action_cable
//= require_self
// require_tree ./channels

(function() {
  this.App || (this.App = {});
  App.cable = ActionCable.createConsumer();

  App.build = App.cable.subscriptions.create('BuildChannel', {
    // normal channel code goes here...
    connected() {
      console.log("connected to the build channel");
      // Called when the subscription is ready for use on the server
      $('.build_log').append('<p>Waiting for build</p>');
      $('.pack_log').hide();
    },

    disconnected() {
      console.log("disconnected from the build channel");    
      // Called when the subscription has been terminated by the server
    },


    received: function(data) {
      //new Notification data["title"], body: data["body"]
      console.log('received', data);
      $('.build_log').append('<p>' + data.content + ' - <span class="confirmation"><i class="fi fi-check" /><small> DONE </small></p>');

      output = '<ul class="accordion" data-accordion id="acc_'+data.index+'">';
      if(data.detail) {
        output += '<li class="accordion-item" data-accordion-item><a href="#panel'+data.index+'" class="accordion-title" id="panel'+data.index+'-heading" aria-controls="panel'+data.index+'">Details</a><div id="panel'+data.index+'" class="accordion-content" role="tabpanel" data-tab-content aria-labelledby="panel'+data.index+'-heading"><span style="white-space: pre-line">' + data.detail + ' </span></div></li>';
      }
      if(data.error) {
        output += '<li class="accordion-item" data-accordion-item><a href="#" class="accordion-title">Fehler</a><div class="accordion-content" data-tab-content><span style="white-space: pre-line">' + data.error + ' </span></div></li>';
      }
      output += '</ul>';

      $('.build_log').append(output);

      var elem = new Foundation.Accordion($('#acc_'+data.index));

      
    }
    
  });

}).call(this);
