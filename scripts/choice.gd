class_name Choice
extends Control

@export var choice_text: String
@onready var choice_label: Label = %ChoiceLabel
@onready var progress_bar: ProgressBar = %ProgressBar

var next_id: String
var requirements: Array = []

func _ready() -> void:
    choice_label.text = choice_text
    SignalBus.face_state.connect(_on_face_update)

func init(choice: Dictionary) -> void:
    choice_text = choice.text
    next_id = choice.next_id
    if choice.has("requirements"):
        for requirement in choice.requirements:
            var requirement_dup = requirement.duplicate()
            requirement_dup.get_or_add("progress", 0.0)
            requirements.push_front(requirement_dup)

func _on_face_update(face_state: Dictionary):
    for requirement in requirements:
        var face_action = face_state[requirement.face_state]
        if typeof(face_action) == TYPE_BOOL and face_action:
            requirement.progress += 1
            if requirement.amount <= requirement.progress:
                SignalBus.next_dialog.emit(next_id, choice_text)
        elif typeof(face_action) == TYPE_FLOAT and face_action > 0.0:
            requirement.progress += face_action
            if requirement.amount <= requirement.progress:
                SignalBus.next_dialog.emit(next_id, choice_text)
        else:
            if requirement.progress > 0.0:
                requirement.progress -= 0.01
        progress_bar.value = requirement.progress / requirement.amount
    
