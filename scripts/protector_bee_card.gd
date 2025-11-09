class_name PortectorBeeCard extends TypedCard

@onready var shield_scene: PackedScene = preload("res://scenes/shield.tscn")

func remove_shield() -> void:
	global_effect = null

func _on_card_card_placed(tile: GridTile) -> void:
	global_effect = shield_scene.instantiate()
	global_effect.parent_card = self
	tile.place_global_effect(global_effect)

func _on_remove(tile: GridTile) -> void:
	if global_effect != null:
		global_effect.remove_self()
		global_effect = null
