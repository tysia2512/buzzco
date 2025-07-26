class_name GridSprite2D extends Sprite2D

@onready var grid_tile_scene = preload("res://scenes/grid_tile.tscn")

func _ready():
	_set_scale()
	
func init_texture(t: Texture2D):
	texture = t
	_set_scale()
	
func _set_scale():
	if texture == null:
		return
		
	var text_size = texture.get_size()
	var tile = grid_tile_scene.instantiate()
	add_child(tile)
	var tile_height = tile.get_texture_size().y
	var tile_width = tile.get_texture_size().x
	tile.queue_free()
	
	var s = min(tile_width / text_size.x, tile_height / text_size.y)
	scale = Vector2(s, s)
