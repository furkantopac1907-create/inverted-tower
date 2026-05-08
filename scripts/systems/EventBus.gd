extends Node

signal player_damaged(amount: int)
signal player_died
signal player_healed(amount: int)
signal sanity_changed(value: int)
signal sanity_depleted
signal lore_collected(scroll_id: String)
signal zone_changed(zone_index: int)
signal enemy_died(enemy: Node)
signal checkpoint_reached(position: Vector2)
