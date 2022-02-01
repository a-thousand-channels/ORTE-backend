$(function() {

  $('#basemaps').on('change', function() {

      console.log( this.value );
      console.log( $(this).find('option:selected').data('url') );
      console.log( $(this).find('option:selected').data('attribution') );
      console.log( $(this).find('option:selected').data('backgroundcolor') );

      $('#layer_basemap_url').val($(this).find('option:selected').data('url'))
      $('#layer_basemap_attribution').val($(this).find('option:selected').data('attribution'))
      $('#layer_background_color').val($(this).find('option:selected').data('backgroundcolor'))
  });

})