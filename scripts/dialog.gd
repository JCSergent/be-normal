class_name Dialog
extends Node

const INTRO = {
    # Each conversation entry is managed as Dictionary with unique ID as key
    "intro_1": {
        "wait": 2,
        "text": "A stranger approaches you in the woods...",
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
        "next_id": "chat_2",
        "choices": [
            {
                "text": "Blink...",
                "requirements": [
                    { "face_state": "is_blinking", "amount": 3 }
                ]
            }
        ]
    },
    "chat_2": {
        "text": "There you go, you'll be fine. Feel better?",
        "time": -1,
        "next_id": "chat_3",
        "choices": [
            {
                "text": "Nod Yes...",
                "requirements": [
                    { "face_state": "is_head_nod_v", "amount": 3 }
                ]
            },
        ]
    },
    "chat_3": {
        "text": "What are you doing out here? Haven't you heard what's going on?",
        "time": -1,
        "next_id": "chat_4",
        "choices": [
            {
                "text": "Nod No...",
                "requirements": [
                    { "face_state": "is_head_nod_h", "amount": 3 }
                ]
            }
        ]
    },
    "chat_4": {
        "text": "These are dark times, I hate to be the one to tell you.",
        "time": -1,
        "next_id": "chat_5",
        "choices": [
            {
                "text": "Frown...",
                "requirements": [
                    { "face_state": "is_frowning", "amount": 30 }
                ]
            }
        ]
    },
    "chat_5": {
        "text": "Some kids have gone missing, in these very woods.",
        "time": -1,
        "next_id": "intro_3",
        "choices": [
            {
                "text": "Smile...",
                "is_bad": true,
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
        "next_id": "chat_7",
        "choices": [
            {
                "text": "Look Shocked...",
                "requirements": [
                    { "face_state": "is_shocked", "amount": 60 }
                ]
            }
        ]
    },
    "chat_7": {
        "text": "You wouldn't know anything about that, would you?",
        "time": -1,
        "next_id": "chat_8",
        "choices": [
            {
                "text": "Look Disgusted...",
                "requirements": [
                    { "face_state": "is_disgust", "amount": 60 }
                ]
            }
        ]
    },
    "chat_8": {
        "text": "These disappearances are no accident either, the mayor says evil work is at play.",
        "time": -1,
        "next_id": "chat_9",
        "choices": [
            {
                "text": "Look Scared...",
                "requirements": [
                    { "face_state": "is_scared", "amount": 60 }
                ]
            }
        ]
    },
    "chat_9": {
        "text": "I'm going to have to test you now, son. Prove your good intentioned, you ready?",
        "time": -1,
        "next_id": "intro_4",
        "choices": [
            {
                "text": "Nod Yes...",
                "requirements": [
                    { "face_state": "is_head_nod_v", "amount": 3 }
                ]
            }
        ]
    },
    "intro_4": {
        "wait": 2,
        "text": "I better react quick. His patience seems short.",
        "next_id": "quiz"
    },
    # ... other dialogue data
    "win_0": {
        "wait": 2,
        "text": "Looks like he's finally run out of questions.",
        "next_id": "win_1"
    },

    "win_1": {
        "text": "You're an odd duck, but is suppose you're harmless. I'll let you be now.",
        "time": -1,
        "next_id": "win_2",
        "choices": [
            {
                "text": "Smile...",
                "requirements": [
                    { "face_state": "is_smiling", "amount": 30 }
                ]
            }
        ]
    },
    "win_2": {
        "wait": 2,
        "text": "CONGRATULATIONS! You Won!",
        "next_id": "win_3"
    },
    "win_3": {
        "wait": 2,
        "text": "Thanks for playing!",
        "next_id": "win_screen"
    },
}


const QUIZ = [
    {
        "text": "Can you love?",
        "choices": [
            {
                "text": "Nod Yes...",
                "requirements": [
                    { "face_state": "is_head_nod_v", "amount": 6 }
                ]
            },
            {
                "text": "Nod No...",
                "is_bad": true,
                "requirements": [
                    { "face_state": "is_head_nod_h", "amount": 3 }
                ]
            }
        ]
    },
    {
        "text": "Imagine a happy place.",
        "choices": [
            {
                "text": "Look Blissful...",
                "requirements": [
                    { "face_state": "is_bliss", "amount": 60 }
                ]
            }
        ]
    },
    {
        "text": "QUICK! You see a bear!",
        "choices": [
            {
                "text": "Show fear...",
                "requirements": [
                    { "face_state": "is_fear", "amount": 60 }
                ]
            }
        ]
    },
    {
        "text": "The love of your life approaches you... Tell them how you feel.",
        "choices": [
            {
                "text": "Get flirty...",
                "requirements": [
                    { "face_state": "is_flirty", "amount": 60 }
                ]
            }
        ]
    },
    {
        "text": "I'm gonna punch you now.",
        "choices": [
            {
                "text": "Get Angry...",
                "requirements": [
                    { "face_state": "is_angry", "amount": 60 }
                ]
            }
        ]
    },
    {
        "text": "Have you wondered why I am out in the woods?",
        "choices": [
            {
                "text": "Look Suspiciously at him...",
                "requirements": [
                    { "face_state": "is_suspicious", "amount": 60 }
                ]
            }
        ]
    },
]



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
