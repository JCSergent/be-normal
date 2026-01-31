class_name Dialog
extends Node

const DIALOGUE_DATA = {
    # Each conversation entry is managed as Dictionary with unique ID as key
    "chat_1": {
        "speaker": "Officer Bartley",
        "text": "Blink, so I know your alive.",
        "choices": [
            {"text": "Blink...", "next_id": "chat_2"}
        ]
    },
    "chat_2": {
        "text": "Can you speak?",
        "choices": [
            {"text": "Yes...", "next_id": "chat_3"},
            {"text": "No...", "next_id": "chat_3"},
        ]
    },
    # ... other dialogue data
}


const INTRO = {
    "speaker": "You",
    "intro_1": {
        "text": "You awake on the forest floor. The body you are in is unfamiliar. You know it is not yours.",
        "choices": [],
        "timer": { "duration": "5", "next_id": "intro_2" }
    },
    "intro_2": {
        "text": "You decide to test what it's capable of. Let the eyelids sink shut.",
        "choices": [{"text": "Blink...", "next_id": "intro_3"}]
    },
    "intro_3": {
        "text": "It feels wrong, but works nonetheless. Next, stretch the neck. Feel it strain.",
        "choices": [
            {"text": "Nod Yes...", "next_id": "intro_4"},
            {"text": "Nod No...", "next_id": "intro_4"},
        ]
    },
}
