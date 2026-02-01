extends Node3D

@onready var camera: Camera3D = %Camera
@onready var flashlight: Node3D = %Flashlight
@onready var flashlight_light: SpotLight3D = %Flashlightlight
@onready var start_ui: HBoxContainer = %StartUI
@onready var chatbox: Chatbox = %Chatbox

const CAMERA_START_OFFSET: float = -1.0

var game_start: bool = false

func _ready() -> void:
    camera.position.x += CAMERA_START_OFFSET

func _process(_delta: float) -> void:
    if Input.is_action_just_pressed("sony_cross") or Input.is_action_just_pressed("sony_start"): #X button
        game_start = true
        start_ui.visible = false

        await get_tree().create_timer(0.5).timeout
        var flashlight_tween = create_tween()
        flashlight_tween.tween_property(flashlight, "position:y", 0.0, 0.5)
        flashlight_tween.tween_callback(blink_light)

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

    
