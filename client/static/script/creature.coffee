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
    '''The Creature view. Handles drawing functions for the creatures'''

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
            x: Math.round(Math.random() * 10),
            y: Math.round(Math.random() * 10)
        }

        #Sprite
        sprite: 'creature_dragoon'

    }

    initialize: ()=>
        return @
