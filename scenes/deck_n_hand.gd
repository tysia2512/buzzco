extends Node2D

@onready  var card_scene: PackedScene = preload("res://scenes/card.tscn")

func _init():
	visible = false
	
func _ready():
	position.x = get_viewport().get_visible_rect().size.x / 2
	position.y = get_viewport().get_visible_rect().size.y * 3 / 4
	visible = true
	
func _on_spawn_card_button_pressed() -> void:
	var card = card_scene.instantiate() as Card
	
