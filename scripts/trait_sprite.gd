class_name TraitSprite extends Sprite2D

signal trait_sprite_removed

func remove_sprite():
	trait_sprite_removed.emit()
	queue_free()
