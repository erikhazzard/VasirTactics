''' ========================================================================    
    namespace.js
    ----------------------
   Sets up the namespace for our game, along with setting up any global
       util functions
    ========================================================================'''
#Global namespace
GAME_NAME = {
    #Events
    events: {}

    #Views and Model Classes
    Views: {},
    Models: {},

    #Game stuff
    #   game will contain the game model
    game: { },
    
    #Interface related stuff 
    #   (elements user interacts with on page, including
    #  engine action buttons)
    interface: {

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
