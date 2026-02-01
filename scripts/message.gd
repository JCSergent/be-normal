class_name Message
extends VBoxContainer

@export var message_text: String
@onready var message_label: Label = %MessageLabel
@onready var choices: HBoxContainer = %Choices
@onready var final_choice: RichTextLabel = %FinalChoice

var CHOICE_SCENE = preload("res://scenes/choice.tscn")

func _ready() -> void:
    message_label.text = message_text

func add_text(text: String) -> void:
    message_text = text

func add_choice(choice: Dictionary) -> void:
    var choice_node: Choice = CHOICE_SCENE.instantiate()
    choice_node.init(choice)
    choices.add_child(choice_node)

func set_final_choice(text: String) -> void:
    choices.visible = false
    choices.queue_free()
    final_choice.text = '[i]' + text + '[/i]'
    final_choice.visible = true
