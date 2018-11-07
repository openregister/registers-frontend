// Taken from https://raw.githubusercontent.com/alphagov/gaap-analytics/master/build/gaap-analytics.js

(function(){function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s}return e})()({1:[function(require,module,exports){
'use strict';

module.exports = function (element, category, action, label) {
  if (element.tagName === 'SUMMARY') {
    action = action + ' opened';
  }
  element.addEventListener('click', function () {
    if (element.tagName === 'SUMMARY') {
      var actionWords = action.split(' ');
      var oldState = actionWords[actionWords.length - 1];
      var newState = element.parentElement.hasAttribute('open') ? 'closed' : 'opened';
      action = action.replace(oldState, newState);
    }
    ga('send', 'event', category, action, label);
  });
};

},{}],2:[function(require,module,exports){
'use strict';

var addListener = require('./add-listener');

module.exports = function (elements) {
  elements.forEach(function (element) {
    var eventCategory = element.getAttribute('data-click-category');
    var eventAction = element.getAttribute('data-click-action');

    switch (element.tagName) {
      case 'A':
      case 'BUTTON':
      {
        var label = element.getAttribute('data-click-label') ? element.getAttribute('data-click-label') : element.innerText;
        addListener(element, eventCategory, eventAction, label);
        break;
      }
      case 'INPUT':
        {
          var label = element.getAttribute('data-click-label') ? element.getAttribute('data-click-label') : element.value;
          addListener(element, eventCategory, eventAction, label);
          break;
        }
      default:
        {
          var childClickables = Array.prototype.slice.call(element.querySelectorAll('a, button, input[type="button"], input[type="radio"], input[type="checkbox"], summary'));

          if (childClickables.length !== 0) {
            childClickables.forEach(function (element) {
              var label = void 0;
              switch (element.tagName) {
                case 'A':
                case 'BUTTON':
                case 'SUMMARY':
                  label = element.innerText;
                  break;
                default:
                  label = element.value;
                  break;
              }

              addListener(element, eventCategory, eventAction, label);
            });
          }
          break;
        }
    }
  });
};

},{"./add-listener":1}],3:[function(require,module,exports){
'use strict';

var buildListener = require('./build-listener');

module.exports = function () {
  var elementsToTrack = Array.prototype.slice.call(document.querySelectorAll('[data-click-events]'));

  if (elementsToTrack && typeof ga === 'function') {
    buildListener(elementsToTrack);
  }
};

},{"./build-listener":2}],4:[function(require,module,exports){
// Works in combination with the following data-attributes
// data-click-events - this just sets the thing up designed to work with A, INPUT[type~="button radio checkbox"], BUTTON
// OR you can put it on a whole div/form and it will track all the aforementioned elements within it
// data-click-category="Header" - this is the category GA will put it in
// data-click-action="Navigation link clicked" - this is the action GA will use

'use strict';

var init = require('./find-trackable');

module.exports = { init: init };

},{"./find-trackable":3}],5:[function(require,module,exports){
'use strict';

var eventTracking = require('./event-tracking');
var virtualPageview = require('./virtual-pageview');

// Add to window.GAAP if in browser context
if (window) {
  window.GAAP = window.GAAP || {};
  window.GAAP.analytics = { eventTracking: eventTracking, virtualPageview: virtualPageview };
}

module.exports.eventTracking = eventTracking;
module.exports.virtualPageview = virtualPageview;

},{"./event-tracking":4,"./virtual-pageview":9}],6:[function(require,module,exports){
'use strict';

module.exports = function (element) {
  element.addEventListener('submit', function (e) {
    e.preventDefault();
    var gaParams = {
      hitType: 'pageview',
      page: e.target.dataset.virtualPageview || ''
    };
    var parameters = e.target.dataset.parameters;

    if (parameters) {
      parameters.split(' ').forEach(function (parameter) {
        var key = parameter.split(':')[0];
        var input = parameter.split(':')[1];
        if (e.target.elements[input]) {
          gaParams[key] = e.target.elements[input].value;
        } else {
          gaParams[key] = input;
        }
      });
    }

    ga('send', gaParams);
    e.target.submit();
  });
};

},{}],7:[function(require,module,exports){
'use strict';

var addListener = require('./add-listener');

module.exports = function (elements) {
  elements.forEach(function (element) {
    addListener(element);
  });
};

},{"./add-listener":6}],8:[function(require,module,exports){
'use strict';

var buildListener = require('./build-listener');

module.exports = function () {
  var elementsToTrack = Array.prototype.slice.call(document.querySelectorAll('[data-virtual-pageview]'));

  if (elementsToTrack && typeof ga === 'function') {
    buildListener(elementsToTrack);
  }
};

},{"./build-listener":7}],9:[function(require,module,exports){
// Works in combination with the following data-attributes
// data-virtual-pageview="page/slug/name" - this triggers the script to run currently only works for form elements
// data-parameters="dimension1:service-name" you can add custom parameters to your virtual pageview, such as dimensions and metrics.
// Where 'service-name' is the name attribute of an element that you want to pass to google
// For multiple space separate
// e.g. data-parameters="dimension1:service-name metric1:total-amount"

'use strict';

var init = require('./find-virtual-pageview');

module.exports = { init: init };

},{"./find-virtual-pageview":8}]},{},[5]);