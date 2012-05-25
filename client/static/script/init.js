(function() {
  ' ========================================================================    \ninit.js\n----------------------\nSets up page / UI related stuff and \n========================================================================';
  var key, tmp_img, val, _ref,
    _this = this;

  GAME_NAME.init = function() {
    'Kick off the game creation';
    var game_state, magicMissile, renderer;
    magicMissile = function(target) {
      return target.transition().duration(1000).attr('width', GAME_NAME.Models.Renderer.prototype.defaults.cellSize.width * 10).attr('height', 5).style('fill', '#dd2222').transition().delay(1000).duration(1000).style('fill', '#ffffff').attr('height', GAME_NAME.Models.Renderer.prototype.defaults.cellSize.width).attr('width', GAME_NAME.Models.Renderer.prototype.defaults.cellSize.width).transition().delay(2000).style('fill', 'none');
    };
    game_state = {
      players: {
        'enoex': new GAME_NAME.Models.Player({
          name: 'Enoex',
          id: '402190r90war',
          spells: {
            'magic_missile': new GAME_NAME.Models.Spell({
              name: 'Magic Missile',
              effect: magicMissile
            }),
            'summon_knight': new GAME_NAME.Models.Spell({
              name: 'Summon Creature'
            })
          },
          creatures: new GAME_NAME.Collections.Creatures([
            new GAME_NAME.Models.Creature({
              name: 'Toestubber_Goblin_1',
              location: {
                x: 2,
                y: 1
              }
            })
          ])
        }),
        'enjalot': new GAME_NAME.Models.Player({
          name: 'Enjalot',
          id: 'u90r2h180f80n',
          spells: {},
          creatures: new GAME_NAME.Collections.Creatures([
            new GAME_NAME.Models.Creature({
              name: 'Toestubber_Goblin_1',
              location: {
                x: 15,
                y: 1
              }
            })
          ])
        })
      }
    };
    game_state.activePlayer = game_state.players.enoex;
    GAME_NAME.game = new GAME_NAME.Models.Game(game_state);
    renderer = GAME_NAME.game.get('renderer');
    renderer.renderUI();
    renderer.render();
    return _this;
  };

  ' ========================================================================    \nCall init\n========================================================================';

  _ref = GAME_NAME.Models.Renderer.prototype.defaults.sprites;
  for (key in _ref) {
    val = _ref[key];
    tmp_img = new Image();
    tmp_img.src = val;
  }

  $(document).ready(function() {
    GAME_NAME.templates.target_creature_mine = $('#template_ui_target_creature_mine').html();
    GAME_NAME.templates.target_creature_theirs = $('#template_ui_target_creature_theirs').html();
    GAME_NAME.templates.target_cell = $('#template_ui_target_cell').html();
    return GAME_NAME.init();
  });

}).call(this);
