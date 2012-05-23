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
        @model.on('cell:renderUI', @renderUI)
        
        #Store reference to passed in vars
        @cellSize = @options.cellSize
        @group = @options.group

        #Create the element (but don't add it yet)
        @x = @model.get('x') * @cellSize.width
        @y = @model.get('y') * @cellSize.height
        @interaction = GAME_NAME.game.get('interaction')

        #Set el as an empty element, we'll create it in render()
        @el = {}

        return @

    #------------------------------------
    #util / helper
    #------------------------------------
    delegateSVGEvents: ()=>
        #Use d3.on to set events
        for key, val of @events
            @svgEl.on(key, @[val])

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
        @tile_group = @group.append('svg:g')
            .attr('class', 'tile_group tile_group_' + @x + ',' + @y)
            .attr('transform', 'translate(' + [@x, @y] + ')')


        #--------------------------------
        #Draw the graphic
        #--------------------------------
        @baseSprite = @tile_group.append('svg:image')
            .attr('class', 'map_tile_image')
            .attr('x', 0)
            .attr('y', 0)
            .attr('width', @options.cellSize.width)
            .attr('height', @options.cellSize.height)
            .attr('xlink:href', params.renderer.get('sprites')[@model.get('baseSprite')])

        #If there is an overlay or top sprite on top of the base sprite
        if @model.get('topSprite')
            @topSprite = @tile_group.append('svg:image')
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
        el = @tile_group.append('svg:rect')
            .attr('class', 'map_tile tile_' + @x + ',' + @y)
            .attr('x', 0)
            .attr('y', 0)
            .attr('width', @options.cellSize.width)
            .attr('height', @options.cellSize.height)

        #Store ref to DOM node
        @el = el.node()
        #Store ref to d3 selection 
        @svgEl = el
        #Setup events, using the events listed above
        @delegateSVGEvents()


    #------------------------------------
    #Cell events
    #------------------------------------
    click: ()=>
        #Called when the cell:clicked event is triggered

        if not @interaction.get('target') or @interaction.get('target').get('className') != 'creature'
            #If no creature is targeted already, we can straight up target 
            #   the cell
            @interaction.set({
                target: @model
                targetHtml: @targetHtml()
            })
        else
            #If a creature is already targeted, we need to do special logic
            #   e.g., move
            #TODO: Do this a better way - pass in X,Y to creature's
            #   CAN MOVE function
            if not @svgEl.classed('tile_disabled')
                @interaction.get('target').move({
                    cell: @model
                })

    target: ()=>
        #Called when user clicks on a cell
        return @

    mouseEnter: ()=>
        @svgEl.classed('map_tile_mouse_over', true)
        return @

    mouseLeave: ()=>
        @svgEl.classed('map_tile_mouse_over', false)
        return @

    #------------------------------------
    #UI Helper functions
    #------------------------------------
    targetHtml: ()=>
        #Renders the target box
        html = _.template(GAME_NAME.templates.target)({
            name: @model.get('name')
            health: ''
        })
        return html

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
        
    #------------------------------------
    #Heler UI Functions
    #------------------------------------
    renderUI: ()=>
        #trigger the view's renderUI function
        @trigger('cell:renderUI')
