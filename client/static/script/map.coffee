''' ========================================================================    
    map.coffee

    Contains the definition for map, which is retrieved from server and made
    up of cells.  A Map object is made up of map cells and the Map
    is owned by the Game object

    ======================================================================== '''
''' ========================================================================    
    Add logging types
    ======================================================================== '''
#Add a log type
GAME_NAME.logger.options.log_types.push('Map')
#Add it as a log type
GAME_NAME.logger.options.setup_log_types()

''' ========================================================================    
    
    Model    

    ======================================================================== '''
class GAME_NAME.Models.Map extends Backbone.Model
    defaults: {
        #Default properties
        name: 'Faydwer'

        #map is the raw map json returned from the server
        #   Each cell is formatted lie [ [{}, {}], [{}, {}] ] 
        #   (example of a 2x2 grid). The contents of each cell
        #   returned from the server represent a cell's parameters,
        #   which get passed into the Cell class.
        map: [
            [ {}, {} ],
            [ {}, {} ]
        ]
        #Cells
        #   Cells contains a dictionary of cell objects, keys being 
        #   i,j. e.g.,
        #       cells['0,4'] = [Cell Object]
        cells: {}
    }

    initialize: ()=>
        '''A Map object is created in the Game class'''
        #Create some map tiles
        @set({
            map: @randomizeMap()
        })

        #When map is created, create its cells based on the map array
        @setupCells({map:@map})

        return @

    randomizeMap: ()=>
        map = []

        #TODO: Get rid of this
        for i in [0..16]
            #Reset the row
            row = []
            for j in [0..8]
                #Create object for cell
                randNum = Math.round(Math.random() * 3)
                tmpRow = {
                    baseSprite: 'terrain_' + Math.round(Math.random() * 1)
                    topSprite: [undefined, undefined, undefined, 'rock'][randNum]
                    canPass: ['all', 'ground', 'ground', 'air'][randNum]
                }
                
                #Push this row to the map
                row.push(tmpRow)
            #Add row to the map tiles
            map.push(row)
        
        return map

    setupCells: (params)=>
        '''Setup the game cells.  This is called from init and
            the cells are setup based on this model's map array
            Takes in a array of cells '''
        #Setup params
        params = params || {}
        params.map = params.map || @get('map')
        #Counter variables
        i=0
        j=0

        #We'll setup the cells locally, then set it to the map object after
        #   creating it
        cells = {}

        #Loop through cells
        for row in params.map
            #Reset j to 0
            j=0
            #Go through each column
            for cell in row
                #create a new Cell object for each cell
                cells[i + ',' + j] = new GAME_NAME.Models.Cell({
                    name: 'cell_' + i + ',' + j
                    x: i,
                    y: j,
                    baseSprite: cell.baseSprite
                    topSprite: cell.topSprite
                    type: cell.type
                    canPass: cell.canPass
                })
                #Increase counter variables
                j++

            #increase row counter variable
            i++

        #Set the Map's cells
        @set({cells: cells})
        GAME_NAME.logger.Map('MAP: cells set, cells: ', @get('cells'))
