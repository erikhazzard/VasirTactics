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
        'click': 'target'
    }

    initialize: ()=>
        '''This creature view is created in Renderer'''
        #It must pass in the associated model, cellSize, and target
        #   group to render to
        if @options.model == undefined or @options.game == undefined or @options.group == undefined
            GAME_NAME.logger.error('ERROR', 'creature view init(): params not properly passed in')
            return false

        #Set the model
        @model = @options.model

        #Store reference to passed in vars
        @game = @options.game
        @map = @options.game.get('map')
        @renderer = @options.game.get('renderer')
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

        return @

    #------------------------------------
    #Events - User Interaction
    #------------------------------------
    target: ()=>
        '''Targets this creature.  Updates the UI and
            darkens the immovable map cells'''
        #Update UI
        $('#game_target_name').html(@model.get(
            'name') + ' <br /> Health: ' + @model.get(
            'health'))

        #Remove the map_tile_selected class from all elements that
        #   have it
        selectedEls = d3.selectAll('.map_tile_selected')
        for el in selectedEls[0]
            curEl = d3.select(el)
            curEl.attr('class',
                curEl.attr('class').replace(/map_tile_selected/gi, ''))

        #Darken all the map cells
        mapTiles = d3.selectAll('.map_tile')
            .attr('class', (d,i)->
                return d3.select(@).attr('class') + ' tile_disabled'
            )

        #Highlight the map cells that the creature can move to
        #TODO: Put this in web worker
        #TODO: Code the real logic for this, not just this fake stub
        for i in [2..4]
            for j in [2..4]
                cell = @map.get('cells')[i + ',' + j].get('view').$el
                cell.attr('class',
                    cell.attr('class').replace(/tile_disabled/gi,'')
                )


        #Highlight this creature's background rect
        rect = @$el.select('rect')
        rect.attr('class',
            rect.attr('class') + ' map_tile_selected')

        #TODO: Move updateTarget logic to a method in renderer?
        #@renderer.updateTarget({
        #    rect: @$el.select('rect')
        #})
        return @

    mouseEnter: ()=>
        rect = @$el.select('rect')
        rect.attr('class',
            rect.attr('class') + ' map_tile_mouse_over')
        return @

    mouseLeave: ()=>
        #TODO: Fix this
        rect = @$el.select('rect')
        rect.attr('class',
            rect.attr('class').replace(/map_tile_mouse_over/gi, ''))
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
