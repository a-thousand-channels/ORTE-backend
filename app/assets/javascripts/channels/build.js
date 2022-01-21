$(document).ready(function(){

  App.user = App.cable.subscriptions.create('BuildChannel', {
    // normal channel code goes here...
    connected() {
      console.log("connected to the build channel");
      // Called when the subscription is ready for use on the server
      $('.build_log').html("");
      $('#btn_start_build').prop('disabled',  false);
      $('.pack_log').hide();
    },

    disconnected() {
      console.log("disconnected from the build channel");
      $('.build_log').html("");
      // Called when the subscription has been terminated by the server
    },


    received: function(data) {
       console.log('received', data);
      if(data.hasOwnProperty('index') && data.index >= 0 ) {
        index_str =   data.index + 1 + '. '
      } else {
        index_str = ''
      }

      switch(data.status) {
        case 'start':
          $('.build_log').append('<p>' + index_str + data.content + '</p>');
          break;
        case 'pre-command':
          $('.build_log').append('<p>' + index_str + data.content + '</p>');
          break;
        case 'command':
          output = '<a name="step_' + data.index + '"></a><ul class="accordion" data-accordion id="acc_' + data.index + '" data-allow-all-closed="true">';
          if(data.command) {
            output += '<li class="accordion-item" data-accordion-item>'
            output += '<a href="#" class="accordion-title">Command - ' + data.duration + ' <span class="confirmation"><i class="fi fi-check" /><small> DONE </small></a>'
            output += '<div class="accordion-content" data-tab-content>'
            output += '<span style="white-space: pre-line; overflow-wrap: break-word;">' + data.command + ' </span></div></li>';
          }
          if(data.detail) {
            output += '<li class="accordion-item" data-accordion-item>'
            output += '<a href="#panel'+data.index+'" class="accordion-title" id="panel'+data.index+'-heading" aria-controls="panel'+data.index+'">Details</a>'
            output += '<div class="accordion-content" data-tab-content>'
            output += '<span style="white-space: pre-line; overflow-wrap: break-word;">' + data.detail + ' </span></div></li>';
          }
          if(data.error) {
            output += '<li class="accordion-item" data-accordion-item>'
            output += '<a href="#" class="accordion-title">Error</a>'
            output += '<div class="accordion-content" data-tab-content>'
            output += '<span style="white-space: pre-line; overflow-wrap: break-word;">' + data.error + ' </span></div></li>';
          }
          output += '</ul>';
          $('.build_log').append(output);
          scrollToAnchor('step_' + data.index );
          var elem = new Foundation.Accordion($('#acc_'+data.index));
          break;
        case 'finished':
          $('.build_log').append('<p>Finished: '  + data.content + ' - ' + data.duration+ ' <span class="confirmation"><i class="fi fi-check" /><small> DONE </small></p>');
          $('.download_area .button').prop('href', data.content);
          $('.download_area .button').html('<i class="fi fi-archive" /> Download your map to go (' + data.filesize + ')');
          $('.download_area').show();
          break;
      }
      map_resize();
      if((data.step_count) > data.index ) {
        $('.loading').show();
      } else {
        $('.loading').hide();
      }

    }

  });
});