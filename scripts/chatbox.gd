extends HBoxContainer

@onready var messages: VBoxContainer = %Messages
var MESSAGE_SCENE = preload("res://scenes/message.tscn")


func _ready() -> void:
    show_message("chat_1")


func show_message(message_id: String):
    var message = MESSAGE_SCENE.instantiate();
    var dialog = Dialog.DIALOGUE_DATA[message_id]
    message.add_text(dialog.text)
    messages.add_child(message)
    for choice in dialog.choices:
        message.add_choice(choice.text)

    
