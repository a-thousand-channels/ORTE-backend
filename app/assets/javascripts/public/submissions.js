  $(function () {

    if( $('#submissions').length > 0 ){

      // hide image preview unless user chooses to provide an image
      $('#place_image_placeholder').hide();
      $('#step_finished #place_image_placeholder').show();
      if (( $('#new_image #image_title').length > 0 ) &&  ( $('#image_title')[0].value.length > 0 )) {
        console.log( $('#image_title')[0].value.length );
        $('#place_image_placeholder').show();
      }
      $('#image_title').on('input change',function(){
        if ( this.value.length > 0 ) {
          console.log( this.value.length );
          $('#place_image_placeholder').show();
        } else {
          $('#place_image_placeholder').hide();
        }
      });
      // setup handler for form field changes
      var form_fields = ['submission_name', 'place_location', 'image_title'];
      form_fields.forEach(element => {
        if( $('#' + element).length > 0 && $('#' + element + '_receiver').length > 0 ) {
          // check on page load
          var value = $('#' + element).val();
          if ( !value.length > 0 ) {
              value = "&nbsp;"
          }
          $('#' + element + '_receiver').html(value);



          // check on input or change
          $('#' + element).on('input change',function(){
            var value = $( this ).val();
            if ( !value.length > 0 ) {
              value = "&nbsp;"
            }
            $('#' + element + '_receiver').html(value.replace(/\n/g, "<br />"));
         });
        }
      });

      if( $('#step_image').length > 0 ){
        $('#image_accordion').on('down.zf.accordion',function(){
          $('#place_image_placeholder').show();
          $( '#image_input' ).val('1');
      });
        $('#image_accordion').on('up.zf.accordion',function(){
          $('#place_image_placeholder').hide();
          $('#image_input').val('0');
        });
      }

      if( $('#place_address').length > 0 ){

        $('input#place_address').on('keyup', function(e) {
            e.preventDefault();
            LookupCity($(this).val(), $(this).data('lookupcityonly'));
        });
        $('button#place_addresslookup_button').click(function(e) {
          e.preventDefault();
          var val = $('input#place_address').val();
          LookupCity(val, $('input#place_address').data('lookupcityonly'));
        });
      }


    }
  });


  function LookupCity(address = '', lookupCityOnly = false) {
    $.ajaxSetup({
      headers : {
        'User-Agent' : 'ORTE-Backend, in development (https://github.com/ut/ORTE-backend)',
        'crossDomain' : true,
        'Accept-Language' : $('#locale').val()
      }
    });
    $('.response-list').remove();
    $('#selection-hint').html('<p>Searching...</p>');
    var items = [];
    console.log("---------------------");
    console.log("LookupNominatim");
    console.log("Checking for params...");
    if ( address === '' ) {
      $('#selection-hint').html("<p>" + I18n.t('search.lookup.no_input') +  "</p>");
      $('#selection-hint').addClass('active');
    }
    if ( address.length < 5 ) {
      console.log('Lookup:: Value too short!');
      $('#selection-hint').html("<p>" + I18n.t('search.lookup.too_short') +  "</p>");
      $('#selection-hint').addClass('active');
    } else {
      console.log('Lookup:: '+address);
      //example
      // https://nominatim.openstreetmap.org/search?q=135+pilkington+avenue,+birmingham&format=xml&polygon=1&addressdetails=1
      var nominatium_url = 'https://nominatim.openstreetmap.org/search';
      var nominatium_url_params = '&format=json&addressdetails=1'
      if(lookupCityOnly) {
        nominatium_url_params = nominatium_url_params + '&featuretype=city'
      }

      var request = $.getJSON( nominatium_url+"?q="+address+nominatium_url_params, function( data ) {

          console.log(data);
          // if no result
          if ( !data || data.length === 0) {
            console.log('Lookup:: No result');
            $('#selection-hint').html("<p>" + I18n.t('search.lookup.no_result') +  "</p>");
            $('#selection-hint').addClass('active');
            return;
          }
          // if results
          console.log("items: "+items.length);
          console.log("data: "+data.length);
          console.log("response: "+$('#response').length);
          $('.response-list').remove();
          $.each( data, function( key, val ) {
            console.log('Lookup:: Data value class ' + val.class);
            var label = ''
            if ( val.class === 'building') {
              label = I18n.t('search.lookup.address');
            }

            // OR better get address details
            /*
            pub Café Treibeis
            house_number  25
            road  Gaußstraße
            suburb  Ottensen
            city_district Altona
            state Hamburg
            postcode  22765
            country Germany
            country_code  de
            */

            if ( val.address !== 'undefined') {
              var location = ''; var address= ''; var road = ''; var house_number = ''; var postcode = '';
              location = val.address[Object.keys(val.address)[0]];
              console.log("Lookup:: Location YEAH "+location);
              if ( typeof val.address.road !== 'undefined') {
                road = val.address.road;
                if ( typeof val.address.house_number !== 'undefined') {
                  house_number   = " "+val.address.house_number;
                  address = "&address="+road+" "+house_number;
                } else {
                  address = "&address="+road;
                }
              }
              if ( typeof val.address.postcode !== 'undefined') {
                postcode = "&postcode="+val.address.postcode;
              }
              var city = ''
              if ( val.address && val.address.city && (val.address.city !== 'undefined')) {
                city = val.address.city;
              } else {
                city = val.address.state
              }
              country = val.address.country
            }
            console.log('Lookup:: Using entry');
            items.push( "<li id='" + key + "' class='nominatim_results' ><a href='return false;' data-zip='"+ postcode + "' data-city='"+ city + "' data-country='"+ country + "' data-lat='"+ val.lat + "' data-lon='"+ val.lon + "' data-location='"+ label + " " + val.display_name + "'>" + label + " " + val.display_name + "</a></li>" );
            
          });
          $( "<ul/>", {
            "id": "response",
            "class": "response-list",
            html: items.join( "" ),
          }).appendTo( "#selection" );

          console.log( "Success" );
          $('#selection-hint').html("<p>" + I18n.t('search.lookup.success_result') +  "</p>");
          $('#selection-hint').addClass('active');
        }).done(function() {
          $('.nominatim_results a').on('click', function(e){

            console.log( "Click" );
            e.preventDefault();
            var lat = $(this).data('lat');
            console.log( "Click", lat );
            $('#place_lat').val(lat);
            $('#place_lon').val($(this).data('lon'));
            $('#place_zip').val($(this).data('zip'));
            $('#place_city').val($(this).data('city'));
            $('#place_country').val($(this).data('country'));
            $('#place_location').val($(this).data('location'));
            $('#place_address').val($(this).data('location'));
            $('#place_address_receiver').text($(this).data('location'));

            $('.response-list').remove();
            $('#selection-hint').html("");
          });
        }).fail(function() {
          console.log( "error" );
          $('#selection-hint').html("<p>" + I18n.t('search.lookup.nothing_found') +  "</p>");
          $('#selection-hint').addClass('active');
        }).always(function() {
          console.log( "Complete" );
        });
    }
  }