class_name Enemy extends Node2D

var enemy: GenericEnemy
var sprite: Sprite2D

func get_texture_size():
	return Vector2(sprite.get_scale().x * sprite.texture.get_width(), sprite.transform.get_scale().y * sprite.texture.get_height())
