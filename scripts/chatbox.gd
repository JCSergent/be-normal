class_name Chatbox
extends HBoxContainer

@onready var messages: VBoxContainer = %Messages
@onready var time_remaining: ProgressBar = %TimeRemaining
@onready var suspicion_bar: ProgressBar = %SuspicionBar
var MESSAGE_SCENE = preload("res://scenes/message.tscn")

var current_message: Message
var started = false

func _ready() -> void:
    # show_message("chat_1")
    SignalBus.next_dialog.connect(_next_dialog)

func _process(delta) -> void:
    if started:
        time_remaining.value -= delta
        if time_remaining.value <= 0.0:
            _next_dialog(current_message.default_next_id, "fail")
            suspicion_bar.value += 20

func start() -> void:
    show_message("chat_1")
    started = true
    

func show_message(message_id: String) -> void:
    var message = MESSAGE_SCENE.instantiate();
    current_message = message

    var dialog = Dialog.DIALOGUE_DATA[message_id]
    message.add_text(dialog.text)

    for child in messages.get_children():
        child.modulate.a -= 0.25
        if child.modulate.a <= 0.0:
            child.queue_free()

    messages.add_child(message)
    for choice in dialog.choices:
        message.add_choice(choice)

    time_remaining.max_value = dialog.time
    time_remaining.value = dialog.time


func _next_dialog(next_id: String, text: String) -> void:
    current_message.set_final_choice(text)
    show_message(next_id)
    suspicion_bar.value = max(0, suspicion_bar.value - 5)


    
