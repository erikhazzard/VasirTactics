''' ========================================================================    
    init.js
    ----------------------
    Sets up page / UI related stuff and 
    ========================================================================'''
GAME_NAME.init = ()=>
    '''Kick off the game creation'''
    #Example spell effect
    magicMissile = (target)=>
        #Todo: do some filter
        target.transition()
            .duration(1000)
            .attr('width', GAME_NAME.Models.Renderer.prototype.defaults.cellSize.width * 10)
            .attr('height', 5)
            .style('fill', '#dd2222')
                .transition()
                    .delay(1000)
                    .duration(1000)
                    .style('fill', '#ffffff')
                    .attr('height', GAME_NAME.Models.Renderer.prototype.defaults.cellSize.width)
                    .attr('width', GAME_NAME.Models.Renderer.prototype.defaults.cellSize.width)
                        .transition()
                            .delay(2000)
                            .style('fill', 'none')

    #TODO: Get game state
    #Fake game state for now
    game_state = {
        players: {
            'enoex': new GAME_NAME.Models.Player({
                name: 'Enoex'
                id: '402190r90war',
                spells: {
                    'magic_missile': new GAME_NAME.Models.Spell({
                        name: 'Magic Missile'
                        effect: magicMissile
                    }),
                    'summon_knight': new GAME_NAME.Models.Spell({
                        name: 'Summon Creature'
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

