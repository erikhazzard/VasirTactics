/* ========================================================================    
 *
 * engine_canvas.js
 * ----------------------
 *
 *  Handles canvas things
 *
 * ======================================================================== */
//============================================================================
//Extend Main App Object
//============================================================================
GAME_NAME.canvas = {
    //HTML element related
    height: undefined,
    width: undefined,

    //Canvas object related
    _canvas: undefined,
    context: undefined,

    functions: {
        clear: undefined,
        draw_entities: undefined,
        init: undefined,
        render: undefined,
        util: {
            draw_rect: undefined
        }
    },
    run_game: undefined
};

//============================================================================
//
//Util Functions
//
//============================================================================
//---------------------------------------
//clear()
//-------
//Clears the canvas
//---------------------------------------
GAME_NAME.canvas.functions.clear = function(){
    //Clear everything
    GAME_NAME.canvas.context.clearRect(
        0,
        0,
        GAME_NAME.canvas.width,
        GAME_NAME.canvas.height);

}
//---------------------------------------
//draw_rect( PARAMS({x,y,w,h}) ):
//-------------
//-Draws a rectangle
//---------------------------------------
GAME_NAME.canvas.functions.util.draw_rect = function(params, y, w, h, color){
    if( typeof params === 'object' ){
        var x = params.x;
        var y = params.y;
        var w = params.w;
        var h = params.h;
        var color = params.color;
    }else if(typeof params === 'number'){
        var x = params;
    }

    if(color === undefined){
        color = '#232323';
    }

    //Get context
    var ctx = GAME_NAME.canvas.context;
    ctx.beginPath();
    ctx.fillStyle = color;
    ctx.fillRect(x,y,w,h);
    ctx.closePath();
    ctx.fill();

    return true;
};

//---------------------------------------
//draw_sprite( PARAMS({x,y,w,h}) ):
//-------------
//-Draws a rectangle
//---------------------------------------
GAME_NAME.canvas.functions.util.draw_sprite = function(params){
    params = params || {}

    var ctx = GAME_NAME.canvas.context,
        engine_canvas = GAME_NAME.canvas;

    if(params.x === undefined || params.y === undefined){
        GAME_NAME.ERRORS.create({
            message: 'No x or y passed into draw_sprite',
            type: 'ERROR'
        });
        return false;
    }

    //Get the sprite position
    sprite_num = params.sprite_num || 0;
    sprite_num = ( (sprite_num % 6) * 5 );

    ctx.drawImage(
        engine_canvas.entities_images[0],
        //sx, sy
        26 * sprite_num, 0,
        //width, height
        26, 44, 
        params.x,
        params.y, 
        26, 44);

    return true;
};
//============================================================================
//
//General Canvas Functions
//
//============================================================================
//---------------------------------------
//draw_entities( ):
//-------------
//Draws all the entities the client knows about
//---------------------------------------
GAME_NAME.canvas.functions.draw_entities = function(){
    //We'll need to loop through all the entities and draw them to the canvas
    var cur_entity = undefined,
        ctx = GAME_NAME.canvas._canvas.getContext('2d'),
        engine_canvas = GAME_NAME.canvas,
        x,y;

    for(i in GAME_NAME.entities){
        if(i !== undefined){
            cur_entity = GAME_NAME.entities[i];
            //Make sure current entity data has been retrieved from server
            //  (Because the response may take 50 ms, this draw_entity will be called
            //  before the data is sent back to client)
            if(cur_entity.persona !== undefined){

                /* OLD - Generate colored squares
                //Generate a color based on entity personality
                var color_r = Math.abs(cur_entity.persona.extraversion
                    + cur_entity.persona.neuroticism);
                var color_g = Math.abs(cur_entity.persona.conscientiousness);
                var color_b = Math.abs(cur_entity.persona.agreeableness
                    + cur_entity.persona.openness);
            
                //Get hex value
                color_r = color_r.toString(16) + '0';
                color_r = color_r.substring(0,2);
                color_g = color_g.toString(16) + '0';
                color_g = color_g.substring(0,2);
                color_b = color_b.toString(16) + '0';
                color_b = color_b.substring(0,2);

                var color = '#' + color_r + color_g + color_b;

                //Draw a rect representing the entity
                engine_canvas.functions.util.draw_rect({
                    x: cur_entity.position[0] 
                        * engine_canvas.config.entity_cell_position_modifier,
                    y: cur_entity.position[1]  
                        * engine_canvas.config.entity_cell_position_modifier,
                    w: engine_canvas.config.entity_width,
                    h: engine_canvas.config.entity_height,
                    color: color
                });
                */

                //TODO: Use subpixel stuff (check http://seb.ly/2011/02/html5-canvas-sprite-optimisation/ )
                x = cur_entity.position[0] 
                    * engine_canvas.config.entity_cell_position_modifier,
                y = cur_entity.position[1]  
                    * engine_canvas.config.entity_cell_position_modifier,
           
                engine_canvas.functions.util.draw_sprite({
                    entity: cur_entity,
                    x: x,
                    y: y,
                    sprite_num: parseInt(cur_entity.id.replace(/[^0-9]/g, ''),10)
                });

                //If the entity is selected by the user, draw another 
                //  'target' rect
                if(GAME_NAME.selected_entity !== undefined 
                    && GAME_NAME.selected_entity == i){
                        engine_canvas.functions.util.draw_rect({
                            x: (cur_entity.position[0]
                                * engine_canvas.config.entity_cell_position_modifier) + 1, 
                            y: (cur_entity.position[1]
                                * engine_canvas.config.entity_cell_position_modifier) + 1,
                            w: engine_canvas.config.entity_width - 2,
                            h: engine_canvas.config.entity_height - 2,
                            color: '#efefef'
                        });
                }
            }
        }
    }
}

