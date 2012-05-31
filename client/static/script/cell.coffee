''' ========================================================================    
    cell.coffee

    Contains the definition for individual cells that make up the map 
    ======================================================================== '''
''' ========================================================================    
    Add logging types
    ======================================================================== '''
#Add a log type
GAME_NAME.logger.options.log_types.push('Cell')
#Add it as a log type
GAME_NAME.logger.options.setup_log_types()

''' ========================================================================    
    
    View

    ======================================================================== '''
class GAME_NAME.Views.Cell extends Backbone.View
    events: {
        'click': 'click'
        'mouseover': 'mouseEnter'
        'mouseout': 'mouseLeave'
    }

    initialize: ()=>
        '''This cell view is created in Renderer'''
        #It must pass in the associated model, cellSize, and target
        #   group to render to
        if @options.model == undefined or @options.cellSize == undefined or @options.group == undefined
            GAME_NAME.logger.error('ERROR', 'cell view: params not properly passed in')
            return false

        #Create a model
        @model = @options.model

        #Listen for events
        #--------------------------------
        @model.on('cell:targeted', @target)
        @model.on('cell:enableCell', @enableCell)
        @model.on('spell:cast', @handleSpell)
        
        #Store reference to passed in vars
        @cellSize = @options.cellSize
        @group = @options.group

        #Create the element (but don't add it yet)
        @x = @model.get('x') * @cellSize.width
        @y = @model.get('y') * @cellSize.height
        @userInterface = GAME_NAME.game.get('userInterface')

        #Set el as an empty element, we'll create it in render()
        @el = {}

        return @

    #------------------------------------
    #util / helper
    #------------------------------------
    delegateSVGEvents: ()=>
        #Use d3.on to set events
        for key, val of @events
            @d3El.on(key, @[val])

        return @

    #------------------------------------
    #
    #render
    #
    #------------------------------------
    render: (params)=>
        '''Render creates the map tile cells and the group containing them
        Expects a renderer model object to be passed in'''
        params = params || {}
        if params.renderer == undefined
            GAME_NAME.logger.error('ERROR', 'cell render(): renderer not passed in')
            return false

        #TODO: Abstract this out so we can render individual cells
        
        #Draw the map cell
        #--------------------------------
        cellGroup = @group.append('svg:g')
            .attr('class', 'cellGroup cellGroup_' + @x + ',' + @y)
            .attr('transform', 'translate(' + [@x, @y] + ')')


        #--------------------------------
        #Draw the graphic
        #--------------------------------
        @baseSprite = cellGroup.append('svg:image')
            .attr('class', 'map_tile_image')
            .attr('x', 0)
            .attr('y', 0)
            .attr('width', @options.cellSize.width)
            .attr('height', @options.cellSize.height)
            .attr('xlink:href', params.renderer.get('sprites')[@model.get('baseSprite')])

        #If there is an overlay or top sprite on top of the base sprite
        if @model.get('topSprite')
            @topSprite = cellGroup.append('svg:image')
                .attr('class', 'map_tile_image_overlay')
                .attr('x', 0)
                .attr('y', 0)
                .attr('width', @options.cellSize.width)
                .attr('height', @options.cellSize.height)
                .attr('xlink:href', params.renderer.get('sprites')[@model.get('topSprite')])

        #Draw the rect / el
        #--------------------------------
        #el and @el will be the background rect (it may be invisible), which will take up
        #   100% width and height of the cell
        @cellRect = cellGroup.append('svg:rect')
            .attr('class', 'map_tile tile_' + @x + ',' + @y)
            .attr('x', 0)
            .attr('y', 0)
            .attr('width', @options.cellSize.width)
            .attr('height', @options.cellSize.height)

        #Store ref to DOM node
        @el = cellGroup.node()
        #Store ref to d3 selection 
        @d3El = cellGroup
        #Setup events, using the events listed above
        @delegateSVGEvents()

    #------------------------------------
    #Cell events
    #------------------------------------
    enableCell: ()=>
        #Turns off the tile_disabled class
        @cellRect.classed('tile_disabled', false)

    click: ()=>
        #Called when the cell:clicked event is triggered

        if not @userInterface.get('target') or @userInterface.get('target').get('className') != 'creature'
            #If no creature is targeted already, we can straight up target 
            #   the cell
            @userInterface.set({
                target: @model
                targetHtml: @targetHtml()
            })
        else
            #If a creature is already targeted, we need to do special logic
            #   e.g., move
            @userInterface.get('target').trigger('creature:move', {
                cell: @model
            })

    target: ()=>
        #Called when user clicks on a cell
        console.log('clicked')
        #Highlight this creature's background rect
        rect = @d3El.select('rect')
        rect.classed('map_tile_selected', true)
        return @

    mouseEnter: ()=>
        @cellRect.classed('map_tile_mouse_over', true)
        return @

    mouseLeave: ()=>
        @cellRect.classed('map_tile_mouse_over', false)
        return @

    #------------------------------------
    #UI Helper functions
    #------------------------------------
    targetHtml: ()=>
        #Renders the target box
        html = _.template(GAME_NAME.templates.target_cell)({
            name: @model.get('name').replace('_', ' ')
            health: ''
        })
        return html

    #------------------------------------
    #Spell handling
    #------------------------------------
    handleSpell: (params)=>
        #Called when a spell is casted on this creature,
        #   called from the spell:cast event
        #make sure the spell is passed in
        params = params || {}
        if not params.spell
            visually.logger.error('cell:handleSpell():',
                'no spell passed into handleSpell',
                'params: ', params)

        #Call the spell effect
        params.spell.get('effect')({target: @d3El, model: @model})

        return @

''' ========================================================================
    
    Model

    ======================================================================== '''
class GAME_NAME.Models.Cell extends Backbone.Model
    defaults: {
        #Default properties
        name: 'cell_i,j'
        className: 'cell'

        i: 0
        j: 0

        baseSprite: ''
        topSprite: ''

        type: '0'

        #Graphic contains the image to use for this cell
        graphic: ''
    }

    initialize: ()=>
        return @

    target: ()=>
        #When target() is called, trigger the cell:targeted event
        #   The view will listen for this event
        @trigger('cell:targeted')
        return @
