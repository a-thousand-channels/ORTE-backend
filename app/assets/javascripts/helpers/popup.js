/*jshint unparam: true, node: true */
/*global jQuery */

function PopupImageOnlyContent(place) {
    'use strict';
    var content = '';

    if (place.imagelink2) {
        content += "<div class='leaflet-popup-content-image'><img src='" + place.imagelink2 + "' /></div>";
    } 
    if (place.edit_link || place.show_link) {
        content += "<p class='text-right'>";
        if (place.show_link) {        
            content += place.show_link;
        }
        if (place.edit_link && place.show_link) {
            content += " | ";
        }
        if (place.edit_link) {
            content += place.edit_link;
        }
        content += "</p>";
    }        
    return content;
}


function PopupFullContent(place) {
    'use strict';
    var content = '';
    if (place.images && place.images[0]) {
        jQuery.each(place.images, function (kkey, image) {
            content += "<div class='leaflet-popup-content-image' id='popup-content-image-'" + kkey + "''><img src='" + image.image_url + "' /></div>";
        });
    }
    if (place.imagelink2) {
        content += "<div class='leaflet-popup-content-image'><img src='" + place.imagelink2 + "' /></div>";
    } else if (place.imagelink) {
        content += "<img src='" + place.imagelink + "' />";
    }
    content += '<div class="leaflet-popup-content-text">';
    if (place.date) {
        content += "<p>" + place.date;
        if (place.address) {
            content += " // " + place.address;
        }
        content += "</p>";
    } else if (place.address) {
        content += "<p class='shy'>" + place.address;
        if ( place.city) {
            content += ", " + place.city;
        }
        content += "</p>";
    }
    content += "<h4>";
    if (place.show_link) {
        content += place.show_link;
        if (place.published !== true) {
            content += " <i class='fi-lock fi-18'></i>";
        }
    }
    content += "</h4>";
    if (place.subtitle) {
        content += "<p>" + place.subtitle + "</p>";
    }
    if (place.teaser) {
        var teaser = place.teaser.replace(/<[^>]*>?/gm, ''); // remove html
        teaser = teaser.replace(/(?:\r\n|\r|\n)/g, '<br>'); // line breaks
        if (teaser.length > 400) {
            teaser = place.teaser.trim().substring(0, 400).split(" ").slice(0, -1).join(" ") + "...";
        }
        content += "<p>" + teaser + "</p>";
    }
    if (place.edit_link) {
        content += "<p class='text-right'>" + place.edit_link + "</p>";
    }
    content += '</div>';
    return content;
}
