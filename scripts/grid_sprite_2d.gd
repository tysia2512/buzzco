@tool
class_name GridSprite2D extends Node2D

@onready var grid_tile_scene = preload("res://scenes/grid_tile.tscn")

@onready var sprite: Sprite2D = $Sprite2D
@onready var polygon: Polygon2D = $Polygon2D
@onready var number_display: GridSpriteNumberDisplay = $GirdSpriteNumberDisplay
@onready var trait_containters: Node2D = $TraitContainers

@export var texture: Texture2D:
	set(value):
		texture = value
		if sprite != null:
			init_texture()

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
	number_display.visible = show_number_display
	if number_display:
		number_display.text = str(number_on_display)
	if texture != null:
		init_texture()
	
func init_texture():
	sprite.texture = texture
	Utils.resize_sprite_to_polygon(sprite, polygon)
	_set_scale()
	
func _set_scale():
	var text_size = Utils.get_size(polygon)
	var tile = grid_tile_scene.instantiate()
	add_child(tile)
	var tile_height = tile.get_texture_size().y
	var tile_width = tile.get_texture_size().x
	tile.queue_free()
	
	var s = min(tile_width / text_size.x, tile_height / text_size.y) * 0.9
	scale = Vector2(s, s)

func add_trait(t: Trait):
	var sprite = Sprite2D.new()
	sprite.texture = t.texture
	var found_rec = false
	for rec in trait_containters.get_children():
		assert(rec is Polygon2D)
		if rec.get_child_count() == 0:
			found_rec = true
			rec.add_child(sprite)
			Utils.resize_sprite_to_polygon(sprite, rec)
			break
	assert(found_rec, "Too many traits")
