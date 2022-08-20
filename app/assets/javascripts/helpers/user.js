function UserZoomLevel(map) {
  map.on('zoomend',function(e){
    var zl  = map.getZoom();
    localStorage.setItem('UserZoomLevel',zl);
    $('#show_zoomlevel').html("Custom level: "+zl);
  });
}
function UserMapBounds(map) {
  map.on('dragend',function(e){
    var bounds = map.getBounds();
    var northeast = bounds.getNorthEast();
    var southwest = bounds.getSouthWest();
    localStorage.setItem('UserMapBoundsNE',northeast['lat']+','+northeast['lng']);
    localStorage.setItem('UserMapBoundsSW',southwest['lat']+','+southwest['lng']);

  });

}