#@tool
extends Node2D

func set_texture(t: Texture2D):
	$GridSprite2D.texture = t
	_rescale()
	
func _rescale():
	scale = $GridSprite2D.scale
	$GridSprite2D.scale = Vector2.ONE

func _ready() -> void:
	_rescale()
