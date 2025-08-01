class_name GridSpriteNumberDisplay extends Node2D

@export var text: String:
	set(value):
		$Label.text = value
		
func get_size() -> Vector2:
	return $Sprite2D.get_rect().size
