class_name Dialog
extends Node

const DIALOGUE_DATA = {
    # Each conversation entry is managed as Dictionary with unique ID as key
    "chat_1": {
        "speaker": "Officer Bartley",
        "text": "Blink, so I know your alive.",
        "choices": [
            {
                "text": "Blink...",
                "next_id": "chat_2",
                "requirements": [
                    { "face_state": "is_blinking", "amount": 3 }
                ]
            }
        ]
    },
    "chat_2": {
        "text": "Are you okay, son?",
        "choices": [
            {
                "text": "Nod Yes...",
                "next_id": "chat_4",
                "requirements": [
                    { "face_state": "is_head_nod_v", "amount": 3 }
                ]
            },
            {
                "text": "Nod No...",
                "next_id": "chat_4",
                "requirements": [
                    { "face_state": "is_head_nod_h", "amount": 3 }
                ]
            }
        ]
    },
    "chat_3": {
        "text": "Are you hurt?",
        "choices": [
            {
                "text": "Nod Yes...",
                "next_id": "chat_4",
                "requirements": [
                    { "face_state": "is_head_nod_v", "amount": 3 }
                ]
            },
            {
                "text": "Nod No...",
                "next_id": "chat_4",
                "requirements": [
                    { "face_state": "is_head_nod_h", "amount": 3 }
                ]
            }
        ]
    },
    "chat_4": {
        "text": "Smile for me, hot stuff.",
        "choices": [
            {
                "text": "Smile...",
                "next_id": "chat_5",
                "requirements": [
                    { "face_state": "is_smiling", "amount": 30 }
                ]
            }
        ]
    },
    "chat_5": {
        "text": "Now frown.",
        "choices": [
            {
                "text": "Frown...",
                "next_id": "chat_6",
                "requirements": [
                    { "face_state": "is_frowning", "amount": 30 }
                ]
            }
        ]
    },
    "chat_6": {
        "text": "There's been a dead body found out here",
        "choices": [
            {
                "text": "Look Shocked...",
                "next_id": "chat_7",
                "requirements": [
                    { "face_state": "is_shocked", "amount": 30 }
                ]
            }
        ]
    },
    "chat_7": {
        "text": "Do you like death?",
        "choices": [
            {
                "text": "Look Disgusted...",
                "next_id": "chat_3",
                "requirements": [
                    { "face_state": "is_disgust", "amount": 30 }
                ]
            }
        ]
    }
    # ... other dialogue data
}


# const INTRO = {
#     "speaker": "You",
#     "intro_1": {
#         "text": "You awake on the forest floor. The body you are in is unfamiliar. You know it is not yours.",
#         "choices": [],
#         "timer": { "duration": "5", "next_id": "intro_2" }
#     },
#     "intro_2": {
#         "text": "You decide to test what it's capable of. Let the eyelids sink shut.",
#         "choices": [{"text": "Blink...", "next_id": "intro_3"}]
#     },
#     "intro_3": {
#         "text": "It feels wrong, but works nonetheless. Next, stretch the neck. Feel it strain.",
#         "choices": [
#             {"text": "Nod Yes...", "next_id": "intro_4"},
#             {"text": "Nod No...", "next_id": "intro_4"},
#         ]
#     },
# }
