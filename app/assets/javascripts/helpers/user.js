/*jshint unparam: true, node: true */
/*global window */
/*global $ */

function userZoomLevel(map) {
    'use strict';
    map.on('zoomend', function () {
        var zl = map.getZoom();
        localStorage.setItem('UserZoomLevel', zl);
        var sw = screen.width;
        var sw_em = sw / parseFloat($('body').css('font-size'))
        if ( sw_em > 39.9375 ) {
            $('#show_zoomlevel').html("Custom level: " + zl + " - "+sw_em);
        }
    });
}
function userMapBounds(map) {
    'use strict';
    map.on('dragend', function () {
        var bounds = map.getBounds();
        var northeast = bounds.getNorthEast();
        var southwest = bounds.getSouthWest();
        localStorage.setItem('UserMapBoundsNE', northeast.lat + ',' + northeast.lng);
        localStorage.setItem('UserMapBoundsSW', southwest.lat + ',' + southwest.lng);
    });
}