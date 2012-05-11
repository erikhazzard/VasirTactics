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
            '402190r90war': new GAME_NAME.Models.Player({
                name: 'Enoex'
                id: '402190r90war',
                spells: [
                    
                ],
                creatures: {
                    'toestubbergoblin1_xx': new GAME_NAME.Models.Creature({
                        name: 'Toestubber_Goblin_1'
                        location: {
                            x: 2,
                            y: 2
                        }
                    })
                }
            }),
            'u90r2h180f80n': new GAME_NAME.Models.Player({
                name: 'Enjalot'
                id: 'u90r2h180f80n'
                spells: [

                ],
                creatures: {
                    'toestubbergoblin2_xx': new GAME_NAME.Models.Creature({
                        name: 'Toestubber_Goblin_2'
                        location: {
                            x: 14,
                            y: 5
                        }
                    })
                }
            })
        }
    }

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
$(document).ready(()=>
    #------------------------------------
    #Async. load all sprites from the Renderer model
    #------------------------------------
    #Load assets 
    for key, val of GAME_NAME.Models.Renderer.prototype.defaults.sprites
        tmp_img = new Image()
        tmp_img.src = val

    #------------------------------------
    #Initialize the game
    #------------------------------------
    GAME_NAME.init()
)

