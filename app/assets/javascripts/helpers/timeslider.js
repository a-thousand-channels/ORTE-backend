jQuery(function ($) {

  let body = document.querySelector("body");

  if ( body.classList.contains("show") && ( body.id === 'maps') ) {
    if ( $('#selection').data('map-marker-display-mode') !== 'single' ) {
      return;
    }
    // scrollbuttons
    let scrollLeft = document.createElement('div');
    scrollLeft.setAttribute('id', 'scroll-left');
    scrollLeft.innerHTML = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor"><path d="M11.8284 12.0005L14.6569 14.8289L13.2426 16.2431L9 12.0005L13.2426 7.75781L14.6569 9.17203L11.8284 12.0005Z"></path></svg>';
    let scrollRight = document.createElement('div');
    scrollRight.setAttribute('id', 'scroll-right');
    scrollRight.innerHTML = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor"><path d="M12.1717 12.0005L9.34326 9.17203L10.7575 7.75781L15.0001 12.0005L10.7575 16.2431L9.34326 14.8289L12.1717 12.0005Z"></path></svg>';

    // timeline
    let timelineWrapper = document.createElement('div');
    timelineWrapper.setAttribute('id', 'timeline-wrapper');
    timelineWrapper.appendChild(scrollLeft);
    timelineWrapper.appendChild(scrollRight);
    let timelineContent = document.createElement('div');
    timelineContent.setAttribute('id', 'timeline-content');
    timelineWrapper.appendChild(timelineContent);
    let body = document.querySelector("body");
    document.body.insertBefore(timelineWrapper, document.querySelector("footer"));


    let minYear = $('#selection').data('map-timeline-minyear');
    let maxYear = $('#selection').data('map-timeline-maxyear');

    let diff = maxYear - minYear;
    console.log("Create Timeline with ",minYear,maxYear);
    let step = 1;

    for (var i = minYear; i <= maxYear; i += step) {
      var div = document.createElement('div');
      div.classList.add('year');
      div.setAttribute('id', 'year'+i);
      div.setAttribute('data-year', i);
      div.textContent = i;
      timelineContent.appendChild(div);
    }

  }
});
let current_selected_year = 1900;
function filterMarkers(selectedYear) {

  console.log("filterMarkers **************",selectedYear);
  console.log(window.markers);
  current_selected_year = ( selectedYear > current_selected_year ) ? selectedYear : current_selected_year;

  const status = document.getElementById("timeline-info-status");
  status.innerHTML = "Selected Year "+selectedYear;

  window.markers.forEach(function(marker) {
    if (!marker.data) {
      window.map.removeLayer(marker);
      return;
    }
    if (marker.data.fromYear <= selectedYear && marker.data.endYear >= selectedYear) {
        console.log("1", marker.data.fromYear,selectedYear,marker.data.endYear,marker.data.color, marker.data.title, marker.data.layer_id);
        
        // TODO: add color!
        icon = LargeMarkerIcon.create({color: marker.data.color});
        marker.setIcon(icon);
        marker.addTo(window.map);
    } 
    // selecting past years
    else if ( marker.data.endYear <= selectedYear) {

        console.log("X Past", marker.data.fromYear,selectedYear,marker.data.endYear,marker.data.color, marker.data.title, marker.data.layer_id);        

        if ( $('#map').hasClass('darken-icons') ) {
          icon = LargeMarkerIcon.create({color: '#555', opacity: 0.2});
        } else {
          icon = LargeMarkerIcon.create({color: '#fff', opacity: 0.25});
        }
        window.map.removeLayer(marker);  
        marker.setIcon(icon);    
        marker.addTo(window.map);    
        // TODO: remove relations and other elements!

    // selecting future years
    } else {
      console.log("X Future", marker.data.fromYear,selectedYear,marker.data.endYear,marker.data.color, marker.data.title, marker.data.layer_id);        
      window.map.removeLayer(marker);  
      
    }    
    
  });
}
function resetMarkers() {
  markers.forEach(function(marker) {
    if (!marker.data) {
      return;
    }
    marker.addTo(map);
    icon = LargeMarkerIcon.create({color: marker.data.color});
    marker.setIcon(icon);       
  });
}

function SelectAndFilterByYear(el,yearDivs,year) {
  let active = false;
  if ( el.classList.contains("active") ) {
    active = true;
    resetMarkers();
  } else {
    filterMarkers(year);
  }
  yearDivs.forEach(function(div) {
    div.classList.remove("active");
  });
  if ( !active ) {
    el.classList.add("active");
  }
}
document.addEventListener("DOMContentLoaded", function() {
  let body = document.querySelector("body");
  if ( body.classList.contains("show") && ( body.id === 'maps') ) {
    if ( $('#selection').data('map-marker-display-mode') !== 'single' ) {
      return;
    }
    const timelineContent = document.getElementById("timeline-content");
    const scrollLeft = document.getElementById("scroll-left");
    const scrollRight = document.getElementById("scroll-right");
    const yearDivs = document.querySelectorAll(".year");

    console.log("Prep eventListeners")
    scrollLeft.addEventListener("click", function() {
      timelineContent.scrollBy({
        left: -100, // Adjust the scroll amount as needed
        behavior: "smooth"
      });
    });

    scrollRight.addEventListener("click", function() {
      timelineContent.scrollBy({
        left: 100, // Adjust the scroll amount as needed
        behavior: "smooth"
      });
    });
    yearDivs.forEach(function(yearDiv) {
      yearDiv.addEventListener("click", function() {

        var selectedYear = this.getAttribute('data-year');
        SelectAndFilterByYear(this,yearDivs,selectedYear);
      });
    });
    console.log("Prep eventListeners done");
    
  }
});


  // for a single slider, used in places index
  $(document).on('changed.zf.slider', '[data-slider]', function(event) {
    var $slider = $(event.currentTarget);
    var $numberInput = $slider.children('input');
    console.log($numberInput.val())
    $('#slider-selection').html($numberInput.val())
    // TODO: create list of all places with startyear and endyear data values
    // hide all
    // show only those existing in the selected year
  });
