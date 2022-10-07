/*global $ */

function prepareBeforeLookup(url) {
    'use strict';
    $.ajaxSetup({
        headers: {
            'User-Agent': 'ORTE-Backend, in development (https://github.com/ut/ORTE-backend)',
            crossDomain: true
        }
    });
    var params = getParams();

    // url is provided via data-attr
    // alter this url if there are "remap" and "place" params
    if (params.remap) {
        // call URL + "edit"
        console.log('Lookup:: Alter URL for places > edit');
        url += '/places/' + params.place_id + "/edit";
    } else {
       // call URL + "new"
        console.log('Lookup:: Alter URL for places > new ');
        url += '/places/new';
    }
    return url;
}

function lookupNominatim(address, url) {
    'use strict';
    if ($('#addresslookup_address').hasClass('hide')) {
        showLookUpField();
    } else {
        $('#response').remove();
        $('#selection-hint').html('<p>Searching...</p>');
        var items = [];
        console.log("---------------------");
        console.log("LookupNominatim");
        console.log("Checking for params...");
        url = prepareBeforeLookup(url);
        if (address === '') {
            $('#selection-hint').html("<p><strong>No input!</strong> Please type in a complete address ('Street Number, City')</p>");
            $('#selection-hint').addClass('active');
        }
        if (address.length < 5) {
            console.log('Lookup:: Value too short!');
            $('#selection-hint').html("<p><strong>Input too short.</strong> Please type in a complete address ('Street Number, City')</p>");
            $('#selection-hint').addClass('active');
        } else {
            console.log('Lookup:: ' + address);
            /* example URL
              https://nominatim.openstreetmap.org/search?q=135+pilkington+avenue,+birmingham&format=xml&polygon=1&addressdetails=1
            */
            var nominatium_url = 'https://nominatim.openstreetmap.org/search';
            var nominatium_url_params = '&format=json&addressdetails=1';
            $.getJSON(nominatium_url + "?q=" + address +nominatium_url_params, function (data) {

                console.log(data);
                // if no result
                if (!data || data.length === 0) {
                    console.log('Lookup:: No result');
                    $('#selection-hint').html("<p>Nothing found. Please try another adress!  (Type 'Street Number, City')</p>");
                    $('#selection-hint').addClass('active');
                    return;
                }
                // if results
                console.log("items: " + items.length);
                console.log("response: " + $('#response').length);
                $.each( data, function (key, val) {
                    if (!val || (typeof val === 'undefined')) {
                        return;
                    }
                    console.log('Lookup:: "value.class" ' + val.class);

                    var regexp = /amenity|building|highway|boundary/gi;
                    var label = '';
                    if (val.class === 'building') {
                        label = 'Adresse:';
                    }
                    var href = url + '?address=' + val.display_name + '&lat=' + val.lat + '&lon=' + val.lon;

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

                    if (typeof val.address !== 'undefined') {
                        var location, road, house_number, postcode;
                        location = val.address[Object.keys(val.address)[0]];
                        console.log("Lookup:: Location YEAH " + location);
                        if (typeof val.address.road !== "undefined") {
                            road = val.address.road;
                            if (typeof val.address.house_number !== 'undefined') {
                                house_number = " " + val.address.house_number;
                                address = "&address=" + road + " " + house_number;
                            } else {
                                address = "&address=" + road;
                            }
                        }
                        if (typeof val.address.postcode !== 'undefined') {
                            postcode = "&postcode=" + val.address.postcode;
                        }
                        var city = '';
                        if (val.address && val.address.city && (val.address.city !== 'undefined')) {
                            city = val.address.city;
                        } else {
                            city = val.address.state;
                        }
                        /* TODO: verify all values */
                        /* FIXME: hamburg as state */
                        href = url + '?' + location + address + postcode + "&city=" + city + '&lat=' + val.lat + '&lon=' + val.lon;
                        if (val.class.match(regexp)) {
                            console.log('Lookup:: Using entry');
                            items.push("<li id='" + key + "'><a href='" + href + "'>" + label + " " + val.display_name + "</a></li>");
                        } else {
                            $('#selection-hint').html("<p>Sorry, could not find something useful.</p>");
                            $('#selection-hint').addClass('active');
                        }
                    } else {
                        console.log('Lookup:: Empty address value');
                        $('#selection-hint').html("<p>Sorry, something went wrong.</p>");
                        $('#selection-hint').addClass('active');
                    }
                });

                $("<ul/>", {
                    id: "response",
                    html: items.join('')
                }).appendTo("#selection");
                console.log("Success");
                $('#selection-hint').html("<p>Please select one result below (or type in another address).</p>");
                $('#selection-hint').addClass('active');
            }).done(function () {
                console.log('done');
                if (items.length === 0) {
                    $('#selection-hint').html("<p>Sorry, something went wrong.</p>");
                    $('#selection-hint').addClass('active');
                }
            }).fail(function () {
                console.log("error");
                $('#selection-hint').html("</p> :( Nothing found. Please try another input.</p>");
                $('#selection-hint').addClass('active');
            }).always(function () {
                console.log("Complete");
            });
        }
    }
}

