class_name Chatbox
extends HBoxContainer

@onready var messages: VBoxContainer = %Messages
@onready var time_remaining: ProgressBar = %TimeRemaining
@onready var suspicion_bar: ProgressBar = %SuspicionBar
var MESSAGE_SCENE = preload("res://scenes/message.tscn")
const SUSPICION_INCREASE: int = 20

var current_message: Message
var using_timer = false

func _ready() -> void:
    SignalBus.next_dialog.connect(_next_dialog)

func _process(delta) -> void:
    if using_timer:
        time_remaining.value -= delta
        if time_remaining.value <= 0.0:
            _next_dialog(current_message.default_next_id, "fail")

func start() -> void:
    show_message("intro_1")

func show_message(message_id: String) -> void:
    var message = MESSAGE_SCENE.instantiate();
    current_message = message

    # Reduce opacity for existing messages
    for child in messages.get_children():
        child.modulate.a -= 0.25
        if child.modulate.a <= 0.0:
            child.queue_free()

    var dialog = Dialog.DIALOGUE_DATA[message_id]

    messages.add_child(message)
    message.add_text(dialog.text, true if dialog.has("wait") else false)

    if dialog.has("choices"):
        for choice in dialog.choices:
            message.add_choice(choice)

    if dialog.has("time") and dialog.time > 0:
        time_remaining.max_value = dialog.time
        time_remaining.value = dialog.time
        using_timer = true
    else:
        using_timer = false
        time_remaining.value = 0

    if dialog.has("wait"):
        await get_tree().create_timer(dialog.wait).timeout
        show_message(dialog.next_id)

func _next_dialog(next_id: String, text: String) -> void:
    current_message.set_final_choice(text)
    show_message(next_id)
    if text == 'fail':
        suspicion_bar.value += SUSPICION_INCREASE
    else:
        suspicion_bar.value = max(0, suspicion_bar.value - 5)
