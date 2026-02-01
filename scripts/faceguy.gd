extends Node3D

@onready var face: MeshInstance3D = %"alguien_nuevo-male_generic"
@onready var suspicionBar: ProgressBar = %SuspicionBar

var curr_time: float = 0.0;

var prev_left_eye: Array[Dictionary] = []
var is_left_winking: float = 0.0
var prev_right_eye: Array[Dictionary] = []
var is_right_winking: float = 0.0
const WINKING_DURATION: float = 0.1
var blink_buffer: bool = false;


const HEADNOD_DURATION: float = 0.1
const HEADNOD_THRESHOLD: float = 0.5
var prev_head_h: Array[Dictionary] = []
var headnod_h_buffer: float = 0.0
var prev_head_v: Array[Dictionary] = []
var headnod_v_buffer: float = 0.0

func _process(delta: float) -> void:
    curr_time += delta;

    # Eyebrows
    var right_trigger = Input.get_action_strength("right_trigger")
    face.set_blend_shape_value(2, right_trigger)
    var left_trigger = Input.get_action_strength("left_trigger")
    face.set_blend_shape_value(3, left_trigger)

    var is_eyebrow_right_raised: bool = false
    if right_trigger > 0.5: is_eyebrow_right_raised = true
    var is_eyebrow_left_raised: bool = false
    if left_trigger > 0.5: is_eyebrow_left_raised = true

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

    # Track Left Eye Winking
    if prev_left_eye.size() == 0 or prev_left_eye[0].value != left_bumper:
        prev_left_eye.push_front({ "value": left_bumper, "time": curr_time})
        if prev_left_eye.size() > 10: prev_left_eye.pop_back()
        # If opening eye, mark as a wink
        if left_bumper == 0.0 and prev_left_eye.size() != 1: is_left_winking = WINKING_DURATION;
    if is_left_winking > 0: is_left_winking -= delta

    # Track Right Eye Winking
    if prev_right_eye.size() == 0 or prev_right_eye[0].value != right_bumper:
        prev_right_eye.push_front({ "value": right_bumper, "time": curr_time})
        if prev_right_eye.size() > 10: prev_right_eye.pop_back()
        # If opening eye, mark as a wink
        if right_bumper == 0.0 and prev_right_eye.size() != 1: is_right_winking = WINKING_DURATION;
    if is_right_winking > 0: is_right_winking -= delta

    var is_blinking: bool = !blink_buffer and is_right_winking > 0.0 and is_left_winking > 0.0
    if is_blinking: blink_buffer = true
    if blink_buffer and is_right_winking <= 0.0 and is_left_winking <= 0.0:
        blink_buffer = false
        
    # Move Mouth
    var mouth = Input.get_vector("right_trigger_left", "right_trigger_right", "right_trigger_up", "right_trigger_down")
    face.set_blend_shape_value(4, -1 * mouth.y)
    face.set_blend_shape_value(5, -1 * mouth.y)
    face.set_blend_shape_value(10, mouth.x)
    face.set_blend_shape_value(11, mouth.x)
    var is_mouth_open = true if mouth.x > 0.5 else false

    var is_smiling = false
    if mouth.y < -0.5: is_smiling = true
    var is_frowning = false
    if mouth.y > 0.5: is_frowning = true

    # Headshake
    var headshake = Input.get_vector("left_trigger_left", "left_trigger_right", "left_trigger_up", "left_trigger_down")
    face.set_blend_shape_value(7, headshake.y)
    face.set_blend_shape_value(8, clampf(1 * headshake.x, 0.0, 1.0))
    face.set_blend_shape_value(9, clampf(-1 * headshake.x, 0.0, 1.0))

    var is_head_up = false
    if headshake.y < -HEADNOD_THRESHOLD: is_head_up = true
    var is_head_down = false
    if headshake.y > HEADNOD_THRESHOLD: is_head_down = true

    # Track Head Nod Horizontally
    var is_head_nod_h: bool = false
    if headshake.x > HEADNOD_THRESHOLD or headshake.x < -HEADNOD_THRESHOLD:
        headnod_h_buffer = HEADNOD_DURATION
        if prev_head_h.size() == 0 or prev_head_h[0].value < -HEADNOD_THRESHOLD && headshake.x > HEADNOD_THRESHOLD or prev_head_h[0].value > HEADNOD_THRESHOLD && headshake.x < -HEADNOD_THRESHOLD:
            prev_head_h.push_front({"value": headshake.x, "time": curr_time})
            if prev_head_h.size() >= 2:
                is_head_nod_h = true
                prev_head_h.clear()
    elif headnod_h_buffer > 0.0:
        headnod_h_buffer -= delta
    elif headnod_h_buffer <= 0.0:
        prev_head_h.clear()

    # Track Head Nod Vertically
    var is_head_nod_v: bool = false
    if headshake.y > HEADNOD_THRESHOLD or headshake.y < -HEADNOD_THRESHOLD:
        headnod_v_buffer = HEADNOD_DURATION
        if prev_head_v.size() == 0 or prev_head_v[0].value < -HEADNOD_THRESHOLD && headshake.y > HEADNOD_THRESHOLD or prev_head_v[0].value > HEADNOD_THRESHOLD && headshake.y < -HEADNOD_THRESHOLD:
            prev_head_v.push_front({"value": headshake.y, "time": curr_time})
            if prev_head_v.size() >= 2:
                is_head_nod_v = true
                prev_head_v.clear()
    elif headnod_v_buffer > 0.0:
        headnod_v_buffer -= delta
    elif headnod_v_buffer <= 0.0:
        prev_head_v.clear()

    # Nostrils
    var is_nostrils_flared = false
    if Input.is_action_pressed("nostrils"):
        is_nostrils_flared = true
        face.set_blend_shape_value(6, 1.0)
    else:
        face.set_blend_shape_value(6, -1.0)

    var is_ears_out = false
    var ear_out = 0.0
    if Input.is_action_pressed("left_ear"):
        ear_out -= 0.5
    if Input.is_action_pressed("right_ear"):
        ear_out -= 0.5

    if ear_out < 0.0: is_ears_out = true
    face.set_blend_shape_value(12, ear_out)


    # Calculate Shock
    var is_shocked = 0.0
    if is_mouth_open: is_shocked += 0.1
    if is_eyebrow_left_raised: is_shocked += 0.1
    if is_eyebrow_right_raised: is_shocked += 0.1

    # Calculate Disgust
    var is_disgust = 0.0
    if is_mouth_open: is_shocked += 0.1
    if is_frowning:
        is_disgust += 0.1
        if is_head_up: is_disgust += 0.1
        if right_bumper and left_bumper: is_disgust += 0.1

    var is_suspicious = 0.0
    if is_eyebrow_left_raised or is_eyebrow_right_raised and not (is_eyebrow_left_raised and is_eyebrow_right_raised): is_suspicious += 0.15
    if is_head_down or is_head_up: is_suspicious += 0.1

    var is_fear = 0.0
    if is_mouth_open: is_fear += 0.1
    if is_frowning:
        is_disgust += 0.1
        if is_head_up: is_fear += 0.1
        if right_bumper and left_bumper: is_fear += 0.1

    var is_bliss = 0.0
    if is_frowning: is_bliss -= 0.1
    if is_mouth_open and is_smiling: is_bliss += 0.1
    if right_bumper and left_bumper: is_bliss += 0.1
    if right_bumper and left_bumper: is_bliss += 0.1
    if is_head_up: is_bliss += 0.1
    is_bliss = max(0, is_bliss)

    var is_angry = 0.0
    if is_frowning: is_angry += 0.1
    if is_head_down: is_angry += 0.05

    var is_flirty = 0.0
    if is_smiling:
        is_flirty += 0.1
        if right_bumper or left_bumper and not (right_bumper and left_bumper): is_flirty += 0.05
        if is_head_down: is_flirty += 0.05

    var is_scared = 0.0
    if is_mouth_open and not is_smiling: is_scared += 0.1
    if is_eyebrow_left_raised: is_scared += 0.05
    if is_eyebrow_right_raised: is_scared += 0.05


    SignalBus.face_state.emit({
        "is_blinking": is_blinking,
        "is_head_nod_h": is_head_nod_h,
        "is_head_nod_v": is_head_nod_v,
        "is_smiling": 0.3 if is_smiling else 0.0,
        "is_frowning": 0.3 if is_frowning else 0.0,
        "is_nostrils_flared": is_nostrils_flared,
        "is_eyebrow_right_raised": is_eyebrow_right_raised,
        "is_eyebrow_left_raised": is_eyebrow_left_raised,
        "is_shocked": is_shocked,
        "is_disgust": is_disgust,
        "is_scared": is_scared,
        "is_bliss": is_bliss,
        "is_suspicious": is_suspicious,
        "is_fear": is_fear,
        "is_flirty": is_flirty,
        "is_angry": is_angry

        # TODO: Add remaining face state
    })
