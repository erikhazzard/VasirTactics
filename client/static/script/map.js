(function() {
  ' ========================================================================    \nmap.coffee\n\nContains the definition for map, which is retrieved from server and made\nup of cells.  A Map object is made up of map cells and the Map\nis owned by the Game object\n\n======================================================================== ';
  ' ========================================================================    \nAdd logging types\n======================================================================== ';
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  GAME_NAME.logger.options.log_types.push('Map');

  GAME_NAME.logger.options.setup_log_types();

  ' ========================================================================    \n\nModel    \n\n======================================================================== ';

  GAME_NAME.Models.Map = (function(_super) {

    __extends(Map, _super);

    function Map() {
      this.setupCells = __bind(this.setupCells, this);
      this.randomizeMap = __bind(this.randomizeMap, this);
      this.initialize = __bind(this.initialize, this);
      Map.__super__.constructor.apply(this, arguments);
    }

    Map.prototype.defaults = {
      name: 'Faydwer',
      map: [[{}, {}], [{}, {}]],
      cells: {}
    };

    Map.prototype.initialize = function() {
      'A Map object is created in the Game class';      this.set({
        map: this.randomizeMap()
      });
      this.setupCells({
        map: this.map
      });
      return this;
    };

    Map.prototype.randomizeMap = function() {
      var i, j, map, randNum, row, tmpRow;
      map = [];
      for (i = 0; i <= 16; i++) {
        row = [];
        for (j = 0; j <= 8; j++) {
          randNum = Math.round(Math.random() * 2);
          tmpRow = {
            baseSprite: 'terrain_' + randNum,
            topSprite: [void 0, void 0, 'rock'][randNum],
            canPass: ['all', 'ground', 'air'][randNum]
          };
          row.push(tmpRow);
        }
        map.push(row);
      }
      return map;
    };

    Map.prototype.setupCells = function(params) {
      'Setup the game cells.  This is called from init and\nthe cells are setup based on this model\'s map array\nTakes in a array of cells ';
      var cell, cells, i, j, row, _i, _j, _len, _len2, _ref;
      params = params || {};
      params.map = params.map || this.get('map');
      i = 0;
      j = 0;
      cells = {};
      _ref = params.map;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        row = _ref[_i];
        j = 0;
        for (_j = 0, _len2 = row.length; _j < _len2; _j++) {
          cell = row[_j];
          cells[i + ',' + j] = new GAME_NAME.Models.Cell({
            name: 'cell_' + i + ',' + j,
            x: i,
            y: j,
            baseSprite: cell.baseSprite,
            topSprite: cell.topSprite,
            type: cell.type,
            canPass: cell.canPass
          });
          j++;
        }
        i++;
      }
      this.set({
        cells: cells
      });
      return GAME_NAME.logger.Map('MAP: cells set, cells: ', this.get('cells'));
    };

    return Map;

  })(Backbone.Model);

}).call(this);
