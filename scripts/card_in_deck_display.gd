class_name CardInDeckDisplay extends Node2D

@onready var count_label: Label = $CountLabel

@export var card_scene: PackedScene:
	set(value):
		card_scene = value
		var card_instance = card_scene.instantiate()
		add_child(card_instance)
@export var count: int = 0:
	set(value):
		count = value
		count_label.text = "x" + str(count)
