class_name Choice
extends PanelContainer

@export var choice_text: String
@onready var choice_label: Label = %ChoiceLabel

func _ready() -> void:
    choice_label.text = choice_text

func add_text(text: String) -> void:
    choice_text = text
