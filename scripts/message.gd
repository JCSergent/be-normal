class_name Message
extends VBoxContainer

@export var message_text: String
@onready var message_label: Label = %MessageLabel
@onready var choices: HBoxContainer = %Choices

var CHOICE_SCENE = preload("res://scenes/choice.tscn")

func _ready() -> void:
    message_label.text = message_text

func add_text(text: String) -> void:
    message_text = text

func add_choice(text: String) -> void:
    var choice: Choice = CHOICE_SCENE.instantiate()
    choice.add_text(text)
    choices.add_child(choice)
