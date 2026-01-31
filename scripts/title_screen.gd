extends Control


# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_released("sony_cross") or Input.is_action_just_released("sony_start"): #X button
		# Load & switch to next scene
		get_tree().change_scene_to_file("res://scenes/Head.tscn")
