class_name Dialog
extends Node

const DIALOGUE_DATA = {
    # Each conversation entry is managed as Dictionary with unique ID as key
    "intro_1": {
        "wait": 2,
        "text": "An stranger approaches you in the woods...",
        "next_id": "intro_2"
    },
    "intro_2": {
        "wait": 2,
        "text": "Stay calm... Be normal...",
        "next_id": "chat_1"
    },
    "chat_1": {
        "text": "Whats with you... can't take a flashlight to the face? Blink it off, won't you.",
        "time": -1,
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
        "text": "There you go, you'll be fine. Feel better?",
        "time": -1,
        "choices": [
            {
                "text": "Nod Yes...",
                "next_id": "chat_3",
                "requirements": [
                    { "face_state": "is_head_nod_v", "amount": 3 }
                ]
            },
        ]
    },
    "chat_3": {
        "text": "What are you doing out here? Haven't you heard what's going on?",
        "time": -1,
        "choices": [
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
        "text": "These are dark times, I hate to be the one to tell you.",
        "time": -1,
        "choices": [
            {
                "text": "Frown...",
                "next_id": "chat_5",
                "requirements": [
                    { "face_state": "is_frowning", "amount": 30 }
                ]
            }
        ]
    },
    "chat_5": {
        "text": "Some kids have gone missing, in these very woods.",
        "time": -1,
        "choices": [
            {
                "text": "Smile...",
                "is_bad": true,
                "next_id": "intro_3",
                "requirements": [
                    { "face_state": "is_smiling", "amount": 30 }
                ]
            }
        ]
    },
    "intro_3": {
        "wait": 2,
        "text": "The stranger didn't like that reaction.",
        "next_id": "chat_6"
    },
    "chat_6": {
        "text": "Did you hear me, son... We're losing children out here!",
        "time": -1,
        "choices": [
            {
                "text": "Look Shocked...",
                "next_id": "chat_7",
                "requirements": [
                    { "face_state": "is_shocked", "amount": 60 }
                ]
            }
        ]
    },
    "chat_7": {
        "text": "Here we go",
        "time": -1,
        "choices": [
            {
                "text": "Look Disgusted...",
                "next_id": "chat_3",
                "requirements": [
                    { "face_state": "is_disgust", "amount": 60 }
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
