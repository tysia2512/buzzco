@tool
class_name GridSprite2D extends Sprite2D

@onready var grid_tile_scene = preload("res://scenes/grid_tile.tscn")

@onready var number_display: GridSpriteNumberDisplay = $GirdSpriteNumberDisplay

@export var show_number_display: bool = false:
	set(value):
		show_number_display = value
		if number_display:
			number_display.visible = value

@export var number_on_display: int:
	set(value):
		number_on_display = value
		if number_display:
			number_display.text = str(value)

func _ready():
	_set_scale()
	_set_label_scale()
	number_display.visible = show_number_display
	if number_display:
		number_display.text = str(number_on_display)
	
func init_texture(t: Texture2D):
	texture = t
	_set_scale()
	if number_display:
		_set_label_scale()
	
func _set_scale():
	if texture == null:
		return
		
	var text_size = texture.get_size()
	var tile = grid_tile_scene.instantiate()
	add_child(tile)
	var tile_height = tile.get_texture_size().y
	var tile_width = tile.get_texture_size().x
	tile.queue_free()
	
	var s = min(tile_width / text_size.x, tile_height / text_size.y) * 0.9
	scale = Vector2(s, s)

func _set_label_scale() -> void:
	if texture == null:
		return
		
	var label_size = number_display.get_size()
	var desired = texture.get_size() * 0.25
	
	var s = min(desired.x / label_size.x, desired.y / label_size.y)
	number_display.scale = Vector2(s, s)
	var tile = grid_tile_scene.instantiate() as GridTile
	add_child(tile)
	number_display.position = tile.get_bottom_left_corner_position() / scale.x
	number_display.z_index = ZLayers.ATTACK_DISPLAY_ON_GRID
	tile.queue_free()
