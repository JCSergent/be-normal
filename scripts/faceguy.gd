extends Node3D

@onready var face: MeshInstance3D = %"alguien_nuevo-male_generic"

var curr_time: float = 0.0;
var prev_left_eye: Array[Dictionary] = []

func _process(delta: float) -> void:
    curr_time += delta;
    # Eyebrows
    var right_trigger = Input.get_action_strength("right_trigger")
    face.set_blend_shape_value(2, right_trigger)
    var left_trigger = Input.get_action_strength("left_trigger")
    face.set_blend_shape_value(3, left_trigger)
    
    # Blinking
    var right_bumper = Input.get_action_strength("right_bumper")
    if right_bumper == 0:
        face.set_blend_shape_value(0, -0.5)
    else:
        face.set_blend_shape_value(0, right_bumper)
    var left_bumper = Input.get_action_strength("left_bumper")
    if left_bumper == 0:
        face.set_blend_shape_value(1, -.5)
    else:
        face.set_blend_shape_value(1, left_bumper)

    # prev_left_eye.push_front({ value: left_bumper, time: curr_time})
    # if prev_left_eye.size() > 20:
    #     prev_left_eye.pop_back()

    # if left_bumper == 1:
        


    # Headshake
    var headshake = Input.get_vector("left_trigger_left", "left_trigger_right", "left_trigger_up", "left_trigger_down")
    face.set_blend_shape_value(7, headshake.y)
    face.set_blend_shape_value(8, clampf(1 * headshake.x, 0.0, 1.0))
    face.set_blend_shape_value(9, clampf(-1 * headshake.x, 0.0, 1.0))

    var mouth = Input.get_vector("right_trigger_left", "right_trigger_right", "right_trigger_up", "right_trigger_down")
    face.set_blend_shape_value(4, -1 * mouth.y)
    face.set_blend_shape_value(5, -1 * mouth.y)

    # Nostrils
    if Input.is_action_pressed("nostrils"):
        face.set_blend_shape_value(6, 1.0)
    else:
        face.set_blend_shape_value(6, -1.0)