function reverseLookupNominatim(map, latlng, lat, lon, url) {
    'use strict';
    console.log('Reverse Lookup:: Lat ' + lat + '/Lon ' + lon);
    var url = prepareBeforeLookup(url);

    if (lat === '') {
        $('#selection-hint').html("<p><strong>No input!</strong> Please try again.</p>");
        $('#selection-hint').addClass('active');
    } else {
        console.log('Reverse Lookup:: ' + lat + "/" + lon);
        //example
        // https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=-34.44076&lon=-58.70521
        var nominatium_reverse_url = 'https://nominatim.openstreetmap.org/reverse';
        var nominatium_url_params = '&format=jsonv2';

        $.getJSON(nominatium_reverse_url + "?lat=" + lat + "&lon=" + lon + nominatium_url_params, function (data) {

            // if no result
            if (!data) {
                console.log('Lookup:: No result');
                $('#selection-hint').html("<p>Nothing found. Please try another place on the map</p>");
                $('#selection-hint').addClass('active');
                return;
            }
            // if results
            var items = [];
            // empty container
            $('#resonse').html(' ');
            console.log(data);
            console.log('Reverse Lookup:: Data val');
            console.log(data.display_name);
            var location = ' ';
            if (data.name && data.name.length > 0) {
                location = data.name;
            }
            var city = '';
            if (data.address && data.address.city) {
                city = data.address.city;
            }
            // call "places/new"
            var house_number = '';
            if (data.address.house_number) {
                house_number = ' ' + data.address.house_number;
            }
            var full_address = location + " " + data.address.road + house_number + ", " + data.address.postcode + ' ' + city + ' (' + data.address.suburb + ")";
            var href = url + '?location=' + location + '&address=' + data.address.road + house_number + '&zip=' + data.address.postcode + '&city=' + city + ' (' + data.address.suburb + ')&lat=' + lat + '&lon=' + lon;
            // that would be a direct call
            // window.location = href;

            // show found place instead
            items.push("<li id='1'><a href='" + href + "'>" + full_address + "</a></li>");
            /*  $( "<ul/>", {
                "id": "response",
                html: items.join( "" ),
              }).appendTo( "#selection" );
            */
            var params = getParams(), hint;
            if (params.remap) {
                hint = 'Re-map to this place';
            } else {
                hint = 'Map this place';
            }
            L.popup().setLatLng(latlng).setContent("<p class='map_this_button text-center'><a href='" + href + "' class='button'>" + hint + "</a><br/>" + full_address + "</p>").openOn(map);
        }).done(function () {
            console.log("success");
            // $('#selection-hint').html("<p>Please select the address shown in the popup or try another input.</p>");
            // $('#selection-hint').addClass('active');
        }).fail(function () {
            console.log("error");
            $('#selection-hint').html("<p>Nothing found. Please try another input.</p>");
            $('#selection-hint').addClass('active');
        }).always(function () {
            console.log("complete");
        });
    }
}

function clearLookUpField() {
    'use strict';
    console.log('clearLookUpField');
    $('#addresslookup_address').addClass('hide');
    $('#addresslookup_address').val('');
    /* disabled
    $('#addresslookup_button i.fi-magnifying-glass').addClass('hide');
    $('#addresslookup_button i.fi-fast-forward').removeClass('hide');
    */
    $('#selection-hint').html("");
    $('#selection-hint').removeClass('active');
}
function showLookUpField() {
    'use strict';
    $('#addresslookup_address').removeClass('hide');
    /* disabled
    $('#addresslookup_button i.fi-magnifying-glass').removeClass('hide');
    $('#addresslookup_button i.fi-fast-forward').addClass('hide');
    */
    $('.leaflet-popup').hide();
    $('#selection-hint').html("");
    $('#selection-hint').removeClass('active');
}
