''' ========================================================================    
    namespace.js
    ----------------------
   Sets up the namespace for our game, along with setting up any global
       util functions
    ========================================================================'''
#Global namespace
GAME_NAME = {
    #Views and Model Classes
    Views: {},
    Models: {},

    #Game stuff
    game: {
        #State is retrieved from server and sent back to server for checks.  
        #  If client sends bad state to server, server will disconnect them
        _state: {},
        
        #Used to render the game
        render: ()-> {}
    },
    
    #Page functions (elements user interacts with on page, including
    #  engine action buttons)
    page_functions: {

    },

    #Logger util
    logger: {},

    #Init function called to kick everything off,
    #  overridden in init.js
    init: ()->{}
}

#Store global ref to it
window.GAME_NAME = GAME_NAME

''' ========================================================================    
    
    Global Functions

    ========================================================================'''
window.requestAnimFrame = (()->
  return  window.requestAnimationFrame       ||
          window.webkitRequestAnimationFrame ||
          window.mozRequestAnimationFrame    ||
          window.oRequestAnimationFrame      ||
          window.msRequestAnimationFrame     ||
          (callback, element)->
            window.setTimeout(callback, 1000 / 60)
)()
