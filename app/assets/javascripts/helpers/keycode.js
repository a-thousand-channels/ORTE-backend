 $(function() {

    $(document).keyup(function(e) {

      // toggle selection bar
      if ( ( $('body').attr('id') == 'maps' ) || ( $('body').attr('id') == 'layers' ) )  {
       if (e.keyCode === 9) $('#selection').toggle('slow');     // tab
      }
      // go back one step
      if ( $('body').attr('id') == 'places' )  {
        if (e.keyCode === 27)  window.history.back();   // esc
      }
    });

});