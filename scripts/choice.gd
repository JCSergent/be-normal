class_name Choice
extends Control

@export var choice_text: String
@onready var choice_label: Label = %ChoiceLabel

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
            requirements.push_front(requirement.duplicate())

func _on_face_update(face_state: Dictionary):
    for requirement in requirements:
        var face_action = face_state[requirement.face_state]
        if typeof(face_action) == TYPE_BOOL and face_action:
            requirement.amount -= 1
            if requirement.amount <= 0:
                SignalBus.next_dialog.emit(next_id, choice_text)
        if typeof(face_action) == TYPE_FLOAT and face_action > 0.0:
            requirement.amount -= face_action
            if requirement.amount <= 0:
                SignalBus.next_dialog.emit(next_id, choice_text)
    
