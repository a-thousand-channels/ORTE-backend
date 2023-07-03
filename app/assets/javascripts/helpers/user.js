/*jshint unparam: true, node: true */
/*global window */
/*global $ */

function userZoomLevel(map) {
    'use strict';
    map.on('zoomend', function () {
        var zl = map.getZoom();
        localStorage.setItem('UserZoomLevel', zl);
        // only for debugging
        // $('#show_zoomlevel').html("Map zoom: " + zl);
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