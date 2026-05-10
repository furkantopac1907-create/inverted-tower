extends Area2D

@export var npc_name := "Mysterious Figure"

func _ready() -> void:
	collision_layer = 32 # Interactable layer
	collision_mask = 0

func interact() -> void:
	if not GameState.has_manuscript:
		EventBus.show_dialogue.emit(npc_name, "Ah, another soul falls into the dark. You will need this to survive the horrors ahead... [Weapon Unlocked]")
		GameState.has_weapon = true
	else:
		if not GameState.has_zone2_key:
			EventBus.show_dialogue.emit(npc_name, "You can read the ancient tongue now... The Cult is below. Take this key and stop them. [Zone 2 Key Unlocked]")
			GameState.has_zone2_key = true
		else:
			EventBus.show_dialogue.emit(npc_name, "Hurry! The Inverted One grows restless.")
