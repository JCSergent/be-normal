extends Control

@onready var ms_elapsed: float = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	ms_elapsed += delta
	
	# player has to look at the Game Over screen for 3 seconds before proceeding
	if ms_elapsed >= 3 and Input.is_action_just_released("sony_cross") or Input.is_action_just_released("sony_start"): #X button
		# Load & switch to next scene
		get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
