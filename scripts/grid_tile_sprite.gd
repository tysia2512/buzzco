extends Sprite2D

func get_texture_size():
	return Vector2(transform.get_scale().x * texture.get_width(), transform.get_scale().y * texture.get_height())
