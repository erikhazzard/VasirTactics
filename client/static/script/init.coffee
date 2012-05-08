''' ========================================================================    
    init.js
    ----------------------
    Sets up page / UI related stuff and 
    ========================================================================'''
GAME_NAME.init = ()=>
    '''Kick off the game creation'''
    #Create the game model
    GAME_NAME.game = new GAME_NAME.Models.Game()

    #Render everything
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

