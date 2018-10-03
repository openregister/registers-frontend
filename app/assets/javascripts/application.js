/* global $ */

// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require dialog-polyfill
//= require govuk/modules
//= require scrolling-tables
//= require gaap-analytics
//= require accessible-autocomplete
//= require govuk/show-hide-content
//= require current-location
//= require accordion-with-descriptions
//= require jquery-ui/widget
//= require jquery-ui/sortable

// GOV.UK Design System
//= require all.js

// Adding a `js` class to the html element allows us to use CSS to do things
// only when JavaScript is enabled - for example, hide the submit button for
// the Register collection 'show by' form.
document.getElementsByTagName('html')[0].className += 'js'

$.fn.extend({
  scrollRight: function (val) {
    if (val === undefined) {
      return this[0].scrollWidth - (this[0].scrollLeft + this[0].clientWidth) + 1;
    }
    return this.scrollLeft(this[0].scrollWidth - this[0].clientWidth - val);
  }
});

$(document).ready(function() {
  GOVUK.modules.start();
});

window.GAAP.analytics.eventTracking.init();
window.GAAP.analytics.virtualPageview.init();

var Radios = window.GOVUKFrontend.Radios
var $radio = document.querySelector('[data-module="radios"]')
if ($radio) {
  new Radios($radio).init()
}
