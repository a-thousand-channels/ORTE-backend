function setupTimeslider(places_by_year) {
  let body = document.querySelector("body");
  console.log('Timeline: setupTimeslider')

  if ( body.classList.contains("show") && ( body.id === 'maps') ) {
    if ( $('#selection').data('map-marker-display-mode') !== 'single' ) {
      return;
    }
    if ( $('#selection').data('map-enable-time-slider') !== true ) {
      return;
    }
    if ( Object.keys(places_by_year).length === 0 ) {
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
    let timelineInfoBox = document.createElement('div');
    timelineInfoBox.setAttribute('id', 'timeline-infobox');    
    timelineInfoBox.innerHTML = '<div id="timeline-info-status"></div><div id="timeline-function">(<a href="">Show all places</a>)</div>';

    let timelineInnerWrapper = document.createElement('div');
    timelineInnerWrapper.setAttribute('id', 'timeline-innerwrapper');
    timelineInnerWrapper.appendChild(scrollLeft);
    timelineInnerWrapper.appendChild(scrollRight);
    let timelineContent = document.createElement('div');
    timelineContent.setAttribute('id', 'timeline-content');
    timelineInnerWrapper.appendChild(timelineContent);
    timelineWrapper.appendChild(timelineInfoBox);
    timelineWrapper.appendChild(timelineInnerWrapper);
    let body = document.querySelector("body");
    document.body.insertBefore(timelineWrapper, document.querySelector("footer"));


    let minYear = $('#selection').data('map-timeline-minyear');
    let maxYear = $('#selection').data('map-timeline-maxyear');

    let diff = maxYear - minYear;
  
    console.log("Timeline: Create Timeline with ",minYear,maxYear,diff);
    let step = 1;

    // argh, after sending the data via JSON an extra hash level is created
    function getPlacesByYear(year) {
      for (let i = 0; i < places_by_year.length; i++) {
        if (places_by_year[i][year]) {
          return places_by_year[i][year];
        }
      }
      return null; // oder ein leerer Array [], falls es keine Orte gibt
    }
    console.log("Timeline: ",2010, getPlacesByYear(2010));

    for (var i = minYear; i <= maxYear; i += step) {
    // for (var i = 0; i <= diff; i += step) {
      var div = document.createElement('div');
      div.classList.add('year');
      div.setAttribute('id', 'year'+i);
      div.setAttribute('data-year', i);
      var thisyear = getPlacesByYear(i);
      console.log("Timeline: Create Timeline entry with ",i, thisyear);
      if ( thisyear ) {
        div.setAttribute('title', 'Show '+thisyear.length+' places for '+i);
        div.setAttribute('data-places', thisyear.length);
      } else {
        div.classList.add('stale');
        div.setAttribute('title', 'No places for '+i);
        div.setAttribute('data-places', 0);
      }
      div.textContent = i;
      timelineContent.appendChild(div);
    }
  }
}
function setupTimesliderEvents(places_by_year) {
    let body = document.querySelector("body");
    if ( body.classList.contains("show") && ( body.id === 'maps') ) {
      if ( $('#selection').data('map-marker-display-mode') !== 'single' ) {
        return;
      }
      if ( $('#selection').data('map-enable-time-slider') !== true ) {
        return;
      }    
      if ( Object.keys(places_by_year).length === 0 ) {
        return;
      }    
      const timelineContent = document.getElementById("timeline-content");
      const scrollLeft = document.getElementById("scroll-left");
      const scrollRight = document.getElementById("scroll-right");
      const yearDivs = document.querySelectorAll(".year");
  
      console.log("Timeline: setupTimesliderEvents","Prep eventListeners")
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
          var selectedYearPlaces = this.getAttribute('data-places');
          SelectAndFilterByYear(this,yearDivs,selectedYear,selectedYearPlaces);
        });
      });
      console.log("Timeline: setupTimesliderEvents","Prep eventListeners done");
      
    }
   
}

let current_selected_year = 1900;
function filterMarkers(selectedYear,places) {

  console.log("Timeline: filterMarkers **************",selectedYear);
  current_selected_year = ( selectedYear > current_selected_year ) ? selectedYear : current_selected_year;

  const status = document.getElementById("timeline-info-status");
  status.innerHTML = "Showing <strong>"+places+"</strong> "+( places == 1 ? 'place' : 'places' )+" in <strong>"+selectedYear+"</strong>";
  

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

        if ( $('#map').hasClass('darken-icons2') ) {
          icon = LargeMarkerIcon.create({color: '#222', opacity: 0.2});
        } else if ( $('#map').hasClass('darken-icons') ) {
          icon = LargeMarkerIcon.create({color: '#555', opacity: 0.2});
        } else {
          icon = LargeMarkerIcon.create({color: '#fff', opacity: 0.3});
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
  const status = document.getElementById("timeline-info-status");
  status.innerHTML = "Showing all places";
  markers.forEach(function(marker) {
    if (!marker.data) {
      return;
    }
    marker.addTo(map);
    icon = LargeMarkerIcon.create({color: marker.data.color});
    marker.setIcon(icon);       
  });
}

function SelectAndFilterByYear(el,yearDivs,year,places) {
  let active = false;
  if ( el.classList.contains("active") ) {

    // reset disabled for now
    // active = true;
    // resetMarkers();

    // maybe a nice panto function?
    // panTo() 
    // var bounds = marker_meta_layers.getBounds().pad(0.35);
  } else {
    filterMarkers(year,places);
  }
  yearDivs.forEach(function(div) {
    div.classList.remove("active");
  });
  if ( !active ) {
    el.classList.add("active");
  }
}


$(document).on('click', '#timeline-function a', function(event) {
  event.preventDefault();
  resetMarkers();
  const yearDivs = document.querySelectorAll(".year");
  yearDivs.forEach(function(div) {
    div.classList.remove("active");
  });  
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
