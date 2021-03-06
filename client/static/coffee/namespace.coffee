''' ========================================================================    
    namespace.js
    ----------------------
   Sets up the namespace for our game, along with setting up any global
       util functions
    ========================================================================'''
#Global namespace
GAME_NAME = (()=>
    return {
        #Events (Extended from Backbone.Events)
        #   This is our global event dispatcher
        events: _.extend({}, Backbone.Events)

        #Views and Model Classes
        Views: {},
        Models: {},
        Collections: {},

        #Game stuff
        #   game will contain the game model
        game: undefined,
        
        #Interface related stuff 
        #   (elements user interacts with on page, including
        #  engine action buttons)
        userInterface: undefined,

        #Logger util
        logger: undefined,

        #Init function called to kick everything off,
        #  overridden in init.js
        init: undefined,

        util: undefined

        #Store HTML template text.
        #   Will be pulled from DOM when the page loads
        templates: {}
    }

)()

#Store global ref to it
window.GAME_NAME = GAME_NAME

''' ========================================================================    
    
    Global Util Functions

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
