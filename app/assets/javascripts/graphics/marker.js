/*
call me like this:

var params = {
  color: "red",
  opacity: 1,
  stroke: "black",
  stroke_width: 1,
  stroke_opacity: 1,
  defs_with_gradient: ""
};

var icon = LargeMarkerIcon.create(params);

*/
var LargeMarkers = {

    CustomLargeIcon = L.Icon.extend({
        options: {
            iconSize:     [this.params.marker_size, this.params.marker_size],
            iconAnchor:   [15, 15],
            popupAnchor:  [0, -15]
        }
    })
    iconSVG: function(params) {
        var svg = `<svg height="${marker_size}" width="${marker_size}" xmlns="http://www.w3.org/2000/svg">${params.defs_with_gradient}<circle class="cls-1" cx="${marker_size/2}" cy="${marker_size/2}" r="${marker_size/2}" fill="${params.color}" fill-opacity="${params.opacity}" stroke="${params.stroke}" stroke-width="${params.stroke_width}" stroke-opacity="${params.stroke_opacity}" shape-rendering="geometricPrecision"></circle></svg>`;
        return encodeURI("data:image/svg+xml," + svg).replace(new RegExp('#', 'g'),'%23');
    },
    create: function(params = {color: "black", opacity: 0.5, stroke: "transparent", stroke_width: 0, stroke_opacity: 0, defs_with_gradient: ""}) {

        return new CustomLargeIcon({iconUrl: iconSVG(params)});
    }

};