/*jshint unparam: true, node: true */
/*global jQuery */
/*global window */

function UserZoomLevel(map) {
    'use strict';
    map.on('zoomend', function () {
        var zl = map.getZoom();
        localStorage.setItem('UserZoomLevel', zl);
        jQuery('#show_zoomlevel').html("Custom level: " + zl);
    });
}
function UserMapBounds(map) {
    'use strict';
    map.on('dragend', function () {
        var bounds = map.getBounds();
        var northeast = bounds.getNorthEast();
        var southwest = bounds.getSouthWest();
        localStorage.setItem('UserMapBoundsNE', northeast.lat + ',' + northeast.lng);
        localStorage.setItem('UserMapBoundsSW', southwest.lat + ',' + southwest.lng);
    });
}