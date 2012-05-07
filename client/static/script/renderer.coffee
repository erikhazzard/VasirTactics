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
    #
    #Functions
    #
    #------------------------------------
    initialize: ()=>
        '''Create the renderer view.  This should be called from game.js'''
        #Game must be passed in from options
        if @options.game == undefined
            GAME_NAME.logger.error('ERROR! renderer view: options.game not set, pass in game!')
            return false

        #Create Renderer model
        @model = new GAME_NAME.Models.Renderer({
            game: @options.game
        })

        #Setup this element
        @$el = d3.select('#game_canvas')

    render: ()=>
        '''This draws all the elements of the game to the screen'''
        #Draw the background map
        @drawMap({
            map: @model.get('game').get('map')
        })

        #TODO: Draw creatures, entities, etc. based on game state
        
    #------------------------------------
    #draw map
    #------------------------------------
    drawMap: (map)=>
        '''This draws the map by rendering each map tile individually'''
        #TODO: Some sort of caching?
        #TODO: Abstract this out?
        
        #Create the map group
        mapGroup = @$el.append('svg:g')
            .attr('class', 'game_map')

        #Loop through each cell of the map and draw it
        for key, val of @model.get('game').get('map').get('cells')
            cell = new GAME_NAME.Views.Cell({
                model: val
                cellSize: @model.get('cellSize')
                group: mapGroup
            })
            
            #Add the cell view to the model
            val.set({
                'view': cell
            })

            #Draw it
            cell.render()

        #Notify the logger we're finished
        GAME_NAME.logger.Render('renderer: map rendering complete')
    #------------------------------------
    #draw entity 
    #------------------------------------
    drawEntity: (entity)=>
        '''Draws the passed in entity on the screen'''

        #When using SVG we only need to draw the entity once
        

''' ========================================================================    

    Model

    ======================================================================== '''
class GAME_NAME.Models.Renderer extends Backbone.Model
    '''Keeps track of the renderer state'''
    defaults: {
        cellSize: {
            height: 42,
            width: 42
        }
    }

    initialize: ()=>
        '''When this renderer model is instaniated, store a reference to the
        game object'''

        return @
