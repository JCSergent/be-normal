class_name Message
extends VBoxContainer

@export var message_text: String
@onready var message_label: Label = %MessageLabel
@onready var choices: HBoxContainer = %Choices
@onready var speaker: RichTextLabel = %Speaker
@onready var final_choice: RichTextLabel = %FinalChoice
@onready var fail_choice: RichTextLabel = %FailChoice

var CHOICE_SCENE = preload("res://scenes/choice.tscn")

var default_next_id: String = ''

func add_text(text: String, flavor: bool) -> void:
    if flavor:
        choices.visible = false
        message_label.visible = false
        speaker.visible = true
        speaker.text = '[i]' + text + '[/i]'
    else:
        message_text = text
        message_label.text = message_text

func add_choice(choice: Dictionary) -> void:
    var choice_node: Choice = CHOICE_SCENE.instantiate()
    choices.add_child(choice_node)
    choice_node.init(choice)
    if default_next_id == '':
        default_next_id = choice.next_id

func set_final_choice(text: String) -> void:
    choices.visible = false
    choices.queue_free()

    if text == 'fail':
        fail_choice.text = '[i]He grows suspicious...[/i]'
        fail_choice.visible = true
    else:
        final_choice.text = '[i]' + text + '[/i]'
        final_choice.visible = true
