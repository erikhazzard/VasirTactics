(function() {
  ' ========================================================================    \ninit.js\n----------------------\nSets up page / UI related stuff and \n========================================================================';
  var key, tmp_img, val, _ref,
    _this = this;

  GAME_NAME.init = function() {
    'Kick off the game creation';
    var game_state, renderer;
    game_state = {
      players: {
        'enoex': new GAME_NAME.Models.Player({
          name: 'Enoex',
          id: '402190r90war',
          spells: {
            'summon_knight': new GAME_NAME.Models.Spell({
              name: 'Summon Creature'
            }),
            'magic_missile': new GAME_NAME.Models.Spell({
              name: 'Magic Missle'
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