//============================================================================
//
//Mouse Related Events
//
//============================================================================
//---------------------------------------
//select_entity({ event }):
//-------------
//Called when the click event is fired on the canvas.  Loops through entities
//  and selects the entity if the mouse is over it
//---------------------------------------
GAME_NAME.canvas.functions.select_entity = function(params, event_type){
    //first parameter should be an event object, second parameter (if not set in
    //  passed in params object), is the 'type' - a string that is either
    //  'click' or 'hover'
    if( typeof params === 'object' ){
        if(params.e !== undefined){
            var e = params.e;
            var event_type = params.event_type
        }else{
            var e = params;
        }
    }else{
        var e = params;
    }

    //Unregister event
    $(document).off('keyup', GAME_NAME.functions.keydown_show_info_window);

    //Get mouse position from passed in event
    var mouse_position = {x: e.offsetX, y: e.offsetY};
    var cur_entity, pos_x, pos_y = undefined;

    //Loop through each entity and determine if entity was clicked
    for(i in GAME_NAME.entities){
        if(i !== undefined){
            if(GAME_NAME.entities[i].position !== undefined){
                cur_entity = GAME_NAME.entities[i];

                //Store the current position
                pos_x = cur_entity.position[0] 
                    * GAME_NAME.canvas.config.entity_cell_position_modifier;
                pos_y = cur_entity.position[1] 
                    * GAME_NAME.canvas.config.entity_cell_position_modifier;
                 
                //Determine if mouse is in between the entity's x,y origin
                //  and their width, height
                if( (mouse_position.x >= pos_x &&
                    mouse_position.x <= (pos_x + 
                                        GAME_NAME.canvas.config.entity_width)
                    ) &&
                    ( mouse_position.y >= pos_y &&
                      mouse_position.y <= (pos_y + 
                                        GAME_NAME.canvas.config.entity_height)
                    )
                ){
                    //If this is a select event, set the target entity
                    if(event_type === 'click'){
                        //If they are not in 'SET TARGET' mode (meaning an entity
                        //  already selected and they are setting the targeted
                        //  entity's target)
                        //Also, pressing shift key will enable entity's target
                        //  selection mode
                        if(GAME_NAME.selection_mode === null 
                            && e.shiftKey !== true){
                            GAME_NAME.functions.set_selected_entity({
                                entity_id: cur_entity.id
                            });
                        }else if(GAME_NAME.selection_mode ===
                            'entity_target' || e.shiftKey === true){
                            GAME_NAME.functions.set_entity_target({
                                'target_entity_id': cur_entity.id 
                            });
                        }
                    }
                    //Register handler to show entity info when pressing i
                    $(document).on('keyup', GAME_NAME.functions.keydown_show_info_window);

                    //Entity was found, return it
                    return cur_entity.id;
                }
            }
        }
    }
}


//============================================================================
//
//Init and Render Functions
//
//============================================================================
//---------------------------------------
//init( ):
//-------------
//Sets up all the canvas stuff
//---------------------------------------
GAME_NAME.canvas.functions.init = function(){
    var engine_canvas = GAME_NAME.canvas;
    //Get canvas object
    engine_canvas._canvas = $('#canvas')[0];
    engine_canvas.height = parseInt($('#canvas').css('height'));
    engine_canvas.width = parseInt($('#canvas').css('width'));

    //Get the context object
    engine_canvas.context = engine_canvas._canvas.getContext('2d');

    //-----------------------------------
    //Add events
    //-----------------------------------
    $(engine_canvas._canvas).bind('click', function(e){
        GAME_NAME.canvas.functions.select_entity({
            e: e,
            event_type: 'click'
        });
    });

    //-----------------------------------
    //Setup the interval that the canvas will be refreshed at
    //-----------------------------------
    engine_canvas.run_game= function(){
        var engine_canvas = GAME_NAME.canvas;
        requestAnimFrame(engine_canvas.run_game);
        engine_canvas.functions.render();
    };

    //-----------------------------------
    //Load entity images
    //-----------------------------------
    //TODO: load a giant image, then split it up for each entity
    engine_canvas.entities_images = [
        new Image()
    ];
    engine_canvas.entities_images[0].src = 'static/image/entities/entities_sheet_1.png';
    
    //Call it
    engine_canvas.entities_images[0].onload = function(){
        var engine_canvas = GAME_NAME.canvas;
        engine_canvas.run_game();
    };

    return true;
}

//---------------------------------------
//draw( ):
//-------------
//Handles the actual drawing of the canvas
//---------------------------------------
GAME_NAME.canvas.functions.render = function(){
    //Get the context object, store a reference so it's easier to work with
    var engine_canvas = GAME_NAME.canvas;
    //Remove everything
    engine_canvas.functions.clear();

    //Draw entities
    engine_canvas.context.fillStyle = '#232323';
    engine_canvas.functions.draw_entities();
}
