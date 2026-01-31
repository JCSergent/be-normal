extends Node

const DIALOGUE_DATA = {
    # Each conversation entry is managed as Dictionary with unique ID as key
    "chat_1": {
        "text": "Blink, so I know you're alive.",
        "choices": [
            {"text": "Blink...", "next_id": "chat_2"},
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
