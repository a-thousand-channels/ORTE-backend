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
    }
    
  });

}).call(this);
