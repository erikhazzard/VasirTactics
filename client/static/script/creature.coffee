''' ========================================================================    
    creature.coffee

    Contains the class definitions for creatures

    ======================================================================== '''
''' ========================================================================    
    Add logging types
    ======================================================================== '''
#Add a log type
GAME_NAME.logger.options.log_types.push('Creature')
#Add it as a log type
GAME_NAME.logger.options.setup_log_types()

''' ========================================================================    
    
    VIEW 

    ======================================================================== '''
class GAME_NAME.Views.Creature extends Backbone.View
    events: {
        'mouseenter': 'mouseEnter'
        'mouseleave': 'mouseLeave'
        'click': 'click'
    }

    initialize: ()=>
        '''This creature view is created in Renderer'''
        #It must pass in the associated model, cellSize, and target
        #   group to render to
        if @options.model == undefined or @options.renderer == undefined or @options.group == undefined
            GAME_NAME.logger.error('ERROR', 'creature view init(): params not properly passed in')
            return false

        #Set the model
        @model = @options.model

        #Store reference to passed in vars
        @renderer = @options.renderer
        @cellSize = @renderer.model.get('cellSize')
        @group = @options.group
        
        #Set el as an empty element, we'll create it in render()
        @el = {}

        return @

    render: (params)=>
        '''Handles the actual rendering / drawing of the creature'''

        #Get x,y of creature
        @x = @model.get('location').x * @cellSize.width
        @y = @model.get('location').y * @cellSize.height

        #When using SVG we only need to draw the entity once
        #The mapGroup will be set from drawMap
        creature_group = @group.append('svg:g')
            .attr('class', 'creature_' + @model.cid)
            .attr('transform', 'translate(' + [@x,@y] + ')')

        #Draw the background rect 
        bg_rect = creature_group.append('svg:rect')
            .attr('class', 'creature_background_rect')
            .attr('x', 0)
            .attr('y', 0)
            .attr('rx', 6)
            .attr('ry', 6)
            .attr('width', @cellSize.width)
            .attr('height', @cellSize.height)

        #Draw the creature image
        creature_group.append('svg:image')
            .attr('x', 0)
            .attr('y', 0)
            .attr('width', @cellSize.width)
            .attr('height', @cellSize.height)
            .attr('xlink:href', @renderer.model.get('sprites')[@model.get('sprite')])

        #Store ref to DOM node
        @el = creature_group.node()
        #Store ref to d3 selection 
        @$el = creature_group
        #Setup events, using the events listed above
        @delegateEvents()

    #------------------------------------
    #Events - User Interaction
    #------------------------------------
    click: ()=>
        #Update UI
        $('#game_target_name').html(@model.get(
            'name') + ' <br /> Health: ' + @model.get(
            'health'))
        return @

    mouseEnter: ()=>
        @$el.select('rect').attr('class', @$el.attr('class') + ' map_tile_mouse_over')
        return @

    mouseLeave: ()=>
        @$el.select('rect').attr('class', @$el.attr('class').replace(/\ map_tile_mouse_over/gi, ''))
        return @

''' ========================================================================    
    
    Model    

    ======================================================================== '''
class GAME_NAME.Models.Creature extends Backbone.Model
    defaults: {
        name: 'Toestubber'

        attack: 1,
        health: 1,
        
        #current target will point to a creature or player object
        target: {},

        #Effects contains effects this creature has
        effects: []

        #Abilities are activated or passive things this creature has
        abilities: []
        
        #Position properties
        #   Stores x,y
        location: {
            x: Math.round(Math.random() * 5),
            y: Math.round(Math.random() * 5)
        }

        #Sprite
        sprite: 'creature_dragoon',

        #Associated view
        view: undefined
    }

    initialize: ()=>
        return @
