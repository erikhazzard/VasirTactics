''' ========================================================================    
    init.js
    ----------------------
    Sets up page / UI related stuff and 
    ========================================================================'''
GAME_NAME.init = ()=>
    '''Kick off the game creation'''
    #TODO: Get game state
    
    #Fake game state for now
    game_state = {
        players: {
            'enoex': new GAME_NAME.Models.Player({
                name: 'Enoex'
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
                        name: 'Toestubber_Goblin_1'
                        location: {
                            x: 2,
                            y: 1
                        }
                    })
                ])
            }),
            'enjalot': new GAME_NAME.Models.Player({
                name: 'Enjalot'
                id: 'u90r2h180f80n'
                spells: {

                },
                creatures: new GAME_NAME.Collections.Creatures([
                    new GAME_NAME.Models.Creature({
                        name: 'Toestubber_Goblin_1'
                        location: {
                            x: 15,
                            y: 1
                        }
                    })
                ])
            })
        }
    }

    #Set active player
    #   This changes when playing hotseat, but not when playing networked
    #   TODO: set from server, set above
    game_state.activePlayer = game_state.players.enoex

    #Create the game model
    #   Pass in the game state
    GAME_NAME.game = new GAME_NAME.Models.Game(
        game_state
    )

    #Render everything
    renderer = GAME_NAME.game.get('renderer')
    renderer.renderUI()
    renderer.render()

    return @

''' ========================================================================    
    Call init
    ========================================================================'''
#------------------------------------
#Async. load all sprites from the Renderer model
#   (Do this before DOM is ready)
#------------------------------------
#Load assets 
for key, val of GAME_NAME.Models.Renderer.prototype.defaults.sprites
    tmp_img = new Image()
    tmp_img.src = val

$(document).ready(()=>
    #TODO: Figure out what can be pulled out of this. Shouldn't have to wait
    #for DOM to create views / models
    #------------------------------------
    #Setup templates
    #------------------------------------
    #Target box
    GAME_NAME.templates.target_creature_mine = $(
        '#template_ui_target_creature_mine').html()
    GAME_NAME.templates.target_creature_theirs = $(
        '#template_ui_target_creature_theirs').html()
    GAME_NAME.templates.target_cell = $(
        '#template_ui_target_cell').html()

    #------------------------------------
    #Initialize the game
    #------------------------------------
    GAME_NAME.init()
)

