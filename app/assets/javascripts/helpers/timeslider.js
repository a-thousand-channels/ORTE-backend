

jQuery(function ($) {

  function filterMarkers(selectedYear) {

    // markers.forEach(function(marker) {
      console.log("filterMarkers **************");
      console.log(marker_layers);
  }
  // for a single slider, used in places index
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