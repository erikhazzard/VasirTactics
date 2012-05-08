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
        #Remove everything in the SVG
        $(@$el.node()).empty()

        #Draw the background map
        @drawMap({
            map: @model.get('game').get('map')
        })

        @drawCreature({
            creature: new GAME_NAME.Models.Creature({})
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
        @mapGroup = @$el.append('svg:g')
            .attr('class', 'game_map')
        mapTileGroup = @mapGroup.append('svg:g')
            .attr('class', 'map_tiles')

        #TODO: Abstract this into Map.render?
        #Loop through each cell of the map and draw it
        for key, val of @model.get('game').get('map').get('cells')
            cell = new GAME_NAME.Views.Cell({
                model: val
                cellSize: @model.get('cellSize')
                group: mapTileGroup
            })
            
            #Add the cell view to the model
            val.set({
                'view': cell
            })

            #Draw it
            cell.render({renderer: @model})

        #Notify the logger we're finished
        GAME_NAME.logger.Render('renderer: map rendering complete')

    #------------------------------------
    #draw creature 
    #------------------------------------
    drawCreature: (params)=>
        '''Draws the passed in entity on the screen. Params expects a
        creature model to be passed in'''
        #Params should take in a Creature model
        params = params || {}
        if params.creature == undefined
            GAME_NAME.logger.error('ERROR! renderer view: drawCreature(): creature not passed in')
            return false
        
        #Get x,y of creature
        x = params.creature.get('location').x * @model.get('cellSize').width
        y = params.creature.get('location').y * @model.get('cellSize').height

        #When using SVG we only need to draw the entity once
        #The mapGroup will be set from drawMap
        creature_group = @mapGroup.append('svg:g')
            .attr('class', 'creature_' + params.creature.cid)
            .attr('transform', 'translate(' + [x,y] + ')')

        #Draw the background rect 
        creature_group.append('svg:rect')
            .attr('class', 'creature_background_rect')
            .attr('x', 0)
            .attr('y', 0)
            .attr('width', @model.get('cellSize').width)
            .attr('height', @model.get('cellSize').height)

        #Draw the creature image
        creature_group.append('svg:image')
            .attr('x', 0)
            .attr('y', 0)
            .attr('width', @model.get('cellSize').width)
            .attr('height', @model.get('cellSize').height)
            .attr('xlink:href', @model.get('sprites')[params.creature.get('sprite')])

        #Finished!
        return @


''' ========================================================================    

    Model

    ======================================================================== '''
class GAME_NAME.Models.Renderer extends Backbone.Model
    '''Keeps track of the renderer state'''

    #TODO: Pre load all images
    defaults: {

        #--------------------------------
        #Map Related
        #--------------------------------
        cellSize: {
            height: 48,
            width: 48
        },
        #--------------------------------
        #Sprites
        #--------------------------------
        sprites: {
            #Terrain / map
            'terrain_0': '/static/image/sprites/map/grass_bg.png',
            'terrain_1': '/static/image/sprites/map/blue_grass.jpg'
            'terrain_2': '/static/image/sprites/map/road.jpg'

            #Obstacles
            'rock': '/static/image/sprites/map/rock.png'

            #Characters
            'creature_dragoon': '/static/image/sprites/creatures/dragoon.png'
        }

    }

    #------------------------------------
    #
    #Functions
    #
    #------------------------------------
    initialize: ()=>
        '''When this renderer model is instaniated, store a reference to the
        game object'''

        return @
