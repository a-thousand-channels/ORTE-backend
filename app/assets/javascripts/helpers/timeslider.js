
jQuery(function ($) {
    
  
  $(document).on('changed.zf.slider', '[data-slider]', function(event) {
    var $slider = $(event.currentTarget);
    var $numberInput = $slider.children('input');
    console.log($numberInput.val())
    $('#slider-selection').html($numberInput.val())
    // TODO: create list of all places with startyear and endyear data values
    // hide all
    // show only those existing in the selected year
  });
});