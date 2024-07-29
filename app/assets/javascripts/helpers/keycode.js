/*global jQuery */
/*global window */

jQuery(function ($) {
    "use strict";
    $(document).keyup(function (e) {
        // Toggle selection bar
        if (($('body').attr('id') === 'maps') || ($('body').attr('id') === 'layers')) {
            if (e.keyCode === 27) {          // ESC
                if ($('#selection').is(":hidden")) {
                    console.log("is hidden");
                    $('#selection').show('slow');
                    $('#selection-reveal-hint').remove();
                } else {
                    console.log("is visible");
                    $('#selection').hide('slow');
                    $('#selection').before('<div id="selection-reveal-hint">Hit ESC to show selection box again</div>');
                    setTimeout(function () {
                        $('#selection-reveal-hint').remove();
                    }, 4500);
                }
            }
        }
        // ESC: Go back one step
        if ($('body').attr('id') === 'places') {
            if (e.keyCode === 27) {
                window.history.back();
            }
        }
    });
});