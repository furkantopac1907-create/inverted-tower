extends Node

var health := 5
var max_health := 5
var sanity := 100
var max_sanity := 100
var current_zone := 1
var checkpoint_position := Vector2.ZERO
var lore_scrolls_collected: Array[String] = []

# Demo Intro variables
var has_weapon := false
var has_manuscript := false
var has_zone2_key := false

func _ready() -> void:
	EventBus.player_damaged.connect(_on_player_damaged)
	EventBus.player_died.connect(_on_player_died)

func damage_player(amount: int) -> void:
	health = max(0, health - amount)
	EventBus.player_damaged.emit(amount)
	if health <= 0:
		EventBus.player_died.emit()

func heal_player(amount: int) -> void:
	health = min(max_health, health + amount)
	EventBus.player_healed.emit(amount)

func drain_sanity(amount: int) -> void:
	sanity = max(0, sanity - amount)
	EventBus.sanity_changed.emit(sanity)
	if sanity <= 0:
		EventBus.sanity_depleted.emit()

func collect_scroll(scroll_id: String) -> void:
	if scroll_id not in lore_scrolls_collected:
		lore_scrolls_collected.append(scroll_id)
		EventBus.lore_collected.emit(scroll_id)

func set_checkpoint(pos: Vector2) -> void:
	checkpoint_position = pos
	EventBus.checkpoint_reached.emit(pos)

func _on_player_damaged(_amount: int) -> void:
	pass

func _on_player_died() -> void:
	await get_tree().create_timer(2.0).timeout
	health = max_health
	EventBus.player_respawned.emit(checkpoint_position)
