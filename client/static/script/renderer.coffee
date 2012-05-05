''' ========================================================================    
    renderer.coffee

    Handles the actual drawing / rendering of the game

    ======================================================================== '''
''' ========================================================================    
    Add logging types
    ======================================================================== '''
#Add a log type
GAME_NAME.logger.options.log_types.push('Render')
#Add it as a log type
GAME_NAME.logger.options.setup_log_types()

''' ========================================================================    

    Renderer

    ======================================================================== '''
class GAME_NAME.Views.Renderer extends Backbone.View
    el: '#canvas_game'

    #------------------------------------
    #Events
    #------------------------------------
    events: {}

    #------------------------------------
    #Functions
    #------------------------------------
    init: ()=>
        #Setup the renderer
        this.game = GAME_NAME.game
        this.$el = d3.select('canvas_game')
        
    drawEntity: (entity)=>
        '''Draws the passed in entity on the screen'''

        #When using SVG we only need to draw the entity once


''' ========================================================================    

    Model

    ======================================================================== '''
class GAME_NAME.Views.Renderer extends Backbone.Model
    '''Keeps track of the renderer state'''
    defaults: {
    }

    initialze: ()=>
        return @
