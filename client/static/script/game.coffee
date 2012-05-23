''' ========================================================================    
    game.coffee

    Cotains the Game model.  A game is instaniated in init and contains
    a map, renderer, reference to players, creatures, etc.

    ======================================================================== '''
''' ========================================================================    
    Add logging types
    ======================================================================== '''
#Add a log type
GAME_NAME.logger.options.log_types.push('Game')
#Add it as a log type
GAME_NAME.logger.options.setup_log_types()

''' ========================================================================    
    
    Model    

    ======================================================================== '''
class GAME_NAME.Models.Game extends Backbone.Model
    defaults: {
        id: 'game_name_01',

        #Players contains a dict of player_id: Player object
        players: {
            playerID: {},
            playerID2: {}
        },

        #Reference to current player
        activePlayer: undefined,

        #Contains the Map object
        map: {}

        #Reference to renderer view
        renderer: {}

        #immutable JSON representation of game state
        _state: {}
    }

    initialize: ()=>
        '''Set everything up'''
        gameSetup = {}

        #Setup interaction (game interface, UI)
        gameSetup.interaction = new GAME_NAME.Models.Interface()
        gameSetup.interactionView = new GAME_NAME.Views.Interface({
            model: gameSetup.interaction
        })
        gameSetup.interactionView.render()
        
        #Setup map
        gameSetup.map = new GAME_NAME.Models.Map()

        #Setup renderer
        gameSetup.renderer = new GAME_NAME.Views.Renderer({
            game: @
        })

        #TODO: Get game state from server based on ID
        #Get map from server
        @set(gameSetup)

        return @

    getMap: ()=>
        '''This function will get the map from the server'''
