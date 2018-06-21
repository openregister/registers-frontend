(function (Modules) {
  "use strict";

  Modules.ScrollingTables = function () {
    var _this = this;

    this.start = function (component) {
      this.$component = $(component);
      this.$table = this.$component.find('table');

      this.insertShadows();
      this.toggleShadows();

      this.$scrollableTable.on('scroll', this.toggleShadows);
    };

    this.insertShadows = function () {
      _this.$table.wrap('<div class="fullscreen-scrollable-table"/>');

      _this.$component.append('<div class="fullscreen-right-shadow" />');
      _this.$component.prepend('<div class="fullscreen-left-shadow" />');

      _this.$scrollableTable = _this.$component.find('.fullscreen-scrollable-table');
    };

    this.toggleShadows = function () {
      _this.$component.find('.fullscreen-right-shadow').toggleClass('visible', _this.$scrollableTable.scrollLeft() < _this.$table.width() - _this.$scrollableTable.width());
      _this.$component.find('.fullscreen-left-shadow').toggleClass('visible', _this.$scrollableTable.scrollRight() < _this.$table.width() - _this.$scrollableTable.width());

      setTimeout(function () {
        return _this.$component.find('.fullscreen-right-shadow, .fullscreen-left-shadow').addClass('with-transition');
      }, 3000);
    };
  };
})(window.GOVUK.Modules);
