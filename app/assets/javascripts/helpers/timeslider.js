jQuery(function ($) {

  function filterMarkers(selectedYear) {
    console.log("filterMarkers **************");
    console.log(window.marker_layers);
    window.marker_layers.forEach(function(marker) {
      if (marker.data.fromYear <= selectedYear && marker.data.endYear >= selectedYear) {
          marker.addTo(map);
          marker.setIcon(icon);
      } else {       
        if ( selectedYear <= current_selected_year ) {
          map.removeLayer(marker);  
          // marker.setIcon(icon_past);
        } else {
          marker.setIcon(icon_past);
        }    
      }
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
// time line
let timelineContent = document.createElement('div');
timelineContent.setAttribute('id', 'timeline-content');
let main = document.querySelector("main");
main.appendChild(timelineContent);

let minYear = 2000;
let maxYear = 2024;

let diff = maxYear - minYear;
let step = 1;

for (var i = minYear; i <= maxYear; i += step) {
  var div = document.createElement('div');
  div.classList.add('year');
  div.setAttribute('id', 'year'+i);
  div.setAttribute('data-year', i);
  div.textContent = i;
  timelineContent.appendChild(div);
}

document.addEventListener("DOMContentLoaded", function() {
  const timelineContent = document.getElementById("timeline-content");
  const scrollLeft = document.getElementById("scroll-left");
  const scrollRight = document.getElementById("scroll-right");
  const yearDivs = document.querySelectorAll(".year");

   
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

      var selectedYear = this.getAttribute('data-year') // You can modify this to select any year within the range
      SelectAndFilterByYear(this,yearDivs,selectedYear)
    });
  });
  el = document.getElementById('year2008'); 
  SelectAndFilterByYear(el,yearDivs,'2008')
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
});