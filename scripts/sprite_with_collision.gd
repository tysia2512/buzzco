#@tool
extends Node2D

func set_texture(t: Texture2D):
	$GridSprite2D.texture = t
	_rescale()
	
func _rescale():
	$EnemyArea.scale = Vector2($GridSprite2D.scale.x * $GridSprite2D.sprite.scale.x, $GridSprite2D.scale.y * $GridSprite2D.sprite.scale.y)

func _ready() -> void:
	_rescale()
