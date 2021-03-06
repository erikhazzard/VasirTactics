''' ========================================================================    
    init.js
    ----------------------
    Sets up page / UI related stuff and 
    ========================================================================'''
GAME_NAME.init = ()=>
    '''Kick off the game creation'''

    #TODO: Get game state from server (or start it fresh?
    #------------------------------------
    #SPELLS
    magicMissile = (params)=>
        #TODO: this would come from server
        #Todo: do some filter
        params = params || {}
        #get model
        model = params.model

        if model.get('className') != 'creature'
            GAME_NAME.logger.log('Spell', 'Could not cast magic missle. Invalid target')
            return false
        
        #Do 1 point of damage
        model.dealDamage(1)
        
        #--------------------------------
        #cell size
        cellSize = GAME_NAME.Models.Renderer.prototype.defaults.cellSize

        #Do the animation on the view
        target = params.target.append('svg:circle')
            .attr('r', 0)
            .attr('cx', cellSize.width/2)
            .attr('cy', cellSize.height/2)
            .style({
                opacity: 0.8
            })

        #Animate the 'missle'
        #TODO: Do a badass effect
        target.transition()
            .duration(1000)
            .attr('r', 40)
            .style({
                fill: '#dd2222'
            })
            .each('end', ()->
                target.transition()
                .duration(700)
                .style('fill', '#ff0000')
                .attr('r', 0)
                .each('end', ()->
                    target.transition()
                        .attr('r', 0)
                        .style('fill', 'none')
                        .remove()
                )
            )
    #Summon creature
    summonCreature = (params)=>
        #TODO: this would come from server
        #Params are passed in from spells.coffee
        #Todo: do some filter
        params = params || {}
        #get model
        model = params.model
 
        #--------------------------------
        #cell size
        cellSize = GAME_NAME.Models.Renderer.prototype.defaults.cellSize

        #Do the animation on the view
        targetCell = params.target.append('svg:circle')
            .attr('r', cellSize.width/1.8)
            .attr('cx', cellSize.width/2)
            .attr('cy', cellSize.height/2)
            .style('opacity', .9)
            .style('fill', '#6699cc')
            .transition()
                .duration(1000)
                .attr('r', 0)
                .style('fill', '#336699')
                .each('end', ()->
                    targetCell.transition()
                    .duration(700)
                    .style('fill', '#ffffff')
                    .attr('r', 0)
                    .each('end', ()->
                        targetCell.transition()
                        .attr('r', 0)
                        .style('fill', 'none')
                        .remove()
                    )
                )

        #Untarget everything
        #TODO: Could trigger a global event
        GAME_NAME.game.get('userInterface').set({target: undefined});

        #Create a create at the target
        summonedCreature = new GAME_NAME.Models.Creature({
            name: (Math.random()).toString(32)
            health: 10
            location: {
                x: model.get('x')
                y: model.get('y')
            }
            moves: 2
            movesLeft: 0
        })
        #Add creature
        GAME_NAME.game.get('activePlayer').get('creatures').add(summonedCreature)

        #Render the creature
        #TODO: should happen automatically on add events
        #TODO: should unrender automatically 
        GAME_NAME.game.get('renderer').drawCreature({ creature: summonedCreature })


    #------------------------------------
    #creature objects
    creatureEnoex = new GAME_NAME.Models.Creature({
        name: 'Enoex'
        health: 20
        location: {
            x: 2,
            y: 1
        }
    })

    creatureEnjalot = new GAME_NAME.Models.Creature({
        name: 'Enjalot'
        health: 20
        location: {
            x: 15,
            y: 1
        }
    })

    #Fake game state for now
    #------------------------------------
    game_state = {
        players: {
            'enoex': new GAME_NAME.Models.Player({
                name: 'Enoex'
                id: '402190r90war',
                spells: {
                    'magic_missile': new GAME_NAME.Models.Spell({
                        name: 'Magic Missile'
                        effect: magicMissile
                        contract: (params)=>
                            if params.model.get('className') != 'creature'
                                contract = {
                                    canCast: false,
                                    message: 'Can only cast on creatures or players'
                                }

                                return contract
                            else
                                return true
                    }),
                    'summon_knight': new GAME_NAME.Models.Spell({
                        name: 'Summon Creature'
                        effect: summonCreature
                        contract: (params)=>
                            if params.model.get('className') != 'cell'
                                return false
                            else
                                return true
                    })
                },
                creatures: new GAME_NAME.Collections.Creatures([
                    creatureEnoex
                ]),
                #creature the representation of the player on the game board
                creature: creatureEnoex
            }),
            'enjalot': new GAME_NAME.Models.Player({
                name: 'Enjalot'
                id: 'u90r2h180f80n'
                spells: {

                },
                creatures: new GAME_NAME.Collections.Creatures([
                    creatureEnjalot
                ]),
                creature: creatureEnjalot
            })
        }
    }

    #Set active player
    #   This changes when playing hotseat, but not when playing networked
    #   TODO: set from server, set above
    game_state.activePlayer = game_state.players.enoex

    #Create the game model
    #   Pass in the game state
    GAME_NAME.game = new GAME_NAME.Models.Game(
        game_state
    )

    #Render everything
    renderer = GAME_NAME.game.get('renderer')
    renderer.renderUI()
    renderer.render()

    return @

''' ========================================================================    
    Call init
    ========================================================================'''
#------------------------------------
#Async. load all sprites from the Renderer model
#   (Do this before DOM is ready)
#------------------------------------
#Load assets 
for key, val of GAME_NAME.Models.Renderer.prototype.defaults.sprites
    tmp_img = new Image()
    tmp_img.src = val

$(document).ready(()=>
    #TODO: Figure out what can be pulled out of this. Shouldn't have to wait
    #for DOM to create views / models
    #------------------------------------
    #Setup templates
    #------------------------------------
    #Target box
    GAME_NAME.templates.target_creature_mine = $(
        '#template_ui_target_creature_mine').html()
    GAME_NAME.templates.target_creature_theirs = $(
        '#template_ui_target_creature_theirs').html()
    GAME_NAME.templates.target_cell = $(
        '#template_ui_target_cell').html()

    #------------------------------------
    #Initialize the game
    #------------------------------------
    GAME_NAME.init()
)

