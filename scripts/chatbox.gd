extends HBoxContainer

@onready var messages: VBoxContainer = %Messages
var MESSAGE_SCENE = preload("res://scenes/message.tscn")

var current_message: Message

func _ready() -> void:
    show_message("chat_1")
    SignalBus.next_dialog.connect(_next_dialog)

func show_message(message_id: String) -> void:
    var message = MESSAGE_SCENE.instantiate();
    current_message = message

    var dialog = Dialog.DIALOGUE_DATA[message_id]
    message.add_text(dialog.text)

    if messages.get_child_count() > 7:
        pass

    messages.add_child(message)
    for choice in dialog.choices:
        message.add_choice(choice)


func _next_dialog(next_id: String, text: String) -> void:
    current_message.set_final_choice(text)
    show_message(next_id)


    
