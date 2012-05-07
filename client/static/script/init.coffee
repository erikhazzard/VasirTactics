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
GAME_NAME.init()
