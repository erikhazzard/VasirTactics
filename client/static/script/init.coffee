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
                id: '402190r90war'
            }),
            'u90r2h180f80n': new GAME_NAME.Models.Player({
                name: 'Enjalot'
                id: 'u90r2h180f80n'
            })
        }
    }

    #Create the game model
    #   Pass in the game state
    GAME_NAME.game = new GAME_NAME.Models.Game(
        game_state
    )

    #Render everything
    GAME_NAME.game.get('renderer').renderUI()
    GAME_NAME.game.get('renderer').render()

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

