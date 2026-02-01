class_name Chatbox
extends HBoxContainer

@onready var messages: VBoxContainer = %Messages
@onready var time_remaining: ProgressBar = %TimeRemaining
@onready var suspicion_bar: ProgressBar = %SuspicionBar
var MESSAGE_SCENE = preload("res://scenes/message.tscn")
const SUSPICION_INCREASE: int = 20

var current_message: Message
var using_timer = false

var is_done_intro = false
var has_won = false
var time = 25
var available_quiz_ids: Array[int] = []

func _ready() -> void:
    SignalBus.next_dialog.connect(_next_dialog)

func _process(delta) -> void:
    if using_timer:
        time_remaining.value -= delta
        if time_remaining.value <= 0.0:
            _next_dialog(current_message.next_id, "fail")

func start() -> void:
    is_done_intro = false
    has_won = false
    time = 20
    for i in Dialog.QUIZ.size():
        available_quiz_ids.push_front(i)
    var dialog = Dialog.INTRO["intro_1"]
    # var dialog = Dialog.INTRO["chat_9"]
    show_message(dialog)

func show_message(dialog: Dictionary) -> void:
    var message = MESSAGE_SCENE.instantiate();
    current_message = message

    # Reduce opacity for existing messages
    for child in messages.get_children():
        child.modulate.a -= 0.25
        if child.modulate.a <= 0.0:
            child.queue_free()

    messages.add_child(message)
    message.add_text(dialog.text, "" if !dialog.has("next_id") else dialog.next_id, true if dialog.has("wait") else false)

    if dialog.has("choices"):
        for choice in dialog.choices:
            message.add_choice(choice)

    if is_done_intro and not has_won:

        # Every 5 quiz answers, reduce time to answer
        if (Dialog.QUIZ.size() - available_quiz_ids.size()) % 5 == 0:
            time = max(10, time - 5)

        time_remaining.max_value = time
        time_remaining.value = time
        using_timer = true
    elif dialog.has("time") and dialog.time > 0:
        time_remaining.max_value = dialog.time
        time_remaining.value = dialog.time
        using_timer = true
    else:
        using_timer = false
        time_remaining.value = 0

    if dialog.has("wait"):
        await get_tree().create_timer(dialog.wait).timeout
        _next_dialog(dialog.next_id, dialog.text, true)

func _next_dialog(next_id: String, text: String, skip_final_choice: bool = false) -> void:
    if not skip_final_choice:
        current_message.set_final_choice(text)

    if text == 'fail':
        suspicion_bar.value += SUSPICION_INCREASE
    else:
        # suspicion_bar.value = max(0, suspicion_bar.value - 5)
        pass

    if next_id == 'win':
        return
        
    if next_id == 'quiz':
        is_done_intro = true

    if not is_done_intro or has_won:
        var dialog = Dialog.INTRO[next_id]
        show_message(dialog)
    else:
        if available_quiz_ids.size() <= 0:
            # WIN STATE
            time = 0
            var dialog = Dialog.INTRO["win_0"]
            has_won = true
            show_message(dialog)
        else:
            var new_id: int = available_quiz_ids.pick_random()
            available_quiz_ids = available_quiz_ids.filter(func out(id): return id != new_id)

            print(available_quiz_ids)

            var dialog = Dialog.QUIZ.get(new_id)
            show_message(dialog)
