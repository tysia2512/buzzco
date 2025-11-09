#@tool
class_name CardDisplay extends Node2D

signal mouse_entered
signal mouse_exited
signal card_clicked

@export var texture: Texture2D:
	set(value):
		texture = value
		if _image_sprite:
			_image_sprite.texture = value
			_resize_texture()
			
@export var card_name: String:
	set(value):
		card_name = value
		if _image_sprite:
			$Name.text = value
			
@export var attack: int = 10:
	set(value):
		attack = value
		if _image_sprite:
			$AttackPts.text = str(value)
@export var description: String = "This is a card. It can be played and placed on the board.":
	set(value):
		description = value
		if _image_sprite:
			$Description.text = value

@export var card: TypedCard = null:
	set(value):
		card = value
		if _collision_polygon:
			_collision_polygon.card = value

@export var enable_collision: bool = true:
	set(value):
		enable_collision = value
		if _collision_polygon:
			_collision_polygon.disabled = !value

@onready var _image_sprite: Sprite2D = $ImageSprite
@onready var _card_template_sprite: Sprite2D = $CardTemplateSprite
@onready var _image_polygon: Polygon2D = $CardTemplateSprite/Polygon2D
@onready var _collision_polygon: CardCollisionPolygon = $Area2D/CollisionPolygon2D

func _ready():
	_image_sprite.texture = texture
	if _image_sprite.texture:
		_resize_texture()
	$Name.text = card_name
	$Description.text = description
	$AttackPts.text = str(attack)
	_collision_polygon.card = card
	_collision_polygon.disabled = !enable_collision
	
func _resize_texture():
	if !_image_polygon or _image_polygon.polygon.is_empty():
		return
	var min_x = _image_polygon.polygon[0].x
	var max_x = _image_polygon.polygon[0].x
	var min_y = _image_polygon.polygon[0].y
	var max_y = _image_polygon.polygon[0].y
	
	for pt in _image_polygon.polygon:
		min_x = min(min_x, pt.x)
		max_x = max(max_x, pt.x)
		min_y = min(min_y, pt.y)
		max_y = max(max_y, pt.y)
	
	var W = max_x - min_x
	var H = max_y - min_y
	
	var s = min(W / _image_sprite.texture.get_width(), H / _image_sprite.texture.get_height())

	_image_sprite.position = Vector2((min_x + max_x) / 2, (min_y + max_y) / 2)
	_image_sprite.scale = Vector2(s, s)

func get_texture_size():
	return _card_template_sprite.texture.get_size() * _card_template_sprite.scale * scale

func _on_area_2d_mouse_entered() -> void:
	mouse_entered.emit()
func _on_area_2d_mouse_exited() -> void:
	mouse_exited.emit()

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		card_clicked.emit()
