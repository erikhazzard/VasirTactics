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

        #Contains a Map object
        map: {}

    }

    initialize: ()=>
        return @
