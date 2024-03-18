
jQuery(function ($) {
    
  
  $(document).on('changed.zf.slider', '[data-slider]', function(event) {
    var $slider = $(event.currentTarget);
    var $numberInput = $slider.children('input');
    let year = $numberInput.val()
    console.log(year)
    $('#slider-selection').html("Year selected: "+year);
    
    // get all places with id + startyear data values  
    let places_with_years = $('#timeline .place-entry').map(function() {
      return {
        id: $(this).attr('id'),
        startyear: $(this).data('startyear'),
        endyear: $(this).data('endyear')
      }
    })
    console.log(places_with_years);

    places_with_years.each(function() {
      console.log(this.id, this.startyear, this.endyear)
      if (year >= this.startyear && year <= this.endyear) {
        console.log('show')
        $('#'+this.id).show()
      } else {
        console.log('hide')
        $('#'+this.id).hide()
      }
    });

  
    // hide all
    // show only those existing in the selected year
  });
});