extends Node3D

@onready var fly_model: Node3D = $fly_rescaled

const STATE_HOVERING = 0
const STATE_MOVING_CIRCLE = 1
const STATE_MOVING_FIGURE_EIGHT = 2
const STATE_LANDING_ON_YOU = 3
#@onready var current_state: int = STATE_HOVERING
@onready var current_state: int = STATE_MOVING_CIRCLE
@onready var current_state_elapsed_time: float = 0.0
@onready var fly_base_position: Vector3 = fly_model.global_position # reset this at the end of every state
@onready var current_state_duration: float = 2.0

@onready var motion_target: Vector3 = Vector3(fly_base_position.x + 2.0, fly_base_position.y, fly_base_position.z)
@onready var current_motion_elapsed_time: float = 0.0
@onready var motion_duration: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	motion_duration = randf_range(3.0, 5.0)

func set_new_state() -> void:
	current_state = randi_range(0, 3)
	print("Moving fly. Current position: (", fly_model.global_position.x, ", ", fly_model.global_position.y, ", ", fly_model.global_position.z, "). New fly state: ", current_state)
	current_state_elapsed_time = 0.0

func update_state(delta: float):
	current_state_elapsed_time += delta
	# change the direction the fly's facing pretty often
	if randi_range(0, 40) == 0:
		fly_model.rotate_z(randf_range(0, 2 * PI))
	
	if current_state == STATE_HOVERING:
		# fly bounces up and down by 0.1 units every 0.5s
		var decimal_part: float = current_state_elapsed_time - int(current_state_elapsed_time)
		fly_model.global_position = Vector3(fly_base_position.x, fly_base_position.y + (sin(2.0 * PI * decimal_part) / 20.0), fly_base_position.z)
		
		# TODO: Make the state last for a variable amount of time, not 2.0s every time	
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
		# TODO: Get position of eye and move toward that position over the period of 2s
		if current_state_elapsed_time >= 2.0:
			set_new_state()
			
func update_motion(delta: float):
	current_motion_elapsed_time += delta
	fly_model.global_position = fly_model.global_position.lerp(motion_target, (current_motion_elapsed_time / motion_duration))
	
	# motion target has been reached; set a new one
	if current_motion_elapsed_time >= motion_duration:
		fly_base_position = motion_target
		motion_target = Vector3(fly_base_position.x + randf_range(-1.0, 2.0), fly_base_position.y + randf_range(-1.0, 1.0), fly_base_position.z)
		current_motion_elapsed_time = 0.0
		motion_duration = randf_range(3.0, 5.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_state(delta)
	update_motion(delta)
