extends Node3D

@onready var camera: Camera3D = %Camera
@onready var flashlight: Node3D = %Flashlight
@onready var flashlight_light: SpotLight3D = %Flashlightlight
@onready var start_ui: HBoxContainer = %StartUI
@onready var chatbox: Chatbox = %Chatbox
@onready var fly_model: Node3D = $fly_rescaled
@onready var nose_marker: Marker3D = $NoseMarker

const STATE_HOVERING = 0
const STATE_MOVING_CIRCLE = 1
const STATE_MOVING_FIGURE_EIGHT = 2
const STATE_LANDING_ON_YOU = 3
const STATE_MOVING = 4
const STATE_SITTING_ON_YOU = 5
const STATE_LEAVING_FRAME = 6

@onready var current_state: int = STATE_MOVING
@onready var current_state_elapsed_time: float = 0.0
@onready var fly_base_position: Vector3 = fly_model.global_position
@onready var fly_goal_position: Vector3 = Vector3(fly_base_position.x + 2.0, fly_base_position.y + 0.3, fly_base_position.z)

const CAMERA_START_OFFSET: float = -1.0

var game_start: bool = false

func _ready() -> void:
    camera.position.x += CAMERA_START_OFFSET

func _process(_delta: float) -> void:
    update_state(_delta)
    if not game_start and Input.is_action_just_pressed("sony_cross") or Input.is_action_just_pressed("sony_start"): #X button
        game_start = true
        start_ui.visible = false

        await get_tree().create_timer(0.5).timeout
        var flashlight_tween = create_tween()
        flashlight_tween.tween_property(flashlight, "position:y", 0.0, 0.5)
        flashlight_tween.tween_callback(blink_light)

func set_new_state() -> void:
    current_state = randi_range(0, 4)
    fly_base_position = fly_model.global_position
    print("Moving fly. Current position: (", fly_model.global_position.x, ", ", fly_model.global_position.y, ", ", fly_model.global_position.z, "). New fly state: ", current_state)
    current_state_elapsed_time = 0.0
    if current_state == STATE_MOVING:
        fly_goal_position = Vector3(fly_base_position.x + randf_range(-1.0, 1.0), fly_base_position.y + randf_range(-1.0, 1.0), fly_base_position.z)

func update_state(delta: float):
    current_state_elapsed_time += delta
    # change the direction the fly's facing pretty often
    if randi_range(0, 40) == 0:
        fly_model.rotate_z(randf_range(0, 2 * PI))
    
    if current_state == STATE_HOVERING:
        # fly bounces up and down by 0.1 units every 0.5s
        var decimal_part: float = current_state_elapsed_time - int(current_state_elapsed_time)
        fly_model.global_position = Vector3(fly_base_position.x, fly_base_position.y + (sin(2.0 * PI * decimal_part) / 20.0), fly_base_position.z)
        
        if current_state_elapsed_time >= 2.0:
            set_new_state()
    elif current_state == STATE_MOVING_CIRCLE:
        fly_model.global_position = Vector3(fly_base_position.x + sin(PI * current_state_elapsed_time) * 0.1, fly_base_position.y + cos(PI * current_state_elapsed_time) * 0.1, fly_base_position.z)
        #fly_model.rotate_z(-(delta * PI))
        
        if current_state_elapsed_time >= 2.0:
            set_new_state()
    elif current_state == STATE_MOVING_FIGURE_EIGHT:
        var x_offset: float = current_state_elapsed_time / 4.0 if current_state_elapsed_time < 2.0 else 0.5 - ((current_state_elapsed_time - 2.0) / 4.0)
        fly_model.global_position = Vector3(fly_base_position.x + x_offset, fly_base_position.y + sin(PI * current_state_elapsed_time) * 0.1, fly_base_position.z)
        
        if current_state_elapsed_time >= 4.0:
            set_new_state()
    elif current_state == STATE_LANDING_ON_YOU:
        var default_nose_marker_pos = Vector3(0.0, 1.077, 1.771) # TODO: Pull this value from the faceguy model
        default_nose_marker_pos = nose_marker.position
        fly_model.global_position = fly_model.global_position.lerp(default_nose_marker_pos, current_state_elapsed_time / 5.0)
        
        if current_state_elapsed_time >= 5.0:
            print("Fly landed on you")
            fly_base_position = fly_model.global_position
            current_state = STATE_SITTING_ON_YOU
    elif current_state == STATE_MOVING:
        fly_model.global_position = fly_base_position.lerp(fly_goal_position, current_state_elapsed_time / 3.0)
        
        if current_state_elapsed_time >= 3.0:
            set_new_state()
    elif current_state == STATE_SITTING_ON_YOU:
        # TODO: Fly away as a reaction to the player flaring nostrils
        if Input.is_action_just_pressed("sony_cross"): # when you flare your nostrils, the fly flies away
        #if current_state_elapsed_time >= 3.0: # after 3 seconds, the fly flies away
            current_state = STATE_LEAVING_FRAME
            current_state_elapsed_time = 0.0
            print("Fly is leaving")
    elif current_state == STATE_LEAVING_FRAME:
        var offscreen_pos = Vector3(3.0, 0.7, 2.0)
        fly_model.global_position = fly_base_position.lerp(offscreen_pos, current_state_elapsed_time / 3.0)
        
        #if current_state_elapsed_time >= 3.0:
            #print("Fly escaped")

func blink_light() -> void:
    await get_tree().create_timer(0.7).timeout
    flashlight_light.visible = true
    await get_tree().create_timer(0.3).timeout
    flashlight_light.visible = false
    await get_tree().create_timer(0.5).timeout
    flashlight_light.visible = true
    await get_tree().create_timer(0.3).timeout

    var camera_tween = create_tween().set_parallel(true)
    camera_tween.tween_property(camera, "position:x", camera.position.x - CAMERA_START_OFFSET, 0.5)
    camera_tween.tween_property(chatbox, "modulate:a", 1.0, 0.5)
    camera_tween.tween_callback(start_game)

func start_game() -> void:
    await get_tree().create_timer(0.8).timeout
    chatbox.start()

    
